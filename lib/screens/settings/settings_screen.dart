import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
<<<<<<< HEAD
=======
import '../login/login_screen.dart';
import 'profile_screen.dart'; // import halaman profil
>>>>>>> 0c7b4a4 ( perbaikan file)

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final authProvider = Provider.of<AuthProvider>(context);
=======
    final userProvider = Provider.of<UserProvider>(context, listen: false);
>>>>>>> 0c7b4a4 ( perbaikan file)

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
<<<<<<< HEAD
            title: Text('User: ${authProvider.currentUser?.email ?? "-"}'),
          ),
=======
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          const Divider(),
>>>>>>> 0c7b4a4 ( perbaikan file)
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
<<<<<<< HEAD
              await authProvider.logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
=======
              await userProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
>>>>>>> 0c7b4a4 ( perbaikan file)
            },
          ),
        ],
      ),
    );
  }
}
