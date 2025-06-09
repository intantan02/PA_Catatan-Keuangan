import '../local/db_helper.dart';
import '../../models/category_model.dart';

class CategoryRepository {
  final DBHelper _dbHelper = DBHelper();

  // Ambil semua kategori dari database lokal
  Future<List<CategoryModel>> getCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return CategoryModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
      );
    });
  }

  // Simpan kategori baru ke database lokal
  Future<int> insertCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', category.toJson());
  }

  // Update kategori yang sudah ada
  Future<int> updateCategory(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Hapus kategori berdasarkan id
  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}