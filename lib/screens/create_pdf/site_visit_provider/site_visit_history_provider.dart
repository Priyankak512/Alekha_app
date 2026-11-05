import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/create_pdf/site_visit_model/site_visit_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiteVisitHistoryProvider with ChangeNotifier {
  static const String keySiteVisitHistory = "site_visit_history_list";
  List<SiteVisitHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<SiteVisitHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  SiteVisitHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Local cache load
      final String raw = await Shared_Preferences.prefGetString(keySiteVisitHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => SiteVisitHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local site visit history: $decodeErr");
      }

      // 2. Supabase remote fetch
      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('site_visits')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<SiteVisitHistoryModel> fetchedList = response.map<SiteVisitHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return SiteVisitHistoryModel.fromJson(map);
            }).toList();

            final Map<String, SiteVisitHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.projectNo}_${item.clientName}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keySiteVisitHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch site_visits error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading site visit history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordSiteVisitExport({
    required String clientName,
    required String projectNo,
    String actionType = 'exported_pdf',
  }) async {
    String senderName = await AuthService.getCurrentUserName();
    if (senderName.trim().isEmpty) {
      senderName = await AuthService.getCurrentUserEmail();
    }
    if (senderName.trim().isEmpty) {
      senderName = "User";
    }

    // Debounce within 5 seconds for duplicate click
    if (_historyList.isNotEmpty) {
      final latest = _historyList.first;
      if (latest.projectNo == projectNo.trim() && latest.clientName == clientName.trim()) {
        try {
          final diff = DateTime.now().difference(DateTime.parse(latest.createdAt)).inSeconds;
          if (diff.abs() < 5) {
            debugPrint("⚠️ Duplicate site visit export skipped");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = SiteVisitHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      projectNo: projectNo.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    // Local save
    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keySiteVisitHistory, encoded);
    } catch (e) {
      debugPrint("❌ Error saving site visit locally: $e");
    }

    // Supabase save
    try {
      final client = Supabase.instance.client;
      final payload = {
        'client_name': newEntry.clientName,
        'project_no': newEntry.projectNo,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };
      await client.from('site_visits').insert(payload);
      debugPrint("✅ Site visit inserted into Supabase");
    } catch (e) {
      debugPrint("❌ Supabase insert site_visits error: $e");
    }
  }

  Future<void> deleteSiteVisitItem(SiteVisitHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keySiteVisitHistory, encoded);
    } catch (_) {}

    try {
      final client = Supabase.instance.client;
      await client
          .from('site_visits')
          .delete()
          .match({
            'client_name': item.clientName,
            'project_no': item.projectNo,
            'created_at': item.createdAt,
          });
    } catch (_) {}
  }
}

