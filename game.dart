// Add these dependencies to the pubspec.yaml file:
// flame: ^1.15.0
// flame_audio: ^2.1.1

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'dart:math' as math;
import 'dart:async';

// main game screen widget thingy
void main() {
  runApp(const MaterialApp(
    home: GameScreen(),
  ));
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DashRocketGame game;
  bool gameCompleted = false;
  
  @override
  void initState() {
    super.initState();
    game = DashRocketGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B1F),
      body: Stack(
        children: [
          // GAMEee Widget
          GameWidget(game: game),
          
          // UI overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // score
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.yellow, size: 20),
                      const SizedBox(width: 8),
                      StreamBuilder<int>(
                        stream: game.scoreStream,
                        builder: (context, snapshot) {
                          return Text(
                            'XP: ${snapshot.data ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  // Questions Stats
                  StreamBuilder<Map<String, int>>(
                    stream: game.statsStream,
                    builder: (context, snapshot) {
                      final stats = snapshot.data ?? {'correct': 0, 'total': 0};
                      return Text(
                        '${stats['correct']}/${stats['total']} Correct',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                  
                  // pause button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          
          // Game Complete Overlay
          StreamBuilder<bool>(
            stream: game.gameCompleteStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return _buildGameCompleteOverlay();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildGameCompleteOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3C896D), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.rocket_launch,
                color: Color(0xFF3C896D),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Mission Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<Map<String, int>>(
                stream: game.statsStream,
                builder: (context, snapshot) {
                  final stats = snapshot.data ?? {'correct': 0, 'total': 0, 'xp': 0};
                  final percentage = stats['total']! > 0 
                    ? (stats['correct']! / stats['total']! * 100).round()
                    : 0;
                  
                  return Column(
                    children: [
                      Text(
                        'XP Earned: ${stats['xp'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Questions: ${stats['correct']}/${stats['total']} ($percentage%)',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      game.resetGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C896D),
                    ),
                    child: const Text('Play Again'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9F4A54),
                    ),
                    child: const Text('Back to Map'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Game Class dundunddunnn
class DashRocketGame extends FlameGame with HasTappables, HasCollisionDetection {
  late RocketPlayer player;
  late Timer asteroidTimer;
  late Timer coinTimer;
  final List<MathQuestion> questions = [];
  final math.Random random = math.Random();
  
  // game staye (at initialization) 
  int score = 0;
  int questionsCorrect = 0;
  int questionsTotal = 0;
  bool gameComplete = false;
  
  // streams (for UI update purposes)
  final StreamController<int> _scoreController = StreamController<int>.broadcast();
  final StreamController<Map<String, int>> _statsController = StreamController<Map<String, int>>.broadcast();
  final StreamController<bool> _gameCompleteController = StreamController<bool>.broadcast();
  
  Stream<int> get scoreStream => _scoreController.stream;
  Stream<Map<String, int>> get statsStream => _statsController.stream;
  Stream<bool> get gameCompleteStream => _gameCompleteController.stream;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // initialize game world !!
    await _initializeGame();
  }
  
  Future<void> _initializeGame() async {
    // camera setup & world bounds (screen)
    camera.viewfinder.visibleGameSize = size;
    
    // add background
    add(SpaceBackground());
    
    // add player!
    player = RocketPlayer();
    add(player);
    
    // initialize questionssss
    _generateQuestions();
    
    // start the spawning of asteroids and coins
    asteroidTimer = Timer(3.0, repeat: true, onTick: _spawnAsteroidBelt);
    coinTimer = Timer(2.0, repeat: true, onTick: _spawnCoin);
    
    add(asteroidTimer);
    add(coinTimer);
    
    // add finish gate after some time
    Timer(30.0, onTick: _spawnFinishGate).start();
  }
  
  void _generateQuestions() {
    // question bank (basic operations for lvl 1)
    final questionTemplates = [
      // Addition
      {'equation': 'x + 5 = 12', 'answer': 7, 'operations': [4, 7, 9, 12]},
      {'equation': '3x + 2x = 25', 'answer': 5, 'operations': [3, 5, 7, 8]},
      {'equation': 'x + 8 = 15', 'answer': 7, 'operations': [6, 7, 9, 12]},
      
      // Subtraction  
      {'equation': 'x - 4 = 6', 'answer': 10, 'operations': [8, 10, 12, 14]},
      {'equation': '7x - 3x = 16', 'answer': 4, 'operations': [2, 4, 6, 8]},
      {'equation': 'x - 7 = 3', 'answer': 10, 'operations': [8, 9, 10, 13]},
      
      // Multiplication
      {'equation': '4x = 20', 'answer': 5, 'operations': [3, 5, 7, 9]},
      {'equation': '3x = 15', 'answer': 5, 'operations': [3, 4, 5, 6]},
      {'equation': '6x = 24', 'answer': 4, 'operations': [2, 4, 6, 8]},
      
      // Division
      {'equation': 'x/2 = 6', 'answer': 12, 'operations': [10, 12, 14, 16]},
      {'equation': 'x/3 = 4', 'answer': 12, 'operations': [9, 12, 15, 18]},
      {'equation': 'x/5 = 3', 'answer': 15, 'operations': [10, 12, 15, 20]},
    ];
    
    questions.addAll(questionTemplates.map((q) => MathQuestion(
      equation: q['equation'] as String,
      correctAnswer: q['answer'] as int,
      options: List<int>.from(q['operations'] as List),
    )));
  }
  
  void _spawnAsteroidBelt() {
    if (questions.isNotEmpty && !gameComplete) {
      final question = questions[random.nextInt(questions.length)];
      add(AsteroidBelt(question: question, game: this));
    }
  }
  
  void _spawnCoin() {
    if (!gameComplete) {
      add(Coin());
    }
  }
  
  void _spawnFinishGate() {
    if (!gameComplete) {
      add(FinishGate(game: this));
    }
  }
  
  void updateScore(int points) {
    score += points;
    _scoreController.add(score);
    _updateStats();
  }
  
  void answerQuestion(bool correct) {
    questionsTotal++;
    if (correct) {
      questionsCorrect++;
      updateScore(5); // XP gained for correct answer
    }
    _updateStats();
  }
  
  void _updateStats() {
    _statsController.add({
      'correct': questionsCorrect,
      'total': questionsTotal,
      'xp': score,
    });
  }
  
  void completeGame() {
    if (!gameComplete) {
      gameComplete = true;
      _gameCompleteController.add(true);
    }
  }
  
  void resetGame() {
    game = DashRocketGame();
    setState(() {
      gameCompleted = false;
    });
  }
}
