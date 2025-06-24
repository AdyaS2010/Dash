// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package: flame/flame.dart';
import 'screen_map.dart';
import 'game.dart';
import 'firebase_options.dart';
import 'screen_sign_up.dart';
import 'auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

/*COLORS
  silver = Color.fromRGBO(200, 200, 200, 100))
  redwood = Color.fromRGBO(159, 74, 84, 100)),
  viridian = Color.fromRGBO(60, 137, 109, 100),
  licorice = Color.fromRGBO(33, 15, 4, 100),
  raisin black = Color.fromRGBO(36, 35, 37),
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dash: A Game of Rocket-Based Algebra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: const Color(0xFF210F04),
        useMaterial3: true,
      ),
      // home: const LogIn(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LogIn(),
        '/map': (context) => const MapScreen(),
        '/sign_up': (context) => const SignUp(),
        '/level1_game': (context) => const GameScreen(),
      },
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
      await _authService.loginWithUsername(
        username: _emailController.text.trim(), //stores usernae (not eail)
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colWidth = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        16,
        68,
        77,
      ), // solid version of background
      body: SafeArea(
        child: Stack(
          children: [
            // this shud be the right bckgrnd img
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/space.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              //Stack (replace w/ same - done above)
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo1.png',
                  width: colWidth * 0.9,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    //controls properties for this container
                    padding: const EdgeInsets.all(28.0),
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    width: colWidth,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF242325,
                      ), //**should we really use this color?**
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        // gargi -> ywanna play around with the vals, theres acc lots of options!
                        BoxShadow(
                          // alr this is the outer part!
                          color: const Color.fromARGB(
                            255,
                            205,
                            134,
                            90,
                          ).withValues(alpha: 0.4),
                          blurRadius: 25,
                          spreadRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          // this is the inner one!
                          color: const Color(0xFF9370DB).withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                        BoxShadow(
                          // shadowww?? if u want
                          color: const Color(0xFF9370DB).withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      //stack within the container
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //these should represent the values being stacked
                        const SizedBox(height: 15),
                        Text(
                          'Welcome, Astronaut! Enter your information to get started.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.orbitron(
                            color: Color(0xFFC8C8C8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          //controls username
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Username...',
                            hintStyle: GoogleFonts.rajdhani(
                              fontSize: 15,
                              color: Color(0xFFC8C8C8),
                            ),
                            labelText: 'Username',
                            labelStyle: GoogleFonts.spaceMono(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 100),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(60, 137, 109, 100),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          //controls password
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Password...',
                            hintStyle: GoogleFonts.rajdhani(
                              fontSize: 15,
                              color: Color(0xFFC8C8C8),
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.spaceMono(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 100),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(60, 137, 109, 100),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color.fromARGB(
                              156,
                              65,
                              150,
                              173,
                            ), // viridian color (for accent)
                            elevation: 3,
                            shadowColor: Colors.black26,
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.abrilFatface(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(221, 249, 246, 246),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUp()),
                            );
                          },
                          child: Text(
                            'Create New Account',
                            style: GoogleFonts.exo2(
                              fontSize: 13,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
