import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class CsvExporter {
  /// Ekspor transaksi milik user tertentu (berdasarkan userId) dari Hive ke CSV
  Future<File> exportUserTransactionsFromHive(int userId) async {
    final box = await Hive.openBox('transactions');
    final transactions = box.values
        .where((e) => e['user_id'] == userId)
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();

    List<List<dynamic>> rows = [];
    // Header row
    rows.add(['Tanggal', 'Kategori', 'Deskripsi', 'Jumlah']);

    // Data rows
    for (var transaction in transactions) {
      rows.add([
        transaction.date,
        transaction.category,
        transaction.title,
        transaction.amount,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/laporan_transaksi_user_$userId.csv');

    return file.writeAsString(csvData);
  }
}