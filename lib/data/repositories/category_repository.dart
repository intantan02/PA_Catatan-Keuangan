import 'package:hive/hive.dart';
import '../../models/category_model.dart';

class CategoryRepository {
  static const String categoryBoxName = 'categories';

  // Ambil semua kategori dari Hive
  Future<List<CategoryModel>> getCategories() async {
    final box = await Hive.openBox(categoryBoxName);
    return box.values
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Simpan kategori baru ke Hive
  Future<int> insertCategory(CategoryModel category) async {
    final box = await Hive.openBox(categoryBoxName);
    final id = box.length + 1;
    await box.put(id, category.copyWith(id: id).toJson());
    return id;
  }

  // Update kategori yang sudah ada di Hive
  Future<void> updateCategory(CategoryModel category) async {
    final box = await Hive.openBox(categoryBoxName);
    if (category.id != null) {
      await box.put(category.id, category.toJson());
    }
  }

  // Hapus kategori berdasarkan id di Hive
  Future<void> deleteCategory(int id) async {
    final box = await Hive.openBox(categoryBoxName);
    await box.delete(id);
  }
}