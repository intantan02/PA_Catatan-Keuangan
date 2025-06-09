import 'package:hive/hive.dart';
import '../../models/transaction_model.dart';
import '../remote/api_service.dart';

class TransactionRepository {
  static const String transactionBoxName = 'transactions';

  /// 1️⃣ AMBIL SEMUA DARI LOKAL (Hive)
  Future<List<TransactionModel>> getAllLocalTransactions() async {
    final box = await Hive.openBox(transactionBoxName);
    final txs = box.values
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();
    txs.sort((a, b) => b.date.compareTo(a.date));
    return txs;
  }

  /// 1️⃣.1️⃣ AMBIL TRANSAKSI LOKAL BERDASARKAN USER ID
  Future<List<TransactionModel>> getLocalTransactionsByUser(int userId) async {
    final box = await Hive.openBox(transactionBoxName);
    final txs = box.values
        .where((e) => e['user_id'] == userId)
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();
    txs.sort((a, b) => b.date.compareTo(a.date));
    return txs;
  }

  /// 2️⃣ INSERT KE LOKAL (Hive)
  Future<int> insertLocalTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox(transactionBoxName);
    final id = box.length + 1;
    await box.put(id, transaction.copyWith(id: id).toLocalJson());
    return id;
  }

  /// 3️⃣ UPDATE di LOKAL (Hive)
  Future<void> updateLocalTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox(transactionBoxName);
    if (transaction.id != null) {
      await box.put(transaction.id, transaction.toLocalJson());
    }
  }

  /// 4️⃣ DELETE dari LOKAL (Hive)
  Future<void> deleteLocalTransaction(int id) async {
    final box = await Hive.openBox(transactionBoxName);
    await box.delete(id);
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
  Future<void> deleteTransactionRemote(int remoteId) async {
    return await ApiService.deleteTransaction(remoteId);
  }
}