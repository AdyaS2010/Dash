import 'package:flutter/material.dart';
import 'screen_map.dart';
import 'auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
          MaterialPageRoute(builder: (context) => const MapScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
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
            // Space background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/space.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 30),

                // Logo section
                Image.asset(
                  'assets/images/logo1.png',
                  width: colWidth * 0.8,
                  alignment: Alignment.center,
                ),

                const SizedBox(height: 20),

                // Rocket emoji for fun space theming
                const Text('🚀', style: TextStyle(fontSize: 40)),

                const SizedBox(height: 10),

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    width: colWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xFF242325),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        // Outer glow effect
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            205,
                            134,
                            90,
                          ).withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                        // Inner purple glow
                        BoxShadow(
                          color: const Color(0xFF9370DB).withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                        // Additional glow layer
                        BoxShadow(
                          color: const Color(0xFF9370DB).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 10),

                        // Welcome message with space theme
                        Text(
                          'Ready for Launch? Create your profile to begin your mathematical space adventure!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.orbitron(
                            // space font choice??
                            color: const Color(0xFFC8C8C8),
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Username field
                        TextField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Choose your callsign...',
                            hintStyle: GoogleFonts.rajdhani(
                              fontSize: 13,
                              color: Color(0xFFC8C8C8),
                            ),
                            labelText: 'Astronaut Username',
                            labelStyle: GoogleFonts.rajdhani(
                              // fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 100),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(60, 137, 109, 100),
                              ),
                            ),
                          ),
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Email field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email...',
                            hintStyle: GoogleFonts.rajdhani(
                              fontSize: 13,
                              color: Color(0xFFC8C8C8),
                            ),
                            labelText: 'Traveler Email',
                            labelStyle: GoogleFonts.rajdhani(
                              // fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 100),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(60, 137, 109, 100),
                              ),
                            ),
                          ),
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Create a secure code...',
                            hintStyle: GoogleFonts.rajdhani(
                              fontSize: 13,
                              color: Color(0xFFC8C8C8),
                            ),
                            labelText: 'Launch Code (Password)',
                            labelStyle: GoogleFonts.rajdhani(
                              // fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 100),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(60, 137, 109, 100),
                              ),
                            ),
                          ),
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Create Account button
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: const Color.fromARGB(
                              156,
                              65,
                              150,
                              173,
                            ), // using the viridian color for accent
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.rocket_launch,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Launch Mission',
                                style: GoogleFonts.abrilFatface(
                                  fontSize: 15,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Back to Sign In button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 14,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Return to Command Center',
                                style: GoogleFonts.exo2(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        // fun footer (obv space-themed!)
                        Text(
                          '⭐ Join the galaxy of math explorers! ⭐',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            color: Color(0xFFC8C8C8),
                            fontStyle: FontStyle.italic,
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
