// lib/services/pdf_exporter.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/transaction_model.dart';

class PdfExporter {
  final pw.Document pdf = pw.Document();

  Future<File> generateTransactionReport(List<TransactionModel> transactions) async {
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
    final file = File("${output.path}/laporan_transaksi.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
