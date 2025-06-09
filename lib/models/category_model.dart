class CategoryModel {
  final int? id;
  final String name;
  final String type; // "expense" atau "income"

  CategoryModel({
    this.id,
    required this.name,
    required this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'type': type,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}