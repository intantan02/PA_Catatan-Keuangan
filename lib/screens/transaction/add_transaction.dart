import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
import 'transaction_detail.dart';

class AddTransactionScreen extends StatefulWidget {
  final int userId;
  const AddTransactionScreen({super.key, required this.userId});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  CategoryModel? _selectedCategory;
  String _type = 'expense';
  String _note = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Load kategori untuk user ini
      Provider.of<CategoryProvider>(context, listen: false)
          .loadCategories(userId: widget.userId);
      // Set userId di TransactionProvider
      Provider.of<TransactionProvider>(context, listen: false).userId = widget.userId;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
        );
      }
      return;
    }

    _formKey.currentState!.save();

    final newTx = TransactionModel(
      id: null,
      remoteId: null,
      title: _title,
      amount: _amount,
      category: _selectedCategory!.name,
      type: _type,
      date: _selectedDate.toIso8601String(),
      note: _note,
      userId: widget.userId,
    );

    final newId = await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(newTx);

    if (mounted && newId != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transactionId: newId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final isLoading = categoryProvider.isLoading;
    final categories = categoryProvider.categories;
    final error = categoryProvider.errorMessage;

    // Filter kategori sesuai tipe transaksi
    final filteredCategories = categories.where((cat) => cat.type == _type).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (error != null
                ? Center(child: Text('Error: $error'))
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Judul'),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'Harus diisi' : null,
                          onSaved: (val) => _title = val!.trim(),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Jumlah'),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Harus diisi';
                            final parsed = double.tryParse(val);
                            if (parsed == null || parsed <= 0) {
                              return 'Masukkan angka lebih dari 0';
                            }
                            return null;
                          },
                          onSaved: (val) => _amount = double.parse(val!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<CategoryModel>(
                          decoration: const InputDecoration(labelText: 'Kategori'),
                          items: filteredCategories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedCategory = val);
                          },
                          value: _selectedCategory,
                          validator: (val) => val == null ? 'Pilih kategori' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Tipe'),
                          value: _type,
                          items: const [
                            DropdownMenuItem(
                              value: 'expense',
                              child: Text('Pengeluaran'),
                            ),
                            DropdownMenuItem(
                              value: 'income',
                              child: Text('Pemasukan'),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _type = val!;
                              _selectedCategory = null; // Reset kategori jika tipe berubah
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                            'Tanggal: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                          ),
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Catatan'),
                          maxLines: 3,
                          onSaved: (val) => _note = val?.trim() ?? '',
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
