// lib/services/csv_exporter.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../models/transaction_model.dart';

class CsvExporter {
  Future<File> exportTransactionsToCsv(List<TransactionModel> transactions) async {
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
    final file = File('${dir.path}/laporan_transaksi.csv');

    return file.writeAsString(csvData);
  }
}
