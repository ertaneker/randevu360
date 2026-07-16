class AppConstants {
  static const String appName = 'Randevu 360';
  static const String version = '1.0.0';

  // WhatsApp Service
  static const String whatsappServiceUrl = 'http://140.86.209.80:3000';
  static const String apiKey = 'c8c3bc9f148cbf64e98b10151a189b1e06bf1e31a61a7a9eedb227783428c3c5';

  // Appointment reminder intervals (hours before)
  static const int reminder24h = 24;
  static const int reminder5h = 5;
  static const int reminder1h = 1;

  // Appointment statuses
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  static const String statusNoShow = 'no_show';

  // Employee roles
  static const String roleAdmin = 'admin';
  static const String roleEmployee = 'employee';

  // Transaction types
  static const String income = 'income';
  static const String expense = 'expense';

  // Debt status
  static const String debtPending = 'pending';
  static const String debtPartial = 'partial';
  static const String debtPaid = 'paid';

  // Default working hours
  static const String defaultStart = '09:00';
  static const String defaultEnd = '19:00';
  static const int defaultSlotDuration = 30; // minutes

  // Category defaults
  static const List<String> incomeCategories = [
    'Kesim',
    'Sakal',
    'Boyama',
    'Fön',
    'Manikür',
    'Pedikür',
    'Cilt Bakımı',
    'Diğer',
  ];

  static const List<String> expenseCategories = [
    'Kira',
    'Elektrik',
    'Su',
    'Doğalgaz',
    'Market',
    'Ürün',
    'Maaş',
    'Sigorta',
    'Vergi',
    'Reklam',
    'Diğer',
  ];
}
