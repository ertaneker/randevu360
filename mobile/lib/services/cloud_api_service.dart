import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';

/// Oracle Cloud API servisi — FirestoreSyncService'in yerine geçer.
///
/// İşletme metadata, çalışan yönetimi, izinler, WhatsApp oturumu ve
/// cihazlar arası veri senkronu artık Firestore yerine PostgreSQL
/// üzerinden bu API ile yapılır.
///
/// Auth: Tüm isteklerde x-api-key header'ı kullanılır (WhatsApp servisiyle
/// aynı mekanizma). Kullanıcı bilgisi (uid, email) istek gövdesinde veya
/// header'da taşınır; yetki kontrolü server tarafında yapılır.
class CloudApiService {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  CloudApiService({http.Client? client})
      : _client = client ?? http.Client(),
        _baseUrl = AppConstants.whatsappServiceUrl,
        _apiKey = AppConstants.apiKey;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      };

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  // ──── İŞLETME ────

  Future<Map<String, dynamic>?> getBusiness(String remoteId) async {
    try {
      final resp = await _client
          .get(Uri.parse('$_baseUrl/api/business/$remoteId'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
      if (resp.statusCode == 404) return null;
      debugPrint('CloudApi getBusiness hata ${resp.statusCode}: ${resp.body}');
      return null;
    } catch (e) {
      debugPrint('CloudApi getBusiness: $e');
      return null;
    }
  }

  Future<bool> upsertBusiness({
    required String remoteId,
    required String name,
    required String ownerUid,
    required String ownerEmail,
    required String ownerName,
    String? phone,
    String? address,
    String? email,
  }) async {
    try {
      final resp = await _client
          .put(
            Uri.parse('$_baseUrl/api/business/$remoteId'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'ownerUid': ownerUid,
              'ownerEmail': normalizeEmail(ownerEmail),
              'ownerName': ownerName,
              'phone': phone ?? '',
              'address': address ?? '',
              'email': email ?? ownerEmail,
            }),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi upsertBusiness: $e');
      return false;
    }
  }

  Future<bool> updateBusinessSettings(
      String remoteId, Map<String, dynamic> settings) async {
    try {
      final resp = await _client
          .put(
            Uri.parse('$_baseUrl/api/business/$remoteId/settings'),
            headers: _headers,
            body: jsonEncode(settings),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi updateBusinessSettings: $e');
      return false;
    }
  }

  // ──── ABONELİK ────

  /// Sunucudan işletmenin abonelik durumunu okur. Tüm cihazlar (sahip +
  /// çalışanlar) açılışta bunu çağırır — gerçek karar sunucuda tarihten
  /// hesaplanır, yerel Play Store durumuna bakılmaz (çalışanın hesabında
  /// zaten satın alma yoktur).
  Future<Map<String, dynamic>?> getSubscriptionStatus(String remoteId) async {
    try {
      final resp = await _client
          .get(Uri.parse('$_baseUrl/api/business/$remoteId/subscription'),
              headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('CloudApi getSubscriptionStatus: $e');
      return null;
    }
  }

  /// Satın alma/yenileme sonrası purchaseToken'ı sunucuya doğrulatır.
  /// Sadece işletme sahibinin cihazından çağrılmalı.
  Future<Map<String, dynamic>?> verifySubscriptionPurchase({
    required String remoteId,
    required String purchaseToken,
    required String productId,
  }) async {
    try {
      final resp = await _client
          .post(
            Uri.parse('$_baseUrl/api/business/$remoteId/subscription/verify'),
            headers: _headers,
            body: jsonEncode({
              'purchaseToken': purchaseToken,
              'productId': productId,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return null;
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('CloudApi verifySubscriptionPurchase: $e');
      return null;
    }
  }

  // ──── ÇALIŞAN YÖNETİMİ ────

  Future<bool> addEmployee({
    required String businessRemoteId,
    required String email,
    required String name,
    required String role,
    String? ownerUid,
    String? ownerEmail,
    String? ownerName,
    String? businessName,
  }) async {
    try {
      final resp = await _client
          .post(
            Uri.parse('$_baseUrl/api/business/$businessRemoteId/employees'),
            headers: _headers,
            body: jsonEncode({
              'email': normalizeEmail(email),
              'name': name,
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi addEmployee: $e');
      return false;
    }
  }

  Future<bool> removeEmployee(String businessRemoteId, String email) async {
    try {
      final resp = await _client
          .delete(
            Uri.parse('$_baseUrl/api/business/$businessRemoteId/employees/${Uri.encodeComponent(normalizeEmail(email))}'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi removeEmployee: $e');
      return false;
    }
  }

  Future<bool> updateEmployeeRole(
      String businessRemoteId, String email, String newRole,
      {String? fbUid}) async {
    try {
      final body = <String, dynamic>{'role': newRole};
      if (fbUid != null && fbUid.isNotEmpty) body['fbUid'] = fbUid;
      final resp = await _client
          .put(
            Uri.parse('$_baseUrl/api/business/$businessRemoteId/employees/${Uri.encodeComponent(normalizeEmail(email))}'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi updateEmployeeRole: $e');
      return false;
    }
  }

  // ──── ÇALIŞAN İZİNLERİ ────

  Future<bool> updateEmployeePermissions(
      String businessRemoteId, String email, Map<String, bool> permissions) async {
    try {
      final resp = await _client
          .put(
            Uri.parse('$_baseUrl/api/business/$businessRemoteId/employees/${Uri.encodeComponent(normalizeEmail(email))}'),
            headers: _headers,
            body: jsonEncode({'permissions': permissions}),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi updateEmployeePermissions: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getEmployeePermissionsRemote(
      String businessRemoteId, String email) async {
    try {
      final resp = await _client
          .get(
            Uri.parse('$_baseUrl/api/business/$businessRemoteId/employees/${Uri.encodeComponent(normalizeEmail(email))}/permissions'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data is Map<String, dynamic> ? data : null;
      }
      return null;
    } catch (e) {
      debugPrint('CloudApi getEmployeePermissionsRemote: $e');
      return null;
    }
  }

  // ──── ÇALIŞAN GİRİŞ ────

  /// Girişte kullanıcının işletme bağlantısını çözer:
  /// önce sahip mi (business doc ID = uid), değilse davetli çalışan mı.
  Future<Map<String, dynamic>?> getEmployeeData(String email, String uid) async {
    // Önce sahip mi? (business doc ID = uid)
    final ownBiz = await getBusiness(uid);
    if (ownBiz != null) {
      return {
        'businessId': uid,
        'businessName': ownBiz['name'] ?? '',
        'role': 'admin',
        'isOwner': true,
      };
    }

    // Çalışan olarak ara
    return findEmployeeInvite(email, uid);
  }

  /// E-posta ile çalışan davetini bulur.
  Future<Map<String, dynamic>?> findEmployeeInvite(
      String email, String uid) async {
    try {
      final resp = await _client
          .get(
            Uri.parse('$_baseUrl/api/employees/lookup?email=${Uri.encodeComponent(normalizeEmail(email))}'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body);
      if (data == null) return null;

      final invite = data as Map<String, dynamic>;

      // fbUid kaydet (çalışanın Firebase UID'si)
      if (invite['fbUid'] == null) {
        try {
          await _client.put(
            Uri.parse('$_baseUrl/api/business/${invite['businessId']}/employees/${Uri.encodeComponent(normalizeEmail(email))}'),
            headers: _headers,
            body: jsonEncode({'fbUid': uid}),
          );
        } catch (_) {}
      }

      return {
        'businessId': invite['businessId'],
        'businessName': invite['businessName'] ?? '',
        'employeeName': invite['employeeName'],
        'role': invite['role'] ?? 'employee',
        'isOwner': false,
      };
    } catch (e) {
      debugPrint('CloudApi findEmployeeInvite: $e');
      return null;
    }
  }

  // ──── WHATSAPP ────

  Future<bool> updateSharedWhatsapp(String remoteId, bool shared) async {
    return updateBusinessSettings(remoteId, {'sharedWhatsapp': shared});
  }

  Future<bool?> getSharedWhatsappRemote(String remoteId) async {
    try {
      final resp = await _client
          .get(
            Uri.parse('$_baseUrl/api/business/$remoteId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return data['sharedWhatsapp'] as bool?;
      }
      return null;
    } catch (e) {
      debugPrint('CloudApi getSharedWhatsappRemote: $e');
      return null;
    }
  }

  Future<String?> getWhatsAppSessionKey(String remoteId) async {
    try {
      final resp = await _client
          .get(
            Uri.parse('$_baseUrl/api/business/$remoteId/whatsapp-session'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return data['sessionKey'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint('CloudApi getWhatsAppSessionKey: $e');
      return null;
    }
  }

  Future<bool> setWhatsAppSessionKey(String remoteId, String sessionKey) async {
    try {
      final resp = await _client
          .put(
            Uri.parse('$_baseUrl/api/business/$remoteId/whatsapp-session'),
            headers: _headers,
            body: jsonEncode({'sessionKey': sessionKey}),
          )
          .timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (e) {
      debugPrint('CloudApi setWhatsAppSessionKey: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getBusinessSettingsRemote(String remoteId) async {
    try {
      final resp = await _client
          .get(
            Uri.parse('$_baseUrl/api/business/$remoteId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return {
          if (data['workingHours'] != null) 'workingHours': data['workingHours'],
          if (data['workingDays'] != null) 'workingDays': data['workingDays'],
        };
      }
      return null;
    } catch (e) {
      debugPrint('CloudApi getBusinessSettingsRemote: $e');
      return null;
    }
  }

  // ──── VERİ SENKRONU ────

  /// Pull: cursor'dan sonraki satırları çek.
  Future<Map<String, dynamic>> syncPull(
      String businessId, int cursor, String deviceId) async {
    try {
      final resp = await _client
          .post(
            Uri.parse('$_baseUrl/api/sync/$businessId/pull'),
            headers: _headers,
            body: jsonEncode({
              'cursor': cursor,
              'limit': 300,
              'deviceId': deviceId,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      return {'rows': [], 'newCursor': cursor};
    } catch (e) {
      debugPrint('CloudApi syncPull: $e');
      rethrow;
    }
  }

  /// Push: kirli satırları gönder.
  Future<int> syncPush(
      String businessId, String deviceId, List<Map<String, dynamic>> rows) async {
    try {
      final resp = await _client
          .post(
            Uri.parse('$_baseUrl/api/sync/$businessId/push'),
            headers: _headers,
            body: jsonEncode({
              'deviceId': deviceId,
              'rows': rows,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return data['pushed'] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('CloudApi syncPush: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
