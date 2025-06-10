import 'package:hive/hive.dart';

class DBHelper {
  static const String userBoxName = 'users';
  static const String transactionBoxName = 'transactions';

  // Register user
  Future<int> registerUser(String email, String password) async {
    final box = await Hive.openBox(userBoxName);
    // Cek apakah email sudah ada
    final existing = box.values.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );
    if (existing != null) {
      throw Exception('Email sudah terdaftar');
    }
    final id = box.length + 1;
    await box.put(id, {'id': id, 'email': email, 'password': password});
    return id;
  }

  // Login user by email & password
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final box = await Hive.openBox(userBoxName);
    final user = box.values.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => null,
    );
    return user != null ? Map<String, dynamic>.from(user) : null;
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final box = await Hive.openBox(userBoxName);
    final user = box.values.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );
    return user != null ? Map<String, dynamic>.from(user) : null;
  }

  // Update user
  Future<void> updateUser(int id, String newEmail, String newPassword) async {
    final box = await Hive.openBox(userBoxName);
    final user = box.get(id);
    if (user != null) {
      await box.put(id, {
        'id': id,
        'email': newEmail,
        'password': newPassword,
      });
    }
  }

  // Get transactions by user_id
  Future<List<Map<String, dynamic>>> getTransactionsByUser(int userId) async {
    final box = await Hive.openBox(transactionBoxName);
    final txs = box.values
        .where((tx) => tx['user_id'] == userId)
        .map((tx) => Map<String, dynamic>.from(tx))
        .toList();
    txs.sort((a, b) => b['date'].compareTo(a['date']));
    return txs;
  }

  // Add transaction
  Future<int> addTransaction(Map<String, dynamic> tx) async {
    final box = await Hive.openBox(transactionBoxName);
    final id = box.length + 1;
    await box.put(id, {...tx, 'id': id});
    return id;
  }

  // Update transaction
  Future<void> updateTransaction(int id, Map<String, dynamic> tx) async {
    final box = await Hive.openBox(transactionBoxName);
    await box.put(id, {...tx, 'id': id});
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    final box = await Hive.openBox(transactionBoxName);
    await box.delete(id);
  }

  Future<void> close() async {
    await Hive.close();
  }
}