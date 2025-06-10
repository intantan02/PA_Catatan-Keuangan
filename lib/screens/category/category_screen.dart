import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  final int userId; // userId wajib disertakan
  const CategoryScreen({super.key, required this.userId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String newCategoryName = '';
  String newCategoryType = 'expense'; // Default tipe kategori

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false)
          .loadCategories(userId: widget.userId);  // panggil dengan userId
    });
  }

  Future<void> _showAddDialog() async {
    newCategoryType = 'expense';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Kategori'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Harus diisi' : null,
                  onSaved: (val) => newCategoryName = val!.trim(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: newCategoryType,
                  decoration: const InputDecoration(labelText: 'Tipe'),
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
                      newCategoryType = val!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final newCat = CategoryModel(
                    name: newCategoryName,
                    type: newCategoryType,
                    userId: widget.userId, // pakai userId valid dari widget
                  );

                  await Provider.of<CategoryProvider>(context, listen: false)
                      .addCategory(newCat);

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: categories.isEmpty
          ? const Center(child: Text('Belum ada kategori'))
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  title: Text(cat.name),
                  subtitle:
                      Text(cat.type == 'income' ? 'Pemasukan' : 'Pengeluaran'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (cat.id != null) {
                        categoryProvider.deleteCategory(cat.id!);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
