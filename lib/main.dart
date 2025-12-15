import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/notification_vm.dart';

// LOCAL NOTIFICATION
import 'core/local_notif.dart';

// SCREENS
import 'views/splash_screen.dart';

// TOP LEVEL FUNCTION (class-এর বাইরে)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Local notification দেখাবে background/terminated অবস্থায়
  final title = message.notification?.title ?? '';
  final body = message.notification?.body ?? '';

  await LocalNotificationService.showNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title,
    body: body,
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Local Notification initialize
  await LocalNotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationVM()),
      ],
      child: MaterialApp(
        title: "Firebase Notification",
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
