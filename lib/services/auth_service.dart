import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final users = FirebaseFirestore.instance.collection("User");

  Future<UserModel?> login(String phone, String password) async {
    final snap = await users
        .where("phone", isEqualTo: phone)
        .where("password", isEqualTo: password)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final doc = snap.docs.first;
    return UserModel.fromMap(doc.id, doc.data());
  }

  Future<UserModel> getUserById(String id) async {
    final doc = await users.doc(id).get();
    return UserModel.fromMap(doc.id, doc.data()!);
  }
}
