import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_vm.dart';
import 'notification_list_screen.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // init notification viewmodel when user data ready
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final notifVM = Provider.of<NotificationVM>(context, listen: false);
    if (auth.currentUser != null) {
      notifVM.init(auth.currentUser!.id);
    }
  }

  @override
  void dispose() {
    Provider.of<NotificationVM>(context, listen: false).disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifVM = Provider.of<NotificationVM>(context);
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          // notification icon with badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationListScreen()),
                  );
                },
              ),
              if (notifVM.unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${notifVM.unreadCount}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),

          // existing logout button (your code)...
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // your existing logout dialog
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Do you want to logout?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        await auth.logout();
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(child: Text("Welcome ${user.name}", style: TextStyle(fontSize: 22))),
    );
  }
}
