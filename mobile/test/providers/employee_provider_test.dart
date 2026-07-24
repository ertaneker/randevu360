import 'package:flutter_test/flutter_test.dart';

import 'package:esnaftakvim/providers/employee_provider.dart';

// ---------------------------------------------------------------------------
// EmployeeProvider — unit tests for state management and computed properties.
// Database-dependent methods (loadEmployees, addEmployee, deleteEmployee,
// updateRole) require a live Drift database.
// ---------------------------------------------------------------------------
void main() {
  group('Initial state', () {
    test('all properties have expected defaults', () {
      final provider = EmployeeProvider();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.employees, isEmpty);
    });
  });

  group('getAdmins', () {
    test('returns empty when there are no employees', () {
      final provider = EmployeeProvider();

      expect(provider.getAdmins(), isEmpty);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies listeners', () {
      final provider = EmployeeProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notifiedCount, 1);
    });
  });

  group('employee list', () {
    test('employees starts empty', () {
      final provider = EmployeeProvider();

      expect(provider.employees, isEmpty);
      expect(provider.employees.length, 0);
    });
  });
}
