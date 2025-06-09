<<<<<<< HEAD
// data/repositories/category_repository.dart

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
=======
// lib/data/repositories/category_repository.dart

import '../../models/category_model.dart';

/// Stub sederhana untuk CategoryRepository.
class CategoryRepository {
  final List<CategoryModel> _dummyDb = [
    CategoryModel(id: 1, name: 'Makan', type: 'expense'),
    CategoryModel(id: 2, name: 'Transport', type: 'expense'),
    CategoryModel(id: 3, name: 'Gaji', type: 'income'),
  ];

  /// Ambil seluruh daftar kategori
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<CategoryModel>.from(_dummyDb);
  }

  Future<CategoryModel> insertCategory(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newId = (_dummyDb.isEmpty)
        ? 1
        : (_dummyDb.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final newCategory = CategoryModel(
      id: newId,
      name: category.name,
      type: category.type,
    );
    _dummyDb.add(newCategory);
    return newCategory;
  }

  Future<void> updateCategory(CategoryModel category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _dummyDb.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _dummyDb[index] = category;
    }
  }

  Future<void> deleteCategory(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyDb.removeWhere((c) => c.id == id);
>>>>>>> 0c7b4a4 ( perbaikan file)
  }
}
