import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';
import '../services/firestore_sync_service.dart';

class EmployeeProvider extends ChangeNotifier {
  DatabaseService? _db;
  void setDatabase(DatabaseService db) { _db = db; }

  List<Map<String, dynamic>> _employees = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEmployees(int businessId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = _db!;
      final result = await db.getEmployees(businessId);
      _employees = result.map((e) => {
        'id': e.id,
        'name': e.name,
        'phone': e.phone,
        'email': e.email,
        'role': e.role,
        'fbUid': e.fbUid,
        'color': e.color,
        'status': e.status,
      }).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Çalışanı yerel DB'ye kaydeder ve davet olarak Firestore'a yazar.
  /// Firestore yazımı başarısız olursa yerel kayıt kalır ama [error]
  /// doldurulur — çalışan kendi cihazından giriş yapamaz, kullanıcıya
  /// gösterilmeli.
  Future<bool> addEmployee(Map<String, dynamic> data) async {
    final email = FirestoreSyncService.normalizeEmail(data['email'] ?? '');
    try {
      final db = _db!;
      await db.addEmployee(EmployeesCompanion(
        businessId: Value(data['businessId']),
        name: Value(data['name']),
        phone: Value(data['phone']),
        email: Value(email),
        role: Value(data['role'] ?? 'employee'),
        color: Value(data['color'] ?? '#6C63FF'),
        createdAt: Value(DateTime.now().toIso8601String()),
      ));
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }

    // Firestore'a davet yaz (çalışanın kendi cihazından girişi için şart)
    final remoteId = data['businessRemoteId'] as String?;
    if (remoteId != null && remoteId.isNotEmpty && email.isNotEmpty) {
      try {
        final syncService = FirestoreSyncService();
        await syncService.addEmployee(
          businessRemoteId: remoteId,
          email: email,
          name: data['name'] ?? '',
          role: data['role'] ?? 'employee',
          ownerUid: data['ownerUid'] ?? '',
          ownerEmail: data['ownerEmail'] ?? '',
          ownerName: data['ownerName'] ?? '',
          businessName: data['businessName'] ?? '',
        );
      } catch (e) {
        _error =
            'Çalışan yerel olarak kaydedildi ama davet buluta yazılamadı. '
            'İnternet bağlantısını kontrol edip tekrar deneyin. ($e)';
      }
    } else {
      _error =
          'Çalışan yerel olarak kaydedildi ama işletme bulut kimliği yok — '
          'davet gönderilemedi.';
    }

    await loadEmployees(data['businessId']);
    return true;
  }

  Future<bool> deleteEmployee(int employeeId, {String? businessRemoteId}) async {
    final emp = _employees.firstWhere(
      (e) => e['id'] == employeeId,
      orElse: () => const {},
    );
    try {
      final db = _db!;
      await db.deleteEmployee(employeeId);
      _employees.removeWhere((e) => e['id'] == employeeId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }

    // Firestore'dan daveti de kaldır — yoksa çalışan giriş yapmaya devam eder
    final email = emp['email'] as String?;
    if (businessRemoteId != null && email != null && email.isNotEmpty) {
      try {
        await FirestoreSyncService()
            .removeEmployee(businessRemoteId, email);
      } catch (e) {
        _error = 'Çalışan yerelden silindi ama bulut daveti kaldırılamadı: $e';
        notifyListeners();
      }
    }
    return true;
  }

  Future<bool> updateRole(int employeeId, String newRole,
      {String? businessRemoteId}) async {
    try {
      final db = _db!;
      await db.updateEmployeeRole(employeeId, newRole);

      final index = _employees.indexWhere((e) => e['id'] == employeeId);
      if (index != -1) {
        _employees[index]['role'] = newRole;
        notifyListeners();

        final email = _employees[index]['email'] as String?;
        if (businessRemoteId != null && email != null && email.isNotEmpty) {
          try {
            await FirestoreSyncService()
                .updateEmployeeRole(businessRemoteId, email, newRole);
          } catch (_) {
            // Bulut güncellenemedi; çalışan bir sonraki girişte eski rolü görür
          }
        }
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  List<Map<String, dynamic>> getAdmins() =>
      _employees.where((e) => e['role'] == 'admin').toList();

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
