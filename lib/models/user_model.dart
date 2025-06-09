// data/models/user_model.dart

class UserModel {
  final int? id;
  final String email;
  final String name;
  final String password; // biasanya disimpan hashed di backend

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
