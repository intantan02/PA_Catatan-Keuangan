import 'dart:convert';
import 'dart:io';
import 'package:catatan_keuangan/models/transaction_model.dart';
import 'package:hive/hive.dart';


Future<void> importJsonToHive() async {
  // Baca file JSON dari path lokal
  final file = File('lib/catatan_keuangan_50.json');
  final jsonString = await file.readAsString();
  final List<dynamic> jsonList = json.decode(jsonString);

  final box = await Hive.openBox('transactions');

  for (var item in jsonList) {
    final transaction = TransactionModel(
      id: int.tryParse(item['id'].toString()),
      remoteId: null,
      title: item['title'] ?? '',
      amount: (item['amount'] is num)
          ? (item['amount'] as num).toDouble()
          : double.tryParse(item['amount'].toString()) ?? 0.0,
      category: item['category'] ?? '', // Jika tidak ada, isi string kosong
      type: item['type'] ?? '',
      date: item['date'] ?? '',
      note: item['note'] ?? '',
      userId: 1, // Ganti sesuai userId yang diinginkan
    );
    await box.put(transaction.id, transaction.toLocalJson());
  }
  print('Import selesai!');
}