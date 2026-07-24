import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';
import '../services/data_sync_service.dart';

class ServiceProvider extends ChangeNotifier {
  DatabaseService? _db;
  void setDatabase(DatabaseService db) { _db = db; }

  /// Hiç hizmet tanımlanmamış işletmeler için başlangıç listesi.
  static const List<Map<String, Object>> defaultServices = [
    {'name': 'Kesim', 'price': 150.0, 'duration': 30},
    {'name': 'Sakal', 'price': 80.0, 'duration': 20},
    {'name': 'Boyama', 'price': 350.0, 'duration': 60},
    {'name': 'Fon', 'price': 120.0, 'duration': 30},
    {'name': 'Manikür', 'price': 200.0, 'duration': 45},
    {'name': 'Pedikür', 'price': 250.0, 'duration': 45},
    {'name': 'Cilt Bakımı', 'price': 300.0, 'duration': 60},
  ];

  List<Map<String, dynamic>> _services = [];
  String _query = '';
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get services => _services;
  String get query => _query;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Arama kutusuna göre süzülmüş liste. Toplu zam da bunun üzerine uygulanır.
  List<Map<String, dynamic>> get filteredServices {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _services;
    return _services.where((s) {
      final name = (s['name'] as String?)?.toLowerCase() ?? '';
      final category = (s['category'] as String?)?.toLowerCase() ?? '';
      return name.contains(q) || category.contains(q);
    }).toList();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> loadServices(int businessId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _db!.getActiveServices(businessId);
      _services = result.map((s) => {
        'id': s.id,
        'businessId': s.businessId,
        'name': s.name,
        'description': s.description,
        'duration': s.duration,
        'price': s.price,
        'category': s.category,
      }).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addService(Map<String, dynamic> data) async {
    try {
      await _db!.addService(ServicesCompanion.insert(
        businessId: data['businessId'] as int,
        name: data['name'] as String,
        duration: data['duration'] as int,
        price: data['price'] as double,
        category: Value(data['category'] as String?),
      ));
      await loadServices(data['businessId'] as int);
      DataSyncService.instance.nudge();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateService(int id, Map<String, dynamic> data) async {
    try {
      await _db!.updateService(id, ServicesCompanion(
        name: Value(data['name'] as String),
        duration: Value(data['duration'] as int),
        price: Value(data['price'] as double),
        category: Value(data['category'] as String?),
      ));
      await loadServices(data['businessId'] as int);
      DataSyncService.instance.nudge();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deactivateService(int id, int businessId) async {
    try {
      await _db!.deactivateService(id);
      await loadServices(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toplu zam. [serviceIds] verilmezse işletmedeki tüm aktif hizmetlere uygulanır.
  Future<bool> bulkAdjustPrices({
    required int businessId,
    required double value,
    required bool isPercent,
    List<int>? serviceIds,
  }) async {
    try {
      await _db!.bulkAdjustServicePrices(
        businessId,
        value: value,
        isPercent: isPercent,
        serviceIds: serviceIds,
      );
      await loadServices(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> seedDefaults(int businessId) async {
    try {
      for (final s in defaultServices) {
        await _db!.addService(ServicesCompanion.insert(
          businessId: businessId,
          name: s['name'] as String,
          duration: s['duration'] as int,
          price: s['price'] as double,
        ));
      }
      await loadServices(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
