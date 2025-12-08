import 'package:flutter/material.dart';
import '../core/prefs.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final service = AuthService();
  UserModel? currentUser;
  bool isLoading = false;

  Future<bool> login(String phone, String password) async {
    isLoading = true;
    notifyListeners();

    final user = await service.login(phone, password);

    isLoading = false;

    if (user != null) {
      currentUser = user;
      await Prefs.saveUser(user.id);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadUser() async {
    String? id = await Prefs.getUser();
    if (id == null) return false;

    currentUser = await service.getUserById(id);
    notifyListeners();
    return true;
  }

  Future logout() async {
    currentUser = null;
    await Prefs.logout();
    notifyListeners();
  }
}
