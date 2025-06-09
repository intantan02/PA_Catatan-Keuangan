import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Muat daftar kategori
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getCategories();
      _categories = data;
    } catch (e) {
      _categories = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Tambah kategori baru
  Future<void> addCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = await _repository.insertCategory(category);
      final newCat = CategoryModel(
        id: id,
        name: category.name,
        type: category.type,
      );
      _categories.add(newCat);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update kategori
  Future<void> updateCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Hapus kategori berdasarkan ID
  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}