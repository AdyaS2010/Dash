// unused: replaced by game.dart

import 'package:flutter/material.dart';


class ScreenGame extends StatelessWidget {
  const ScreenGame({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: const Center(
        child: Text('Press play to start'),
      ),
    );
  }
}
