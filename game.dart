// These dependencies are added to pubspec.yaml:
// flame: ^1.16.0
// flame_audio: ^2.2.0

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart'; // for TapDownEvent -> import needed
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'dart:math' as math;
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DashRocketGame game;

  @override
  void initState() {
    super.initState();
    game = DashRocketGame();
  }

  @override
  void dispose() {
    game.onRemove(); // ensure streams are closed (when widget is disposed (of))
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B1F),
      body: Stack(
        children: [
          // game widget
          GameWidget(game: game),

          // UI overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.8,
                ),  
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF3C896D), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // XP Score
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

                  // question statsss
                  StreamBuilder<Map<String, int>>(
                    stream: game.statsStream,
                    builder: (context, snapshot) {
                      final stats = snapshot.data ?? {'correct': 0, 'total': 0};
                      return Text(
                        '${stats['correct']}/${stats['total']} ✓',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),

                  // close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // game complete overlay
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
      color: Colors.black.withValues(alpha: 0.85),  
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF3C896D), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF3C896D,
                ).withValues(alpha: 0.3), 
       blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF3C896D,
                  ).withValues(alpha: 0.2),  
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Color(0xFF3C896D),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🚀 Mission Complete!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              StreamBuilder<Map<String, int>>(
                stream: game.statsStream,
                builder: (context, snapshot) {
                  final stats =
                      snapshot.data ?? {'correct': 0, 'total': 0, 'xp': 0};
                  final percentage = stats['total']! > 0
                      ? (stats['correct']! / stats['total']! * 100).round()
                      : 0;

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withValues(
                            alpha: 0.1,
                          ),  
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.yellow.withValues(alpha: 0.3),
                          ),  
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.yellow,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'XP Earned: ${stats['xp'] ?? 0}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            'Questions',
                            '${stats['total']}',
                            Icons.quiz,
                          ),
                          _buildStatCard(
                            'Correct',
                            '${stats['correct']}',
                            Icons.check_circle,
                          ),
                          _buildStatCard(
                            'Accuracy',
                            '$percentage%',
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      game.resetGame();
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Play Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C896D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.home, size: 20),
                    label: const Text('Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9F4A54),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),  
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class MathQuestion {
  final String equation;
  final int correctAnswer;
  final List<int> options;

  MathQuestion({
    required this.equation,
    required this.correctAnswer,
    required this.options,
  });
}

class RocketPlayer extends RectangleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  late Vector2 targetPosition;
  bool isMoving = false;
  double moveSpeed = 400.0;

  RocketPlayer() : super(size: Vector2(40, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(game.size.x / 2, game.size.y - 100);
    targetPosition = position.clone();

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMoving) {
      final direction = targetPosition - position;
      if (direction.length < 5) {
        position = targetPosition.clone();
        isMoving = false;
      } else {
        final normalizedDirection = direction.normalized();
        position += normalizedDirection * moveSpeed * dt;
      }
    }
  }

  void moveTo(Vector2 target) {
    // to keep rocket within screen bounds yippee (bounce buonce)
    final clampedX = target.x.clamp(size.x / 2, game.size.x - size.x / 2);
    final clampedY = target.y.clamp(size.y / 2, game.size.y - size.y / 2);

    targetPosition = Vector2(clampedX, clampedY);
    isMoving = true;

    // add visual feedback of sorts
    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(duration: 0.1, reverseDuration: 0.1),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    // create rocket body
    final paint = Paint()
      ..color = const Color(0xFF3C896D)
      ..style = PaintingStyle.fill;

    final bodyRect = Rect.fromLTWH(8, 15, 24, 40);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(12)),
      paint,
    );

    // tip of rocket
    final tipPaint = Paint()..color = const Color(0xFF5CB85C);
    final tipPath = Path()
      ..moveTo(20, 0)
      ..lineTo(8, 15)
      ..lineTo(32, 15)
      ..close();
    canvas.drawPath(tipPath, tipPaint);

    // flames
    final flamePaint = Paint()..color = Colors.orange;
    final flameRect = Rect.fromLTWH(12, 55, 16, 12);
    canvas.drawOval(flameRect, flamePaint);

    // 'window'
    final windowPaint = Paint()..color = Colors.lightBlue;
    canvas.drawCircle(const Offset(20, 25), 6, windowPaint);
  }
}

class SpaceBackground extends Component with HasGameReference<DashRocketGame> {
  final List<Vector2> stars = [];
  final math.Random random = math.Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // stars (randomly generated -> to appear)
    for (int i = 0; i < 50; i++) {
      stars.add(
        Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    // space background (using gradient)
    final gradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0B0B1F), Color(0xFF1A1A2E), Color(0xFF16213E)],
      ).createShader(Rect.fromLTWH(0, 0, game.size.x, game.size.y));

    canvas.drawRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y), gradient);

    // stars (illustration)
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8);  
    for (final star in stars) {
      canvas.drawCircle(star.toOffset(), 1, starPaint);
    }
  }
}

class Coin extends CircleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  double moveSpeed = 100.0;
  late double rotationSpeed;

  Coin() : super(radius: 15, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final random = math.Random();
    position = Vector2(random.nextDouble() * (game.size.x - 60) + 30, -radius);

    rotationSpeed = random.nextDouble() * 4 + 2;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += moveSpeed * dt;
    angle += rotationSpeed * dt;

    if (position.y > game.size.y + radius) {
      removeFromParent();
    }
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other); // Must call super

    if (other is RocketPlayer) {
      game.collectCoin();

      // 'collection effect'
      add(
        ScaleEffect.by(
          Vector2.all(1.5),
          EffectController(duration: 0.2),
          onComplete: () => removeFromParent(),
        ),
      );

      return false; // in order to prevent further collision checks - for this frame
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    // coin (w/ gradient)
    final gradient = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.yellow, Colors.orange],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, gradient);

    // coin border
    final borderPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // star symbol(s)!
    final starPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset.zero, radius * 0.3, starPaint);
  }
}

class Asteroid extends CircleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  final int answer;
  final bool isCorrect;
  final AsteroidBelt parentBelt;

  Asteroid({
    required this.answer,
    required this.isCorrect,
    required this.parentBelt,
  }) : super(radius: 35, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other); // gotta call super apparently

    if (other is RocketPlayer) {
      game.answerQuestion(isCorrect);
      parentBelt.onAsteroidClicked(this);
      return false; // again, help prevent further collision checks for this frame!
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    // asteroid -> tryna manage a rocky texture??!
    final asteroidPaint = Paint()
      ..color = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFF795548)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, radius, asteroidPaint);

    // border
    final borderPaint = Paint()
      ..color = isCorrect ? const Color(0xFF388E3C) : const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // answer text!
    final textPainter = TextPainter(
      text: TextSpan(
        text: answer.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}

class AsteroidBelt extends PositionComponent
    with HasGameReference<DashRocketGame> {
  final MathQuestion question;
  final List<Asteroid> asteroids = [];
  double moveSpeed = 80.0;
  bool isAnswered = false;

  AsteroidBelt({required this.question});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // asteroids (in concave formation ofc!)
    final spacing = 70.0;
    final startX = (game.size.x - (spacing * 4)) / 2;

    for (int i = 0; i < 5; i++) {
      final asteroid = Asteroid(
        answer: question.options[i],
        isCorrect: question.options[i] == question.correctAnswer,
        parentBelt: this,
      );

      // asteroid belt -> concave formation (higher/lower in middle: DECIDE)
      final heightOffset = i == 2 ? -20.0 : (i == 1 || i == 3 ? -10.0 : 0.0);
      asteroid.position = Vector2(startX + (spacing * i), -100 + heightOffset);

      asteroids.add(asteroid);
      add(asteroid);
    }

    position = Vector2(0, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isAnswered) {
      position.y += moveSpeed * dt;

      // remove if off screen...
      if (position.y > game.size.y + 200) {
        removeFromParent();
      }
    }
  }

  void onAsteroidClicked(Asteroid clickedAsteroid) {
    if (isAnswered) return;

    isAnswered = true;

    // mm explosion effect + remove all asteroids as aftermath!
    for (final asteroid in asteroids) {
      asteroid.add(
        ScaleEffect.by(
          Vector2.all(clickedAsteroid.isCorrect ? 1.5 : 0.5),
          EffectController(duration: 0.3),
          onComplete: () => asteroid.removeFromParent(),
        ),
      );
    }

    // to remove the belt after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      removeFromParent();
    });
  }

  @override
  void render(Canvas canvas) {
    // questions to appear above asteroids
    if (!isAnswered) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: question.equation,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1)),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((game.size.x - textPainter.width) / 2, -150),
      );
    }
  }
}

class FinishGate extends RectangleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  double moveSpeed = 60.0;

  FinishGate() : super(size: Vector2(200, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(game.size.x / 2, -size.y);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += moveSpeed * dt;

    if (position.y > game.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other); // Must call super

    if (other is RocketPlayer) {
      game.completeGame();
      return false; // adadada collision check check stuff for frame
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    // gate -> texture glowing effect!?!
    final gatePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
      ).createShader(size.toRect());

    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)),
      gatePaint,
    );

    // text!!
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'FINISH',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }
}

class DashRocketGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  late RocketPlayer player;
  late TimerComponent asteroidTimer;
  late TimerComponent coinTimer;
  late TimerComponent finishGateTimer;
  final List<MathQuestion> questions = [];
  final math.Random random = math.Random();

  // Game state
  int score = 0;
  int questionsCorrect = 0;
  int questionsTotal = 0;
  int questionsSpawned = 0;
  bool gameComplete = false;

  // Streams for UI updates
  final StreamController<int> _scoreController =
      StreamController<int>.broadcast();
  final StreamController<Map<String, int>> _statsController =
      StreamController<Map<String, int>>.broadcast();
  final StreamController<bool> _gameCompleteController =
      StreamController<bool>.broadcast();

  Stream<int> get scoreStream => _scoreController.stream;
  Stream<Map<String, int>> get statsStream => _statsController.stream;
  Stream<bool> get gameCompleteStream => _gameCompleteController.stream;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _initializeGame();
  }

  Future<void> _initializeGame() async { // Adding everything necessary for initialization!
    // background
    add(SpaceBackground());

    // player
    player = RocketPlayer();
    add(player);

    // generate questions
    _generateQuestions();

    // start (spawning) timers
    _setupTimers();

    // Initialize the UI!!! 
    _updateStats();
  }

  void _setupTimers() {
    // make sure existing timers are removed - if called during reset
    children.whereType<TimerComponent>().forEach(
      (timer) => timer.removeFromParent(),
    );

    asteroidTimer = TimerComponent(
      period: 4.0,
      repeat: true,
      onTick: _spawnAsteroidBelt,
    );

    coinTimer = TimerComponent(period: 2.5, repeat: true, onTick: _spawnCoin);

    finishGateTimer = TimerComponent(
      period: 45.0,
      repeat: false,
      onTick: _spawnFinishGate,
    );

    add(asteroidTimer);
    add(coinTimer);
    add(finishGateTimer);
  }

  void _generateQuestions() {
    final questionTemplates = [
      // basic linear equations (as of now, will update) 
      {
        'equation': 'x + 3 = 8',
        'answer': 5,
        'options': [3, 5, 7, 11, 8],
      },
      {
        'equation': 'x - 4 = 6',
        'answer': 10,
        'options': [2, 8, 10, 12, 14],
      },
      {
        'equation': '2x = 12',
        'answer': 6,
        'options': [4, 6, 8, 10, 24],
      },
      {
        'equation': 'x/3 = 4',
        'answer': 12,
        'options': [7, 9, 12, 15, 1],
      },
      {
        'equation': '3x + 1 = 10',
        'answer': 3,
        'options': [2, 3, 4, 5, 9],
      },
      {
        'equation': '2x - 5 = 7',
        'answer': 6,
        'options': [4, 5, 6, 7, 12],
      },
      {
        'equation': 'x + 7 = 15',
        'answer': 8,
        'options': [6, 7, 8, 9, 22],
      },
      {
        'equation': '4x = 20',
        'answer': 5,
        'options': [3, 4, 5, 6, 80],
      },
      {
        'equation': 'x/2 = 9',
        'answer': 18,
        'options': [16, 17, 18, 19, 4],
      },
      {
        'equation': '5x - 3 = 17',
        'answer': 4,
        'options': [2, 3, 4, 5, 14],
      },
      {
        'equation': 'x + 12 = 20',
        'answer': 8,
        'options': [6, 7, 8, 9, 32],
      },
      {
        'equation': '3x = 21',
        'answer': 7,
        'options': [5, 6, 7, 8, 63],
      },
      {
        'equation': 'x - 8 = 2',
        'answer': 10,
        'options': [8, 9, 10, 11, 6],
      },
      {
        'equation': '2x + 4 = 14',
        'answer': 5,
        'options': [3, 4, 5, 6, 9],
      },
      {
        'equation': 'x/4 = 3',
        'answer': 12,
        'options': [9, 11, 12, 13, 0],
      },
    ];

    questions.clear(); // clear all previous questions on reset!
    questions.addAll(
      questionTemplates.map(
        (q) => MathQuestion(
          equation: q['equation'] as String,
          correctAnswer: q['answer'] as int,
          options: List<int>.from(q['options'] as List),
        ),
      ),
    );
  }

  void _spawnAsteroidBelt() {
    if (questionsSpawned < 15 && !gameComplete && questions.isNotEmpty) {
      final question = questions[random.nextInt(questions.length)];
      add(AsteroidBelt(question: question));
      questionsSpawned++;

      // stop spawning after 15 questions limit (for now)
      if (questionsSpawned >= 15) {
        asteroidTimer.removeFromParent();
      }
    }
  }

  void _spawnCoin() {
    if (!gameComplete) {
      add(Coin());
    }
  }

  void _spawnFinishGate() {
    if (!gameComplete) {
      add(FinishGate());
      coinTimer.removeFromParent(); // stop coin spawning twds the end.
    }
  }

  void collectCoin() {
    updateScore(1);
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
      updateScore(5);
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
      updateScore(20); // bonus for completing level (when one reaches the finish line!)
      _gameCompleteController.add(true);
      // discontinue all timers when game is complete
      children.whereType<TimerComponent>().forEach(
        (timer) => timer.removeFromParent(),
      );
    }
  }

  void resetGame() {
    // reset game state
    score = 0;
    questionsCorrect = 0;
    questionsTotal = 0;
    questionsSpawned = 0;
    gameComplete = false;

    // update streams and such
    _scoreController.add(0);
    _statsController.add({'correct': 0, 'total': 0, 'xp': 0});
    _gameCompleteController.add(false);

    // remove all components (except: background and player)
    final componentsToRemove = children
        .where(
          (component) =>
              component is! SpaceBackground && component is! RocketPlayer,
        )
        .toList();

    for (final component in componentsToRemove) {
      component.removeFromParent();
    }

    // reset player pos
    player.position = Vector2(size.x / 2, size.y - 100);
    player.targetPosition = player.position.clone();
    player.isMoving = false;

    // regenerate questions (eh shouldnt be much, but thats why theres a q bank!) for a new game!!!
    _generateQuestions();

    // restart timers 
    _setupTimers();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // hadto correct the signature and parameter name to work
    super.onTapDown(event); // have to call super
    if (!gameComplete) {
      // convert tap position to world coordinates actually!!
      final tapPosition =
          event.canvasPosition; // uses the canvasPosition for world coordinates
      player.moveTo(tapPosition);
    }
  }

  @override
  void onRemove() {
    // totally clean up streams
    _scoreController.close();
    _statsController.close();
    _gameCompleteController.close();
    super.onRemove();
  }
}
