<<<<<<< HEAD
// app.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'core/theme.dart';
import 'providers/user_provider.dart';
>>>>>>> 0c7b4a4 ( perbaikan file)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

<<<<<<< HEAD
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
=======
  Future<bool> _checkLoginStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.checkLoginStatus(); // update state userProvider
    return userProvider.isLoggedIn;
>>>>>>> 0c7b4a4 ( perbaikan file)
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Catatan Keuangan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return snapshot.data == true ? const HomeScreen() : const LoginScreen();
          }
        },
=======
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
>>>>>>> 0c7b4a4 ( perbaikan file)
      ),
    );
  }
}
