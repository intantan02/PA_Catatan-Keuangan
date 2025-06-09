// lib/services/sync_service.dart
import '../data/remote/api_service.dart';
import '../models/transaction_model.dart';

// lib/data/local/db_helper.dart


class DbHelper {
  Future<List<TransactionModel>> getAllTransactions() async {
    // TODO: Implement fetching all transactions from local database
    return [];
  }

  Future<void> markTransactionsAsSynced(List<TransactionModel> transactions) async {
    // TODO: Implement marking transactions as synced in local database
  }

  Future<void> insertOrUpdateTransaction(TransactionModel transaction) async {
    // TODO: Implement insert or update transaction in local database
  }
}


class SyncService {
  final ApiService apiService = ApiService();
  final DbHelper dbHelper = DbHelper();

  /// Sinkronisasi transaksi lokal ke server
  Future<bool> syncTransactions() async {
    try {
      // Ambil semua transaksi lokal
      List<TransactionModel> localTransactions = await dbHelper.getAllTransactions();

      // Kirim ke server
      bool success = await ApiService.uploadTransactions(localTransactions);

      if (success) {
        // Tandai transaksi sudah sinkron (contoh)
        await dbHelper.markTransactionsAsSynced(localTransactions);
      }

      return success;
    } catch (e) {
      print('Sync error: $e');
      return false;
    }
  }

  /// Download data terbaru dari server dan simpan lokal
  Future<void> fetchAndUpdateData() async {
    try {
      List<TransactionModel> remoteTransactions = await ApiService.fetchTransactions();

      // Update database lokal
      for (var tx in remoteTransactions) {
        await dbHelper.insertOrUpdateTransaction(tx);
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }
}
