import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/invoice_generator/invoice_model/invoice_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceHistoryProvider with ChangeNotifier {
  static const String keyInvoiceHistory = "invoice_history_list";
  List<InvoiceHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<InvoiceHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  InvoiceHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Pehle local cache hamesha load karo taaki data turant visible rahe
      final String raw = await Shared_Preferences.prefGetString(keyInvoiceHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => InvoiceHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local invoice history: $decodeErr");
      }

      // 2. Agar Supabase se sync karna hai
      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('invoices')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<InvoiceHistoryModel> fetchedList = response.map<InvoiceHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return InvoiceHistoryModel.fromJson(map);
            }).toList();

            // Merge local and remote: key by (invoiceNo + clientName + totalAmount) or createdAt prefix
            final Map<String, InvoiceHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              // Match by date date-time minute or invoiceNo+client
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.invoiceNo}_${item.clientName}_${item.totalAmount}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.invoiceNo}_${item.clientName}_${item.totalAmount}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyInvoiceHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch invoices error (table may not be created yet): $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading invoice history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Triggered when user clicks "Export as Pdf"
  Future<void> recordInvoiceExport({
    required String clientName,
    required String invoiceNo,
    required String totalAmount,
    String projectNo = '',
    String contactNo = '',
    String paymentStatus = '',
    String invoiceType = 'Invoice',
    String actionType = 'exported_pdf',
  }) async {
    String senderName = await AuthService.getCurrentUserName();
    if (senderName.trim().isEmpty) {
      senderName = await AuthService.getCurrentUserEmail();
    }
    if (senderName.trim().isEmpty) {
      senderName = "User";
    }

    // Prevent duplicate entries within 5 seconds for same invoice & client
    if (_historyList.isNotEmpty) {
      final latest = _historyList.first;
      if (latest.invoiceNo == (invoiceNo.trim().isEmpty ? "N/A" : invoiceNo.trim()) &&
          latest.clientName == (clientName.trim().isEmpty ? "Client" : clientName.trim())) {
        try {
          final diff = DateTime.now().difference(DateTime.parse(latest.createdAt)).inSeconds;
          if (diff.abs() < 5) {
            debugPrint("⚠️ Duplicate invoice export call skipped (within 5 seconds)");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = InvoiceHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      invoiceNo: invoiceNo.trim().isEmpty ? "N/A" : invoiceNo.trim(),
      contactNo: contactNo.trim(),
      paymentStatus: paymentStatus.trim(),
      totalAmount: totalAmount.trim(),
      projectNo: projectNo.trim(),
      senderUserName: senderName,
      actionType: actionType,
      invoiceType: invoiceType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    // 1. Instant local persistence
    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyInvoiceHistory, encoded);
      debugPrint("💾 [InvoiceHistoryProvider] Saved invoice locally: ${_historyList.length}");
    } catch (e) {
      debugPrint("❌ [InvoiceHistoryProvider] Error saving locally: $e");
    }

    // 2. Persist to Supabase Database
    try {
      final client = Supabase.instance.client;
      final payload = {
        'client_name': newEntry.clientName,
        'invoice_no': newEntry.invoiceNo,
        'contact_no': newEntry.contactNo,
        'payment_status': newEntry.paymentStatus,
        'project_no': newEntry.projectNo,
        'total_amount': newEntry.totalAmount,
        'invoice_type': newEntry.invoiceType,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };

      debugPrint("🚀 [InvoiceHistoryProvider] Inserting into Supabase 'invoices': $payload");
      await client.from('invoices').insert(payload);
      debugPrint("✅ [InvoiceHistoryProvider] Insert into 'invoices' successful");
    } catch (e) {
      debugPrint("❌ [InvoiceHistoryProvider] Supabase insert error: $e");
    }
  }

  // Delete invoice item
  Future<void> deleteInvoiceItem(InvoiceHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyInvoiceHistory, encoded);
    } catch (e) {
      log("Error deleting invoice locally: $e");
    }

    try {
      final client = Supabase.instance.client;
      await client
          .from('invoices')
          .delete()
          .match({
            'invoice_no': item.invoiceNo,
            'client_name': item.clientName,
            'created_at': item.createdAt,
          });
    } catch (e) {
      log("Supabase delete invoices error: $e");
    }
  }

  Future<void> clearAllHistory() async {
    _historyList.clear();
    await Shared_Preferences.prefSetString(keyInvoiceHistory, "[]");
    notifyListeners();
  }
}

