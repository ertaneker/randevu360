import 'package:flutter_test/flutter_test.dart';

import 'package:randevu360/providers/customer_provider.dart';

// ---------------------------------------------------------------------------
// CustomerProvider — unit tests for state management and computed properties.
// Database-dependent methods (loadCustomers, addCustomer, getCustomerByPhone)
// require a live Drift database and are tested via integration or widget tests.
// ---------------------------------------------------------------------------
void main() {
  group('Initial state', () {
    test('all properties have expected defaults', () {
      final provider = CustomerProvider();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.customers, isEmpty);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies listeners', () {
      final provider = CustomerProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notifiedCount, 1);
    });
  });

  group('customer list operations', () {
    test('customers list is initially empty', () {
      final provider = CustomerProvider();

      expect(provider.customers, isEmpty);
      expect(provider.customers.length, 0);
    });
  });
}
