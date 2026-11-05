import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/fees_module/fees_model/fees_reminder_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeesReminderProvider with ChangeNotifier {
  static const String keyReminderHistory = "fees_reminder_history_list";
  List<FeesReminderHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<FeesReminderHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  FeesReminderProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Pehle local cache hamesha load karo taaki data turant visible rahe
      final String raw = await Shared_Preferences.prefGetString(keyReminderHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => FeesReminderHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local reminder history: $decodeErr");
      }

      // 2. Agar Supabase se bhi sync karna hai
      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('fees_reminders')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<FeesReminderHistoryModel> fetchedList = response.map<FeesReminderHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return FeesReminderHistoryModel(
                id: (map['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
                name: (map['name'] ?? '').toString(),
                projectNo: (map['project_no'] ?? '').toString(),
                amountPending: (map['amount_pending'] ?? '').toString(),
                projectCategory: (map['project_category'] ?? '').toString(),
                invoiceNo: (map['invoice_no'] ?? '').toString(),
                feesStage: (map['fees_stage'] ?? '').toString(),
                note: (map['note'] ?? '').toString(),
                regards: (map['regards'] ?? '').toString(),
                senderUserName: (map['sender_user_name'] ?? '').toString(),
                actionType: (map['action_type'] ?? '').toString(),
                createdAt: (map['created_at'] ?? DateTime.now().toIso8601String()).toString(),
              );
            }).toList();

            // Local aur Supabase data merge karo bina duplicates ke
            final Map<String, FeesReminderHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.name}_${item.projectNo}_${item.amountPending}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.name}_${item.projectNo}_${item.amountPending}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyReminderHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch fees_reminders error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading fees reminder history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Triggered ONLY when user Shares or Copies the message
  Future<void> recordReminderAction({
    required String name,
    required String projectNo,
    required String amountPending,
    required String actionType,
    String projectCategory = '',
    String invoiceNo = '',
    String feesStage = '',
    String note = '',
    String regards = '',
  }) async {
    String senderName = await AuthService.getCurrentUserName();
    if (senderName.trim().isEmpty) {
      senderName = await AuthService.getCurrentUserEmail();
    }
    if (senderName.trim().isEmpty) {
      senderName = "User";
    }

    final newEntry = FeesReminderHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      projectNo: projectNo.trim(),
      amountPending: amountPending.trim(),
      projectCategory: projectCategory,
      invoiceNo: invoiceNo.trim(),
      feesStage: feesStage.trim(),
      note: note.trim(),
      regards: regards.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    // 1. TURANT Local storage me save kare (bina kisi wait ke taaki restart hone par kabhi na khoye)
    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyReminderHistory, encoded);
      debugPrint("💾 [FeesReminderProvider] Saved to Local Storage successfully! Total items: ${_historyList.length}");
    } catch (e) {
      debugPrint("❌ [FeesReminderProvider] Error saving reminder history locally: $e");
    }

    // 2. Persist to Supabase Database
    try {
      final client = Supabase.instance.client;
      // Try with all extra fields first
      final payloadFull = {
        'name': newEntry.name,
        'project_no': newEntry.projectNo,
        'amount_pending': newEntry.amountPending,
        'invoice_no': newEntry.invoiceNo,
        'fees_stage': newEntry.feesStage,
        'project_category': newEntry.projectCategory,
        'note': newEntry.note,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };

      try {
        await client.from('fees_reminders').insert(payloadFull);
        debugPrint("✅ [FeesReminderProvider] Insert successful (full payload)");
      } catch (colErr) {
        debugPrint("⚠️ Full payload failed ($colErr), retrying with base columns...");
        // Fallback to base columns if new columns (action_type, sender_user_name) are not added to Supabase yet
        final payloadBase = {
          'name': newEntry.name,
          'project_no': newEntry.projectNo,
          'amount_pending': newEntry.amountPending,
          'invoice_no': newEntry.invoiceNo,
          'fees_stage': newEntry.feesStage,
          'created_at': newEntry.createdAt,
        };
        await client.from('fees_reminders').insert(payloadBase);
        debugPrint("✅ [FeesReminderProvider] Insert successful (base payload)");
      }
    } catch (e) {
      debugPrint("❌ [FeesReminderProvider] Supabase insert fees_reminders error: $e");
    }
  }

  // Delete a single reminder item from both local storage & Supabase
  Future<void> deleteReminderItem(FeesReminderHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    // Update local storage
    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyReminderHistory, encoded);
    } catch (e) {
      log("Error updating reminder history locally after delete: $e");
    }

    // Delete from Supabase Database
    try {
      final client = Supabase.instance.client;
      await client
          .from('fees_reminders')
          .delete()
          .match({
            'name': item.name,
            'project_no': item.projectNo,
            'created_at': item.createdAt,
          });
    } catch (e) {
      log("Supabase delete fees_reminders error: $e");
    }
  }

  Future<void> clearAllHistory() async {
    _historyList.clear();
    await Shared_Preferences.prefSetString(keyReminderHistory, "[]");
    notifyListeners();
  }
}
