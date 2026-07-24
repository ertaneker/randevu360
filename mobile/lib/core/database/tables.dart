import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Senkron alanları tek formatta üretir: UTC ISO-8601.
/// String karşılaştırmasıyla (LWW) sıralanabilir olması için tüm cihazlar
/// aynı format ve dilimi (UTC) kullanmak zorunda.
String newSyncTimestamp() => DateTime.now().toUtc().toIso8601String();

/// Yeni satır UUID'si. Public olmalı: clientDefault ifadesi üretilen
/// database_service.g.dart içine kopyalanır ve oradan erişilir.
String newRowUid() => _uuid.v4();

/// Cihazlar arası senkronlanan tabloların ortak kolonları.
///
/// - [rowUid]: global satır kimliği (UUID). Yerel int id'ler cihaza özeldir;
///   cihazlar arası eşleşme bununla yapılır. FK'ler Firestore dokümanında
///   rowUid olarak taşınır.
/// - [syncUpdatedAt]: son içerik değişikliği (UTC ISO). LWW çakışma çözümü
///   bu alanla yapılır. UPDATE'lerde SQL trigger otomatik günceller
///   (bkz. DatabaseService._syncTriggerSql).
/// - [deletedAt]: tombstone — silinen satır fiziksel silinmez, bu alan
///   dolar ve diğer cihazlara yayılır.
/// - [lastSyncedAt]: en son push/pull edilen syncUpdatedAt değeri.
///   `syncUpdatedAt != lastSyncedAt` ⇒ satır kirli, push edilecek.
///
/// Kolonlar nullable: SQLite `ALTER TABLE ADD COLUMN NOT NULL` default'suz
/// eklemeye izin vermez; eski satırlar migration sonrası backfill edilir.
mixin SyncColumns on Table {
  TextColumn get rowUid => text().nullable().clientDefault(newRowUid)();
  TextColumn get syncUpdatedAt =>
      text().nullable().clientDefault(newSyncTimestamp)();
  TextColumn get deletedAt => text().nullable()();
  TextColumn get lastSyncedAt => text().nullable()();
}

// ──── İŞLETME ────
@DataClassName('Business')
class Businesses extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Global işletme kimliği (Firestore doc ID = sahibin Firebase UID'si).
  // Cihazlar arası eşleşme bununla yapılır; yerel int id cihaza özeldir.
  TextColumn get remoteId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get address => text()();
  TextColumn get email => text().nullable()();
  TextColumn get ownerName => text()();
  TextColumn get ownerFbUid => text()(); // Firebase Auth UID
  TextColumn get workingDays => text()(); // JSON array: ["mon","tue",...]
  TextColumn get workingHours => text()(); // JSON: {"start":"09:00","end":"19:00"}
  TextColumn get status => text().withDefault(const Constant('active'))();
  // Varsayılan true: mevcut davranış tek hat (yöneticinin hattı). Kapatılırsa
  // her çalışan kendi WhatsApp hesabını bağlar.
  BoolColumn get sharedWhatsapp => boolean().withDefault(const Constant(true))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}

// ──── ÇALIŞAN ────
@DataClassName('Employee')
class Employees extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get role => text().withDefault(const Constant('employee'))(); // admin / employee
  TextColumn get fbUid => text().nullable()();
  TextColumn get color => text().nullable()(); // Takvimde renk kodu
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get createdAt => text()();
}

// ──── MÜŞTERİ ────
@DataClassName('Customer')
class Customers extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // manual / contacts / whatsapp
  RealColumn get totalDebt => real().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
}

// ──── HİZMET ────
@DataClassName('Service')
class Services extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get duration => integer()(); // dakika
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
}

// ──── RANDEVU ────
@DataClassName('Appointment')
class Appointments extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get employeeId => integer().references(Employees, #id).nullable()();
  IntColumn get serviceId => integer().references(Services, #id).nullable()();
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get time => text()(); // HH:MM
  TextColumn get endTime => text().nullable()(); // HH:MM — boşsa süre = ayarlardaki periyot
  RealColumn get price => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending/confirmed/completed/cancelled
  TextColumn get note => text().nullable()();
  TextColumn get createdBy => text()(); // "owner" / employee email
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  // Bildirim durumu
  BoolColumn get notified24h => boolean().withDefault(const Constant(false))();
  BoolColumn get notified5h => boolean().withDefault(const Constant(false))();
  BoolColumn get notified1h => boolean().withDefault(const Constant(false))();
}

// ──── RANDEVU LOG ────
@DataClassName('AppointmentLog')
class AppointmentLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get appointmentId => integer().references(Appointments, #id)();
  TextColumn get action => text()(); // created / updated / cancelled / status_changed
  TextColumn get performedBy => text()();
  TextColumn get details => text().nullable()();
  TextColumn get createdAt => text()();
}

// ──── GELİR/GİDER ────
@DataClassName('Transaction')
class Transactions extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get type => text()(); // income / expense
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))(); // cash / card / transfer
  IntColumn get appointmentId => integer().references(Appointments, #id).nullable()();
  IntColumn get customerId => integer().references(Customers, #id).nullable()();
  TextColumn get date => text()();
  TextColumn get createdAt => text()();
}

// ──── MÜŞTERİ BORÇ ────
@DataClassName('Debt')
class Debts extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get appointmentId => integer().references(Appointments, #id).nullable()();
  RealColumn get amount => real()();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending / partial / paid
  TextColumn get dueDate => text().nullable()();
  TextColumn get createdAt => text()();
}

// ──── GELİR/GİDER KATEGORİLERİ ────
@DataClassName('TransactionCategory')
class TransactionCategories extends Table with SyncColumns {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()(); // income / expense
  TextColumn get createdAt => text()();
}

// ──── WHATSAPP MESAJ LOG ────
@DataClassName('MessageLog')
class MessageLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get messageId => text()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get customerPhone => text()();
  TextColumn get messageType => text()(); // reminder-24h / reminder-5h / reminder-1h / direct / incoming
  TextColumn get message => text()();
  TextColumn get status => text()(); // sent / failed / received
  TextColumn get direction => text().withDefault(const Constant('outgoing'))(); // outgoing / incoming
  TextColumn get error => text().nullable()();
  TextColumn get sentAt => text()();
}

// ──── ÇALIŞMA SAATLERİ (çalışan bazlı) ────
@DataClassName('WorkingHour')
class WorkingHours extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id).nullable()();
  IntColumn get businessId => integer().references(Businesses, #id)();
  TextColumn get dayOfWeek => text()(); // mon / tue / wed / thu / fri / sat / sun
  TextColumn get startTime => text()(); // HH:MM
  TextColumn get endTime => text()(); // HH:MM
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// ──── ÇALIŞAN İZİNLERİ ────
@DataClassName('EmployeePermission')
class EmployeePermissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  IntColumn get businessId => integer().references(Businesses, #id)();
  BoolColumn get canSendWhatsapp => boolean().withDefault(const Constant(true))();
  BoolColumn get canBulkWhatsapp => boolean().withDefault(const Constant(true))();
  BoolColumn get canViewFinance => boolean().withDefault(const Constant(true))();
  BoolColumn get canManageServices => boolean().withDefault(const Constant(false))();
  BoolColumn get canManageEmployees => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}
