import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction_card.dart';
import 'add_transaction.dart';
import 'transaction_detail.dart';
import 'package:hive/hive.dart';
import '../../models/transaction_model.dart';

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
            .loadTransactions(userId: widget.userId);
      });
    }
  }

  Future<void> _editTransaction(TransactionModel trx) async {
    final titleController = TextEditingController(text: trx.title);
    final amountController = TextEditingController(text: trx.amount.toString());
    final noteController = TextEditingController(text: trx.note);
    String category = trx.category;
    String type = trx.type;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Transaksi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Catatan'),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  controller: TextEditingController(text: category),
                  onChanged: (val) => category = val,
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                    DropdownMenuItem(value: 'expense', child: Text('Pengeluaran')),
                  ],
                  onChanged: (val) {
                    if (val != null) type = val;
                  },
                  decoration: const InputDecoration(labelText: 'Tipe'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final box = await Hive.openBox('transactions');
                final updated = trx.copyWith(
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? trx.amount,
                  note: noteController.text,
                  category: category,
                  type: type,
                );
                await box.put(trx.id, updated.toLocalJson());
                if (mounted) Navigator.pop(context);
                setState(() {});
                Provider.of<TransactionProvider>(context, listen: false)
                    .loadTransactions(userId: widget.userId);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTransaction(int id) async {
    final box = await Hive.openBox('transactions');
    await box.delete(id);
    setState(() {});
    Provider.of<TransactionProvider>(context, listen: false)
        .loadTransactions(userId: widget.userId);
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
                              .loadTransactions(userId: widget.userId);
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
                                      transactionId: trx.id!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TransactionCard(
                                    transaction: trx,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TransactionDetailScreen(
                                            transactionId: trx.id!,
                                          ),
                                        ),
                                      );
                                    },
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _editTransaction(trx),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Hapus Transaksi'),
                                                content: const Text('Yakin ingin menghapus transaksi ini?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('Batal'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text('Hapus'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await _deleteTransaction(trx.id!);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
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
                  .loadTransactions(userId: widget.userId);
            });
          }
        },
      ),
    );
  }
}