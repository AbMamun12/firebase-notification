import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),

            auth.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              child: Text("Login"),
              onPressed: () async {
                bool ok = await auth.login(
                    phoneCtrl.text.trim(), passCtrl.text.trim());

                if (ok) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid phone or password")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
