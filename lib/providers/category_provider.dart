<<<<<<< HEAD
// providers/category_provider.dart

import 'package:flutter/material.dart';
import '../../models/category_model.dart';
=======
// lib/providers/category_provider.dart

import 'package:flutter/material.dart';
import '../models/category_model.dart';
>>>>>>> 0c7b4a4 ( perbaikan file)
import '../data/repositories/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

<<<<<<< HEAD
  bool get isLoading => null;

  Future<void> loadCategories() async {
    _categories = await _repository.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _repository.insertCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _repository.updateCategory(category);
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    _categories.removeWhere((c) => c.id == id);
=======
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
      final newCat = await _repository.insertCategory(category);
      _categories.add(newCat);
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
>>>>>>> 0c7b4a4 ( perbaikan file)
    notifyListeners();
  }
}
