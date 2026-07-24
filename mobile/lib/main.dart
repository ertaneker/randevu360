import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'core/backup/backup_scheduler.dart';
import 'core/database/database_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp();

  // Local database
  final databaseService = DatabaseService();

  // Gece otomatik Drive yedeği (02:00-03:00 arası rastgele)
  await Workmanager().initialize(backupCallbackDispatcher);
  if (await BackupScheduler.isEnabled()) {
    await BackupScheduler.scheduleNext();
  }

  // Notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(EsnafTakvimApp(
    databaseService: databaseService,
    notificationService: notificationService,
  ));
}

