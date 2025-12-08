import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future saveUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", id);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userId");
  }
}
