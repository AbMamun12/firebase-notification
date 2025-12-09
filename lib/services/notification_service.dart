import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_notification.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Streams: global notifications
  Stream<List<AppNotification>> globalNotificationsStream() {
    return _db
        .collection('notifications')
        .doc('global') // we can also use a collection directly
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => AppNotification.fromDoc(d.id, d.data(), isGlobal: true))
        .toList());
  }

  // user notifications stream
  Stream<List<AppNotification>> userNotificationsStream(String uid) {
    return _db
        .collection('notifications')
        .doc('users')
        .collection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) =>
        AppNotification.fromDoc(d.id, d.data(), isGlobal: false, userId: uid))
        .toList());
  }


  // Combined stream helper (not a real combined stream here; viewmodel will merge)
  // Mark read/unread
  Future markAsRead(String uid, AppNotification notif) async {
    if (notif.isGlobal) {
      // For global ones, you may store read status per-user in a subcollection like:
      // notifications/global/items/{notifId}/readBy/{uid}: {readAt: ...}
      // Simpler approach: create a per-user read registry
      await _db
          .collection('notifications')
          .doc('global')
          .collection('items')
          .doc(notif.id)
          .collection('readBy')
          .doc(uid)
          .set({'readAt': FieldValue.serverTimestamp()});
    } else {
      await _db
          .collection('notifications')
          .doc('users')
          .collection(uid)
          .doc(notif.id)
          .update({'read': true});
    }
  }

  Future markAsUnread(String uid, AppNotification notif) async {
    if (notif.isGlobal) {
      await _db
          .collection('notifications')
          .doc('global')
          .collection('items')
          .doc(notif.id)
          .collection('readBy')
          .doc(uid)
          .delete();
    } else {
      await _db
          .collection('notifications')
          .doc('users')
          .collection(uid)
          .doc(notif.id)
          .update({'read': false});
    }
  }

  // Check if user has read a global notification
  Future<bool> isGlobalReadBy(String notifId, String uid) async {
    final doc = await _db
        .collection('notifications')
        .doc('global')
        .collection('items')
        .doc(notifId)
        .collection('readBy')
        .doc(uid)
        .get();
    return doc.exists;
  }

  // helper to create notification (for testing)
  Future createGlobalNotification(String title, String body, {Map<String, dynamic>? extra}) {
    final ref = _db.collection('notifications').doc('global').collection('items').doc();
    return ref.set({
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'extra': extra ?? {},
    });
  }

  Future createUserNotification(String uid, String title, String body, {Map<String, dynamic>? extra}) {
    final ref = _db.collection('notifications').doc('users').collection(uid).doc();
    return ref.set({
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
      'extra': extra ?? {},
    });
  }
}
