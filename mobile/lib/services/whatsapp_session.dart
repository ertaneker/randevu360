import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../core/database/database_service.dart';
import '../providers/auth_provider.dart';
import '../providers/business_provider.dart';
import 'cloud_api_service.dart';

/// Gönderim/bağlantı için WhatsApp oturum anahtarını çözer.
///
/// Sunucu (Baileys) oturumları bu anahtarla ayırır:
/// - Yönetici veya "Ortak WhatsApp Hattı" açıkken: işletme anahtarı
///   (yöneticinin bağladığı hat kullanılır).
/// - Ortak hat kapalıyken çalışan: kendi anahtarı (`{bizId}_emp{empId}`) —
///   çalışan kendi WhatsApp hesabını bağlar ve oradan gönderir.
///
/// sharedWhatsapp önce Firestore'dan okunur (yönetici başka cihazda
/// değiştirmiş olabilir); çevrimdışıysa yerel DB değerine başvurulur.
Future<String> resolveWhatsAppSessionKey(BuildContext context) async {
  final auth = context.read<AuthProvider>();
  final bizProv = context.read<BusinessProvider>();
  final db = context.read<DatabaseService>();

  if (bizProv.business == null) {
    await bizProv.loadBusiness();
  }
  final business = bizProv.business;
  final businessKey = business?['id']?.toString() ?? 'unknown';

  if (auth.isAdmin) return businessKey;

  // Çalışan: sharedWhatsapp değerini Firestore'dan oku (güncel olanı),
  // çevrimdışıysa yerel değere başvur.
  bool shared = business?['sharedWhatsapp'] == true;
  final remoteId = business?['remoteId'] as String?;
  if (remoteId != null && remoteId.isNotEmpty) {
    try {
      final remote = await CloudApiService()
          .getSharedWhatsappRemote(remoteId)
          .timeout(const Duration(seconds: 5));
      if (remote != null) {
        shared = remote;
        // Yerel değeri Firestore ile güncelle
        if (business != null) {
          await db.setSharedWhatsapp(business['id'] as int, shared);
          await bizProv.loadBusiness();
        }
      }
    } catch (_) {
      // Çevrimdışı — yerel değer kullanılır
    }
  }

  if (shared) return businessKey;

  final email = auth.user?.email;
  if (email == null) return businessKey;
  final employee = await db.getEmployeeByEmail(email);
  if (employee == null) return businessKey;

  return '${businessKey}_emp${employee.id}';
}
