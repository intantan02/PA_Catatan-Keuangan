import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../data/local/preferences_helper.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  /// Inisialisasi user dari Hive & Preferences saat app start
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
            name: userData['name'] as String? ?? '', userId: '',
          );
        } else {
          _user = null;
          _isLoggedIn = false;
          await PreferencesHelper.clearPreferences(); // bersihkan jika data user invalid
        }
      } else {
        _isLoggedIn = false;
        _user = null;
        await PreferencesHelper.clearPreferences();
      }
    }
    notifyListeners();
  }

  /// Login user dan simpan data ke Preferences dan provider
  Future<bool> login(String email, String password) async {
    final success = await _repository.login(email, password);
    if (success) {
      final userData = await _repository.getUserByEmail(email);
      if (userData != null) {
        _user = UserModel(
          id: userData['id'] as int,
          email: userData['email'] as String,
          password: userData['password'] as String,
          name: userData['name'] as String? ?? '', userId: '',
        );

        _isLoggedIn = true;

        await PreferencesHelper.setLoginStatus(true);
        await PreferencesHelper.setUserEmail(email);
        await PreferencesHelper.setUserId(userData['id'] as int);

        notifyListeners();
      } else {
        return false; // gagal dapat data user setelah login
      }
    }
    return success;
  }

  /// Logout, hapus data di preferences dan provider
  Future<void> logout() async {
    await _repository.logout();
    await PreferencesHelper.clearPreferences();

    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  /// Update user di repository, Hive, preferences dan provider
  Future<bool> updateUser(String newEmail, String newPassword) async {
    if (_user == null) return false;

    final success = await _repository.updateUser(
      _user!.id!,
      newEmail,
      newPassword,
    );

    if (success) {
      final box = await Hive.openBox('users');

      final updated = _user!.copyWith(email: newEmail, password: newPassword);
      await box.put(_user!.id, updated.toLocalJson());

      _user = updated;

      await PreferencesHelper.setUserEmail(newEmail);
      notifyListeners();
    }

    return success;
  }

  /// Set user langsung dari Map (misal manual login/register)
  void setUserFromMap(Map<String, dynamic> userMap) {
    _user = UserModel.fromJson(userMap);
    _isLoggedIn = true;
    notifyListeners();
  }
}
