import 'package:flutter/material.dart';
import '../data/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../data/local/preferences_helper.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Inisialisasi user dari shared preferences saat app start
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await PreferencesHelper.getLoginStatus();
    if (_isLoggedIn) {
      final email = await PreferencesHelper.getUserEmail();
      final userId = await PreferencesHelper.getUserId();

      if (email != null && userId != null) {
        final userData = await _repository.getUserByEmail(email);
        if (userData != null) {
          _user = UserModel(
            id: userData['id'] as int,
            email: userData['email'] as String,
            password: userData['password'] as String,
            name: '', // Isi jika ada kolom name
          );
        } else {
          _user = null;
          _isLoggedIn = false;
        }
      } else {
        _isLoggedIn = false;
        _user = null;
      }
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _repository.login(email, password);
    if (success) {
      _isLoggedIn = true;

      final userData = await _repository.getUserByEmail(email);
      if (userData != null) {
        _user = UserModel(
          id: userData['id'] as int,
          email: userData['email'] as String,
          password: userData['password'] as String,
          name: '', // Isi jika ada kolom name
        );

        await PreferencesHelper.setLoginStatus(true);
        await PreferencesHelper.setUserEmail(email);
        await PreferencesHelper.setUserId(userData['id'] as int);
      }

      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _repository.logout();
    await PreferencesHelper.clearPreferences();

    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  Future<bool> updateUser(String newEmail, String newPassword) async {
    if (_user == null) return false;

    final success = await _repository.updateUser(
      _user!.id!,
      newEmail,
      newPassword,
    );

    if (success) {
      _user = UserModel(
        id: _user!.id,
        email: newEmail,
        password: newPassword,
        name: _user!.name,
      );
      await PreferencesHelper.setUserEmail(newEmail);
      notifyListeners();
    }
    return success;
  }
}