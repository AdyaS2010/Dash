import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'screen_log_in.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LogIn()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text("Hello, ${user?.email}!"),
      ),
    );
  }
}
