import 'dart:async';

import 'package:drift/drift.dart' show TableInfo, Table, Variable;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../core/database/database_service.dart';
import 'cloud_api_service.dart';

/// Cihazlar arası ortak veri senkronu (bkz. ADR-001).
///
/// Model: PostgreSQL satır günlüğü (eski Firestore rows koleksiyonu yerine).
/// Her senkron satır `sync_rows` tablosunda yaşar:
/// `{table, updatedAt (istemci UTC ISO — LWW), deletedAt, deviceId,
///   serverAt (Unix micros — pull imleci), data{kolonlar, FK'ler rowUid}}`
///
/// - Kirli satır tespiti ve tombstone'lar DB katmanında (SyncColumns +
///   SQL trigger'lar, bkz. DatabaseService._ensureSyncInfrastructure).
/// - Sıra: önce PULL sonra PUSH — yeni katılan cihaz, kendi yerel kopyasını
///   (ör. çalışanın kendini eklediği satır) uzak eşleşmesiyle birleştirmeden
///   push etmesin, duplike doğmasın.
/// - Çakışma: LWW, updatedAt string karşılaştırması (UTC ISO).
/// - Periyodik polling yok — manuel tetikleme (açılış + nudge + kullanıcı).
class DataSyncService {
  DataSyncService._();
  static final DataSyncService instance = DataSyncService._();

  static const _cursorPrefPrefix = 'sync_cursor_';
  static const _devicePrefKey = 'sync_device_id';
  static const _pgFirstPushKey = 'sync_pg_first_push_v2';
  static const _pullBatchSize = 300;
  static const _pushChunkSize = 400;

  final CloudApiService _api = CloudApiService();

  DatabaseService? _db;
  int? _businessId;
  String? _remoteId;
  Timer? _periodic;
  Timer? _debounce;
  bool _busy = false;
  bool _appActive = true;

  /// Son senkron hatası (UI/log için).
  String? lastError;

  /// FK kolonları: kolon adı → hedef tablo adı. Dokümanda rowUid taşınır.
  static const Map<String, Map<String, String>> _foreignKeys = {
    'appointments': {
      'customer_id': 'customers',
      'employee_id': 'employees',
      'service_id': 'services',
    },
    'transactions': {
      'appointment_id': 'appointments',
      'customer_id': 'customers',
    },
    'debts': {
      'customer_id': 'customers',
      'appointment_id': 'appointments',
    },
  };

  /// rowUid eşleşmeyen gelen satır için ikincil eşleştirme kolonu.
  static const Map<String, String> _dedupeColumns = {
    'employees': 'email',
    'customers': 'phone',
    'services': 'name',
  };

  static const Set<String> _metaColumns = {
    'id',
    'business_id',
    'row_uid',
    'sync_updated_at',
    'deleted_at',
    'last_synced_at',
  };

  bool get isRunning => _db != null;

  /// Servisi başlatır: referansları kurar ve 30 sn periyodik senkron
  /// döngüsünü açar (PostgreSQL $0/okuma, maliyet yok). İlk senkronu
  /// çağıran bekleyebilsin diye [syncNow] ayrıca çağrılmalıdır.
  ///
  /// Firestore→PostgreSQL geçişinde (ilk çalıştırma): tüm satırların
  /// last_synced_at değerini sıfırlar — eski Firestore sync durumu
  /// PostgreSQL'e push'u engellemesin.
  Future<void> start(DatabaseService db, int businessId, String remoteId) async {
    _db = db;
    _businessId = businessId;
    _remoteId = remoteId;
    await _ensureFirstPush(db, remoteId);
    _startPolling();
  }

  /// Firestore→PostgreSQL geçişi: ilk çalıştırmada tüm satırları kirli
  /// işaretler, cursor'ı sıfırlar. Sonraki açılışlarda tekrarlanmaz.
  Future<void> _ensureFirstPush(DatabaseService db, String remoteId) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_pgFirstPushKey) == true) return;

    debugPrint('DataSync: Firestore→PG geçişi — tüm satırlar push edilecek');
    for (final table in db.syncedTables) {
      await db.customStatement(
        'UPDATE ${table.actualTableName} SET last_synced_at = NULL',
      );
    }
    await prefs.remove(_cursorPrefPrefix + remoteId);
    await prefs.setBool(_pgFirstPushKey, true);
  }

  void stop() {
    _periodic?.cancel();
    _periodic = null;
    _db = null;
    _businessId = null;
    _remoteId = null;
    _debounce?.cancel();
    _debounce = null;
  }

  /// Uygulama ön plana döndüğünde çağrılır — hemen sync yapıp polling'i başlatır.
  void onAppResume() {
    _appActive = true;
    _startPolling();
    syncNow();
  }

  /// Uygulama arka plana gittiğinde polling'i durdurur.
  void onAppPause() {
    _appActive = false;
    _periodic?.cancel();
    _periodic = null;
    _debounce?.cancel();
    _debounce = null;
  }

  void _startPolling() {
    if (_periodic != null) return;
    if (_db == null) return;
    _periodic = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (_appActive) syncNow();
      },
    );
  }

  /// Yerel yazma sonrası dürtme — 2 sn debounce ile senkron tetikler.
  void nudge() {
    if (_db == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), syncNow);
  }

  /// Cihazdaki tüm yerel senkron durumunu sıfırlar.
  static Future<void> clearLocalState() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith(_cursorPrefPrefix)) await prefs.remove(key);
      if (key == _pgFirstPushKey) await prefs.remove(key);
    }
  }

  /// Tam senkron turu: pull → push. Yeniden giriş korumalı.
  Future<bool> syncNow() async {
    final db = _db;
    final businessId = _businessId;
    final remoteId = _remoteId;
    if (db == null || businessId == null || remoteId == null) return false;
    if (_busy) return true;
    _busy = true;
    try {
      final pulled = await _pull(db, businessId, remoteId);
      final pushed = await _push(db, businessId, remoteId);
      debugPrint('DataSync: tamam — $pulled satır alındı, $pushed satır gönderildi');
      lastError = null;
      return true;
    } catch (e) {
      lastError = e.toString();
      debugPrint('DataSync hata: $e');
      return false;
    } finally {
      _busy = false;
    }
  }

  // ───────────────────────── PUSH ─────────────────────────

  Future<int> _push(
      DatabaseService db, int businessId, String remoteId) async {
    var pushed = 0;
    final deviceId = await _deviceId();

    for (final table in db.syncedTables) {
      final tableName = table.actualTableName;
      final dirty = await db.getDirtyRows(table, businessId);
      if (dirty.isEmpty) continue;

      // Chunk'lar halinde gönder
      for (var i = 0; i < dirty.length; i += _pushChunkSize) {
        final chunk = dirty.skip(i).take(_pushChunkSize).toList();
        final rows = <Map<String, dynamic>>[];
        final marks = <(int, String)>[];

        for (final row in chunk) {
          final rowUid = row['row_uid'] as String;
          final updatedAt = row['sync_updated_at'] as String;
          final data = await _serializeRow(db, table, row);
          if (data == null) continue;

          rows.add({
            'rowUid': rowUid,
            'table': tableName,
            'updatedAt': updatedAt,
            'deletedAt': row['deleted_at'],
            'data': data,
          });
          final localId = row['id'];
          final id = localId is int ? localId : int.tryParse('$localId') ?? 0;
          marks.add((id, updatedAt));
        }

        if (rows.isEmpty) continue;

        final count = await _api.syncPush(remoteId, deviceId, rows);
        for (final (id, updatedAt) in marks) {
          await db.markRowSynced(table, id, updatedAt);
        }
        pushed += count;
        debugPrint('DataSync push: $tableName $count satır');
      }
    }
    return pushed;
  }

  Future<Map<String, dynamic>?> _serializeRow(DatabaseService db,
      TableInfo<Table, dynamic> table, Map<String, dynamic> row) async {
    final tableName = table.actualTableName;
    final fks = _foreignKeys[tableName] ?? const {};
    final data = <String, dynamic>{};

    for (final entry in row.entries) {
      final col = entry.key;
      if (_metaColumns.contains(col)) continue;

      if (fks.containsKey(col)) {
        final v = entry.value;
        final localId = v is int ? v : int.tryParse('$v');
        if (localId == null) {
          data['${col}_uid'] = null;
          continue;
        }
        final targetTable = _tableByName(db, fks[col]!);
        final uid = await db.rowUidForId(targetTable, localId);
        if (uid == null) {
          if (col == 'customer_id' &&
              (tableName == 'appointments' || tableName == 'debts')) {
            return null;
          }
          data['${col}_uid'] = null;
          continue;
        }
        data['${col}_uid'] = uid;
        continue;
      }

      final v = entry.value;
      data[col] = v;
    }
    return data;
  }

  // ───────────────────────── PULL ─────────────────────────

  Future<int> _pull(
      DatabaseService db, int businessId, String remoteId) async {
    var applied = 0;
    final prefs = await SharedPreferences.getInstance();
    final cursorKey = '$_cursorPrefPrefix$remoteId';
    final deviceId = await _deviceId();
    var cursor = prefs.getInt(cursorKey) ?? 0;

    while (true) {
      final result = await _api.syncPull(remoteId, cursor, deviceId);
      final rows = (result['rows'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final newCursor = _parseInt(result['newCursor']) ?? cursor;

      // Tabloya göre grupla, bağımlılık sırasıyla uygula
      final byTable = <String, List<Map<String, dynamic>>>{};
      for (final row in rows) {
        final tableName = row['table'] as String?;
        if (tableName == null) continue;
        byTable.putIfAbsent(tableName, () => []).add(row);
      }

      final orphans = <Map<String, dynamic>>[];
      for (final table in db.syncedTables) {
        final docs = byTable[table.actualTableName];
        if (docs == null) continue;
        for (final doc in docs) {
          final ok = await _applyDoc(db, businessId, table, doc);
          if (!ok) {
            orphans.add(doc);
          } else {
            applied++;
          }
        }
      }

      for (final doc in orphans) {
        final tableName = doc['table'] as String;
        final table = _tableByName(db, tableName);
        final ok = await _applyDoc(db, businessId, table, doc);
        if (!ok) {
          debugPrint('DataSync: yetim satır atlandı '
              '($tableName/${doc['rowUid']}) — ebeveyn FK çözülemedi');
        } else {
          applied++;
        }
      }

      await prefs.setInt(cursorKey, newCursor);
      cursor = newCursor;
      if (rows.length < _pullBatchSize) break;
    }
    return applied;
  }

  Future<bool> _applyDoc(DatabaseService db, int businessId,
      TableInfo<Table, dynamic> table, Map<String, dynamic> doc) async {
    final tableName = table.actualTableName;
    final rowUid = doc['rowUid'] as String?;
    final remoteUpdatedAt = doc['updatedAt'] as String?;
    final data = doc['data'] as Map<String, dynamic>?;
    if (rowUid == null || remoteUpdatedAt == null || data == null) return true;

    var local = await db.getRowByUid(table, rowUid);
    local ??= await _findUnsyncedTwin(db, tableName, data, rowUid);

    if (local != null) {
      final localUpdatedAt = local['sync_updated_at'] as String? ?? '';
      if (localUpdatedAt.compareTo(remoteUpdatedAt) > 0) return true;
      if (localUpdatedAt == remoteUpdatedAt &&
          local['last_synced_at'] == remoteUpdatedAt) {
        return true;
      }
    }

    final columns = <String, dynamic>{
      'business_id': businessId,
      'row_uid': rowUid,
      'sync_updated_at': remoteUpdatedAt,
      'last_synced_at': remoteUpdatedAt,
      'deleted_at': doc['deletedAt'],
    };

    final validColumns = table.columnsByName.keys.toSet();
    final fks = _foreignKeys[tableName] ?? const {};

    for (final entry in data.entries) {
      var col = entry.key;
      var value = entry.value;

      if (col.endsWith('_uid') &&
          fks.containsKey(col.substring(0, col.length - 4))) {
        col = col.substring(0, col.length - 4);
        if (value == null) {
          columns[col] = null;
          continue;
        }
        final targetTable = _tableByName(db, fks[col]!);
        final localId = await db.localIdForUid(targetTable, value as String);
        if (localId == null) {
          final required = col == 'customer_id' &&
              (tableName == 'appointments' || tableName == 'debts');
          if (required) return false;
          columns[col] = null;
          continue;
        }
        columns[col] = localId;
        continue;
      }

      if (!validColumns.contains(col) || _metaColumns.contains(col)) continue;
      if (value is bool) value = value ? 1 : 0;
      if (value is! num && value is! String && value != null) continue;
      columns[col] = value;
    }

    await db.applyRemoteRow(
      table,
      columns: columns,
      existingLocalId: _toInt(local?['id']),
    );
    return true;
  }

  Future<Map<String, dynamic>?> _findUnsyncedTwin(DatabaseService db,
      String tableName, Map<String, dynamic> data, String remoteUid) async {
    final matchCol = _dedupeColumns[tableName];
    final matchVal = matchCol == null ? null : data[matchCol];
    if (matchCol == null || matchVal == null || '$matchVal'.isEmpty) {
      return null;
    }
    var rows = await db
        .customSelect(
          'SELECT * FROM $tableName '
          'WHERE $matchCol = ? AND last_synced_at IS NULL LIMIT 1',
          variables: [Variable(matchVal)],
        )
        .get();
    if (rows.isEmpty) {
      rows = await db
          .customSelect(
            'SELECT * FROM $tableName '
            'WHERE $matchCol = ? LIMIT 1',
            variables: [Variable(matchVal)],
          )
          .get();
      if (rows.isNotEmpty) {
        final row = Map<String, dynamic>.of(rows.first.data);
        final existingUid = row['row_uid'] as String?;
        if (existingUid != null && existingUid != remoteUid) {
          await db.customStatement(
            'UPDATE $tableName SET row_uid = ? WHERE row_uid = ?',
            [remoteUid, existingUid],
          );
          row['row_uid'] = remoteUid;
          debugPrint('DataSync dedup: $tableName $matchVal '
              '($existingUid → $remoteUid)');
        }
        return row;
      }
    }
    return rows.isEmpty ? null : Map<String, dynamic>.of(rows.first.data);
  }

  // ───────────────────────── yardımcılar ─────────────────────────

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return int.tryParse('$v');
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse('$v');
  }

  TableInfo<Table, dynamic> _tableByName(DatabaseService db, String name) =>
      db.syncedTables.firstWhere((t) => t.actualTableName == name);

  Future<String> _deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_devicePrefKey);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_devicePrefKey, id);
    }
    return id;
  }
}
