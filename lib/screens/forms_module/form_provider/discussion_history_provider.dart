import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/forms_module/form_model/discussion_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionHistoryProvider with ChangeNotifier {
  static const String keyDiscussionHistory = "discussion_history_list";
  List<DiscussionHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<DiscussionHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  DiscussionHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String raw = await Shared_Preferences.prefGetString(keyDiscussionHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => DiscussionHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local discussion history: $decodeErr");
      }

      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('discussions')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<DiscussionHistoryModel> fetchedList = response.map<DiscussionHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return DiscussionHistoryModel.fromJson(map);
            }).toList();

            final Map<String, DiscussionHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_${item.discussionDate}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_${item.discussionDate}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyDiscussionHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch discussions error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading discussion history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordDiscussionAction({
    required String clientName,
    required String projectNo,
    required String discussionDate,
    required String discussionTime,
    required String discussionFrom,
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
            debugPrint("⚠️ Duplicate discussion record skipped within 5 seconds");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = DiscussionHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      projectNo: projectNo.trim(),
      discussionDate: discussionDate.trim(),
      discussionTime: discussionTime.trim(),
      discussionFrom: discussionFrom.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyDiscussionHistory, encoded);
    } catch (e) {
      debugPrint("❌ Error saving discussion locally: $e");
    }

    try {
      final client = Supabase.instance.client;
      final payload = {
        'client_name': newEntry.clientName,
        'project_no': newEntry.projectNo,
        'discussion_date': newEntry.discussionDate,
        'discussion_time': newEntry.discussionTime,
        'discussion_from': newEntry.discussionFrom,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };
      await client.from('discussions').insert(payload);
      debugPrint("✅ Discussion inserted into Supabase");
    } catch (e) {
      debugPrint("❌ Supabase insert discussions error: $e");
    }
  }

  Future<void> deleteDiscussionItem(DiscussionHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyDiscussionHistory, encoded);
    } catch (_) {}

    try {
      final client = Supabase.instance.client;
      await client.from('discussions').delete().match({
        'client_name': item.clientName,
        'created_at': item.createdAt,
      });
    } catch (_) {}
  }
}

