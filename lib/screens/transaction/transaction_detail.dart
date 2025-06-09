<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
// lib/screens/transaction/transaction_detail.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
>>>>>>> 0c7b4a4 ( perbaikan file)
import '../../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    // 1) Parse string ISO lengkap menjadi DateTime
    final dateTime = DateTime.parse(transaction.date).toLocal();

    // 2) Format hanya tanggal, misalnya "02 Jun 2025"
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

>>>>>>> 0c7b4a4 ( perbaikan file)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text('Judul: ${transaction.title}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Jumlah: Rp ${transaction.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Kategori ID: ${transaction.categoryId}'),
            const SizedBox(height: 8),
            Text('Tipe: ${transaction.type}'),
            const SizedBox(height: 8),
            Text('Tanggal: ${transaction.date.toLocal().toString().split(' ')[0]}'),
=======
            Text(
              'Judul   : ${transaction.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Text(
              'Jumlah : Rp ${NumberFormat('#,##0', 'id_ID').format(transaction.amount)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text(
              'Kategori: ${transaction.category}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text(
              'Tipe    : ${transaction.type}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Tampilkan hanya tanggal, tanpa “T” atau jam
            Text(
              'Tanggal : $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
>>>>>>> 0c7b4a4 ( perbaikan file)
          ],
        ),
      ),
    );
  }
}
<<<<<<< HEAD

extension on String {
  toLocal() {}
}
=======
>>>>>>> 0c7b4a4 ( perbaikan file)
