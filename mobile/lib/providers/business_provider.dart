import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';
import '../services/firestore_sync_service.dart';
import 'dart:convert';

class BusinessProvider extends ChangeNotifier {
  DatabaseService? _db;
  Map<String, dynamic>? _business;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get business => _business;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSetupComplete => _business != null;

  void setDatabase(DatabaseService db) {
    _db = db;
  }

  Future<void> loadBusiness() async {
    if (_db == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Fix duplicate rows from previous buggy saveBusiness
      await _db!.cleanupDuplicateBusinesses();
      final result = await _db!.getMyBusiness();
      if (result != null) {
        _business = {
          'id': result.id,
          'remoteId': result.remoteId,
          'name': result.name,
          'phone': result.phone,
          'address': result.address,
          'email': result.email,
          'ownerName': result.ownerName,
          'workingDays': jsonDecode(result.workingDays),
          'workingHours': jsonDecode(result.workingHours),
          'status': result.status,
        };
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveBusiness(Map<String, dynamic> data) async {
    if (_db == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Upsert: check if business already exists
      final existing = await _db!.getMyBusiness();
      final ownerName = data['ownerName']?.toString() ?? '';
      final ownerFbUid = data['ownerFbUid']?.toString() ?? '';

      if (existing != null) {
        await _db!.updateBusiness(BusinessesCompanion(
          id: Value(existing.id),
          remoteId: Value(existing.remoteId ??
              (ownerFbUid.isNotEmpty ? ownerFbUid : null)),
          name: Value(data['name']?.toString() ?? existing.name),
          phone: Value(data['phone']?.toString() ?? existing.phone),
          address: Value(data['address']?.toString() ?? existing.address),
          email: Value(data['email']?.toString() ?? existing.email ?? ''),
          ownerName: Value(ownerName.isNotEmpty ? ownerName : existing.ownerName),
          ownerFbUid: Value(ownerFbUid.isNotEmpty ? ownerFbUid : existing.ownerFbUid),
          workingDays: Value(jsonEncode(data['workingDays'] ?? jsonDecode(existing.workingDays))),
          workingHours: Value(jsonEncode(data['workingHours'] ?? jsonDecode(existing.workingHours))),
          createdAt: Value(existing.createdAt),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ));
      } else {
        await _db!.saveBusiness(BusinessesCompanion.insert(
          remoteId: Value(ownerFbUid.isNotEmpty ? ownerFbUid : null),
          name: data['name']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          address: data['address']?.toString() ?? '',
          ownerName: ownerName,
          ownerFbUid: ownerFbUid,
          workingDays: jsonEncode(data['workingDays'] ?? ['mon', 'tue', 'wed', 'thu', 'fri', 'sat']),
          workingHours: jsonEncode(data['workingHours'] ?? {'start': '09:00', 'end': '19:00'}),
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ));
      }

      // Sync to Firestore so returning users are recognized
      await _syncToFirestore(data, ownerFbUid);

      // Reload from DB to get auto-generated id and full data
      await loadBusiness();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _syncToFirestore(Map<String, dynamic> data, String ownerFbUid) async {
    if (ownerFbUid.isEmpty) return;
    try {
      final syncService = FirestoreSyncService();
      await syncService.upsertBusiness(
        remoteId: ownerFbUid,
        name: data['name']?.toString() ?? '',
        ownerUid: ownerFbUid,
        ownerEmail: data['email']?.toString() ?? '',
        ownerName: data['ownerName']?.toString() ?? '',
      );
    } catch (_) {
      // Firestore sync failure is non-fatal — business works locally
    }
  }

  /// Eski kurulumlar için: remoteId'si olmayan işletme satırına
  /// sahibin UID'sini yazar ve Firestore dokümanını garanti eder.
  /// Döner: remoteId (başarısızsa null).
  Future<String?> ensureRemoteId({
    required String ownerUid,
    required String ownerEmail,
    required String ownerName,
  }) async {
    if (_db == null) return null;
    var current = _business;
    if (current == null) {
      await loadBusiness();
      current = _business;
    }
    if (current == null) return null;

    var remoteId = current['remoteId'] as String?;
    if (remoteId == null || remoteId.isEmpty) {
      remoteId = ownerUid;
      await _db!.setBusinessRemoteId(current['id'] as int, remoteId);
      _business = {...current, 'remoteId': remoteId};
      notifyListeners();
    }

    try {
      final syncService = FirestoreSyncService();
      await syncService.upsertBusiness(
        remoteId: remoteId,
        name: current['name']?.toString() ?? '',
        ownerUid: ownerUid,
        ownerEmail: ownerEmail,
        ownerName: ownerName,
      );
    } catch (_) {
      // Çevrimdışıysa yerel remoteId yine de geçerli
    }
    return remoteId;
  }

  /// Çalışan cihazında, davet edilen işletme için yerel bir satır oluşturur
  /// (yoksa). Döner: yerel businessId.
  Future<int?> adoptRemoteBusiness({
    required String remoteId,
    required String name,
  }) async {
    if (_db == null) return null;
    try {
      final existing = await _db!.getBusinessByRemoteId(remoteId);
      if (existing != null) {
        await loadBusiness();
        return existing.id;
      }

      final now = DateTime.now().toIso8601String();
      final id = await _db!.saveBusiness(BusinessesCompanion.insert(
        remoteId: Value(remoteId),
        name: name,
        phone: '',
        address: '',
        ownerName: '',
        // remoteId = sahibin Firebase UID'si; yerelde de aynı anlamda saklanır
        ownerFbUid: remoteId,
        workingDays: jsonEncode(['mon', 'tue', 'wed', 'thu', 'fri', 'sat']),
        workingHours: jsonEncode({'start': '09:00', 'end': '19:00'}),
        createdAt: now,
        updatedAt: now,
      ));
      await loadBusiness();
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
