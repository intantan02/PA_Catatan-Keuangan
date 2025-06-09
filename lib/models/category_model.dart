<<<<<<< HEAD
// data/models/category_model.dart

class CategoryModel {
  final int? id;
  final String name;
  final String type;

  CategoryModel({
    this.id,
=======
// lib/models/category_model.dart

class CategoryModel {
  final int id;
  final String name;
  final String type; // "expense" atau "income"

  CategoryModel({
    required this.id,
>>>>>>> 0c7b4a4 ( perbaikan file)
    required this.name,
    required this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
<<<<<<< HEAD
      id: json['id'],
      name: json['name'],
      type: json['type'],
=======
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'expense',
>>>>>>> 0c7b4a4 ( perbaikan file)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}
