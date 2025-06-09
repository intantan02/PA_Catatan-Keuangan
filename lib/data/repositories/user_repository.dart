import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/db_helper.dart';

class UserRepository {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyUserEmail = 'userEmail';

  final DBHelper _dbHelper = DBHelper();

  // Simpan status login di SharedPreferences
  Future<void> setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, status);
  }

  // Ambil status login dari SharedPreferences
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Simpan email user di SharedPreferences
  Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  // Ambil email user dari SharedPreferences
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  // Login dengan cek DB lokal, simpan status & email jika berhasil
  Future<bool> login(String email, String password) async {
    final user = await _dbHelper.getUserByEmailAndPassword(email, password);
    if (user != null) {
      await setLoginStatus(true);
      await setUserEmail(email);
      return true;
    }
    return false;
  }

  // Ambil data user dari DB berdasarkan email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  // Update user (email dan password) di DB dan SharedPreferences
  Future<bool> updateUser(int id, String newEmail, String newPassword) async {
    final result = await _dbHelper.updateUser(id, newEmail, newPassword);
    if (result > 0) {
      await setUserEmail(newEmail);
      return true;
    }
    return false;
  }

  // Logout dan hapus semua data shared preferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}