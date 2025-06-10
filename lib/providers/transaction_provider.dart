import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  static const String transactionBoxName = 'transactions';

  int _userId = 0;
  set userId(int value) {
    _userId = value;
    loadTransactions(userId: _userId);
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions({int? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ Jika userId null → ambil data dari JSON lokal
      if ((userId ?? _userId) == 0) {
        final jsonStr = await rootBundle.loadString('assets/catatan_keuangan_50.json');
        final jsonList = json.decode(jsonStr) as List;
        _transactions = jsonList
           .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _transactions.sort((a, b) => b.date.compareTo(a.date));
      } else {
        final box = await Hive.openBox(transactionBoxName);
        final txs = box.values
            .where((e) => e['user_id'] == (userId ?? _userId))
            .map((e) => TransactionModel.fromLocalJson(Map<String, dynamic>.from(e)))
            .toList();
        txs.sort((a, b) => b.date.compareTo(a.date));
        _transactions = txs;
      }
    } catch (e) {
      _transactions = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<int?> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final box = await Hive.openBox(transactionBoxName);
      final id = box.length + 1;
      final tx = transaction.copyWith(id: id, userId: _userId);
      await box.put(id, tx.toLocalJson());
      await loadTransactions(userId: _userId);

      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final box = await Hive.openBox(transactionBoxName);
      if (transaction.id != null) {
        await box.put(transaction.id, transaction.toLocalJson());
        await loadTransactions(userId: _userId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final box = await Hive.openBox(transactionBoxName);
      if (transaction.id != null) {
        await box.delete(transaction.id);
        await loadTransactions(userId: _userId);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }
}
