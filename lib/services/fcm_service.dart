import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/core/local_notif.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future initFCM(Function(RemoteMessage) onMessageCallback,
      Function(RemoteMessage) onOpenedCallback) async {
    // Request permission (iOS)
    NotificationSettings settings = await _messaging.requestPermission();
    // print('User granted permission: ${settings.authorizationStatus}');

    // Get token
    String? token = await _messaging.getToken();
    // you should send this token to server / save to Firestore when user logs in

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // show local notification
      final notifTitle = message.notification?.title ?? '';
      final notifBody = message.notification?.body ?? '';
      await LocalNotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: notifTitle,
          body: notifBody,
          payload: message.data['payload']);
      onMessageCallback(message);
    });

    // When user taps notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onOpenedCallback(message);
    });

    // terminated -> opened from notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onOpenedCallback(initialMessage);
    }
  }

  Future<String?> getToken() => _messaging.getToken();

  Future subscribeTopic(String topic) => _messaging.subscribeToTopic(topic);
  Future unsubscribeTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
}
