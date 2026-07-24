import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../core/database/database_service.dart';
import '../providers/auth_provider.dart';
import 'cloud_api_service.dart';

/// Çalışan yetki anahtarları (EmployeePermissions tablosu alanları).
enum EmployeePermissionKey {
  sendWhatsapp,
  bulkWhatsapp,
  viewFinance,
  manageServices,
  manageEmployees,
}

/// Çalışan izinlerini çözer.
///
/// İzinler yönetici cihazında düzenlenir ve Firestore'a yazılır
/// (businesses/{remoteId}/employees/{email}.permissions). Çalışan cihazı
/// kontrol anında Firestore'dan okur ve yerel tabloya önbellekler;
/// çevrimdışıyken son bilinen yerel değerler geçerlidir.
class PermissionService {
  /// Son Firestore izin kontrolünün zamanı (aynı sayfa açılışında
  /// tekrar tekrar Firestore'a gitmeyi önler).
  static final Map<String, DateTime> _lastRemoteFetch = {};

  /// Yerel önbelleği Firestore'dan günceller. Başarısız olursa sessizce
  /// düşer — çağıran yerel değerlerle devam eder.
  static Future<void> refreshFromRemote(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (auth.isAdmin) return; // yönetici her zaman tam yetkili

    final email = auth.user?.email;
    if (email == null) return;

    final db = context.read<DatabaseService>();
    final employee = await db.getEmployeeByEmail(email);
    if (employee == null) return;

    final business = await db.getMyBusiness();
    final remoteId = business?.remoteId;
    if (remoteId == null || remoteId.isEmpty) return;

    try {
      final remote = await CloudApiService()
          .getEmployeePermissionsRemote(remoteId, email)
          .timeout(const Duration(seconds: 5));
      if (remote != null) {
        await db.cacheEmployeePermissions(
            employee.id, employee.businessId, remote);
        _lastRemoteFetch[email] = DateTime.now();
      }
    } catch (_) {
      // Çevrimdışı — yerel önbellek kullanılır
    }
  }

  /// Oturumdaki kullanıcının [key] iznine sahip olup olmadığını döner.
  /// Yönetici her zaman yetkilidir. Hiç kayıt yoksa varsayılanlar geçerli:
  /// WhatsApp/finans açık, hizmet/çalışan yönetimi kapalı.
  ///
  /// Önce yerel önbelleğe bakar; 30 sn'den eskiyse Firestore'dan tazeler.
  static Future<bool> can(
      BuildContext context, EmployeePermissionKey key) async {
    final auth = context.read<AuthProvider>();
    if (auth.isAdmin) return true;

    final email = auth.user?.email;
    if (email == null) return false;

    final db = context.read<DatabaseService>();
    final employee = await db.getEmployeeByEmail(email);
    if (employee == null) return false;

    // 30 sn'de bir Firestore'dan tazele; diğer çağrılarda yerel önbellek
    final lastFetch = _lastRemoteFetch[email];
    if (lastFetch == null ||
        DateTime.now().difference(lastFetch).inSeconds > 30) {
      // Firestore kontrolünü beklemeden önce yerel değeri dönelim;
      // arka planda tazele. UI bir sonraki build'de güncel değeri alır.
      unawaited(refreshFromRemote(context));
    }

    final p = await db.getEmployeePermissions(employee.id);
    switch (key) {
      case EmployeePermissionKey.sendWhatsapp:
        return p?.canSendWhatsapp ?? true;
      case EmployeePermissionKey.bulkWhatsapp:
        return p?.canBulkWhatsapp ?? true;
      case EmployeePermissionKey.viewFinance:
        return p?.canViewFinance ?? true;
      case EmployeePermissionKey.manageServices:
        return p?.canManageServices ?? false;
      case EmployeePermissionKey.manageEmployees:
        return p?.canManageEmployees ?? false;
    }
  }
}
