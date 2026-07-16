import 'package:flutter_test/flutter_test.dart';

import 'package:randevu360/providers/finance_provider.dart';

// ---------------------------------------------------------------------------
// FinanceProvider — unit tests for state management, computed properties,
// and period selection. Database-dependent methods (loadTransactions,
// addTransaction, loadDebts) require a live Drift database.
// ---------------------------------------------------------------------------
void main() {
  group('Initial state', () {
    test('all properties have expected defaults', () {
      final provider = FinanceProvider();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.transactions, isEmpty);
      expect(provider.debts, isEmpty);
      expect(provider.totalIncome, 0);
      expect(provider.totalExpense, 0);
    });

    test('balance is zero with no transactions', () {
      final provider = FinanceProvider();

      expect(provider.balance, 0);
    });

    test('selected period defaults to current month', () {
      final provider = FinanceProvider();
      final now = DateTime.now();

      expect(provider.selectedYear, now.year);
      expect(provider.selectedMonth, now.month);
    });
  });

  group('setPeriod', () {
    test('updates selected year and month and notifies listeners', () {
      final provider = FinanceProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.setPeriod(2026, 3);

      expect(provider.selectedYear, 2026);
      expect(provider.selectedMonth, 3);
      expect(notifiedCount, 1);
    });

    test('allows setting a past period', () {
      final provider = FinanceProvider();

      provider.setPeriod(2024, 12);

      expect(provider.selectedYear, 2024);
      expect(provider.selectedMonth, 12);
    });
  });

  group('Balance calculation', () {
    test('balance = totalIncome - totalExpense (both zero)', () {
      final provider = FinanceProvider();

      expect(provider.totalIncome, 0);
      expect(provider.totalExpense, 0);
      expect(provider.balance, 0);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies listeners', () {
      final provider = FinanceProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notifiedCount, 1);
    });
  });
}
