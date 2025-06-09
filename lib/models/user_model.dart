import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String password; // biasanya disimpan hashed di backend

  @HiveField(4)
  final String userId; // tambahan field userId

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      userId: json['userId'] as String? ?? '',  // userId ditambahkan di sini
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'userId': userId,  // userId ditambahkan di sini
    };
  }

  // Untuk Hive
  factory UserModel.fromLocalJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'userId': userId,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? password,
    String? userId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      userId: userId ?? this.userId,
    );
  }
}
