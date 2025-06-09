import 'package:hive/hive.dart';

class PreferencesHelper {
  static const String _boxName = 'preferences';

  static Future<Box> _getBox() async {
    return await Hive.openBox(_boxName);
  }

  static Future<void> setLoginStatus(bool status) async {
    final box = await _getBox();
    await box.put('isLoggedIn', status);
  }

  static Future<bool> getLoginStatus() async {
    final box = await _getBox();
    return box.get('isLoggedIn', defaultValue: false) as bool;
  }

  static Future<void> setUserEmail(String email) async {
    final box = await _getBox();
    await box.put('userEmail', email);
  }

  static Future<String?> getUserEmail() async {
    final box = await _getBox();
    return box.get('userEmail') as String?;
  }

  static Future<void> setUserId(int userId) async {
    final box = await _getBox();
    await box.put('userId', userId);
  }

  static Future<int?> getUserId() async {
    final box = await _getBox();
    return box.get('userId') as int?;
  }

  static Future<void> clearPreferences() async {
    final box = await _getBox();
    await box.clear();
  }
}