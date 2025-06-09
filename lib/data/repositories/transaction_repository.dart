<<<<<<< HEAD
// data/repositories/transaction_repository.dart

import '../local/db_helper.dart';
import '../../models/transaction_model.dart';
import '../remote/api_service.dart';
=======
import '../local/db_helper.dart';
import '../../models/transaction_model.dart';
import '../remote/api_service.dart';
import 'package:sqflite/sqflite.dart';
>>>>>>> 0c7b4a4 ( perbaikan file)

class TransactionRepository {
  final DBHelper _dbHelper = DBHelper();

<<<<<<< HEAD
  // Ambil data transaksi dari database lokal
  Future<List<TransactionModel>> getLocalTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        type: maps[i]['type'],
        date: maps[i]['date'],
      );
    });
  }

  // Simpan transaksi ke database lokal
  Future<int> insertLocalTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toJson());
  }

  // Ambil data transaksi dari API remote
  Future<List<TransactionModel>> getRemoteTransactions() {
    return ApiService.fetchTransactions();
  }

  // Kirim transaksi ke API remote
  Future<bool> postTransactionRemote(TransactionModel transaction) {
    return ApiService.postTransaction(transaction);
=======
  /// 1️⃣ AMBIL SEMUA DARI LOKAL
  Future<List<TransactionModel>> getAllLocalTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('transactions', orderBy: 'date DESC');

    return maps.map((json) => TransactionModel.fromLocalJson(json)).toList();
  }

  /// 1️⃣.1️⃣ AMBIL TRANSAKSI LOKAL BERDASARKAN USER ID
  Future<List<TransactionModel>> getLocalTransactionsByUser(int userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return maps.map((json) => TransactionModel.fromLocalJson(json)).toList();
  }

  /// 2️⃣ INSERT KE LOKAL (jika sukses, baru nanti kita POST ke remote)
  Future<int> insertLocalTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'transactions',
      transaction.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 3️⃣ UPDATE di LOKAL (misalnya setelah berhasil POST -> kita update kolom remote_id)
  Future<int> updateLocalTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toLocalJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 4️⃣ DELETE dari LOKAL
  Future<int> deleteLocalTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 5️⃣ AMBIL DARI REMOTE (API /notes)
  Future<List<TransactionModel>> getAllRemoteTransactions() async {
    return await ApiService.fetchTransactions();
  }

  /// 6️⃣ POST KE REMOTE. Mengembalikan objek lengkap (dengan remoteId baru)
  Future<TransactionModel> postTransactionRemote(
      TransactionModel transaction) async {
    return await ApiService.createTransaction(transaction);
  }

  /// 7️⃣ UPDATE DI REMOTE (jika Anda butuh fitur edit di remote)
  Future<TransactionModel> updateTransactionRemote(
      TransactionModel transaction) async {
    return await ApiService.updateTransaction(transaction);
  }

  /// 8️⃣ DELETE DI REMOTE
  Future<void> deleteTransactionRemote(String remoteId) async {
    return await ApiService.deleteTransaction(remoteId);
>>>>>>> 0c7b4a4 ( perbaikan file)
  }
}
