import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/offer_latter_module/offer_latter_model/offer_letter_history_model.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferLetterHistoryProvider with ChangeNotifier {
  static const String keyOfferLetterHistory = "offer_letter_history_list";
  List<OfferLetterHistoryModel> _historyList = [];
  bool _isLoading = false;

  List<OfferLetterHistoryModel> get historyList => _historyList;
  bool get isLoading => _isLoading;

  OfferLetterHistoryProvider() {
    loadHistory(fromSupabase: true);
  }

  Future<void> loadHistory({bool fromSupabase = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String raw = await Shared_Preferences.prefGetString(keyOfferLetterHistory, "[]");
      try {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _historyList = decoded
            .map((item) => OfferLetterHistoryModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (decodeErr) {
        log("Error decoding local offer letter history: $decodeErr");
      }

      if (fromSupabase) {
        try {
          final client = Supabase.instance.client;
          final response = await client
              .from('offer_letters')
              .select()
              .order('created_at', ascending: false);

          if (response is List) {
            final List<OfferLetterHistoryModel> fetchedList = response.map<OfferLetterHistoryModel>((data) {
              final map = Map<String, dynamic>.from(data as Map);
              return OfferLetterHistoryModel.fromJson(map);
            }).toList();

            final Map<String, OfferLetterHistoryModel> mergedMap = {};
            for (var item in fetchedList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.offerType}_${item.clientName}_${item.contactNo}_$dateKey";
              mergedMap[key] = item;
            }
            for (var item in _historyList) {
              final dateKey = item.createdAt.length >= 16 ? item.createdAt.substring(0, 16) : item.createdAt;
              final key = "${item.offerType}_${item.clientName}_${item.contactNo}_$dateKey";
              mergedMap.putIfAbsent(key, () => item);
            }

            _historyList = mergedMap.values.toList();
            _historyList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
            await Shared_Preferences.prefSetString(keyOfferLetterHistory, encoded);
          }
        } catch (supabaseError) {
          debugPrint("⚠️ Supabase fetch offer_letters error: $supabaseError");
        }
      }
    } catch (e) {
      log("Error loading offer letter history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordOfferLetterAction({
    required String offerType, // 'Architecture', 'Interior', 'Basic'
    required String clientName,
    required String contactNo,
    required String location,
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
      if (latest.offerType == offerType &&
          latest.clientName == clientName.trim() &&
          latest.actionType == actionType) {
        try {
          final diff = DateTime.now().difference(DateTime.parse(latest.createdAt)).inSeconds;
          if (diff.abs() < 5) {
            debugPrint("⚠️ Duplicate offer letter record skipped within 5 seconds");
            return;
          }
        } catch (_) {}
      }
    }

    final newEntry = OfferLetterHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      offerType: offerType,
      clientName: clientName.trim().isEmpty ? "Client" : clientName.trim(),
      contactNo: contactNo.trim(),
      location: location.trim(),
      senderUserName: senderName,
      actionType: actionType,
      createdAt: DateTime.now().toIso8601String(),
    );

    _historyList.insert(0, newEntry);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyOfferLetterHistory, encoded);
    } catch (e) {
      debugPrint("❌ Error saving offer letter locally: $e");
    }

    try {
      final client = Supabase.instance.client;
      final payload = {
        'offer_type': newEntry.offerType,
        'client_name': newEntry.clientName,
        'contact_no': newEntry.contactNo,
        'location': newEntry.location,
        'sender_user_name': newEntry.senderUserName,
        'action_type': newEntry.actionType,
        'created_at': newEntry.createdAt,
      };
      await client.from('offer_letters').insert(payload);
      debugPrint("✅ Offer letter inserted into Supabase");
    } catch (e) {
      debugPrint("❌ Supabase insert offer_letters error: $e");
    }
  }

  Future<void> deleteOfferLetterItem(OfferLetterHistoryModel item) async {
    _historyList.removeWhere((element) => element.id == item.id || element.createdAt == item.createdAt);
    notifyListeners();

    try {
      final encoded = jsonEncode(_historyList.map((e) => e.toJson()).toList());
      await Shared_Preferences.prefSetString(keyOfferLetterHistory, encoded);
    } catch (_) {}

    try {
      final client = Supabase.instance.client;
      await client.from('offer_letters').delete().match({
        'client_name': item.clientName,
        'created_at': item.createdAt,
      });
    } catch (_) {}
  }
}

