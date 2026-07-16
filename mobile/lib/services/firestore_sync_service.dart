import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore: sadece çalışan senkronizasyonu ve cross-device veri paylaşımı için.
/// Tüm ana veriler SQLite'da, sadece minimal özet Firestore'da.
///
/// Multi-tenant kimlik modeli:
/// - Firestore doc ID (remoteId) = işletme sahibinin Firebase UID'si.
///   Global olarak benzersizdir; yerel SQLite int id'leri cihaza özeldir.
/// - Çalışan e-postaları her zaman küçük harfe normalize edilir
///   (Google hesap e-postaları küçük harftir, davet eşleşmesi buna dayanır).
class FirestoreSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String normalizeEmail(String email) => email.trim().toLowerCase();

  // ──── İŞLETME KAYDI ────
  /// İşletme dokümanını oluşturur veya günceller (merge).
  /// [remoteId] = sahibin Firebase UID'si.
  Future<void> upsertBusiness({
    required String remoteId,
    required String name,
    required String ownerUid,
    required String ownerEmail,
    required String ownerName,
  }) async {
    final email = normalizeEmail(ownerEmail);
    await _firestore.collection('businesses').doc(remoteId).set({
      'name': name,
      'ownerUid': ownerUid,
      'ownerEmail': email,
      'ownerName': ownerName,
      'employees': FieldValue.arrayUnion([email]),
      'admins': FieldValue.arrayUnion([ownerUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ──── ÇALIŞAN YÖNETİMİ ────
  /// Çalışan davetini Firestore'a yazar. İşletme dokümanı yoksa
  /// [ownerUid]/[ownerEmail]/[ownerName]/[businessName] ile oluşturur —
  /// sessizce başarısız olmaz.
  Future<void> addEmployee({
    required String businessRemoteId,
    required String email,
    required String name,
    required String role,
    required String ownerUid,
    required String ownerEmail,
    required String ownerName,
    required String businessName,
  }) async {
    final normalized = normalizeEmail(email);
    final businessRef =
        _firestore.collection('businesses').doc(businessRemoteId);

    // İşletme dokümanı garanti altına al (eski kurulumlarda eksik olabilir)
    await upsertBusiness(
      remoteId: businessRemoteId,
      name: businessName,
      ownerUid: ownerUid,
      ownerEmail: ownerEmail,
      ownerName: ownerName,
    );

    await businessRef.update({
      'employees': FieldValue.arrayUnion([normalized]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await businessRef.collection('employees').doc(normalized).set({
      'name': name,
      'email': normalized,
      'role': role,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeEmployee(String businessRemoteId, String email) async {
    final normalized = normalizeEmail(email);
    final businessRef =
        _firestore.collection('businesses').doc(businessRemoteId);

    await businessRef.update({
      'employees': FieldValue.arrayRemove([normalized]),
    });
    await businessRef.collection('employees').doc(normalized).delete();
  }

  Future<void> updateEmployeeRole(
    String businessRemoteId,
    String email,
    String newRole,
  ) async {
    await _firestore
        .collection('businesses')
        .doc(businessRemoteId)
        .collection('employees')
        .doc(normalizeEmail(email))
        .update({'role': newRole});
  }

  // ──── ÇALIŞAN VERİSİNİ OKU ────
  /// Girişte kullanıcının işletme bağlantısını çözer:
  /// önce sahip mi, değilse davetli çalışan mı.
  Future<Map<String, dynamic>?> getEmployeeData(
    String email,
    String uid,
  ) async {
    // Sahip mi? (doc ID = ownerUid olduğu için direkt lookup)
    final ownDoc =
        await _firestore.collection('businesses').doc(uid).get();
    if (ownDoc.exists) {
      return {
        'businessId': ownDoc.id,
        'businessName': ownDoc.data()?['name'] ?? '',
        'role': 'admin',
        'isOwner': true,
      };
    }

    // Eski kurulumlar: doc ID sayısal olabilir, ownerUid alanından ara
    final legacy = await _firestore
        .collection('businesses')
        .where('ownerUid', isEqualTo: uid)
        .limit(1)
        .get();
    if (legacy.docs.isNotEmpty) {
      final doc = legacy.docs.first;
      return {
        'businessId': doc.id,
        'businessName': doc.data()['name'] ?? '',
        'role': 'admin',
        'isOwner': true,
      };
    }

    // Çalışan olarak ara
    return findEmployeeInvite(email, uid);
  }

  /// E-posta ile çalışan davetini bulur.
  /// Dönen 'businessId' Firestore doc ID'sidir (remoteId, String).
  Future<Map<String, dynamic>?> findEmployeeInvite(
    String email,
    String uid,
  ) async {
    final normalized = normalizeEmail(email);
    final businesses = await _firestore
        .collection('businesses')
        .where('employees', arrayContains: normalized)
        .get();

    if (businesses.docs.isEmpty) return null;

    final doc = businesses.docs.first;
    final employeeDoc =
        await doc.reference.collection('employees').doc(normalized).get();
    final employeeData = employeeDoc.data();

    // fbUid'i kaydet (rules izin vermezse akışı bozma)
    if (employeeData != null && employeeData['fbUid'] == null) {
      try {
        await doc.reference
            .collection('employees')
            .doc(normalized)
            .update({'fbUid': uid});
      } catch (_) {
        // Yazma izni yoksa önemli değil; giriş devam eder
      }
    }

    return {
      'businessId': doc.id,
      'businessName': doc.data()['name'] ?? '',
      'employeeName': employeeData?['name'],
      'role': employeeData?['role'] ?? 'employee',
      'isOwner': false,
    };
  }

  // ──── RANDEVU ÖZETİ (senkronizasyon için) ────
  Future<void> syncAppointment(
      String businessRemoteId, Map<String, dynamic> apt) async {
    await _firestore
        .collection('businesses')
        .doc(businessRemoteId)
        .collection('appointments')
        .doc('${apt['id']}')
        .set({
      'customerName': apt['customerName'],
      'date': apt['date'],
      'time': apt['time'],
      'employeeId': apt['employeeId'],
      'status': apt['status'],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ──── WHATSAPP BİLDİRİMİ ────
  Future<void> checkPendingNotifications() async {
    // TODO: Yaklaşan randevuları kontrol et, bildirim zamanı geldiyse push gönder
  }
}
