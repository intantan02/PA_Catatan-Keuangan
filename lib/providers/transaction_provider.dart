import 'package:flutter/material.dart';
import '../data/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  int _userId = 0;
  set userId(int value) {
    _userId = value;
    loadTransactions();
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final localData = await _repository.getLocalTransactionsByUser(_userId);
      _transactions = localData;

      final remoteData = await _repository.getAllRemoteTransactions();
      final localByRemoteId = {
        for (var tx in localData) if (tx.remoteId != null) tx.remoteId!: tx
      };

      for (var remoteTx in remoteData) {
        if (!localByRemoteId.containsKey(remoteTx.remoteId)) {
          await _repository.insertLocalTransaction(
            remoteTx.copyWith(userId: _userId),
          );
        }
      }

      _transactions = await _repository.getLocalTransactionsByUser(_userId);
    } catch (e) {
      _transactions = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newLocalId = await _repository.insertLocalTransaction(
        transaction.copyWith(userId: _userId),
      );
      final localTx = transaction.copyWith(id: newLocalId, userId: _userId);

      final remoteTx = await _repository.postTransactionRemote(localTx);
      final updatedLocalTx = localTx.copyWith(remoteId: remoteTx.remoteId);

      await _repository.updateLocalTransaction(updatedLocalTx);
      _transactions = await _repository.getLocalTransactionsByUser(_userId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (transaction.remoteId != null) {
        final updatedRemoteTx = await _repository.updateTransactionRemote(transaction);
        transaction = transaction.copyWith(
          title: updatedRemoteTx.title,
          amount: updatedRemoteTx.amount,
          category: updatedRemoteTx.category,
          type: updatedRemoteTx.type,
          date: updatedRemoteTx.date,
          note: updatedRemoteTx.note,
        );
      }

      await _repository.updateLocalTransaction(transaction);
      _transactions = await _repository.getLocalTransactionsByUser(_userId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (transaction.remoteId != null) {
        await _repository.deleteTransactionRemote(transaction.remoteId!);
      }
      if (transaction.id != null) {
        await _repository.deleteLocalTransaction(transaction.id!);
      }
      _transactions = await _repository.getLocalTransactionsByUser(_userId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}