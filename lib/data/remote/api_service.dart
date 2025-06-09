<<<<<<< HEAD
// data/remote/api_service.dart
=======
// lib/data/remote/api_service.dart
>>>>>>> 0c7b4a4 ( perbaikan file)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../models/transaction_model.dart';

class ApiService {
<<<<<<< HEAD
  static Future<List<TransactionModel>> fetchTransactions() async {
    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/transactions'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  static Future<bool> postTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toJson()),
    );
    return response.statusCode == 201;
  }

  uploadTransactions(List<TransactionModel> localTransactions) {}
}
=======
  static final String _notesEndpoint = '${AppConstants.apiBaseUrl}/notes';

  static Future<List<TransactionModel>> fetchTransactions() async {
    final uri = Uri.parse(_notesEndpoint);
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

  static Future<TransactionModel> createTransaction(
      TransactionModel transaction) async {
    final uri = Uri.parse(_notesEndpoint);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toRemoteJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          json.decode(response.body) as Map<String, dynamic>;
      return TransactionModel.fromRemoteJson(jsonMap);
    } else {
      throw Exception(
          'Gagal membuat catatan (status: ${response.statusCode})');
    }
  }

  static Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    if (transaction.remoteId == null) {
      throw Exception('Tidak dapat mengupdate catatan tanpa remoteId');
    }
    final uri = Uri.parse('$_notesEndpoint/${transaction.remoteId}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toRemoteJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          json.decode(response.body) as Map<String, dynamic>;
      return TransactionModel.fromRemoteJson(jsonMap);
    } else {
      throw Exception(
          'Gagal mengupdate catatan (status: ${response.statusCode})');
    }
  }

  static Future<void> deleteTransaction(String remoteId) async {
    final uri = Uri.parse('$_notesEndpoint/$remoteId');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Gagal menghapus catatan (status: ${response.statusCode})');
    }
  }
}
>>>>>>> 0c7b4a4 ( perbaikan file)
