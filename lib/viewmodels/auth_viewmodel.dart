import 'package:flutter/material.dart';
import '../core/prefs.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      /// === SAVE USER IN LOCAL STORAGE === ///
      await Prefs.saveUser(user.id);

      /// === NOW UPDATE FCM TOKEN IN FIRESTORE === ///
      final fcm = FCMService();
      final token = await fcm.getToken();

      if (token != null) {
        FirebaseFirestore.instance
            .collection('User')
            .doc(user.id)
            .update({'fcmToken': token});
      }

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

    // update token here also
    final fcm = FCMService();
    final token = await fcm.getToken();
    if (token != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(id)
          .update({'fcmToken': token});
    }

    notifyListeners();
    return true;
  }

  Future logout() async {
    currentUser = null;
    await Prefs.logout();
    notifyListeners();
  }
}
