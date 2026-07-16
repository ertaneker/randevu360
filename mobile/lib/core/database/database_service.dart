import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
])
class DatabaseService extends _$DatabaseService {
  DatabaseService() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
    },
  );

  /// Veritabanının tutarlı bir kopyasını [targetPath] konumuna yazar
  /// (Google Drive yedeklemesi için; açık DB dosyasını kopyalamak güvenli değil).
  Future<void> exportTo(String targetPath) async {
    final escaped = targetPath.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$escaped'");
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'randevu360.db'));

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
}

// --- Employee Queries ---
extension EmployeeQueries on DatabaseService {
  Future<int> addEmployee(EmployeesCompanion emp) =>
      into(employees).insert(emp);

  Future<List<Employee>> getEmployees(int businessId) =>
      (select(employees)..where((t) => t.businessId.equals(businessId))).get();

  Future<Employee?> getEmployeeByEmail(String email) =>
      (select(employees)..where((t) => t.email.equals(email))).getSingleOrNull();

  Future<int> updateEmployeeRole(int id, String role) {
    return (update(employees)..where((t) => t.id.equals(id)))
        .write(EmployeesCompanion(role: Value(role)));
  }

  Future<int> deleteEmployee(int id) {
    return (delete(employees)..where((t) => t.id.equals(id))).go();
  }
}

// --- Appointment Queries ---
extension AppointmentQueries on DatabaseService {
  Stream<List<Appointment>> watchAppointments(int businessId) {
    return (select(appointments)
      ..where((t) => t.businessId.equals(businessId))
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
      WHERE a.business_id = ?
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
      ..where((t) => t.businessId.equals(businessId) & t.date.equals(dateStr))
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

  Future<List<Transaction>> getTransactions(int businessId,
      {DateTime? start, DateTime? end}) {
    return (select(transactions)
      ..where((t) => t.businessId.equals(businessId))
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
      'WHERE business_id = ? AND date >= ? AND date <= ? GROUP BY status',
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
      "AND status = 'completed' GROUP BY employee_id",
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
      "WHERE business_id = ? AND type = 'income' "
      "AND strftime('%Y', date) = ? AND strftime('%m', date) = ?",
      variables: [Variable(businessId), Variable('$year'), Variable(month.toString().padLeft(2, '0'))],
    ).getSingle().then((r) => (r.data['total'] as num).toDouble());
  }

  Future<double> getTotalExpense(int businessId, {required int year, required int month}) {
    return customSelect(
      "SELECT COALESCE(SUM(amount), 0) as total FROM transactions "
      "WHERE business_id = ? AND type = 'expense' "
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
      (select(customers)..where((t) => t.businessId.equals(businessId))).get();

  Future<Customer?> getCustomerByPhone(String phone) =>
      (select(customers)..where((t) => t.phone.equals(phone))).getSingleOrNull();
}

// --- Service Queries ---
extension ServiceQueries on DatabaseService {
  Future<int> addService(ServicesCompanion service) =>
      into(services).insert(service);

  Future<List<Service>> getServices(int businessId) =>
      (select(services)
        ..where((t) => t.businessId.equals(businessId))
        ..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])
      ).get();

  Future<List<Service>> getActiveServices(int businessId) =>
      (select(services)
        ..where((t) => t.businessId.equals(businessId) & t.status.equals('active'))
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

  Future<int> deleteService(int id) {
    return (delete(services)..where((t) => t.id.equals(id))).go();
  }

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
        ..where((t) => t.businessId.equals(businessId))
        ..orderBy([(t) => OrderingTerm(expression: t.name)])
      ).get();

  Future<int> addCategory(TransactionCategoriesCompanion category) =>
      into(transactionCategories).insert(category);

  Future<int> deleteCategory(int id) =>
      (delete(transactionCategories)..where((t) => t.id.equals(id))).go();
}

// --- Debt Queries ---
extension DebtQueries on DatabaseService {
  Future<int> addDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<List<Debt>> getCustomerDebts(int customerId) =>
      (select(debts)..where((t) => t.customerId.equals(customerId))).get();

  Future<List<Debt>> getPendingDebts(int businessId) =>
      (select(debts)
        ..where((t) =>
            t.businessId.equals(businessId) &
            t.status.isIn(['pending', 'partial']))
      ).get();

  /// Müşterinin açık borçları, en eskisi önce (tahsilat bu sırayla düşülür).
  Future<List<Debt>> getOpenDebtsForCustomer(int businessId, int customerId) =>
      (select(debts)
        ..where((t) =>
            t.businessId.equals(businessId) &
            t.customerId.equals(customerId) &
            t.status.isIn(['pending', 'partial']))
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
