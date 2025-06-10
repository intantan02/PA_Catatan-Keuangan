import 'package:catatan_keuangan/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/local/db_helper.dart';
import '../../../data/local/preferences_helper.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    // Cek apakah email sudah terdaftar
    final existingUser = await _dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar')),
      );
      return;
    }

    // Simpan user baru ke Hive
    await _dbHelper.registerUser(email, password);

    // Login user langsung setelah register
    final user = await _dbHelper.loginUser(email, password);
    if (user != null) {
      // Simpan userId ke Hive preferences
      await PreferencesHelper.setUserId(user['id'] as int);
      await PreferencesHelper.setLoginStatus(true);
      await PreferencesHelper.setUserEmail(user['email'] as String);

      // Set user ke provider agar data user tersedia di seluruh aplikasi
      Provider.of<UserProvider>(context, listen: false).setUserFromMap(user);

      // Navigasi ke HomeScreen, replace agar tidak bisa back ke register
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal login setelah registrasi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}