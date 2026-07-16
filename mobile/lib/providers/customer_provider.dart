import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';

class CustomerProvider extends ChangeNotifier {
  DatabaseService? _db;

  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setDatabase(DatabaseService db) {
    _db = db;
  }

  Future<void> loadCustomers(int businessId) async {
    if (_db == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _db!.getCustomers(businessId);
      _customers = result.map((c) => {
        'id': c.id,
        'businessId': c.businessId,
        'name': c.name,
        'phone': c.phone,
        'email': c.email,
        'note': c.note,
        'source': c.source,
        'totalDebt': c.totalDebt,
        'createdAt': c.createdAt,
      }).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCustomer(Map<String, dynamic> data) async {
    if (_db == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _db!.addCustomer(CustomersCompanion(
        businessId: Value(data['businessId']),
        name: Value(data['name']),
        phone: Value(data['phone']),
        email: Value(data['email'] ?? ''),
        note: Value(data['note'] ?? ''),
        source: Value(data['source'] ?? 'manual'),
        totalDebt: const Value(0),
        createdAt: Value(DateTime.now().toIso8601String()),
      ));

      // Reload to refresh customer list
      await loadCustomers(data['businessId']);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCustomerByPhone(String phone) async {
    if (_db == null) return null;

    try {
      final result = await _db!.getCustomerByPhone(phone);
      if (result == null) return null;
      return {
        'id': result.id,
        'businessId': result.businessId,
        'name': result.name,
        'phone': result.phone,
        'email': result.email,
        'note': result.note,
        'source': result.source,
        'totalDebt': result.totalDebt,
        'createdAt': result.createdAt,
      };
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
