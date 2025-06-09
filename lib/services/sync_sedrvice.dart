import 'package:hive/hive.dart';
import '../data/remote/api_service.dart';
import '../models/transaction_model.dart';

class DbHelper {
  /// Ambil semua transaksi milik user tertentu dari Hive
  Future<List<TransactionModel>> getAllTransactions({required int userId}) async {
    final box = await Hive.openBox('transactions');
    return box.values
        .where((e) => e['user_id'] == userId)
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> markTransactionsAsSynced(List<TransactionModel> transactions) async {
    // Implementasi opsional: update flag di Hive jika ada field 'synced'
    // Contoh:
    // final box = await Hive.openBox('transactions');
    // for (var tx in transactions) {
    //   final data = Map<String, dynamic>.from(box.get(tx.id));
    //   data['synced'] = true;
    //   await box.put(tx.id, data);
    // }
  }

  Future<void> insertOrUpdateTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox('transactions');
    await box.put(transaction.id, transaction.toLocalJson());
  }
}

class SyncService {
  final ApiService apiService = ApiService();
  final DbHelper dbHelper = DbHelper();

  /// Sinkronisasi transaksi lokal ke server (hanya milik user tertentu)
  Future<bool> syncTransactions(int userId) async {
    try {
      // Ambil semua transaksi lokal milik user
      List<TransactionModel> localTransactions =
          await dbHelper.getAllTransactions(userId: userId);

      // Kirim ke server
      bool success = await ApiService.uploadTransactions(localTransactions);

      if (success) {
        // Tandai transaksi sudah sinkron (jika perlu)
        await dbHelper.markTransactionsAsSynced(localTransactions);
      }

      return success;
    } catch (e) {
      print('Sync error: $e');
      return false;
    }
  }

  /// Download data terbaru dari server dan simpan lokal (hanya milik user)
  Future<void> fetchAndUpdateData(int userId) async {
    try {
      List<TransactionModel> remoteTransactions = await ApiService.fetchTransactions();

      // Filter hanya transaksi milik user
      final userTransactions =
          remoteTransactions.where((tx) => tx.userId == userId).toList();

      // Update database lokal
      for (var tx in userTransactions) {
        await dbHelper.insertOrUpdateTransaction(tx);
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }
}