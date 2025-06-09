import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/transaction_model.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  Future<Map<String, double>> _getSummary() async {
    final box = await Hive.openBox('transactions');
    final transactions = box.values
        .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
        .toList();

    double totalIncome = 0;
    double totalExpense = 0;

    for (final tx in transactions) {
      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else if (tx.type == 'expense') {
        totalExpense += tx.amount;
      }
    }

    return {
      'income': totalIncome,
      'expense': totalExpense,
      'balance': totalIncome - totalExpense,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: FutureBuilder<Map<String, double>>(
        future: _getSummary(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Pemasukan: Rp${data['income']?.toStringAsFixed(2) ?? '0'}',
                    style: const TextStyle(fontSize: 18, color: Colors.green)),
                const SizedBox(height: 12),
                Text('Total Pengeluaran: Rp${data['expense']?.toStringAsFixed(2) ?? '0'}',
                    style: const TextStyle(fontSize: 18, color: Colors.red)),
                const SizedBox(height: 12),
                Text('Saldo: Rp${data['balance']?.toStringAsFixed(2) ?? '0'}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}