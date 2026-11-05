import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/fees_module/fees_model/fees_received_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeesReceivedProvider with ChangeNotifier {
  static const String keyReceivedHistory = "fees_received_history_list";
  List<FeesReceivedHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<FeesReceivedHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  FeesReceivedProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Pehle local cache hamesha load karo taaki data turant visible rahe
      final String raw = await Shared_Preferences.prefGetString(keyReceivedHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => FeesReceivedHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local received history: $decodeErr");
      }

      // 2. Agar Supabase se bhi sync karna hai
      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('fees_received')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<FeesReceivedHistoryModel> fetchedList = response.map<FeesReceivedHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return FeesReceivedHistoryModel(
                id: (map['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
                clientName: (map['client_name'] ?? '').toString(),
                projectNo: (map['project_no'] ?? '').toString(),
                amountReceived: (map['amount_received'] ?? '').toString(),
                feesStage: (map['fees_stage'] ?? '').toString(),
                invoiceNo: (map['invoice_no'] ?? '').toString(),
                paymentMode: (map['payment_mode'] ?? '').toString(),
                feesSummary: (map['fees_summary'] ?? '').toString(),
                regards: (map['regards'] ?? '').toString(),
                senderUserName: (map['sender_user_name'] ?? '').toString(),
                actionType: (map['action_type'] ?? '').toString(),
                createdAt: (map['created_at'] ?? DateTime.now().toIso8601String()).toString(),
              );
            }).toList();

            // Local aur Supabase data merge karo bina duplicates ke
            final Map<String, FeesReceivedHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.clientName}_${item.projectNo}_${item.amountReceived}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.clientName}_${item.projectNo}_${item.amountReceived}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyReceivedHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch fees_received error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading fees received history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Triggered ONLY when user Shares or Copies the message
  Future<void> recordReceivedAction({
    required String clientName,
    required String projectNo,
    required String amountReceived,
    required String actionType,
    String feesStage = '',
    String invoiceNo = '',
    String paymentMode = '',
    String feesSummary = '',
    String regards = '',
  }) async {
    String senderName = await AuthService.getCurrentUserName();
    if (senderName.trim().isEmpty) {
      senderName = await AuthService.getCurrentUserEmail();
    }
    if (senderName.trim().isEmpty) {
      senderName = "User";
    }

    final newEntry = FeesReceivedHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientName.trim(),
      projectNo: projectNo.trim(),
      amountReceived: amountReceived.trim(),
      feesStage: feesStage.trim(),
      invoiceNo: invoiceNo.trim(),
      paymentMode: paymentMode.trim(),
      feesSummary: feesSummary.trim(),
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
      await Shared_Preferences.prefSetString(keyReceivedHistory, encoded);
      debugPrint("💾 [FeesReceivedProvider] Saved to Local Storage successfully! Total items: ${_historyList.length}");
    } catch (e) {
      debugPrint("❌ [FeesReceivedProvider] Error saving received history locally: $e");
    }

    // 2. Persist to Supabase Database
    try {
      final client = Supabase.instance.client;
      final payloadFull = {
        'client_name': newEntry.clientName,
        'project_no': newEntry.projectNo,
        'amount_received': newEntry.amountReceived,
        'invoice_no': newEntry.invoiceNo,
        'payment_mode': newEntry.paymentMode,
        'fees_stage': newEntry.feesStage,
        'fees_summary': newEntry.feesSummary,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };

      try {
        await client.from('fees_received').insert(payloadFull);
        debugPrint("✅ [FeesReceivedProvider] Insert successful (full payload)");
      } catch (colErr) {
        debugPrint("⚠️ Full payload failed ($colErr), retrying with base columns...");
        // Fallback to base columns if new columns (action_type, sender_user_name) are not added to Supabase yet
        final payloadBase = {
          'client_name': newEntry.clientName,
          'project_no': newEntry.projectNo,
          'amount_received': newEntry.amountReceived,
          'invoice_no': newEntry.invoiceNo,
          'payment_mode': newEntry.paymentMode,
          'created_at': newEntry.createdAt,
        };
        await client.from('fees_received').insert(payloadBase);
        debugPrint("✅ [FeesReceivedProvider] Insert successful (base payload)");
      }
    } catch (e) {
      debugPrint("❌ [FeesReceivedProvider] Supabase insert fees_received error: $e");
    }
  }

  // Delete a single received item from both local storage & Supabase
  Future<void> deleteReceivedItem(FeesReceivedHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    // Update local storage
    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyReceivedHistory, encoded);
    } catch (e) {
      log("Error updating received history locally after delete: $e");
    }

    // Delete from Supabase Database
    try {
      final client = Supabase.instance.client;
      await client
          .from('fees_received')
          .delete()
          .match({
            'client_name': item.clientName,
            'project_no': item.projectNo,
            'created_at': item.createdAt,
          });
    } catch (e) {
      log("Supabase delete fees_received error: $e");
    }
  }

  Future<void> clearAllHistory() async {
    _historyList.clear();
    await Shared_Preferences.prefSetString(keyReceivedHistory, "[]");
    notifyListeners();
  }
}
