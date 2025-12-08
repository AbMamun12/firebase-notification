import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Do you want to logout?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () async {
                          await auth.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                                (route) => false,
                          );
                        },
                        child: Text("OK")),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Welcome ${user.name}",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
