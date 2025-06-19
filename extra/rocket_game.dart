// Made by Gemini as an experiment for testing/prototyping purposes (though we decided to stick with our original implementation - didn't test/see this in action)! 

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Dodger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;

  double rocketX = 0.0; // Rocket's horizontal position
  List<Asteroid> asteroids = [];
  int score = 0;
  bool isGameOver = false;

  // Game parameters
  final double rocketWidth = 50.0;
  final double rocketHeight = 50.0;
  final double asteroidSize = 30.0;
  double asteroidSpeed = 2.0;
  int asteroidSpawnRate = 50; // Lower is faster
  int asteroidCount = 1;

  // Asteroid belt parameters
  final int asteroidBeltInterval = 15; // Seconds
  final int asteroidBeltDuration = 5; // Seconds
  bool inAsteroidBelt = false;
  int asteroidBeltStart = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // Roughly 60 FPS
    )..addListener(() {
        if (!isGameOver) {
          _updateGameState();
        }
      });
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();

    _startGameTimer();
  }

  void _startGameTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        setState(() {
          score++;
        });

        if (score % asteroidBeltInterval == 0 && score != 0) {
          _startAsteroidBelt();
        }

        if (inAsteroidBelt && (score - asteroidBeltStart) >= asteroidBeltDuration) {
          _endAsteroidBelt();
        }
      } else {
        timer.cancel();
      }
    });

    Timer.periodic(Duration(milliseconds: asteroidSpawnRate), (timer) {
       if (!isGameOver) {
         _spawnAsteroids();
       } else {
         timer.cancel();
       }
    });
  }


  void _updateGameState() {
    setState(() {
      // Move asteroids
      for (var asteroid in asteroids) {
        asteroid.y += asteroidSpeed;
      }

      // Remove off-screen asteroids
      asteroids.removeWhere((asteroid) => asteroid.y > MediaQuery.of(context).size.height);

      // Check for collisions
      _checkCollisions();
    });
  }

  void _spawnAsteroids() {
    for (int i = 0; i < asteroidCount; i++) {
      final random = Random();
      asteroids.add(Asteroid(
        x: random.nextDouble() * (MediaQuery.of(context).size.width - asteroidSize),
        y: -asteroidSize, // Start above the screen
      ));
    }
  }

  void _checkCollisions() {
    final rocketRect = Rect.fromLTWH(rocketX, MediaQuery.of(context).size.height - rocketHeight, rocketWidth, rocketHeight);

    for (var asteroid in asteroids) {
      final asteroidRect = Rect.fromLTWH(asteroid.x, asteroid.y, asteroidSize, asteroidSize);
      if (rocketRect.overlaps(asteroidRect)) {
        _gameOver();
        break;
      }
    }
  }

  void _gameOver() {
    setState(() {
      isGameOver = true;
    });
    _controller.stop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      rocketX = 0.0;
      asteroids.clear();
      score = 0;
      isGameOver = false;
      asteroidSpeed = 2.0;
      asteroidSpawnRate = 50;
      asteroidCount = 1;
      inAsteroidBelt = false;
      asteroidBeltStart = 0;
    });
    _startGameTimer();
    _controller.repeat();
  }

  void _startAsteroidBelt() {
    setState(() {
      inAsteroidBelt = true;
      asteroidBeltStart = score;
      asteroidSpeed *= 2; // Increase speed
      asteroidCount *= 3; // Increase count
      asteroidSpawnRate = 20;
    });
  }

  void _endAsteroidBelt() {
    setState(() {
      inAsteroidBelt = false;
      asteroidSpeed /= 2; // Reset speed
      asteroidCount ~/= 3; // Reset count
      asteroidSpawnRate = 50;
      if (asteroidCount < 1) asteroidCount = 1; // Ensure at least one asteroid
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Dodger'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text('Score: $score', style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (!isGameOver) {
            setState(() {
              rocketX += details.primaryDelta!;
              // Keep rocket within screen bounds
              rocketX = rocketX.clamp(0.0, MediaQuery.of(context).size.width - rocketWidth);
            });
          }
        },
        child: Stack(
          children: [
            // Background
            Container(
              color: Colors.black,
            ),
            // Asteroids
            ...asteroids.map((asteroid) => Positioned(
              left: asteroid.x,
              top: asteroid.y,
              child: Icon(Icons.adjust, color: Colors.grey, size: asteroidSize), // Using an icon for simplicity
            )),
            // Rocket
            Positioned(
              left: rocketX,
              bottom: 0,
              child: Icon(Icons.rocket_launch, color: Colors.white, size: rocketWidth), // Using an icon for simplicity
            ),
            if (isGameOver)
              Center(
                child: Text(
                  'Game Over\nScore: $score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            if (inAsteroidBelt)
              Positioned(
                top: 50,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    'ASTEROID BELT INCOMING!',
                    style: TextStyle(fontSize: 24, color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Asteroid {
  double x;
  double y;

  Asteroid({required this.x, required this.y});
}
