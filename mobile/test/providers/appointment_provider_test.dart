import 'package:flutter_test/flutter_test.dart';

import 'package:esnaftakvim/providers/appointment_provider.dart';

// ---------------------------------------------------------------------------
// Tests for AppointmentProvider — focuses on state management and computed
// properties. Database-dependent methods (loadAppointments, createAppointment,
// updateStatus) are excluded because they require a live Drift database.
// ---------------------------------------------------------------------------
void main() {
  group('Initial state', () {
    test('all properties have expected defaults', () {
      final provider = AppointmentProvider();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.appointments, isEmpty);
      expect(provider.selectedAppointment, isNull);
      expect(provider.filterEmployeeId, isNull);
      expect(provider.todayAppointments, isEmpty);
      expect(provider.selectedDayAppointments, isEmpty);
      expect(provider.totalToday, 0);
      expect(provider.completedToday, 0);
      expect(provider.pendingToday, 0);
    });

    test('selectedDate is today when created', () {
      final provider = AppointmentProvider();
      final now = DateTime.now();

      expect(provider.selectedDate.year, now.year);
      expect(provider.selectedDate.month, now.month);
      expect(provider.selectedDate.day, now.day);
    });
  });

  group('setSelectedDate', () {
    test('updates selectedDate and notifies listeners', () {
      final provider = AppointmentProvider();
      final newDate = DateTime(2026, 7, 4);
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.setSelectedDate(newDate);

      expect(provider.selectedDate, newDate);
      expect(notifiedCount, 1);
    });

    test('selectedDayAppointments reflects the new date', () {
      final provider = AppointmentProvider();
      final testDate = DateTime(2026, 7, 4);
      const dateStr = '2026-07-04';

      // Inject test data that includes an appointment for the target date
      // and another for a different date.
      provider.setAppointmentsForTesting([
        {
          'id': 1,
          'date': dateStr,
          'time': '10:00',
          'status': 'pending',
          'employeeId': 1,
          'customerId': 1,
          'businessId': 1,
        },
        {
          'id': 2,
          'date': '2026-07-05',
          'time': '11:00',
          'status': 'completed',
          'employeeId': 2,
          'customerId': 2,
          'businessId': 1,
        },
      ]);

      provider.setSelectedDate(testDate);

      expect(provider.selectedDayAppointments.length, 1);
      expect(provider.selectedDayAppointments[0]['id'], 1);
    });
  });

  group('setEmployeeFilter', () {
    test('updates filterEmployeeId and notifies listeners', () {
      final provider = AppointmentProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.setEmployeeFilter(3);

      expect(provider.filterEmployeeId, 3);
      expect(notifiedCount, 1);
    });

    test('setting filter to null clears the filter', () {
      final provider = AppointmentProvider();

      provider.setEmployeeFilter(3);
      expect(provider.filterEmployeeId, 3);

      provider.setEmployeeFilter(null);
      expect(provider.filterEmployeeId, isNull);
    });
  });

  group('todayAppointments', () {
    test('returns empty list when there are no appointments', () {
      final provider = AppointmentProvider();

      expect(provider.todayAppointments, isEmpty);
    });

    test('returns only appointments whose date matches today', () {
      final provider = AppointmentProvider();
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      provider.setAppointmentsForTesting([
        {
          'id': 1,
          'date': todayStr,
          'time': '09:00',
          'status': 'pending',
          'employeeId': 1,
          'customerId': 1,
          'businessId': 1,
        },
        {
          'id': 2,
          'date': todayStr,
          'time': '10:00',
          'status': 'completed',
          'employeeId': 2,
          'customerId': 2,
          'businessId': 1,
        },
        {
          'id': 3,
          'date': '2025-01-01',
          'time': '11:00',
          'status': 'cancelled',
          'employeeId': 1,
          'customerId': 3,
          'businessId': 1,
        },
      ]);

      expect(provider.todayAppointments.length, 2);
      expect(provider.todayAppointments[0]['id'], 1);
      expect(provider.todayAppointments[1]['id'], 2);
    });
  });

  group('Computed counters', () {
    test('totalToday, completedToday, pendingToday with mixed data', () {
      final provider = AppointmentProvider();
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      provider.setAppointmentsForTesting([
        {
          'id': 1,
          'date': todayStr,
          'time': '09:00',
          'status': 'pending',
          'employeeId': 1,
          'customerId': 1,
          'businessId': 1,
        },
        {
          'id': 2,
          'date': todayStr,
          'time': '10:00',
          'status': 'completed',
          'employeeId': 1,
          'customerId': 2,
          'businessId': 1,
        },
        {
          'id': 3,
          'date': todayStr,
          'time': '11:00',
          'status': 'confirmed',
          'employeeId': 2,
          'customerId': 3,
          'businessId': 1,
        },
        {
          'id': 4,
          'date': todayStr,
          'time': '12:00',
          'status': 'pending',
          'employeeId': 2,
          'customerId': 4,
          'businessId': 1,
        },
      ]);

      expect(provider.totalToday, 4);
      expect(provider.completedToday, 1);
      expect(provider.pendingToday, 2); // two items with status 'pending'
    });

    test('all counters are zero when no appointments exist', () {
      final provider = AppointmentProvider();

      expect(provider.totalToday, 0);
      expect(provider.completedToday, 0);
      expect(provider.pendingToday, 0);
    });
  });

  group('clearError', () {
    test('sets error to null and notifies listeners', () {
      final provider = AppointmentProvider();
      var notifiedCount = 0;
      provider.addListener(() => notifiedCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notifiedCount, 1);
    });
  });
}
