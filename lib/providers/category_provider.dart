import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'package:hive/hive.dart';

class CategoryProvider with ChangeNotifier {
  static const String categoryBoxName = 'categories';

  late Box _categoryBox; // Simpan box Hive untuk reuse

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Buka box Hive sekali saja
  Future<void> _openBox() async {
    if (!Hive.isBoxOpen(categoryBoxName)) {
      _categoryBox = await Hive.openBox(categoryBoxName);
    } else {
      _categoryBox = Hive.box(categoryBoxName);
    }
  }

  Future<void> loadCategories({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _openBox();

      final allCategories = _categoryBox.toMap().entries.map((entry) {
        final map = Map<String, dynamic>.from(entry.value);
        map['id'] = entry.key; // Pasang id dari key Hive
        return CategoryModel.fromJson(map);
      }).toList();

      // Filter kategori berdasarkan userId
      _categories = allCategories.where((cat) => cat.userId == userId).toList();
    } catch (e) {
      _categories = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _openBox();

      final id = await _categoryBox.add(category.toJson()); // id otomatis
      final newCat = category.copyWith(id: id);
      await _categoryBox.put(id, newCat.toJson()); // update dengan id yang benar
      _categories.add(newCat);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _openBox();

      if (category.id != null) {
        await _categoryBox.put(category.id, category.toJson());
        final index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = category;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _openBox();

      await _categoryBox.delete(id);
      _categories.removeWhere((c) => c.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
