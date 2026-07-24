import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'tables.dart';

part 'database_service.g.dart';

@DriftDatabase(tables: [
  Businesses,
  Employees,
  Customers,
  Services,
  Appointments,
  AppointmentLogs,
  Transactions,
  Debts,
  MessageLogs,
  WorkingHours,
  TransactionCategories,
  EmployeePermissions,
])
class DatabaseService extends _$DatabaseService {
  DatabaseService() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  /// Cihazlar arası senkronlanan tablolar — bağımlılık sırasıyla
  /// (önce ebeveynler: FK çevirisi pull sırasında ebeveyni bulabilsin).
  List<TableInfo<Table, dynamic>> get syncedTables => [
        employees,
        customers,
        services,
        transactionCategories,
        appointments,
        transactions,
        debts,
      ];

  static const List<String> _syncColumnNames = [
    'row_uid',
    'sync_updated_at',
    'deleted_at',
    'last_synced_at',
  ];

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(businesses, businesses.remoteId);
      }
      if (from < 3) {
        await m.createTable(transactionCategories);
      }
      if (from < 4) {
        await m.createTable(employeePermissions);
        await m.addColumn(businesses, businesses.sharedWhatsapp);
      }
      if (from < 5) {
        // Cihazlar arası senkron kolonları (SyncColumns mixin)
        for (final table in syncedTables) {
          for (final name in _syncColumnNames) {
            await m.addColumn(table, table.columnsByName[name]!);
          }
        }
      }
      if (from < 6) {
        await m.addColumn(appointments, appointments.endTime);
      }
    },
    beforeOpen: (details) async {
      await _ensureSyncInfrastructure();
      // Eski duplike satırları temizle (iki cihaz bağımsız push yaptıysa)
      try {
        await cleanupDuplicateRows();
      } catch (_) {
        // Temizlik başarısız olursa akışı bozma
      }
    },
  );

  /// Senkron altyapısını idempotent kurar: UUID/timestamp backfill,
  /// row_uid unique index'leri ve UPDATE trigger'ları.
  ///
  /// Trigger, uygulama kodundaki HERHANGİ bir UPDATE'te syncUpdatedAt'i
  /// otomatik bumplar — provider'larda dokunma noktası gerekmez. Koşul,
  /// senkron motorunun kendi yazımlarını (pull-apply: sync_updated_at
  /// değişir; push-mark: last_synced_at değişir) dışarıda bırakır, yoksa
  /// sonsuz push döngüsü oluşurdu.
  Future<void> _ensureSyncInfrastructure() async {
    for (final table in syncedTables) {
      final t = table.actualTableName;

      // Backfill: eski satırlara UUID (satır başına tek tek — her satıra
      // farklı değer gerekir) ve senkron zamanı.
      final missing = await customSelect(
        'SELECT id FROM $t WHERE row_uid IS NULL',
      ).get();
      for (final row in missing) {
        await customStatement(
          'UPDATE $t SET row_uid = ? WHERE id = ?',
          [const Uuid().v4(), row.data['id']],
        );
      }
      await customStatement(
        "UPDATE $t SET sync_updated_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') "
        'WHERE sync_updated_at IS NULL',
      );

      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_${t}_row_uid ON $t (row_uid)',
      );
      await customStatement('''
        CREATE TRIGGER IF NOT EXISTS trg_${t}_sync_touch
        AFTER UPDATE ON $t
        FOR EACH ROW
        WHEN NEW.sync_updated_at IS OLD.sync_updated_at
         AND NEW.last_synced_at IS OLD.last_synced_at
        BEGIN
          UPDATE $t SET sync_updated_at = strftime('%Y-%m-%dT%H:%M:%fZ','now')
          WHERE id = NEW.id;
        END
      ''');
    }
  }

  /// Veritabanının tutarlı bir kopyasını [targetPath] konumuna yazar
  /// (Google Drive yedeklemesi için; açık DB dosyasını kopyalamak güvenli değil).
  Future<void> exportTo(String targetPath) async {
    final escaped = targetPath.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$escaped'");
  }

  /// Tüm tablolardaki verileri siler (cihazda başka işletmeye ait veri
  /// kaldığında taze kurulum için). Şema korunur.
  Future<void> wipeAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'esnaftakvim.db'));

      // Drive'dan indirilen yedek varsa DB açılmadan önce devreye al.
      // WAL/SHM/journal dosyaları eski veritabanına ait — kalırlarsa
      // geri yüklenen dosyanın üzerine oynatılır, o yüzden silinmeli.
      final pending = File(p.join(dir.path, 'restore_pending.db'));
      if (await pending.exists()) {
        for (final suffix in ['-wal', '-shm', '-journal']) {
          final side = File('${file.path}$suffix');
          if (await side.exists()) await side.delete();
        }
        await pending.rename(file.path);
      }

      return NativeDatabase(file);
    });
  }
}

// --- Business Queries ---
extension BusinessQueries on DatabaseService {
  Future<int> saveBusiness(BusinessesCompanion business) =>
      into(businesses).insert(business);

  Future<Business?> getBusiness(int id) =>
      (select(businesses)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Business?> getMyBusiness() async {
    // Use LIMIT 1 to avoid "more than one row" error from duplicate inserts
    final rows = await (select(businesses)
      ..limit(1)
    ).get();
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Delete duplicate business rows, keeping only the first one.
  Future<void> cleanupDuplicateBusinesses() async {
    final allRows = await select(businesses).get();
    if (allRows.length > 1) {
      final toDelete = allRows.sublist(1);
      for (final row in toDelete) {
        await (delete(businesses)..where((t) => t.id.equals(row.id))).go();
      }
    }
  }

  Future<bool> updateBusiness(BusinessesCompanion business) =>
      update(businesses).replace(business);

  Future<Business?> getBusinessByRemoteId(String remoteId) =>
      (select(businesses)..where((t) => t.remoteId.equals(remoteId)))
          .getSingleOrNull();

  Future<int> setBusinessRemoteId(int id, String remoteId) {
    return (update(businesses)..where((t) => t.id.equals(id)))
        .write(BusinessesCompanion(remoteId: Value(remoteId)));
  }

  Future<int> setSharedWhatsapp(int id, bool value) {
    return (update(businesses)..where((t) => t.id.equals(id)))
        .write(BusinessesCompanion(sharedWhatsapp: Value(value)));
  }

  /// Çalışan cihazında Firestore'dan gelen çalışma saatlerini
  /// direkt DB'ye yazar (saveBusiness'tan bağımsız, Firestore yazma yok).
  Future<void> updateBusinessWorkingHours(int id, {
    required Map<String, dynamic> workingHours,
    List<dynamic>? workingDays,
  }) async {
    final now = DateTime.now().toIso8601String();
    if (workingDays != null) {
      await customStatement(
        'UPDATE businesses SET working_hours = ?, working_days = ?, updated_at = ? WHERE id = ?',
        [jsonEncode(workingHours), jsonEncode(workingDays), now, id],
      );
    } else {
      await customStatement(
        'UPDATE businesses SET working_hours = ?, updated_at = ? WHERE id = ?',
        [jsonEncode(workingHours), now, id],
      );
    }
  }
}

// --- Employee Queries ---
extension EmployeeQueries on DatabaseService {
  Future<int> addEmployee(EmployeesCompanion emp) =>
      into(employees).insert(emp);

  Future<List<Employee>> getEmployees(int businessId) =>
      (select(employees)
            ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull()))
          .get();

  Future<Employee?> getEmployeeByEmail(String email) =>
      (select(employees)
            ..where((t) => t.email.equals(email) & t.deletedAt.isNull()))
          .getSingleOrNull();

  Future<int> updateEmployeeRole(int id, String role) {
    return (update(employees)..where((t) => t.id.equals(id)))
        .write(EmployeesCompanion(role: Value(role)));
  }

  Future<int> updateEmployeeColor(int id, String color) {
    return (update(employees)..where((t) => t.id.equals(id)))
        .write(EmployeesCompanion(color: Value(color)));
  }

  /// Tombstone — silme diğer cihazlara senkronla yayılır.
  Future<void> deleteEmployee(int id) => softDeleteRow(employees, id);

  /// Yerel oturum temizliği (silinen çalışanın kendi cihazı) — senkrona
  /// yayılmaması için kasıtlı hard delete; cihaz zaten ardından sıfırlanır.
  Future<int> deleteEmployeeByEmail(String email) {
    return (delete(employees)..where((t) => t.email.equals(email))).go();
  }
}

// --- Appointment Queries ---
extension AppointmentQueries on DatabaseService {
  Stream<List<Appointment>> watchAppointments(int businessId) {
    return (select(appointments)
      ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc),
      ])
    ).watch();
  }

  /// Returns appointments with customer, employee, and service names resolved.
  Stream<List<Map<String, dynamic>>> watchAppointmentsWithDetails(int businessId) {
    return customSelect(
      '''
      SELECT
        a.*,
        c.name AS customer_name,
        c.phone AS customer_phone,
        e.name AS employee_name,
        s.name AS service_name,
        s.duration AS service_duration
      FROM appointments a
      LEFT JOIN customers c ON a.customer_id = c.id
      LEFT JOIN employees e ON a.employee_id = e.id
      LEFT JOIN services s ON a.service_id = s.id
      WHERE a.business_id = ? AND a.deleted_at IS NULL
      ORDER BY a.date ASC, a.time ASC
      ''',
      variables: [Variable(businessId)],
      readsFrom: {appointments, customers, employees, services},
    ).watch().map((rows) => rows.map(_mapJoinedRow).toList());
  }

  Map<String, dynamic> _mapJoinedRow(QueryRow row) {
    final data = row.data;
    return {
      'id': data['id'] as int,
      'businessId': data['business_id'] as int,
      'customerId': data['customer_id'] as int,
      'employeeId': data['employee_id'] as int?,
      'serviceId': data['service_id'] as int?,
      'date': data['date'] as String,
      'time': data['time'] as String,
      'endTime': data['end_time'] as String?,
      'price': (data['price'] as num?)?.toDouble(),
      'status': data['status'] as String,
      'note': data['note'] as String?,
      'createdBy': data['created_by'] as String,
      'customerName': data['customer_name'] as String?,
      'customerPhone': data['customer_phone'] as String?,
      'employeeName': data['employee_name'] as String?,
      'serviceName': data['service_name'] as String?,
      'serviceDuration': data['service_duration'] as int?,
      'notified24h': (data['notified_24h'] as int?) == 1,
      'notified5h': (data['notified_5h'] as int?) == 1,
      'notified1h': (data['notified_1h'] as int?) == 1,
    };
  }

  Future<int> createAppointment(AppointmentsCompanion apt) =>
      into(appointments).insert(apt);

  Future<int> updateAppointmentStatus(int id, String status) {
    return (update(appointments)..where((t) => t.id.equals(id)))
        .write(AppointmentsCompanion(status: Value(status)));
  }

  Future<List<Appointment>> getAppointmentsByDate(int businessId, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return (select(appointments)
      ..where((t) =>
          t.businessId.equals(businessId) &
          t.date.equals(dateStr) &
          t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc)])
    ).get();
  }
}

// --- Appointment Log Queries ---
extension AppointmentLogQueries on DatabaseService {
  Future<int> addAppointmentLog(AppointmentLogsCompanion log) =>
      into(appointmentLogs).insert(log);

  Future<List<AppointmentLog>> getAppointmentLogs(int appointmentId) =>
      (select(appointmentLogs)
        ..where((t) => t.appointmentId.equals(appointmentId))
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
      ).get();
}

// --- Finance Queries ---
extension FinanceQueries on DatabaseService {
  Future<int> addTransaction(TransactionsCompanion tx) =>
      into(transactions).insert(tx);

  /// Hatalı girilen gelir/gider/tahsilat düzeltilir; appointmentId ve
  /// customerId'ye dokunulmaz (ilişkili randevu/müşteri değişmez).
  Future<int> updateTransaction(int id, TransactionsCompanion tx) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(tx);
  }

  /// Hatalı işlem kaydı silinir (tombstone — geçmiş senkronu bozmaz).
  Future<void> deleteTransaction(int id) => softDeleteRow(transactions, id);

  Future<List<Transaction>> getTransactions(int businessId,
      {DateTime? start, DateTime? end}) {
    return (select(transactions)
      ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).get();
  }

  /// İstatistik ekranı için tarih aralığındaki işlemler; randevu üzerinden
  /// çalışan, müşteri tablosundan isim bağlanır.
  Future<List<Map<String, dynamic>>> getTransactionsDetailed(
      int businessId, String startDate, String endDate) {
    return customSelect(
      '''
      SELECT t.id, t.type, t.amount, t.payment_method, t.category, t.date,
             t.customer_id,
             a.employee_id AS employee_id,
             e.name AS employee_name,
             c.name AS customer_name
      FROM transactions t
      LEFT JOIN appointments a ON a.id = t.appointment_id
      LEFT JOIN employees e ON e.id = a.employee_id
      LEFT JOIN customers c ON c.id = t.customer_id
      WHERE t.business_id = ? AND t.date >= ? AND t.date <= ?
        AND t.deleted_at IS NULL
      ORDER BY t.date
      ''',
      variables: [Variable(businessId), Variable(startDate), Variable(endDate)],
      readsFrom: {transactions, appointments, employees, customers},
    ).get().then((rows) => rows
        .map((r) => {
              'type': r.data['type'] as String,
              'amount': (r.data['amount'] as num).toDouble(),
              'paymentMethod': r.data['payment_method'] as String? ?? 'cash',
              'category': r.data['category'] as String? ?? '',
              'date': r.data['date'] as String,
              'customerId': r.data['customer_id'] as int?,
              'customerName': r.data['customer_name'] as String?,
              'employeeId': r.data['employee_id'] as int?,
              'employeeName': r.data['employee_name'] as String?,
            })
        .toList());
  }

  /// Tarih aralığındaki randevu sayıları (status -> adet).
  Future<Map<String, int>> getAppointmentStatusCounts(
      int businessId, String startDate, String endDate) {
    return customSelect(
      'SELECT status, COUNT(*) AS cnt FROM appointments '
      'WHERE business_id = ? AND date >= ? AND date <= ? '
      'AND deleted_at IS NULL GROUP BY status',
      variables: [Variable(businessId), Variable(startDate), Variable(endDate)],
      readsFrom: {appointments},
    ).get().then((rows) => {
          for (final r in rows)
            r.data['status'] as String: (r.data['cnt'] as num).toInt(),
        });
  }

  /// Çalışan başına tamamlanan randevu sayısı (istatistik ekranı).
  Future<Map<int, int>> getEmployeeCompletedCounts(
      int businessId, String startDate, String endDate) {
    return customSelect(
      "SELECT employee_id, COUNT(*) AS cnt FROM appointments "
      "WHERE business_id = ? AND date >= ? AND date <= ? "
      "AND status = 'completed' AND deleted_at IS NULL GROUP BY employee_id",
      variables: [Variable(businessId), Variable(startDate), Variable(endDate)],
      readsFrom: {appointments},
    ).get().then((rows) => {
          for (final r in rows)
            if (r.data['employee_id'] != null)
              (r.data['employee_id'] as num).toInt():
                  (r.data['cnt'] as num).toInt(),
        });
  }

  Future<double> getTotalIncome(int businessId, {required int year, required int month}) {
    return customSelect(
      "SELECT COALESCE(SUM(amount), 0) as total FROM transactions "
      "WHERE business_id = ? AND type = 'income' AND deleted_at IS NULL "
      "AND strftime('%Y', date) = ? AND strftime('%m', date) = ?",
      variables: [Variable(businessId), Variable('$year'), Variable(month.toString().padLeft(2, '0'))],
    ).getSingle().then((r) => (r.data['total'] as num).toDouble());
  }

  Future<double> getTotalExpense(int businessId, {required int year, required int month}) {
    return customSelect(
      "SELECT COALESCE(SUM(amount), 0) as total FROM transactions "
      "WHERE business_id = ? AND type = 'expense' AND deleted_at IS NULL "
      "AND strftime('%Y', date) = ? AND strftime('%m', date) = ?",
      variables: [Variable(businessId), Variable('$year'), Variable(month.toString().padLeft(2, '0'))],
    ).getSingle().then((r) => (r.data['total'] as num).toDouble());
  }
}

// --- Customer Queries ---
extension CustomerQueries on DatabaseService {
  Future<int> addCustomer(CustomersCompanion customer) =>
      into(customers).insert(customer);

  Future<List<Customer>> getCustomers(int businessId) =>
      (select(customers)
            ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull()))
          .get();

  Future<Customer?> getCustomerByPhone(String phone) =>
      (select(customers)
            ..where((t) => t.phone.equals(phone) & t.deletedAt.isNull()))
          .getSingleOrNull();
}

// --- Service Queries ---
extension ServiceQueries on DatabaseService {
  Future<int> addService(ServicesCompanion service) =>
      into(services).insert(service);

  Future<List<Service>> getServices(int businessId) =>
      (select(services)
        ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])
      ).get();

  Future<List<Service>> getActiveServices(int businessId) =>
      (select(services)
        ..where((t) =>
            t.businessId.equals(businessId) &
            t.status.equals('active') &
            t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])
      ).get();

  Future<int> updateService(int id, ServicesCompanion service) {
    return (update(services)..where((t) => t.id.equals(id)))
        .write(service);
  }

  /// Soft delete: geçmiş randevular serviceId üzerinden hizmete bağlı olduğu
  /// için satır silinmez, listelerden düşürülür.
  Future<int> deactivateService(int id) {
    return (update(services)..where((t) => t.id.equals(id)))
        .write(const ServicesCompanion(status: Value('inactive')));
  }

  /// Tombstone — silme diğer cihazlara senkronla yayılır.
  Future<void> deleteService(int id) => softDeleteRow(services, id);

  /// Toplu zam. [isPercent] true ise yüzde, false ise sabit tutar eklenir.
  /// [serviceIds] boşsa işletmedeki tüm aktif hizmetlere uygulanır.
  Future<int> bulkAdjustServicePrices(
    int businessId, {
    required double value,
    required bool isPercent,
    List<int>? serviceIds,
  }) {
    final priceExpr = isPercent ? 'price * (1 + ? / 100.0)' : 'price + ?';
    final hasIds = serviceIds != null && serviceIds.isNotEmpty;
    final idFilter =
        hasIds ? ' AND id IN (${List.filled(serviceIds.length, '?').join(',')})' : '';

    return customUpdate(
      'UPDATE services SET price = MAX(0, ROUND($priceExpr, 2)) '
      'WHERE business_id = ? AND status = \'active\'$idFilter',
      variables: [
        Variable(value),
        Variable(businessId),
        if (hasIds) ...serviceIds.map(Variable.new),
      ],
      updates: {services},
    );
  }
}

// --- Working Hours Queries ---
extension WorkingHoursQueries on DatabaseService {
  Future<int> saveWorkingHour(WorkingHoursCompanion wh) =>
      into(workingHours).insert(wh);

  Future<List<WorkingHour>> getWorkingHours(int businessId) =>
      (select(workingHours)
        ..where((t) => t.businessId.equals(businessId))
      ).get();

  Future<List<WorkingHour>> getEmployeeWorkingHours(int employeeId) =>
      (select(workingHours)
        ..where((t) => t.employeeId.equals(employeeId))
      ).get();

  Future<int> updateWorkingHour(int id, WorkingHoursCompanion wh) {
    return (update(workingHours)..where((t) => t.id.equals(id)))
        .write(wh);
  }

  Future<int> deleteWorkingHour(int id) {
    return (delete(workingHours)..where((t) => t.id.equals(id))).go();
  }
}

// --- Category Queries ---
extension CategoryQueries on DatabaseService {
  Future<List<TransactionCategory>> getCategories(int businessId) =>
      (select(transactionCategories)
        ..where((t) => t.businessId.equals(businessId) & t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.name)])
      ).get();

  Future<int> addCategory(TransactionCategoriesCompanion category) =>
      into(transactionCategories).insert(category);

  /// Tombstone — silme diğer cihazlara senkronla yayılır.
  Future<void> deleteCategory(int id) =>
      softDeleteRow(transactionCategories, id);
}

// --- Debt Queries ---
extension DebtQueries on DatabaseService {
  Future<int> addDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<List<Debt>> getCustomerDebts(int customerId) =>
      (select(debts)
            ..where((t) => t.customerId.equals(customerId) & t.deletedAt.isNull()))
          .get();

  Future<List<Debt>> getPendingDebts(int businessId) =>
      (select(debts)
        ..where((t) =>
            t.businessId.equals(businessId) &
            t.status.isIn(['pending', 'partial']) &
            t.deletedAt.isNull())
      ).get();

  /// Müşterinin açık borçları, en eskisi önce (tahsilat bu sırayla düşülür).
  Future<List<Debt>> getOpenDebtsForCustomer(int businessId, int customerId) =>
      (select(debts)
        ..where((t) =>
            t.businessId.equals(businessId) &
            t.customerId.equals(customerId) &
            t.status.isIn(['pending', 'partial']) &
            t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
      ).get();

  Future<int> updateDebtPayment(int debtId, double paidAmount, String status) =>
      (update(debts)..where((t) => t.id.equals(debtId))).write(
        DebtsCompanion(paidAmount: Value(paidAmount), status: Value(status)),
      );

  /// Açık borçlar çalışan kırılımıyla: borç, doğduğu randevunun çalışanına
  /// bağlanır (randevusuz borçlar employee_id = null döner).
  Future<List<Map<String, dynamic>>> getDebtorsByEmployee(int businessId) {
    return customSelect(
      '''
      SELECT a.employee_id AS employee_id, e.name AS employee_name,
             c.id AS customer_id, c.name AS customer_name,
             c.phone AS customer_phone,
             SUM(d.amount - d.paid_amount) AS remaining
      FROM debts d
      LEFT JOIN appointments a ON a.id = d.appointment_id
      LEFT JOIN employees e ON e.id = a.employee_id
      JOIN customers c ON c.id = d.customer_id
      WHERE d.business_id = ? AND d.status IN ('pending', 'partial')
        AND d.deleted_at IS NULL
      GROUP BY a.employee_id, c.id
      HAVING SUM(d.amount - d.paid_amount) > 0.009
      ORDER BY remaining DESC
      ''',
      variables: [Variable(businessId)],
      readsFrom: {debts, appointments, employees, customers},
    ).get().then((rows) => rows
        .map((r) => {
              'employeeId': r.data['employee_id'] as int?,
              'employeeName': r.data['employee_name'] as String?,
              'customerId': r.data['customer_id'] as int,
              'customerName': r.data['customer_name'] as String? ?? '',
              'customerPhone': r.data['customer_phone'] as String? ?? '',
              'remaining': (r.data['remaining'] as num).toDouble(),
            })
        .toList());
  }

  /// Borcu olan müşteriler: müşteri başına kalan toplam borç.
  Future<List<Map<String, dynamic>>> getDebtorsWithDetails(int businessId) {
    return customSelect(
      '''
      SELECT c.id AS customer_id, c.name AS customer_name, c.phone AS customer_phone,
             SUM(d.amount - d.paid_amount) AS remaining,
             COUNT(d.id) AS open_debts,
             MIN(d.created_at) AS oldest_debt_at
      FROM debts d
      JOIN customers c ON c.id = d.customer_id
      WHERE d.business_id = ? AND d.status IN ('pending', 'partial')
        AND d.deleted_at IS NULL
      GROUP BY c.id, c.name, c.phone
      HAVING SUM(d.amount - d.paid_amount) > 0.009
      ORDER BY remaining DESC
      ''',
      variables: [Variable(businessId)],
      readsFrom: {debts, customers},
    ).get().then((rows) => rows
        .map((r) => {
              'customerId': r.data['customer_id'] as int,
              'name': r.data['customer_name'] as String? ?? '',
              'phone': r.data['customer_phone'] as String? ?? '',
              'remaining': (r.data['remaining'] as num).toDouble(),
              'openDebts': (r.data['open_debts'] as num).toInt(),
              'oldestDebtAt': r.data['oldest_debt_at'] as String?,
            })
        .toList());
  }
}

// --- Sync Queries (DataSyncService tarafından kullanılır) ---
extension SyncQueries on DatabaseService {
  /// Push bekleyen satırlar: hiç senkronlanmamış veya son senkron sonrası
  /// değişmiş. UTC ISO string karşılaştırması kronolojiktir.
  Future<List<Map<String, dynamic>>> getDirtyRows(
      TableInfo<Table, dynamic> table, int businessId) async {
    final t = table.actualTableName;
    final rows = await customSelect(
      'SELECT * FROM $t WHERE business_id = ? AND row_uid IS NOT NULL '
      'AND sync_updated_at IS NOT NULL '
      'AND (last_synced_at IS NULL OR sync_updated_at > last_synced_at)',
      variables: [Variable(businessId)],
    ).get();
    return rows.map((r) => Map<String, dynamic>.of(r.data)).toList();
  }

  /// Başarılı push sonrası işaretle. Yalnızca last_synced_at değiştiği için
  /// sync trigger'ı tetiklenmez; push ile mark arasında satır değiştiyse
  /// sync_updated_at ileride kalır ve satır kirli kalmaya devam eder.
  Future<void> markRowSynced(
      TableInfo<Table, dynamic> table, int id, String syncUpdatedAt) {
    return customStatement(
      'UPDATE ${table.actualTableName} SET last_synced_at = ? WHERE id = ?',
      [syncUpdatedAt, id],
    );
  }

  Future<Map<String, dynamic>?> getRowByUid(
      TableInfo<Table, dynamic> table, String rowUid) async {
    final rows = await customSelect(
      'SELECT * FROM ${table.actualTableName} WHERE row_uid = ? LIMIT 1',
      variables: [Variable(rowUid)],
    ).get();
    return rows.isEmpty ? null : Map<String, dynamic>.of(rows.first.data);
  }

  Future<String?> rowUidForId(TableInfo<Table, dynamic> table, int id) async {
    final rows = await customSelect(
      'SELECT row_uid FROM ${table.actualTableName} WHERE id = ? LIMIT 1',
      variables: [Variable(id)],
    ).get();
    return rows.isEmpty ? null : rows.first.data['row_uid'] as String?;
  }

  Future<int?> localIdForUid(
      TableInfo<Table, dynamic> table, String rowUid) async {
    final rows = await customSelect(
      'SELECT id FROM ${table.actualTableName} WHERE row_uid = ? LIMIT 1',
      variables: [Variable(rowUid)],
    ).get();
    return rows.isEmpty ? null : rows.first.data['id'] as int?;
  }

  /// Tombstone: satırı fiziksel silmek yerine deleted_at doldurulur;
  /// trigger sync_updated_at'i bumplar, tombstone diğer cihazlara yayılır.
  Future<void> softDeleteRow(TableInfo<Table, dynamic> table, int id) {
    return customStatement(
      'UPDATE ${table.actualTableName} '
      "SET deleted_at = strftime('%Y-%m-%dT%H:%M:%fZ','now') WHERE id = ?",
      [id],
    );
  }

  /// Pull-apply: kolon haritasıyla insert/update. sync_updated_at ve
  /// last_synced_at birlikte remote değere çekilir — trigger tetiklenmez,
  /// satır "temiz" durur.
  Future<void> applyRemoteRow(
    TableInfo<Table, dynamic> table, {
    required Map<String, dynamic> columns,
    int? existingLocalId,
  }) async {
    final t = table.actualTableName;
    if (existingLocalId == null) {
      final cols = columns.keys.toList();
      final placeholders = List.filled(cols.length, '?').join(',');
      await customStatement(
        'INSERT INTO $t (${cols.join(',')}) VALUES ($placeholders)',
        [for (final c in cols) columns[c]],
      );
    } else {
      final cols = columns.keys.where((c) => c != 'id').toList();
      final setClause = cols.map((c) => '$c = ?').join(', ');
      await customStatement(
        'UPDATE $t SET $setClause WHERE id = ?',
        [for (final c in cols) columns[c], existingLocalId],
      );
    }
  }

  /// İki cihaz bağımsız push yaptığında oluşan duplike satırları temizler.
  /// Her dedup grubunda en yeni `sync_updated_at`'e sahip satır korunur,
  /// diğerleri tombstone yapılır. Idempotent — tekrar çağrılsa zarar vermez.
  Future<int> cleanupDuplicateRows() async {
    var removed = 0;
    // employees → email, customers → phone, services → name, kategoriler → ad
    const dedupes = {
      'employees': 'email',
      'customers': 'phone',
      'services': 'name',
      'transaction_categories': 'name',
    };
    for (final entry in dedupes.entries) {
      final t = entry.key;
      final col = entry.value;
      final dups = await customSelect(
        'SELECT $col, COUNT(*) as cnt FROM $t '
        'WHERE deleted_at IS NULL GROUP BY $col HAVING cnt > 1',
      ).get();
      for (final row in dups) {
        final val = row.data[col];
        if (val == null) continue;
        // En yeni sync_updated_at'e sahip satırı bul, diğerlerini tombstone
        final ids = await customSelect(
          'SELECT id FROM $t WHERE $col = ? AND deleted_at IS NULL '
          'ORDER BY sync_updated_at DESC',
          variables: [Variable(val)],
        ).get();
        if (ids.length < 2) continue;
        final keeper = ids.first.data['id'] as int;
        for (final dup in ids.skip(1)) {
          final dupId = dup.data['id'] as int;
          await softDeleteRow(
            _tableByName(t),
            dupId,
          );
          removed++;
        }
        // Keep duplicates' rowUids point to keeper (future syncs merge cleanly)
        if (ids.length > 1) {
          final keeperUid = (await customSelect(
            'SELECT row_uid FROM $t WHERE id = ?',
            variables: [Variable(keeper)],
          ).get()).first.data['row_uid'] as String?;
          if (keeperUid != null) {
            for (final dup in ids.skip(1)) {
              await customStatement(
                'UPDATE $t SET row_uid = ? WHERE id = ?',
                [keeperUid, dup.data['id']],
              );
            }
          }
        }
      }
    }
    return removed;
  }

  TableInfo<Table, dynamic> _tableByName(String name) {
    for (final t in syncedTables) {
      if (t.actualTableName == name) return t;
    }
    throw ArgumentError('Unknown synced table: $name');
  }
}

// --- Employee Permission Queries ---
extension EmployeePermissionQueries on DatabaseService {
  Future<EmployeePermission?> getEmployeePermissions(int employeeId) async {
    // limit(1): olası eski duplike satırlarda getSingleOrNull patlamasın
    final rows = await (select(employeePermissions)
          ..where((t) => t.employeeId.equals(employeeId))
          ..limit(1))
        .get();
    return rows.isNotEmpty ? rows.first : null;
  }

  /// employeeId'ye göre upsert — PK'ya göre değil. Aynı çalışana ikinci
  /// satır açılmasını engeller.
  Future<void> saveEmployeePermissions(EmployeePermissionsCompanion perm) async {
    final employeeId = perm.employeeId.value;
    final existing = await getEmployeePermissions(employeeId);
    if (existing == null) {
      await into(employeePermissions).insert(perm);
    } else {
      await (update(employeePermissions)
            ..where((t) => t.id.equals(existing.id)))
          .write(perm);
    }
  }

  /// Firestore'dan gelen izin haritasını yerel tabloya yazar (çalışan cihazı
  /// çevrimdışıyken son bilinen değerleri kullanabilsin).
  Future<void> cacheEmployeePermissions(
      int employeeId, int businessId, Map<String, dynamic> perms) async {
    final now = DateTime.now().toIso8601String();
    final existing = await getEmployeePermissions(employeeId);
    await saveEmployeePermissions(EmployeePermissionsCompanion(
      employeeId: Value(employeeId),
      businessId: Value(businessId),
      canSendWhatsapp:
          Value(perms['canSendWhatsapp'] as bool? ?? true),
      canBulkWhatsapp:
          Value(perms['canBulkWhatsapp'] as bool? ?? true),
      canViewFinance: Value(perms['canViewFinance'] as bool? ?? true),
      canManageServices:
          Value(perms['canManageServices'] as bool? ?? false),
      canManageEmployees:
          Value(perms['canManageEmployees'] as bool? ?? false),
      createdAt: Value(existing?.createdAt ?? now),
      updatedAt: Value(now),
    ));
  }

  Future<List<EmployeePermission>> getBusinessPermissions(int businessId) =>
      (select(employeePermissions)..where((t) => t.businessId.equals(businessId)))
          .get();

  Future<void> ensureEmployeePermission(int employeeId, int businessId) async {
    final existing = await getEmployeePermissions(employeeId);
    if (existing == null) {
      await saveEmployeePermissions(EmployeePermissionsCompanion.insert(
        employeeId: employeeId,
        businessId: businessId,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
    }
  }
}
