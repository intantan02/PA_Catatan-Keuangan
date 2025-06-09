<<<<<<< HEAD
// data/repositories/user_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class UserRepository {
  // Simpan status login di SharedPreferences
  Future<void> setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
=======
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
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  // Ambil status login dari SharedPreferences
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
<<<<<<< HEAD
    return prefs.getBool('isLoggedIn') ?? false;
=======
    return prefs.getBool(_keyIsLoggedIn) ?? false;
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  // Simpan email user di SharedPreferences
  Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
<<<<<<< HEAD
    await prefs.setString('userEmail', email);
=======
    await prefs.setString(_keyUserEmail, email);
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  // Ambil email user dari SharedPreferences
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
<<<<<<< HEAD
    return prefs.getString('userEmail');
  }

  // Simulasi login (bisa diganti dengan API autentikasi)
  Future<bool> login(String email, String password) async {
    // Dummy validasi, harus diganti sesuai kebutuhan
    if (email == 'user@example.com' && password == 'password123') {
=======
    return prefs.getString(_keyUserEmail);
  }

  // Login dengan cek DB lokal, simpan status & email jika berhasil
  Future<bool> login(String email, String password) async {
    final user = await _dbHelper.getUserByEmailAndPassword(email, password);
    if (user != null) {
>>>>>>> 0c7b4a4 ( perbaikan file)
      await setLoginStatus(true);
      await setUserEmail(email);
      return true;
    }
    return false;
  }

<<<<<<< HEAD
  // Logout dan hapus data user
=======
  // Ambil data user dari DB berdasarkan email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  // Update user (email dan password) di DB dan SharedPreferences
  Future<bool> updateUser(int id, String newEmail, String newPassword) async {
    final result = await _dbHelper.updateUser(id, newEmail, newPassword);
    if (result > 0) {
      // Update email di shared preferences jika berhasil update DB
      await setUserEmail(newEmail);
      return true;
    }
    return false;
  }

  // Logout dan hapus semua data shared preferences
>>>>>>> 0c7b4a4 ( perbaikan file)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
