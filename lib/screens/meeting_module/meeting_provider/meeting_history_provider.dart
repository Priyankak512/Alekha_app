import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/meeting_module/meeting_model/meeting_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MeetingHistoryProvider with ChangeNotifier {
  static const String keyMeetingHistory = "meeting_history_list";
  List<MeetingHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<MeetingHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  MeetingHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String raw = await Shared_Preferences.prefGetString(keyMeetingHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => MeetingHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local meeting history: $decodeErr");
      }

      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('meetings')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<MeetingHistoryModel> fetchedList = response.map<MeetingHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return MeetingHistoryModel.fromJson(map);
            }).toList();

            final Map<String, MeetingHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_${item.meetingDate}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_${item.meetingDate}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyMeetingHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch meetings error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading meeting history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordMeetingAction({
    required String clientOrAgency,
    required String agencyName,
    required String clientName,
    required String projectNo,
    required String meetingDate,
    required String meetingTime,
    String actionType = 'shared',
  }) async {
    String senderName = await AuthService.getCurrentUserName();
    if (senderName.trim().isEmpty) {
      senderName = await AuthService.getCurrentUserEmail();
    }
    if (senderName.trim().isEmpty) {
      senderName = "User";
    }

    if (_historyList.isNotEmpty) {
      final latest = _historyList.first;
      if (latest.projectNo == projectNo.trim() &&
          latest.clientName == clientName.trim() &&
          latest.actionType == actionType) {
        try {
          final diff = DateTime.now().difference(DateTime.parse(latest.createdAt)).inSeconds;
          if (diff.abs() < 5) {
            debugPrint("⚠️ Duplicate meeting record skipped within 5 seconds");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = MeetingHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientOrAgency: clientOrAgency.trim(),
      agencyName: agencyName.trim(),
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      projectNo: projectNo.trim(),
      meetingDate: meetingDate.trim(),
      meetingTime: meetingTime.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyMeetingHistory, encoded);
    } catch (e) {
      debugPrint("❌ Error saving meeting locally: $e");
    }

    try {
      final client = Supabase.instance.client;
      final payload = {
        'client_or_agency': newEntry.clientOrAgency,
        'agency_name': newEntry.agencyName,
        'client_name': newEntry.clientName,
        'project_no': newEntry.projectNo,
        'meeting_date': newEntry.meetingDate,
        'meeting_time': newEntry.meetingTime,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };
      await client.from('meetings').insert(payload);
      debugPrint("✅ Meeting inserted into Supabase");
    } catch (e) {
      debugPrint("❌ Supabase insert meetings error: $e");
    }
  }

  Future<void> deleteMeetingItem(MeetingHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyMeetingHistory, encoded);
    } catch (_) {}

    try {
      final client = Supabase.instance.client;
      await client.from('meetings').delete().match({
        'client_name': item.clientName,
        'project_no': item.projectNo,
        'created_at': item.createdAt,
      });
    } catch (_) {}
  }
}

