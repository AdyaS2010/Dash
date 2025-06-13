import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_rocket_algebra/main.dart';
import 'screen_map.dart';
import 'auth_service.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});


  @override
  State<SignUp> createState() => _SignUpState();
}


class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final AuthService _authService = AuthService();


  void _register() async {
    try {
      await _authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text,
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${e.toString()}"),
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth =  MediaQuery.of(context).size.width;
    final colWidth = screenWidth * 0.8;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                width: colWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFF242325), //**should we really use this color?**
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Create an Account!', //add monospace font here
                      style: TextStyle(
                        color: Color(0xFFC8C8C8),
                      )
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a new username...',
                        hintStyle: TextStyle(fontSize: 10, color:Color(0xFFC8C8C8),),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 100)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(60, 137, 109, 100)),
                        ),
                      ),
                      style: TextStyle(color:Colors.white, fontSize: 10),
                      ),
                    TextField(
                      controller: _emailController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter an email address...',
                        hintStyle: TextStyle(fontSize: 10, color:Color(0xFFC8C8C8),),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 100)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(60, 137, 109, 100)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a password...',
                        hintStyle: TextStyle(fontSize: 10, color:Color(0xFFC8C8C8),),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 100)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(60, 137, 109, 100)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      obscureText: true
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){Navigator.pop(context);},
                      child: const Text('Back to Sign In'),
                    )
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
}
