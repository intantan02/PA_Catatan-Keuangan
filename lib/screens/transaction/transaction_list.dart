import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction_card.dart';
import 'add_transaction.dart';
import 'transaction_detail.dart';

class TransactionListScreen extends StatefulWidget {
  final int? userId;

  const TransactionListScreen({super.key, required this.userId});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      Future.microtask(() {
        Provider.of<TransactionProvider>(context, listen: false)
            .loadTransactions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final txList = transactionProvider.transactions;
    final isLoading = transactionProvider.isLoading;
    final error = transactionProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (error != null
              ? Center(child: Text('Error: $error'))
              : txList.isEmpty
                  ? const Center(child: Text('Belum ada transaksi'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        if (widget.userId != null) {
                          await Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .loadTransactions();
                        }
                      },
                      child: ListView.builder(
                        itemCount: txList.length,
                        itemBuilder: (context, index) {
                          final trx = txList[index];
                          final dateOnly = trx.date.split('T')[0];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TransactionDetailScreen(
                                      transaction: trx,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TransactionCard(transaction: trx),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 2.0),
                                    child: Text(
                                      'Tanggal: $dateOnly',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (widget.userId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTransactionScreen(userId: widget.userId!),
              ),
            ).then((_) {
              Provider.of<TransactionProvider>(context, listen: false)
                  .loadTransactions();
            });
          }
        },
      ),
    );
  }
}