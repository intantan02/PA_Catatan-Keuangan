import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../models/transaction_model.dart';

class ApiService {
  static final String _endpoint = '${AppConstants.apiBaseUrl}/notes';

  static Future<List<TransactionModel>> fetchTransactions() async {
    final uri = Uri.parse(_endpoint);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => TransactionModel.fromRemoteJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }

  static Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    final uri = Uri.parse(_endpoint);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toRemoteJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return TransactionModel.fromRemoteJson(jsonMap);
    } else {
      throw Exception('Gagal membuat catatan (status: ${response.statusCode})');
    }
  }

  static Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    if (transaction.remoteId == null) {
      throw Exception('Tidak dapat mengupdate catatan tanpa remoteId');
    }
    final uri = Uri.parse('$_endpoint/${transaction.remoteId}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toRemoteJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return TransactionModel.fromRemoteJson(jsonMap);
    } else {
      throw Exception('Gagal mengupdate catatan (status: ${response.statusCode})');
    }
  }

  static Future<void> deleteTransaction(String remoteId) async {
    final uri = Uri.parse('$_endpoint/$remoteId');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus catatan (status: ${response.statusCode})');
    }
  }

  /// Upload banyak transaksi ke server (sinkronisasi batch)
  static Future<bool> uploadTransactions(List<TransactionModel> transactions) async {
    // Jika API tidak mendukung batch, lakukan satu per satu
    bool allSuccess = true;
    for (final tx in transactions) {
      try {
        await createTransaction(tx);
      } catch (_) {
        allSuccess = false;
      }
    }
    return allSuccess;
  }
}