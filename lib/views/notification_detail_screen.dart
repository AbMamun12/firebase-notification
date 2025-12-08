import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatelessWidget {
  final AppNotification notif;
  const NotificationDetailScreen({required this.notif, super.key});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('yyyy-MM-dd HH:mm').format(notif.createdAt);
    return Scaffold(
      appBar: AppBar(title: Text("Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(time, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text(notif.body, style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            if (notif.extra != null && notif.extra!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: notif.extra!.entries.map((e) =>
                    Text("${e.key}: ${e.value}")
                ).toList(),
              )
          ],
        ),
      ),
    );
  }
}
