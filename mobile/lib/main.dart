import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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

  // Background service for WhatsApp
  await initializeBackgroundService();

  // Gece otomatik Drive yedeği (02:00-03:00 arası rastgele)
  await Workmanager().initialize(backupCallbackDispatcher);
  if (await BackupScheduler.isEnabled()) {
    await BackupScheduler.scheduleNext();
  }

  // Notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(Randevu360App(
    databaseService: databaseService,
    notificationService: notificationService,
  ));
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'randevu360_whatsapp',
      initialNotificationTitle: 'Randevu 360',
      initialNotificationContent: 'WhatsApp servisi aktif',
      foregroundServiceNotificationId: 888,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  // Background WhatsApp check logic
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}
