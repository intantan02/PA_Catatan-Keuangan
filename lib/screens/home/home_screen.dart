<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
=======
// lib/presentation/pages/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 0c7b4a4 ( perbaikan file)
import '../../providers/user_provider.dart';
import '../transaction/transaction_list.dart';
import '../category/category_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/custom_button.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
<<<<<<< HEAD

  final List<Widget> screens = [
    const TransactionListScreen(),
    const CategoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
=======
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final List<Widget> pages = [
      TransactionListScreen(userId: userId),
      const CategoryScreen(),
      const SettingsScreen(),
    ];
>>>>>>> 0c7b4a4 ( perbaikan file)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Keuangan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
<<<<<<< HEAD
              await authProvider.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => LoginScreen()));
=======
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId');
              await userProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
>>>>>>> 0c7b4a4 ( perbaikan file)
            },
          ),
        ],
      ),
<<<<<<< HEAD
      body: screens[selectedIndex],
=======
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : pages[selectedIndex],
>>>>>>> 0c7b4a4 ( perbaikan file)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (idx) {
          setState(() {
            selectedIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
