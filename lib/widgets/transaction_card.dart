import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final Widget? trailing;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final amountColor = isIncome ? Colors.green : Colors.red;

    // Format tanggal (hanya tanggal, tanpa jam)
    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(transaction.date);
      formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    } catch (_) {
      formattedDate = transaction.date;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(formattedDate),
        trailing: trailing ??
            Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(transaction.amount),
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
      ),
    );
  }
}