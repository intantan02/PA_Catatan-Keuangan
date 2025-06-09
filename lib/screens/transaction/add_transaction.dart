import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======

>>>>>>> 0c7b4a4 ( perbaikan file)
import '../../providers/category_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
<<<<<<< HEAD
import '../../widgets/custom_button.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);
=======

class AddTransactionScreen extends StatefulWidget {
  final int userId;  // tambahkan userId

  const AddTransactionScreen({Key? key, required this.userId}) : super(key: key);
>>>>>>> 0c7b4a4 ( perbaikan file)

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
  String title = '';
  double amount = 0;
  CategoryModel? selectedCategory;
  String type = 'expense'; // 'income' or 'expense'
  DateTime selectedDate = DateTime.now();
=======

  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  CategoryModel? _selectedCategory;
  String _type = 'expense';
  String _note = '';
>>>>>>> 0c7b4a4 ( perbaikan file)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.loadCategories();
=======
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
<<<<<<< HEAD
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih kategori terlebih dahulu')));
      return;
    }
    _formKey.currentState!.save();

    final transaction = TransactionModel(
      id: 0,
      title: title,
      amount: amount,
      categoryId: selectedCategory!.id,
      date: selectedDate,
      type: type,
    );

    await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(transaction);

    Navigator.pop(context);
=======
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
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
        userId: widget.userId,  // kirim userId ke model
      );

      await Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTx);

      if (mounted) Navigator.of(context).pop();
    }
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
<<<<<<< HEAD
=======
    final isLoading = categoryProvider.isLoading;
    final categories = categoryProvider.categories;
    final error = categoryProvider.errorMessage;
>>>>>>> 0c7b4a4 ( perbaikan file)

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
<<<<<<< HEAD
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Judul wajib diisi' : null,
                onSaved: (val) => title = val!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Jumlah wajib diisi';
                  if (double.tryParse(val) == null) return 'Jumlah harus angka';
                  return null;
                },
                onSaved: (val) => amount = double.parse(val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(labelText: 'Kategori'),
                value: selectedCategory,
                items: categoryProvider.categories
                    .map((cat) => DropdownMenuItem<CategoryModel>(
                          value: cat,
                          child: Text(cat.name),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val;
                  });
                },
                validator: (val) =>
                    val == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Tipe: '),
                  Radio<String>(
                      value: 'income',
                      groupValue: type,
                      onChanged: (val) {
                        setState(() {
                          type = val!;
                        });
                      }),
                  const Text('Pemasukan'),
                  Radio<String>(
                      value: 'expense',
                      groupValue: type,
                      onChanged: (val) {
                        setState(() {
                          type = val!;
                        });
                      }),
                  const Text('Pengeluaran'),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              CustomButton(label: 'Simpan', onPressed: _submit),
            ],
          ),
        ),
=======
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
                              (val == null || val.trim().isEmpty)
                                  ? 'Harus diisi'
                                  : null,
                          onSaved: (val) => _title = val!.trim(),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Jumlah'),
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Harus diisi';
                            }
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
                          decoration:
                              const InputDecoration(labelText: 'Kategori'),
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedCategory = val);
                          },
                          value: _selectedCategory,
                          validator: (val) =>
                              val == null ? 'Pilih kategori' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Tipe'),
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
                            setState(() => _type = val!);
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
                          decoration:
                              const InputDecoration(labelText: 'Catatan'),
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
>>>>>>> 0c7b4a4 ( perbaikan file)
      ),
    );
  }
}
