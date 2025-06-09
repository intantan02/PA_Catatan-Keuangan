<<<<<<< HEAD
// providers/user_provider.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
=======
import 'package:flutter/material.dart';
import '../data/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../data/local/preferences_helper.dart';

class UserProvider extends ChangeNotifier {
>>>>>>> 0c7b4a4 ( perbaikan file)
  final UserRepository _repository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

<<<<<<< HEAD
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _repository.getLoginStatus();
    if (_isLoggedIn) {
      final email = await _repository.getUserEmail();
      _user = UserModel(email: email ?? '', name: '', password: '');
    } else {
      _user = null;
=======
  // Inisialisasi user dari shared preferences saat app start
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await PreferencesHelper.getLoginStatus();
    if (_isLoggedIn) {
      final email = await PreferencesHelper.getUserEmail();
      final userId = await PreferencesHelper.getUserId();

      if (email != null && userId != null) {
        // Ambil data user lengkap dari repository jika perlu
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
>>>>>>> 0c7b4a4 ( perbaikan file)
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _repository.login(email, password);
    if (success) {
      _isLoggedIn = true;
<<<<<<< HEAD
      _user = UserModel(email: email, name: '', password: password);
=======

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

>>>>>>> 0c7b4a4 ( perbaikan file)
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _repository.logout();
<<<<<<< HEAD
=======
    await PreferencesHelper.clearPreferences();

>>>>>>> 0c7b4a4 ( perbaikan file)
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
<<<<<<< HEAD
}
=======

  Future<bool> updateUser(String newEmail, String newPassword) async {
    if (_user == null) return false;

    final success = await _repository.updateUser(
      _user!.id!,
      newEmail,
      newPassword,
    );

    if (success) {
      // Update user lokal dan simpan di preferences
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
>>>>>>> 0c7b4a4 ( perbaikan file)
