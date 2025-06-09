import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'providers/user_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.checkLoginStatus();
    return userProvider.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
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
  }
}