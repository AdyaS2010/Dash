import 'package:flutter/material.dart';


class ScreenMap extends StatelessWidget {
  const ScreenMap({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Map'),
      ),
      body: const Center(
        child: Text('Choose a level...'),
      ),
    );
  }
}


