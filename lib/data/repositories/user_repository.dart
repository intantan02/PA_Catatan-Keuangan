import '../../data/local/db_helper.dart';
import '../../data/local/preferences_helper.dart';

class UserRepository {
  final DBHelper _dbHelper = DBHelper();

  // Simpan status login di Hive
  Future<void> setLoginStatus(bool status) async {
    await PreferencesHelper.setLoginStatus(status);
  }

  // Ambil status login dari Hive
  Future<bool> getLoginStatus() async {
    return await PreferencesHelper.getLoginStatus();
  }

  // Simpan email user di Hive
  Future<void> setUserEmail(String email) async {
    await PreferencesHelper.setUserEmail(email);
  }

  // Ambil email user dari Hive
  Future<String?> getUserEmail() async {
    return await PreferencesHelper.getUserEmail();
  }

  // Simpan userId di Hive
  Future<void> setUserId(int userId) async {
    await PreferencesHelper.setUserId(userId);
  }

  // Ambil userId dari Hive
  Future<int?> getUserId() async {
    return await PreferencesHelper.getUserId();
  }

  // Login dengan cek DB lokal, simpan status & email jika berhasil
  Future<bool> login(String email, String password) async {
    final user = await _dbHelper.loginUser(email, password);
    if (user != null) {
      await setLoginStatus(true);
      await setUserEmail(email);
      await setUserId(user['id'] as int);
      return true;
    }
    return false;
  }

  // Ambil data user dari DB berdasarkan email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  // Update user (email dan password) di DB dan Hive
  Future<bool> updateUser(int id, String newEmail, String newPassword) async {
    await _dbHelper.updateUser(id, newEmail, newPassword);
    await setUserEmail(newEmail);
    return true;
  }

  // Logout dan hapus semua data preferences Hive
  Future<void> logout() async {
    await PreferencesHelper.clearPreferences();
  }
}