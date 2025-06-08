import 'package:flutter/material.dart';


class ScreenShare extends StatelessWidget {
  const ScreenShare({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share High Scores'),
      ),
      body: const Center(
        child: Text('Welcome to Screen Two!'),
      ),
    );
  }
}
