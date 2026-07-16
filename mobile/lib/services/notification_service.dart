import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Android notification channel
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // WhatsApp service channel (foreground service bildirimi)
    const whatsappChannel = AndroidNotificationChannel(
      'randevu360_whatsapp',
      'WhatsApp Servisi',
      description: 'WhatsApp bağlantı durumu bildirimleri',
      importance: Importance.low,
      playSound: false,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(whatsappChannel);

    // Appointment reminders channel
    const reminderChannel = AndroidNotificationChannel(
      'randevu360_reminders',
      'Randevu Hatırlatmaları',
      description: 'Randevu hatırlatma bildirimleri',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);

    // Firebase Cloud Messaging
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // TODO: Get FCM token and save to local storage
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundMessageTap);

    _initialized = true;
  }

  Future<void> showWhatsappNotification({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'randevu360_whatsapp',
          'WhatsApp Servisi',
          importance: Importance.low,
          priority: Priority.low,
          showWhen: false,
        ),
      ),
    );
  }

  Future<void> showReminderNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'randevu360_reminders',
          'Randevu Hatırlatmaları',
          importance: Importance.high,
          priority: Priority.high,
          fullScreenIntent: true,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - navigate to relevant screen
    final payload = response.payload;
    if (payload != null) {
      // Navigator.push to appointment detail, etc.
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showReminderNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification.title ?? 'Randevu 360',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  void _onBackgroundMessageTap(RemoteMessage message) {
    // Navigate to relevant screen
  }
}
