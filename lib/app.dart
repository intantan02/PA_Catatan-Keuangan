import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'providers/user_provider.dart';
import 'models/user_model.dart';
import 'models/category_model.dart';
import 'models/transaction_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    // Buka box yang sering dipakai di awal aplikasi
    await Hive.openBox('preferences');
    await Hive.openBox('categories');
    await Hive.openBox('transactions');
  }

  Future<bool> _checkLoginStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.checkLoginStatus();
    return userProvider.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return ChangeNotifierProvider(
          create: (_) => UserProvider(),
          child: MaterialApp(
            title: 'Catatan Keuangan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: FutureBuilder<bool>(
              future: _checkLoginStatus(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const LoginPage();
                } else {
                  return snapshot.data == true
                      ? const HomeScreen()
                      : const LoginPage();
                }
              },
            ),
          ),
        );
      },
    );
  }
}