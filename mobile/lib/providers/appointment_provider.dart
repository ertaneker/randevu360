import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';
import '../core/backup/backup_service.dart';
import '../services/data_sync_service.dart';

class AppointmentProvider extends ChangeNotifier {
  DatabaseService? _db;
  BackupService? _backupService;
  void setDatabase(DatabaseService db) { _db = db; }

  /// Lazy-init backup and fire-and-forget a Drive backup.
  /// Sessiz giriş kullanılır — randevu kaydederken Google izin ekranı
  /// açılmamalı; izin hiç verilmemişse yedek sessizce atlanır.
  /// Errors are silently caught — never blocks the caller.
  void _triggerBackup() {
    try {
      _backupService ??= BackupService();
      _backupService!.authenticateSilently().then((ok) {
        if (ok) _backupService!.backup(_db!);
      });
    } catch (_) {}
  }

  List<Map<String, dynamic>> _appointments = [];
  Map<String, dynamic>? _selectedAppointment;
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  int? _filterEmployeeId;

  List<Map<String, dynamic>> get appointments => _appointments;
  Map<String, dynamic>? get selectedAppointment => _selectedAppointment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  int? get filterEmployeeId => _filterEmployeeId;

  // Günün randevuları
  List<Map<String, dynamic>> get todayAppointments {
    final today = DateTime.now();
    return _appointments
        .where((a) => a['date'] == _formatDate(today))
        .toList();
  }

  // Seçili günün randevuları
  List<Map<String, dynamic>> get selectedDayAppointments {
    var filtered = _appointments
        .where((a) => a['date'] == _formatDate(_selectedDate))
        .toList();
    if (_filterEmployeeId != null) {
      filtered = filtered
          .where((a) => a['employeeId'] == _filterEmployeeId)
          .toList();
    }
    return filtered;
  }

  /// Seçili günün randevularını çalışan ID'sine göre gruplandırır.
  /// Grid görünümünde her çalışan sütunundaki hücreleri doldurmak için.
  Map<int, List<Map<String, dynamic>>> get selectedDayAppointmentsByEmployee {
    final result = <int, List<Map<String, dynamic>>>{};
    for (final apt in selectedDayAppointments) {
      final empId = apt['employeeId'] as int?;
      if (empId == null) continue;
      result.putIfAbsent(empId, () => []).add(apt);
    }
    return result;
  }

  // İstatistikler
  int get totalToday => todayAppointments.length;
  int get completedToday =>
      todayAppointments.where((a) => a['status'] == 'completed').length;
  int get pendingToday =>
      todayAppointments.where((a) => a['status'] == 'pending').length;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setEmployeeFilter(int? employeeId) {
    _filterEmployeeId = employeeId;
    notifyListeners();
  }

  Future<void> loadAppointments(int businessId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = _db!;
      final result = await db.watchAppointmentsWithDetails(businessId).first;
      _appointments = result;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Oluşturulan randevunun id'sini döndürür (WhatsApp senkronu için gerekli),
  /// hata durumunda null.
  Future<int?> createAppointment(Map<String, dynamic> data) async {
    try {
      final db = _db!;
      final appointmentId = await db.createAppointment(AppointmentsCompanion(
        businessId: Value(data['businessId']),
        customerId: Value(data['customerId']),
        employeeId: Value(data['employeeId']),
        serviceId: Value(data['serviceId']),
        date: Value(data['date']),
        time: Value(data['time']),
        endTime: Value(data['endTime']),
        price: Value(data['price']),
        note: Value(data['note'] ?? ''),
        createdBy: Value(data['createdBy']),
        createdAt: Value(DateTime.now().toIso8601String()),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ));

      // Write appointment log
      await db.addAppointmentLog(AppointmentLogsCompanion.insert(
        appointmentId: appointmentId,
        action: 'created',
        performedBy: data['createdBy']?.toString() ?? 'owner',
        details: const Value('Randevu oluşturuldu'),
        createdAt: DateTime.now().toIso8601String(),
      ));

      // Reload appointments after creating to refresh the list
      await loadAppointments(data['businessId']);
      _triggerBackup();
      DataSyncService.instance.nudge();
      return appointmentId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateStatus(int appointmentId, String status) async {
    try {
      final db = _db!;
      await db.updateAppointmentStatus(appointmentId, status);

      // Write appointment log
      final statusLabel = status == 'confirmed' ? 'Onaylandı' : status == 'completed' ? 'Tamamlandı' : status == 'cancelled' ? 'İptal edildi' : 'Beklemede';
      await db.addAppointmentLog(AppointmentLogsCompanion.insert(
        appointmentId: appointmentId,
        action: 'status_changed',
        performedBy: 'owner',
        details: Value('Durum: $statusLabel'),
        createdAt: DateTime.now().toIso8601String(),
      ));

      final index = _appointments.indexWhere((a) => a['id'] == appointmentId);
      if (index != -1) {
        _appointments[index]['status'] = status;
        notifyListeners();
      }
      _triggerBackup();
      DataSyncService.instance.nudge();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Test support — injects appointment data without a live database.
  @visibleForTesting
  void setAppointmentsForTesting(List<Map<String, dynamic>> appointments) {
    _appointments = appointments;
    notifyListeners();
  }
}
