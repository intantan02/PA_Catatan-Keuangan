import 'package:hive/hive.dart';
import '../../models/transaction_model.dart';

class ApiService {
  static const String transactionBoxName = 'transactions';

  /// Ambil semua transaksi dari Hive
  static Future<List<TransactionModel>> fetchTransactions() async {
    final box = await Hive.openBox(transactionBoxName);
    return box.values
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Tambah transaksi ke Hive
  static Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox(transactionBoxName);
    final id = box.length + 1;
    final txMap = transaction.copyWith(id: id).toLocalJson();
    await box.put(id, txMap);
    return TransactionModel.fromLocalJson(txMap);
  }

  /// Update transaksi di Hive
  static Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw Exception('Tidak dapat mengupdate catatan tanpa id');
    }
    final box = await Hive.openBox(transactionBoxName);
    await box.put(transaction.id, transaction.toLocalJson());
    return transaction;
  }

  /// Hapus transaksi dari Hive
  static Future<void> deleteTransaction(int id) async {
    final box = await Hive.openBox(transactionBoxName);
    await box.delete(id);
  }

  /// Upload banyak transaksi ke Hive (batch insert)
  static Future<bool> uploadTransactions(List<TransactionModel> transactions) async {
    final box = await Hive.openBox(transactionBoxName);
    bool allSuccess = true;
    for (final tx in transactions) {
      try {
        final id = box.length + 1;
        await box.put(id, tx.copyWith(id: id).toLocalJson());
      } catch (_) {
        allSuccess = false;
      }
    }
    return allSuccess;
  }
}