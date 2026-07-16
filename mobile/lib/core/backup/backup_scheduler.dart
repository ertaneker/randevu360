import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../database/database_service.dart';
import 'backup_service.dart';

/// Gece otomatik Drive yedeği. Her gece 02:00-03:00 arasında rastgele bir
/// dakikada çalışır (herkesin aynı anda yüklememesi ve kullanım dışı saat
/// için). Workmanager kullanılır: uygulama kapalıyken de tetiklenir.
///
/// Görev tek seferliktir; her çalışmada bir sonraki gece için kendini
/// yeniden kurar. Google oturumu (Drive izniyle) daha önce açılmışsa
/// sessizce yedekler; değilse o gece atlanır.
class BackupScheduler {
  static const String taskName = 'nightlyDriveBackup';
  static const String prefEnabled = 'auto_backup_enabled';
  static const String prefLastRun = 'auto_backup_last_run';
  static const String prefLastResult = 'auto_backup_last_result';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefEnabled) ?? true; // varsayılan: açık
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefEnabled, enabled);
    if (enabled) {
      await scheduleNext();
    } else {
      await Workmanager().cancelByUniqueName(taskName);
    }
  }

  /// Bir sonraki gece 02:00-03:00 arasında rastgele bir zamana kurar.
  /// Aynı isimle tekrar kurmak öncekinin yerine geçer (replace).
  static Future<void> scheduleNext() async {
    final now = DateTime.now();
    var target = DateTime(
      now.year, now.month, now.day, 2, Random().nextInt(60));
    if (!target.isAfter(now)) {
      target = target.add(const Duration(days: 1));
    }

    await Workmanager().registerOneOffTask(
      taskName,
      taskName,
      initialDelay: target.difference(now),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Arka plan görevinin gövdesi (callbackDispatcher'dan çağrılır).
  static Future<void> runBackup() async {
    final prefs = await SharedPreferences.getInstance();
    String result;

    try {
      final backup = BackupService();
      final authed = await backup.authenticate();
      if (!authed) {
        result = 'atlandı: ${backup.lastError ?? 'Google oturumu yok'}';
      } else {
        final db = DatabaseService();
        try {
          final ok = await backup.backup(db);
          result = ok ? 'başarılı' : 'hata: ${backup.lastError ?? ''}';
        } finally {
          await db.close();
        }
      }
    } catch (e) {
      result = 'hata: $e';
    }

    await prefs.setString(prefLastRun, DateTime.now().toIso8601String());
    await prefs.setString(prefLastResult, result);
    debugPrint('Gece yedeği: $result');
  }
}

/// Workmanager arka plan giriş noktası. Uygulama kapalıyken ayrı bir
/// isolate'ta çalışır; yedeği alır ve ertesi gece için kendini yeniden kurar.
@pragma('vm:entry-point')
void backupCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == BackupScheduler.taskName) {
      await BackupScheduler.runBackup();
      if (await BackupScheduler.isEnabled()) {
        await BackupScheduler.scheduleNext();
      }
    }
    return true;
  });
}
