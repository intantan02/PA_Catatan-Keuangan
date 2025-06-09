<<<<<<< HEAD
import 'package:catatan_keuangan/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/custom_button.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
=======
// lib/screens/category/category_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key); // Supaya lint `use_key_in_widget_constructors` juga teratasi
>>>>>>> 0c7b4a4 ( perbaikan file)

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String newCategoryName = '';

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    Provider.of<CategoryProvider>(context, listen: false).loadCategories();
  }

  Future<void> _addCategory() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await Provider.of<CategoryProvider>(context, listen: false)
        .addCategory(newCategoryName as CategoryModel);

    Navigator.pop(context);
  }

  void _showAddDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Tambah Kategori'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Kategori'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Nama wajib diisi' : null,
                onSaved: (val) => newCategoryName = val!.trim(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal')),
              TextButton(onPressed: _addCategory, child: const Text('Simpan')),
            ],
          );
        });
=======
    // Muat data kategori saat screen muncul
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
<<<<<<< HEAD

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final cat = categoryProvider.categories[index];
                return ListTile(
                  title: Text(cat.name),
=======
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
                  // Contoh tombol hapus jika diperlukan
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      categoryProvider.deleteCategory(cat.id!);
                    },
                  ),
>>>>>>> 0c7b4a4 ( perbaikan file)
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
<<<<<<< HEAD
        child: const Icon(Icons.add),
        onPressed: _showAddDialog,
=======
        onPressed: () async {
          // Tampilkan dialog untuk menambah kategori baru
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tambah Kategori'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nama Kategori'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Harus diisi' : null,
                    onSaved: (val) => newCategoryName = val!.trim(),
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

                        // --- PERBAIKAN UTAMA DI SINI ---
                        // Buat objek CategoryModel baru dengan name dari input, dan tipe default
                        final newCat = CategoryModel(
                          id: 0,                    // Bisa null jika ID di-handle repository
                          name: newCategoryName,     
                          type: 'default',          // Ganti sesuai kebutuhan aplikasi Anda
                        );

                        await Provider.of<CategoryProvider>(context,
                                listen: false)
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
        },
        child: const Icon(Icons.add),
>>>>>>> 0c7b4a4 ( perbaikan file)
      ),
    );
  }
}
