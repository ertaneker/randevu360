import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drift/drift.dart' show Value;
import '../core/auth/auth_service.dart';
import '../core/database/database_service.dart';
import '../services/data_sync_service.dart';
import '../services/cloud_api_service.dart';

class AuthProvider extends ChangeNotifier {
  final IAuthService _authService;
  DatabaseService? _db;
  AuthStatus _status = AuthStatus.loading;
  User? _user;
  String? _errorMessage;
  Map<String, dynamic>? _businessData;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _businessData?['role'] == 'admin';
  Map<String, dynamic>? get businessData => _businessData;

  AuthProvider({IAuthService? authService, DatabaseService? databaseService})
      : _authService = authService ?? AuthService(),
        _db = databaseService {
    Future.microtask(() => _checkAuthState());
  }

  void setDatabase(DatabaseService db) {
    _db = db;
  }

  void _checkAuthState() {
    _authService.authStateChanges.listen((User? user) async {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
        _user = null;
        _businessData = null;
        notifyListeners();
        return;
      }

      _user = user;
      _status = AuthStatus.checking;
      notifyListeners();

      await _syncBusinessData(user);

      _status = AuthStatus.authenticated;
      notifyListeners();
    });
  }

  Future<void> _syncBusinessData(User user) async {
    // 1. Try local SQLite first — instant, works offline, no network delay
    if (_db != null) {
      _businessData = await _resolveRoleFromLocalDb(user);
    }

    // 2. Yerel kayıt çalışan girişiyse Firestore'dan hâlâ davetli mi doğrula —
    //    işletme sahibi çalışanı sildiyse cihazdaki kayıt tek başına yeterli değil.
    if (_businessData != null && _businessData!['viaEmployee'] == true) {
      await _verifyEmployeeStillActive(user);
    }

    // 3. Already found locally — skip Firestore, we're done
    if (_businessData != null) return;

    // 4. No local data — new user, try Firestore
    try {
      final api = CloudApiService();
      _businessData = await api.getEmployeeData(user.email ?? '', user.uid);
    } catch (_) {
      _businessData = null;
    }

    // 5. Firestore kullanıcıyı tanıdı ama yerel DB'de işletme yok (uygulama
    //    yeniden kurulmuş / veri silinmiş). İşletme satırını yerelde yeniden
    //    oluştur; yoksa tüm ekranlar "işletme bilgisi bulunamadı" der.
    //    Detay veriler (müşteri, randevu, finans) local-first olduğundan
    //    ancak Drive yedeğinden geri gelir.
    if (_businessData != null && _db != null) {
      await _restoreLocalBusiness(user);
    }
  }

  /// Çalışan daveti Firestore'dan silinmişse yerel kaydı da temizler;
  /// kullanıcı RoleSelectionScreen'e düşer. Çevrimdışıyken (sorgu hatası)
  /// yerel kayıt korunur — erişim kesilmez.
  Future<void> _verifyEmployeeStillActive(User user) async {
    try {
      final api = CloudApiService();
      final invite =
          await api.findEmployeeInvite(user.email ?? '', user.uid);
      if (invite == null) {
        await _db?.deleteEmployeeByEmail(user.email ?? '');
        _businessData = null;
      }
    } catch (_) {
      // Doğrulanamadı (çevrimdışı vb.) — yerel oturum devam eder
    }
  }

  /// Firestore'daki işletme bağlantısından yerel Businesses satırını kurar.
  Future<void> _restoreLocalBusiness(User user) async {
    try {
      final remoteId = _businessData!['businessId']?.toString();
      if (remoteId == null || remoteId.isEmpty) return;

      final existing = await _db!.getBusinessByRemoteId(remoteId);
      if (existing != null) return;

      final isOwner = _businessData!['isOwner'] == true;
      final now = DateTime.now().toIso8601String();
      await _db!.saveBusiness(BusinessesCompanion.insert(
        remoteId: Value(remoteId),
        name: _businessData!['businessName']?.toString() ?? '',
        phone: '',
        address: '',
        email: Value(user.email),
        ownerName: isOwner ? (user.displayName ?? '') : '',
        // remoteId = sahibin Firebase UID'si; çalışan cihazında da bu saklanır
        ownerFbUid: isOwner ? user.uid : remoteId,
        workingDays: jsonEncode(['mon', 'tue', 'wed', 'thu', 'fri', 'sat']),
        workingHours: jsonEncode({'start': '09:00', 'end': '19:00'}),
        createdAt: now,
        updatedAt: now,
      ));
    } catch (_) {
      // Oluşturulamadıysa kullanıcı kurulum ekranından devam edebilir
    }
  }

  /// Check local SQLite to determine if this user is an owner or employee.
  Future<Map<String, dynamic>?> _resolveRoleFromLocalDb(User user) async {
    try {
      // Check if user is the business owner (by Firebase UID)
      final business = await _db!.getMyBusiness();
      if (business != null && business.ownerFbUid == user.uid) {
        return {
          'role': 'admin',
          'isOwner': true,
          'businessId': business.id,
          'businessName': business.name,
          'source': 'local',
        };
      }

      // Check if user is an employee (by email)
      final employee = await _db!.getEmployeeByEmail(user.email ?? '');
      if (employee != null) {
        return {
          'role': employee.role,
          'isOwner': employee.role == 'admin',
          'businessId': employee.businessId,
          'source': 'local',
          'viaEmployee': true,
        };
      }
    } catch (_) {
      // SQLite read failed — user will see RoleSelectionScreen
    }
    return null;
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.signInWithGoogle();
      if (result == null) {
        // User cancelled the sign-in sheet
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // The authStateChanges stream listener fires during signInWithGoogle
      // and may have already resolved the role. If not, resolve here.
      if (_businessData == null) {
        _user = result.user;
        await _syncBusinessData(result.user!);
      }

      // Don't overwrite status if stream already set it to authenticated
      if (_status != AuthStatus.authenticated) {
        _status = AuthStatus.authenticated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    // Senkron motorunu durdur — oturum değişiminde eski remoteId ile
    // Firestore'a yazmaya devam etmesin (PERMISSION_DENIED).
    try {
      DataSyncService.instance.stop();
    } catch (_) {
      // Test ortamında Firebase init olmadığında ignore
    }
    try {
      await _authService.signOut();
    } catch (_) {
      // Firebase/Google sign-out may fail, but we still clear local state
    }
    _user = null;
    _status = AuthStatus.unauthenticated;
    _businessData = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void setRole(String role) {
    _businessData = {
      'role': role,
      'isOwner': role == 'admin',
    };
    notifyListeners();
  }

  /// Rol + işletme bilgisini birlikte kurar (çalışan/sahip girişi sonrası).
  void setSession({
    required String role,
    int? businessId,
    String? businessName,
  }) {
    _businessData = {
      'role': role,
      'isOwner': role == 'admin',
      if (businessId != null) 'businessId': businessId,
      if (businessName != null) 'businessName': businessName,
    };
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
