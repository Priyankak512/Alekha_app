import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/selection_module/selection_model/selection_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectionHistoryProvider with ChangeNotifier {
  static const String keySelectionHistory = "selection_history_list";
  List<SelectionHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<SelectionHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  SelectionHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String raw = await Shared_Preferences.prefGetString(keySelectionHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => SelectionHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local selection history: $decodeErr");
      }

      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('selections')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<SelectionHistoryModel> fetchedList = response.map<SelectionHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return SelectionHistoryModel.fromJson(map);
            }).toList();

            final Map<String, SelectionHistoryModel> mergedMap = {};
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
            await Shared_Preferences.prefSetString(keySelectionHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch selections error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading selection history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordSelectionExport({
    required String clientName,
    required String projectNo,
    String selectionDate = '',
    String selectionTime = '',
    String actionType = 'exported_pdf',
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
      if (latest.projectNo == projectNo.trim() && latest.clientName == clientName.trim()) {
        try {
          final diff = DateTime.now().difference(DateTime.parse(latest.createdAt)).inSeconds;
          if (diff.abs() < 5) {
            debugPrint("⚠️ Duplicate selection export skipped");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = SelectionHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      projectNo: projectNo.trim(),
      selectionDate: selectionDate.trim(),
      selectionTime: selectionTime.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keySelectionHistory, encoded);
    } catch (e) {
      debugPrint("❌ Error saving selection locally: $e");
    }

    try {
      final client = Supabase.instance.client;
      final payload = {
        'client_name': newEntry.clientName,
        'project_no': newEntry.projectNo,
        'selection_date': newEntry.selectionDate,
        'selection_time': newEntry.selectionTime,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };
      await client.from('selections').insert(payload);
      debugPrint("✅ Selection inserted into Supabase");
    } catch (e) {
      debugPrint("❌ Supabase insert selections error: $e");
    }
  }

  Future<void> deleteSelectionItem(SelectionHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keySelectionHistory, encoded);
    } catch (_) {}

    try {
      final client = Supabase.instance.client;
      await client.from('selections').delete().match({
        'client_name': item.clientName,
        'project_no': item.projectNo,
        'created_at': item.createdAt,
      });
    } catch (_) {}
  }
}
