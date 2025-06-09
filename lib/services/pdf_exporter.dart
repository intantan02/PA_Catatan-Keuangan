import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class PdfExporter {
  final pw.Document pdf = pw.Document();

  /// Generate laporan transaksi hanya untuk user tertentu dari Hive
  Future<File> generateUserTransactionReport(int userId) async {
    final box = await Hive.openBox('transactions');
    final transactions = box.values
        .where((e) => e['user_id'] == userId)
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('Laporan Transaksi', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Tanggal', 'Kategori', 'Title', 'Jumlah'],
                data: transactions.map((t) => [
                  t.date,
                  t.category,
                  t.title,
                  _formatCurrency(t.amount),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/laporan_transaksi_user_$userId.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}