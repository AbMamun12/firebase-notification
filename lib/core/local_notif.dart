import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(settings, onDidReceiveNotificationResponse: (resp) {
      // handle tapped local notification if needed
    });
  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'app_channel', 'App Notifications',
      channelDescription: 'App notifications channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platform = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(id, title, body, platform, payload: payload);
  }
}
