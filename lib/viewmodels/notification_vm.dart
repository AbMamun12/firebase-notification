import 'dart:async';
import 'package:firebase_notification/core/local_notif.dart';
import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../services/notification_service.dart';
import '../services/fcm_service.dart';

class NotificationVM extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  final FCMService _fcm = FCMService();

  List<AppNotification> notifications = []; // combined list
  int unreadCount = 0;

  StreamSubscription? _globalSub;
  StreamSubscription? _userSub;
  String? uid;

  void init(String userId) async {
    uid = userId;

    // init local notification plugin
    await LocalNotificationInit(); // below we will define this small wrapper

    // init FCM listeners
    await _fcm.initFCM((message) {
      // onMessage
      // you might want to parse message and add to list or show overlay
    }, (message) {
      // onOpenedApp -> navigate to detail if needed (handle in UI)
    });

    listenToStreams();
  }

  void listenToStreams() {
    if (uid == null) return;
    // global
    _globalSub = _service.globalNotificationsStream().listen((globalList) async {
      // For each global notification, detect readBy (async)
      List<AppNotification> processed = [];
      for (var g in globalList) {
        bool isRead = await _service.isGlobalReadBy(g.id, uid!);
        processed.add(AppNotification(
          id: g.id,
          title: g.title,
          body: g.body,
          createdAt: g.createdAt,
          read: isRead,
          extra: g.extra,
          isGlobal: true,
          userId: null,
        ));
      }
      // Merge with user-specific (we'll keep user list separately)
      _mergeAndNotify(processed, fromUser: false);
    });

    // user-specific
    _userSub = _service.userNotificationsStream(uid!).listen((userList) {
      _mergeAndNotify(userList, fromUser: true);
    });
  }

  List<AppNotification> _globalCache = [];
  List<AppNotification> _userCache = [];

  void _mergeAndNotify(List<AppNotification> newList, {required bool fromUser}) {
    if (fromUser) {
      _userCache = newList;
    } else {
      _globalCache = newList;
    }

    // combine, sort by createdAt desc
    List<AppNotification> combined = [];
    combined.addAll(_globalCache);
    combined.addAll(_userCache);
    combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    notifications = combined;
    unreadCount = notifications.where((n) => n.read != true).length;
    notifyListeners();
  }

  Future markAsRead(AppNotification n) async {
    if (uid == null) return;
    await _service.markAsRead(uid!, n);
  }

  Future markAsUnread(AppNotification n) async {
    if (uid == null) return;
    await _service.markAsUnread(uid!, n);
  }

  void disposeStreams() {
    _globalSub?.cancel();
    _userSub?.cancel();
  }

  // small wrapper to init local notifications (calls LocalNotificationService.init)
  Future LocalNotificationInit() async {
    await LocalNotificationService.init();
  }
}
