class UserModel {
  final String id;
  final String name;
  final String phone;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'],
      phone: data['phone'],
      password: data['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phone": phone,
      "password": password,
    };
  }
}
