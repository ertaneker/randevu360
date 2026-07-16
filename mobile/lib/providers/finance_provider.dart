import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../core/database/database_service.dart';

class FinanceProvider extends ChangeNotifier {
  DatabaseService? _db;
  void setDatabase(DatabaseService db) { _db = db; }

  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _debts = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  bool _isLoading = false;
  String? _error;
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get debts => _debts;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get selectedYear => _selectedYear;
  int get selectedMonth => _selectedMonth;

  void setPeriod(int year, int month) {
    _selectedYear = year;
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> loadTransactions(int businessId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = _db!;
      final result = await db.getTransactions(businessId);

      _transactions = result.map((t) => {
        'id': t.id,
        'type': t.type,
        'amount': t.amount,
        'category': t.category,
        'description': t.description,
        'paymentMethod': t.paymentMethod,
        'date': t.date,
      }).toList();

      _totalIncome = await db.getTotalIncome(
        businessId,
        year: _selectedYear,
        month: _selectedMonth,
      );

      _totalExpense = await db.getTotalExpense(
        businessId,
        year: _selectedYear,
        month: _selectedMonth,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTransaction(Map<String, dynamic> data) async {
    try {
      final db = _db!;
      await db.addTransaction(TransactionsCompanion(
        businessId: Value(data['businessId']),
        type: Value(data['type']),
        amount: Value(data['amount']),
        category: Value(data['category']),
        description: Value(data['description'] ?? ''),
        paymentMethod: Value(data['paymentMethod'] ?? 'cash'),
        appointmentId: Value(data['appointmentId']),
        customerId: Value(data['customerId']),
        date: Value(data['date']),
        createdAt: Value(DateTime.now().toIso8601String()),
      ));

      // Reload to refresh transaction list and totals
      await loadTransactions(data['businessId']);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDebts(int businessId) async {
    try {
      final db = _db!;
      final result = await db.getPendingDebts(businessId);
      _debts = result.map((d) => {
        'id': d.id,
        'customerId': d.customerId,
        'amount': d.amount,
        'paidAmount': d.paidAmount,
        'remaining': d.amount - d.paidAmount,
        'description': d.description,
        'status': d.status,
      }).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  // ──── BORÇLULAR ────

  List<Map<String, dynamic>> _debtors = [];

  /// Borcu olan müşteriler (müşteri başına kalan toplam).
  List<Map<String, dynamic>> get debtors => _debtors;

  double get totalDebtRemaining =>
      _debtors.fold(0.0, (sum, d) => sum + (d['remaining'] as double));

  Future<void> loadDebtors(int businessId) async {
    try {
      _debtors = await _db!.getDebtorsWithDetails(businessId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Randevu tamamlanırken ödenmeyen tutarı borç olarak kaydeder.
  Future<bool> addDebt({
    required int businessId,
    required int customerId,
    required double amount,
    int? appointmentId,
    String? description,
  }) async {
    try {
      final now = DateTime.now();
      await _db!.addDebt(DebtsCompanion(
        businessId: Value(businessId),
        customerId: Value(customerId),
        appointmentId: Value(appointmentId),
        amount: Value(amount),
        description: Value(description),
        createdAt: Value(now.toIso8601String()),
      ));
      await loadDebtors(businessId);
      await loadDebts(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Borç tahsilatı: tutar müşterinin en eski borcundan başlayarak düşülür,
  /// kısmi ödeme desteklenir; kalan takip edilir. Gelir, borç kalemi başına
  /// ayrı işlem olarak yazılır ve kalemin randevusuna bağlanır — böylece
  /// istatistikte tahsilat, işi yapan çalışanın kazancı olarak görünür.
  Future<bool> payDebt({
    required int businessId,
    required int customerId,
    required double amount,
    required String method,
    String? customerName,
  }) async {
    try {
      final db = _db!;
      final openDebts = await db.getOpenDebtsForCustomer(businessId, customerId);

      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final description = customerName != null && customerName.isNotEmpty
          ? 'Borç tahsilatı: $customerName'
          : 'Borç tahsilatı';

      var left = amount;
      for (final debt in openDebts) {
        if (left <= 0) break;
        final remaining = debt.amount - debt.paidAmount;
        final pay = left >= remaining ? remaining : left;
        final newPaid = debt.paidAmount + pay;
        final status = (debt.amount - newPaid) <= 0.009 ? 'paid' : 'partial';
        await db.updateDebtPayment(debt.id, newPaid, status);

        await db.addTransaction(TransactionsCompanion(
          businessId: Value(businessId),
          type: const Value('income'),
          amount: Value(pay),
          category: const Value('Borç Tahsilatı'),
          description: Value(description),
          paymentMethod: Value(method),
          appointmentId: Value(debt.appointmentId),
          customerId: Value(customerId),
          date: Value(dateStr),
          createdAt: Value(now.toIso8601String()),
        ));

        left -= pay;
      }

      await loadDebtors(businessId);
      await loadDebts(businessId);
      await loadTransactions(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ──── KATEGORİLER ────

  static const List<String> _defaultIncomeCategories = [
    'Hizmet', 'Ürün Satışı', 'Bahşiş', 'Diğer Gelir',
  ];
  static const List<String> _defaultExpenseCategories = [
    'Kira', 'Malzeme', 'Maaş', 'Fatura', 'Temizlik', 'Diğer Gider',
  ];

  List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get categories => _categories;

  List<String> categoryNames(String type) => _categories
      .where((c) => c['type'] == type)
      .map((c) => c['name'] as String)
      .toList();

  /// Kategorileri yükler; işletme için hiç kategori yoksa varsayılanları
  /// tohumlar (kullanıcı ayarlardan ekleyip silebilir).
  Future<void> loadCategories(int businessId) async {
    try {
      final db = _db!;
      var result = await db.getCategories(businessId);

      if (result.isEmpty) {
        final now = DateTime.now().toIso8601String();
        for (final name in _defaultIncomeCategories) {
          await db.addCategory(TransactionCategoriesCompanion(
            businessId: Value(businessId),
            name: Value(name),
            type: const Value('income'),
            createdAt: Value(now),
          ));
        }
        for (final name in _defaultExpenseCategories) {
          await db.addCategory(TransactionCategoriesCompanion(
            businessId: Value(businessId),
            name: Value(name),
            type: const Value('expense'),
            createdAt: Value(now),
          ));
        }
        result = await db.getCategories(businessId);
      }

      _categories = result
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'type': c.type,
              })
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addCategory(int businessId, String name, String type) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final exists = _categories.any((c) =>
        c['type'] == type &&
        (c['name'] as String).toLowerCase() == trimmed.toLowerCase());
    if (exists) {
      _error = 'Bu kategori zaten var';
      notifyListeners();
      return false;
    }
    try {
      await _db!.addCategory(TransactionCategoriesCompanion(
        businessId: Value(businessId),
        name: Value(trimmed),
        type: Value(type),
        createdAt: Value(DateTime.now().toIso8601String()),
      ));
      await loadCategories(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Kategori silinir; geçmiş işlemler metin olarak kategori adını taşıdığı
  /// için etkilenmez.
  Future<bool> deleteCategory(int businessId, int categoryId) async {
    try {
      await _db!.deleteCategory(categoryId);
      await loadCategories(businessId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ──── İSTATİSTİK ────

  List<Map<String, dynamic>> _statsTransactions = [];
  Map<String, int> _statsAppointmentCounts = {};
  Map<int, int> _statsEmployeeCompleted = {};
  List<Map<String, dynamic>> _statsDebtorsByEmployee = [];
  bool _statsLoading = false;

  /// Açık borçlar çalışan kırılımıyla (çalışan+müşteri başına kalan).
  List<Map<String, dynamic>> get statsDebtorsByEmployee =>
      _statsDebtorsByEmployee;

  /// Seçilen aralıktaki işlemler (çalışan + müşteri adı bağlı).
  List<Map<String, dynamic>> get statsTransactions => _statsTransactions;
  Map<String, int> get statsAppointmentCounts => _statsAppointmentCounts;

  /// Çalışan id -> tamamlanan randevu sayısı.
  Map<int, int> get statsEmployeeCompleted => _statsEmployeeCompleted;
  bool get statsLoading => _statsLoading;

  Future<void> loadStatistics(
      int businessId, String startDate, String endDate) async {
    _statsLoading = true;
    notifyListeners();

    try {
      final db = _db!;
      _statsTransactions =
          await db.getTransactionsDetailed(businessId, startDate, endDate);
      _statsAppointmentCounts =
          await db.getAppointmentStatusCounts(businessId, startDate, endDate);
      _statsEmployeeCompleted =
          await db.getEmployeeCompletedCounts(businessId, startDate, endDate);
      _statsDebtorsByEmployee = await db.getDebtorsByEmployee(businessId);
    } catch (e) {
      _error = e.toString();
    }

    _statsLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
