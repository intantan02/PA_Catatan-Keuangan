// lib/widgets/transaction_card.dart
<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../core/utils/currency_formatter.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.amount >= 0 ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.2),
          child: Icon(
            transaction.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(transaction.date),
        trailing: Text(
          formatCurrency(transaction.amount),
          style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
=======

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../core/utils/date_helper.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse string menjadi DateTime
    final dateTime = DateHelper.parseDateTime(transaction.date);

    // Format hanya tanggal (tanpa jam)
    final formattedDate = DateHelper.formatDate(dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          transaction.type == 'income'
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          color:
              transaction.type == 'income' ? Colors.green : Colors.red,
        ),
        title: Text(transaction.title),
        subtitle: Text(formattedDate),
        trailing: Text(
          NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
              .format(transaction.amount),
          style: TextStyle(
            color: transaction.type == 'income'
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
>>>>>>> 0c7b4a4 ( perbaikan file)
        ),
      ),
    );
  }
}
