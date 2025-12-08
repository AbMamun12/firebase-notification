import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD

import 'firebase_options.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/notification_vm.dart';

// LOCAL NOTIFICATION
import 'core/local_notif.dart';

// SCREENS
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Local Notification initialize
  await LocalNotificationService.init();

  runApp(const MyApp());
=======

import 'firebase_options.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const MyApp(),
    ),
  );
>>>>>>> origin/master
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return MaterialApp(
      title: "Firebase Notification",
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
>>>>>>> origin/master
    );
  }
}
