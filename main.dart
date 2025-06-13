import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_rocket_algebra/screen_map.dart';
import 'firebase_options.dart';
import 'screen_sign_up.dart';
import 'auth_service.dart';


/*COLORS
  silver = Color.fromRGBO(200, 200, 200, 100))
  redwood = Color.fromRGBO(159, 74, 84, 100)),
  viridian = Color.fromRGBO(60, 137, 109, 100),
  licorice = Color.fromRGBO(33, 15, 4, 100),
  raisin black = Color.fromRGBO(36, 35, 37),
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash: A Game of Rocket Algebra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey
          ),
        scaffoldBackgroundColor: Color(0xFF210F04),
        useMaterial3: true,
      ),
      home: const LogIn(),
    );
  }
}


class LogIn extends StatefulWidget {
  const LogIn({super.key});


  @override
  State<LogIn> createState() => _LogInState();
}


class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();


  void _login() async {
    try {
      await _authService.loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login failed: ${e.toString()}"),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth =  MediaQuery.of(context).size.width;
    final colWidth = screenWidth * 0.8;


    return Scaffold(
      backgroundColor: const Color(0xFF210F04), // solid version of background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logo1.png',
              width: colWidth,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 15),
            Center(
              child: Container( //controls properties for this container
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                width: colWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFF242325), //**should we really use this color?**
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column( //stack within the container
                  mainAxisSize: MainAxisSize.max, //leave maximum amount of space around the stack
                  children: [ //these should represent the values being stacked
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, Astronaut! Enter your information to get started.', //add monospace font here
                      style: TextStyle(
                        color: Color(0xFFC8C8C8),
                      )
                    ),
                    const SizedBox(height: 15),
                    TextField( //controls username
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Username...',
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
                      style: TextStyle(color:Colors.white, fontSize: 10), //note: this controls the text the user is actually entering!!
                    ),
                    const SizedBox(height: 10), //space between username and password
                    TextField( //controls password
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Password...',
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
                      style: TextStyle(color: Colors.white, fontSize: 10), //controls user-entered text
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color.fromRGBO(200, 200,200, 100)
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 10)
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUp()),
                        );
                      },
                      child: const Text(
                        'Create New Account',
                        style: TextStyle(fontSize: 9, color: Colors.blueGrey),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
