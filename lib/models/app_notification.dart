import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool? read;
  final Map<String, dynamic>? extra;
  final bool isGlobal;
  final String? userId; // if user-specific

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read,
    this.extra,
    required this.isGlobal,
    this.userId,
  });

  factory AppNotification.fromDoc(String id, Map<String, dynamic> data,
      {bool isGlobal = false, String? userId}) {
    return AppNotification(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] as bool?,
      extra: (data['extra'] as Map<String, dynamic>?) ?? {},
      isGlobal: isGlobal,
      userId: userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'read': read ?? false,
      'extra': extra ?? {},
    };
  }
}
