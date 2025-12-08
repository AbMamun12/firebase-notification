import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_vm.dart';
import 'notification_detail_screen.dart';
import '../models/app_notification.dart';
import '../viewmodels/auth_viewmodel.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NotificationVM>(context);
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: vm.notifications.isEmpty
          ? Center(child: Text("No notifications"))
          : ListView.builder(
        itemCount: vm.notifications.length,
        itemBuilder: (context, idx) {
          final n = vm.notifications[idx];
          return ListTile(
            tileColor: n.read == true ? Colors.white : Colors.grey[200],
            leading: Icon(n.isGlobal ? Icons.public : Icons.person),
            title: Text(n.title),
            subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: Icon(n.read == true ? Icons.mark_email_read : Icons.mark_email_unread),
              onPressed: () {
                if (n.read == true) {
                  vm.markAsUnread(n);
                } else {
                  vm.markAsRead(n);
                }
              },
            ),
            onTap: () async {
              // mark as read then open detail
              if (n.read != true) await vm.markAsRead(n);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationDetailScreen(notif: n)),
              );
            },
          );
        },
      ),
    );
  }
}
