import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import '../../models/transaction_model.dart';

class TransactionDetailScreen extends StatefulWidget {
  final int transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  Future<TransactionModel?> _getTransaction() async {
    final box = await Hive.openBox('transactions');
    final data = box.get(widget.transactionId);
    if (data != null) {
      return TransactionModel.fromLocalJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> _editTransaction(TransactionModel transaction) async {
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(text: transaction.amount.toString());
    final noteController = TextEditingController(text: transaction.note);
    String category = transaction.category;
    String type = transaction.type;

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
                final updated = transaction.copyWith(
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? transaction.amount,
                  note: noteController.text,
                  category: category,
                  type: type,
                );
                await box.put(transaction.id, updated.toLocalJson());
                if (mounted) Navigator.pop(context);
                setState(() {});
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
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return true;
    }
    return true;
  }

  Future<String?> _getDownloadFolderPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;
      String path = directory.path;
      final paths = path.split('/');
      int androidIndex = paths.indexOf('Android');
      if (androidIndex > 0) {
        path = paths.sublist(0, androidIndex).join('/');
      }
      return '$path/Download';
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    return null;
  }

  Future<void> _exportToCsv(TransactionModel transaction) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin penyimpanan ditolak')));
      }
      return;
    }

    final rows = [
      ['Judul', 'Jumlah', 'Kategori', 'Tipe', 'Tanggal', 'Catatan'],
      [
        transaction.title,
        transaction.amount,
        transaction.category,
        transaction.type,
        transaction.date,
        transaction.note,
      ]
    ];
    final csvData = const ListToCsvConverter().convert(rows);

    final folderPath = await _getDownloadFolderPath();
    if (folderPath == null) return;

    final dir = Directory(folderPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    final file = File('${dir.path}/transaksi_${transaction.id}.csv');
    await file.writeAsString(csvData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV berhasil disimpan di: ${file.path}')),
      );
    }
  }

  Future<void> _exportToPdf(TransactionModel transaction) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin penyimpanan ditolak')));
      }
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Table.fromTextArray(
          headers: ['Judul', 'Jumlah', 'Kategori', 'Tipe', 'Tanggal', 'Catatan'],
          data: [
            [
              transaction.title,
              transaction.amount.toString(),
              transaction.category,
              transaction.type,
              transaction.date,
              transaction.note,
            ]
          ],
        ),
      ),
    );

    final folderPath = await _getDownloadFolderPath();
    if (folderPath == null) return;

    final dir = Directory(folderPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    final file = File('${dir.path}/transaksi_${transaction.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF berhasil disimpan di: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          FutureBuilder<TransactionModel?>(
            future: _getTransaction(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTransaction(snapshot.data!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
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
                          await _deleteTransaction(snapshot.data!.id!);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Export ke CSV',
                      onPressed: () => _exportToCsv(snapshot.data!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      tooltip: 'Export ke PDF',
                      onPressed: () => _exportToPdf(snapshot.data!),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<TransactionModel?>(
        future: _getTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Transaksi tidak ditemukan'));
          }
          final transaction = snapshot.data!;
          final dateTime = DateTime.parse(transaction.date).toLocal();
          final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Tanggal : $formattedDate',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  'Catatan : ${transaction.note}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
