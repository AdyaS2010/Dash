// These dependencies are added to pubspec.yaml:
// flame: ^1.16.0 & flame_audio: ^2.2.0

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> _saveScoreToFirestore(int score, int questionsCorrect) async {
  print("=== _saveScoreToFirestore called ===");
  print("Parameters: score=$score, questionsCorrect=$questionsCorrect");

  User? currentUser = _auth.currentUser;
  print("Current user: ${currentUser?.uid ?? 'NO USER LOGGED IN'}");

  if (currentUser != null) {
    String uid = currentUser.uid;
    print("User UID: $uid");

    DocumentReference docRef = _firestore.collection('users').doc(uid);
    print("Document reference created");

    try {
      print("Getting current document...");
      DocumentSnapshot documentSnapshot = await docRef.get();
      print("Document exists: ${documentSnapshot.exists}");

      // Define XP thresholds for each level
      final Map<String, int> levelUnlockThresholds = {
        'level2': 1000,
        'level3': 2500,
        'level4': 5000,
        'level5': 10000,
      };

      // Safely extract data with proper type checking
      final data = documentSnapshot.data() as Map<String, dynamic>?;
      
      final currentHighScore = data?['highScore'] ?? 0;
      final currentTotalPoints = data?['totalPoints'] ?? 0;
      
      // Handle levelsUnlocked field safely - it's a Map<String, bool> in Firestore
      List<String> unlockedLevels = [];
      final levelsUnlockedData = data?['levelsUnlocked'];
      
      if (levelsUnlockedData == null) {
        // If field doesn't exist, start with level1
        unlockedLevels = ['level1'];
      } else if (levelsUnlockedData is Map) {
        // Extract levels where the boolean value is true
        unlockedLevels = levelsUnlockedData.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key.toString())
            .toList();
        
        // Ensure level1 is always included if no levels are unlocked
        if (unlockedLevels.isEmpty) {
          unlockedLevels = ['level1'];
        }
      } else {
        // Fallback: start with level1
        print("Unexpected type for levelsUnlocked: ${levelsUnlockedData.runtimeType}");
        unlockedLevels = ['level1'];
      }

      print("Current high score: $currentHighScore");
      print("Current total points: $currentTotalPoints");
      print("Current unlocked levels: $unlockedLevels");

      // Calculate the new high score and total points
      final newHighScore = (score > currentHighScore) ? score : currentHighScore;
      final newTotalPoints = currentTotalPoints + score;

      print("New high score: $newHighScore");
      print("New total points: $newTotalPoints");

      // Check and unlock levels dynamically
      Map<String, bool> levelsUnlockedMap = {};
      
      // Convert current unlocked levels list to map format
      for (String level in unlockedLevels) {
        levelsUnlockedMap[level] = true;
      }
      
      // Check thresholds and add new levels
      levelUnlockThresholds.forEach((levelName, threshold) {
        if (newTotalPoints >= threshold) {
          levelsUnlockedMap[levelName] = true;
          if (!unlockedLevels.contains(levelName)) {
            unlockedLevels.add(levelName);
            print("Level $levelName unlocked for user $uid! (Total XP: $newTotalPoints)");
          }
        } else {
          // Ensure levels that don't meet threshold are marked as false
          levelsUnlockedMap[levelName] = levelsUnlockedMap[levelName] ?? false;
        }
      });
      
      // Ensure level1 is always unlocked
      levelsUnlockedMap['level1'] = true;

      print("About to update document...");

      // Update the document - store levelsUnlocked as a Map<String, bool>
      await docRef.set({
        'highScore': newHighScore,
        'totalPoints': newTotalPoints,
        'questionsCorrect': FieldValue.increment(questionsCorrect),
        'levelsUnlocked': levelsUnlockedMap, // Store as Map<String, bool>
      }, SetOptions(merge: true));

      print("Document updated successfully!");
      print("Score and question data updated successfully for user $uid. Total XP: $newTotalPoints, Levels Unlocked: $unlockedLevels");
      
    } catch (e) {
      print("Error updating score for user $uid: $e");
      print("Error type: ${e.runtimeType}");
      rethrow; // Use rethrow instead of throw e
    }
  } else {
    print("No user is currently logged in. Cannot save score to Firestore.");
    throw Exception("No authenticated user");
  }

  print("=== _saveScoreToFirestore finished ===");
}

class GameScreen extends StatefulWidget {
  final bool isReload;

  const GameScreen({super.key, this.isReload = false});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DashRocketGame game;

  @override
  void initState() {
    super.initState();
    game = DashRocketGame(isReload: widget.isReload);
  }

  @override
  void dispose() {
    game.onRemove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B1F),
      body: Stack(
        children: [
          GameWidget(game: game),

          // ui overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF3C896D), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  StreamBuilder<bool>(
                    stream: game.isPausedStream,
                    builder: (context, snapshot) {
                      final isGamePaused = snapshot.data ?? false;
                      return IconButton(
                        onPressed: () {
                          if (isGamePaused) {
                            game.resumeGame();
                          } else {
                            game.pauseGame();
                          }
                        },
                        icon: Icon(
                          isGamePaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      FlameAudio.bgm.stop();
                      Navigator.pop(context);
                    },
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

          // pause overlay
          StreamBuilder<Map<String, dynamic>>(
            stream: game.gameStateStream,
            builder: (context, snapshot) {
              final gameState =
                  snapshot.data ?? {'paused': false, 'complete': false};
              final isGamePaused = gameState['paused'] ?? false;
              final isGameComplete = gameState['complete'] ?? false;

              if (isGamePaused && !isGameComplete) {
                return _buildPauseOverlay(context);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F3460),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF3C896D),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3C896D).withValues(alpha: 0.3),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pause icon with glow effect
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C896D).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(
                              0xFF3C896D,
                            ).withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.pause_circle_filled,
                          color: Color(0xFF3C896D),
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title with enhanced styling
                      const Text(
                        'Game Paused',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take a break and come back when ready!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Enhanced Resume Button
                      _buildPauseButton(
                        onPressed: () => game.resumeGame(),
                        icon: Icons.play_arrow,
                        label: 'Resume Game',
                        color: const Color(0xFF3C896D),
                        isPrimary: true,
                      ),
                      const SizedBox(height: 16),

                      // Action buttons row
                      Row(
                        children: [
                          Expanded(
                            child: _buildPauseButton(
                              onPressed: () {
                                game.reloadGameScreen(context);
                              },
                              icon: Icons.refresh,
                              label: 'Restart',
                              color: const Color(0xFF9F4A54),
                              isCompact: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPauseButton(
                              onPressed: () {
                                FlameAudio.bgm.stop();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              icon: Icons.home,
                              label: 'Dashboard',
                              color: const Color(0xFF6B7280),
                              isCompact: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Quick stats preview (if available)
                      StreamBuilder<Map<String, int>>(
                        stream: game.statsStream,
                        builder: (context, snapshot) {
                          final stats =
                              snapshot.data ?? {'correct': 0, 'total': 0};
                          if (stats['total']! > 0) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem(
                                    Icons.quiz,
                                    '${stats['total']}',
                                    'Questions',
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  _buildStatItem(
                                    Icons.check_circle,
                                    '${stats['correct']}',
                                    'Correct',
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  _buildStatItem(
                                    Icons.trending_up,
                                    '${stats['total']! > 0 ? (stats['correct']! / stats['total']! * 100).round() : 0}%',
                                    'Accuracy',
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPauseButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool isPrimary = false,
    bool isCompact = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isPrimary ? 20 : 15),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: isPrimary ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isPrimary ? 28 : (isCompact ? 20 : 24)),
        label: Text(
          label,
          style: TextStyle(
            fontSize: isPrimary ? 18 : (isCompact ? 14 : 16),
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isPrimary ? 32 : (isCompact ? 16 : 24),
            vertical: isPrimary ? 18 : (isCompact ? 12 : 15),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isPrimary ? 20 : 15),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 18),
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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                color: const Color(0xFF3C896D).withValues(alpha: 0.3),
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
                  color: const Color(0xFF3C896D).withValues(alpha: 0.2),
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
                          color: Colors.yellow.withValues(alpha: 0.1),
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
                              'XP Earned: ${stats['xp']}',
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
                      const SizedBox(height: 28),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(24),
                        ),
                        child: const Text(
                          'Share Stats',
                          style: TextStyle(fontSize: 26),
                        ),
                        onPressed: () async {
                          await SharePlus.instance.share(
                            ShareParams(
                              text: 'I just got ${stats['xp']} XP in the game!',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // async
                              game.reloadGameScreen(
                                context,
                              ); // await game.resetGame();
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
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
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
                  );
                },
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
  double moveSpeed = 450.0;
  double thrustParticleTimer = 0.0;

  RocketPlayer() : super(size: Vector2(40, 60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(game.size.x / 2, game.size.y - 100);
    targetPosition = position.clone();
    add(
      RectangleHitbox(size: Vector2(30, 50)),
    ); // making rocket hitbox as precise as possible!
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

    // add subtle floating motion when idle
    if (!isMoving) {
      thrustParticleTimer += dt;
      position.y += math.sin(thrustParticleTimer * 3) * 0.5;
    }
  }

  void moveTo(Vector2 target) {
    final clampedX = target.x.clamp(size.x / 2, game.size.x - size.x / 2);
    final clampedY = target.y.clamp(size.y / 2, game.size.y - size.y / 2);

    targetPosition = Vector2(clampedX, clampedY);
    isMoving = true;

    // enhanced visual feedback
    add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(duration: 0.08, reverseDuration: 0.08),
      ),
    );

    // add rotation effect based on movement direction
    final direction = targetPosition - position;
    final angle = math.atan2(direction.y, direction.x);
    add(
      RotateEffect.to(
        angle * 0.1, // subtle tilt
        EffectController(duration: 0.3, reverseDuration: 0.3),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    // enhanced rocket with gradient and better proportions
    final bodyGradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(6, 12, 28, 45));

    // main rocket body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(6, 12, 28, 45),
      const Radius.circular(14),
    );
    canvas.drawRRect(bodyRect, bodyGradient);

    // rocket tip
    final tipPaint = Paint()..color = const Color(0xFF66BB6A);
    final tipPath = Path()
      ..moveTo(20, 0)
      ..lineTo(6, 12)
      ..lineTo(34, 12)
      ..close();
    canvas.drawPath(tipPath, tipPaint);

    // enhanced flames with gradient
    final flameGradient = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.orange, Colors.deepOrange, Colors.red],
      ).createShader(Rect.fromLTWH(10, 57, 20, 15));

    final flamePath = Path()
      ..moveTo(10, 57)
      ..quadraticBezierTo(15, 72, 20, 67)
      ..quadraticBezierTo(25, 72, 30, 57)
      ..close();
    canvas.drawPath(flamePath, flameGradient);

    // cockpit window with reflection
    final windowPaint = Paint()..color = const Color(0xFF81D4FA);
    canvas.drawCircle(const Offset(20, 28), 8, windowPaint);

    // window reflection
    final reflectionPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawCircle(const Offset(17, 25), 3, reflectionPaint);

    // side fins
    final finPaint = Paint()..color = const Color(0xFF2E7D32);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 35, 8, 20),
        const Radius.circular(4),
      ),
      finPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(32, 35, 8, 20),
        const Radius.circular(4),
      ),
      finPaint,
    );
  }
}

class SpaceBackground extends Component with HasGameReference<DashRocketGame> {
  final List<Vector2> stars = [];
  final List<Vector2> planets = [];
  final math.Random random = math.Random();
  double scrollOffset = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // generate stars
    for (int i = 0; i < 80; i++) {
      stars.add(
        Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y * 2, // extended for scrolling
        ),
      );
    }

    // generate distant planets
    for (int i = 0; i < 3; i++) {
      planets.add(
        Vector2(
          random.nextDouble() * game.size.x,
          random.nextDouble() * game.size.y,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    scrollOffset += 20 * dt; // slow background scroll

    // reset scroll when it gets too high
    if (scrollOffset > game.size.y) {
      scrollOffset = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    // enhanced space gradient
    final gradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0B0B1F),
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
          Color(0xFF0E4B99),
        ],
      ).createShader(Rect.fromLTWH(0, 0, game.size.x, game.size.y));

    canvas.drawRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y), gradient);

    // render distant planets
    for (int i = 0; i < planets.length; i++) {
      final planet = planets[i];
      final planetPaint = Paint()
        ..color = [
          const Color(0xFF4A148C).withValues(alpha: 0.3),
          const Color(0xFF006064).withValues(alpha: 0.3),
          const Color(0xFF8D6E63).withValues(alpha: 0.3),
        ][i % 3];

      canvas.drawCircle(
        planet.toOffset(),
        [25.0, 18.0, 30.0][i % 3],
        planetPaint,
      );
    }

    // enhanced stars with varying sizes and brightness
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final adjustedY = (star.y + scrollOffset) % (game.size.y * 2);

      final brightness = 0.3 + (random.nextDouble() * 0.7);
      final size = 0.5 + (random.nextDouble() * 1.5);

      final starPaint = Paint()
        ..color = Colors.white.withValues(alpha: brightness);

      canvas.drawCircle(Offset(star.x, adjustedY), size, starPaint);
    }
  }
}

class AsteroidBelt extends PositionComponent
    with HasGameReference<DashRocketGame> {
  final MathQuestion question;
  final List<Asteroid> asteroids = [];
  double moveSpeed =
      50.0; // slower for better gameplay and readability purposes!
  bool isAnswered = false;
  late TextComponent questionText;

  AsteroidBelt({required this.question});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // create question text component that renders above asteroids
    questionText = TextComponent(
      text: question.equation,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(blurRadius: 8, color: Colors.black, offset: Offset(2, 2)),
          ],
        ),
      ),
      anchor: Anchor.center,
    );

    // position question text above asteroid formation
    questionText.position = Vector2(game.size.x / 2, -150);
    add(questionText);

    // create perfectly centered asteroid formation
    // ADD (consider/implement) BETTER SPACING AND POSITIONING
    final spacing = 75.0;
    final totalWidth = spacing * 4; // 5 asteroids = 4 gaps
    final startX = ((game.size.x - totalWidth) / 2) + 37;

    // shuffle options to randomize positions
    final shuffledOptions = List<int>.from(question.options)
      ..shuffle(game.random); // ooohhhh ahhh !!!

    for (int i = 0; i < 5; i++) {
      final asteroid = Asteroid(
        answer: shuffledOptions[i],
        isCorrect: shuffledOptions[i] == question.correctAnswer,
        parentBelt: this,
      );

      // elegant arc formation - slight curve for visual appeal
      final heightOffset = math.sin((i / 4) * math.pi) * 15.0;
      asteroid.position = Vector2(startX + (spacing * i), -30 + heightOffset);

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

      // remove if off screen
      if (position.y > game.size.y + 250) {
        removeFromParent();
      }
    }
  }

  void onAsteroidClicked(Asteroid clickedAsteroid) {
    if (isAnswered) return;

    isAnswered = true;

    // hide question text immediately
    questionText.removeFromParent(); // LOOK INTO THIS (dont want to fade asap)

    // enhanced visual feedback for all asteroids
    for (final asteroid in asteroids) {
      if (asteroid == clickedAsteroid) {
        // clicked asteroid gets special treatment
        if (clickedAsteroid.isCorrect) {
          // correct answer - green glow and scale up
          asteroid.add(
            ScaleEffect.by(Vector2.all(1.4), EffectController(duration: 0.4)),
          );
        } else {
          // wrong answer - shake and shrink
          asteroid.add(
            MoveEffect.by(
              Vector2(10, 0),
              EffectController(
                duration: 0.1,
                reverseDuration: 0.1,
                repeatCount: 3,
              ),
            ),
          );
          asteroid.add(
            ScaleEffect.by(Vector2.all(0.7), EffectController(duration: 0.3)),
          );
        }

        // fade out after effect
        Future.delayed(const Duration(milliseconds: 400), () {
          asteroid.add(
            OpacityEffect.fadeOut(
              EffectController(duration: 0.2),
              onComplete: () => asteroid.removeFromParent(),
            ),
          );
        });
      } else {
        // if wrong answer was clicked, highlight the correct answer
        if (!clickedAsteroid.isCorrect && asteroid.isCorrect) {
          // make correct asteroid green and scale up
          asteroid._hasBeenAnswered = true; // mark as answered to change color
          asteroid.add(
            ScaleEffect.by(Vector2.all(1.3), EffectController(duration: 0.5)),
          );
          // fade out after showing correct answer
          Future.delayed(const Duration(milliseconds: 800), () {
            asteroid.add(
              OpacityEffect.fadeOut(
                EffectController(duration: 0.3),
                onComplete: () => asteroid.removeFromParent(),
              ),
            );
          });
        } else {
          // other asteroids fade out quickly
          asteroid.add(
            OpacityEffect.fadeOut(
              EffectController(duration: 0.3),
              onComplete: () => asteroid.removeFromParent(),
            ),
          );
        }
      }
    }

    // remove the belt after animations complete
    Future.delayed(const Duration(milliseconds: 1000), () {
      removeFromParent();
    });
  }
}

class Asteroid extends CircleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  final int answer;
  final bool isCorrect;
  final AsteroidBelt parentBelt;
  bool _hasBeenAnswered = false;

  // static elements for consistent professional look
  final List<Vector2> staticFeatures = [];
  final List<double> featureSizes = [];
  double pulseTimer = 0.0;

  Asteroid({
    required this.answer,
    required this.isCorrect,
    required this.parentBelt,
  }) : super(radius: 38, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      CircleHitbox(radius: radius * 0.8),
    ); // making hitbox slightly smaller than visual size so the collision detection is more accurate

    // generate consistent static features using answer as seed
    final random = math.Random(answer.hashCode);
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi / 3) + random.nextDouble() * 0.5;
      final distance = radius * (0.3 + random.nextDouble() * 0.3);
      staticFeatures.add(
        Vector2(math.cos(angle) * distance, math.sin(angle) * distance),
      );
      featureSizes.add(radius * (0.08 + random.nextDouble() * 0.12));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // subtle breathing effect for unanswered asteroids
    if (!_hasBeenAnswered) {
      pulseTimer += dt;
      scale = Vector2.all(1.0 + math.sin(pulseTimer * 2) * 0.02);
    }
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is RocketPlayer && !_hasBeenAnswered) {
      _hasBeenAnswered = true;
      game.answerQuestion(isCorrect);

      if (isCorrect) {
        FlameAudio.play('correct.mp3');
      } else {
        FlameAudio.play('wrong.mp3');
      }

      parentBelt.onAsteroidClicked(this);
      return false;
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    Color baseColor;
    Color accentColor;

    if (_hasBeenAnswered) {
      if (isCorrect) {
        baseColor = const Color(0xFF4CAF50);
        accentColor = const Color(0xFF81C784);
      } else {
        baseColor = const Color(0xFFE53935);
        accentColor = const Color(0xFFEF5350);
      }
    } else {
      // uniform professional dark asteroid color
      baseColor = const Color(0xFF424242);
      accentColor = const Color(0xFF616161);
    }

    // main asteroid body with professional gradient
    final gradient = Paint()
      ..shader = RadialGradient(
        colors: [accentColor, baseColor],
        stops: const [0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, gradient);

    // static surface features for realistic look
    final featurePaint = Paint()..color = baseColor.withValues(alpha: 0.6);

    for (int i = 0; i < staticFeatures.length; i++) {
      canvas.drawCircle(
        staticFeatures[i].toOffset(),
        featureSizes[i],
        featurePaint,
      );
    }

    // professional border
    final borderPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // answer text with perfect positioning and readability
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 4,
          color: Colors.black.withValues(alpha: 0.8),
          offset: const Offset(1, 1),
        ),
      ],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: answer.toString(), style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}

class Coin extends CircleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  double moveSpeed = 85.0;
  double rotationSpeed = 1.5;
  double pulseTimer = 0.0;
  double horizontalOffset = 0.0;
  late double centerX;
  double glowIntensity = 0.0;

  Coin() : super(radius: 16, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final random = math.Random();
    centerX = random.nextDouble() * (game.size.x - 120) + 60;
    position = Vector2(centerX, -radius);
    horizontalOffset = random.nextDouble() * 2 * math.pi;

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += moveSpeed * dt;
    angle += rotationSpeed * dt;
    pulseTimer += dt * 1.5;
    glowIntensity = (math.sin(pulseTimer * 2) + 1) * 0.5;

    // smooth, predictable horizontal movement
    position.x = centerX + math.sin(pulseTimer + horizontalOffset) * 12;

    if (position.y > game.size.y + radius) {
      removeFromParent();
    }
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is RocketPlayer) {
      game.collectCoin();
      FlameAudio.play('coin.mp3');

      // satisfying collection effect
      add(ScaleEffect.by(Vector2.all(1.6), EffectController(duration: 0.12)));

      add(
        OpacityEffect.fadeOut(
          EffectController(duration: 0.12),
          onComplete: () => removeFromParent(),
        ),
      );

      return false;
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    // dynamic glow effect
    final glowPaint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.2 + glowIntensity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset.zero, radius + 4, glowPaint);

    // professional coin gradient
    final gradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF59D),
          const Color(0xFFFFEB3B),
          const Color(0xFFF57C00),
        ],
        stops: const [0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    canvas.drawCircle(Offset.zero, radius, gradient);

    // elegant border
    final borderPaint = Paint()
      ..color = const Color(0xFFF57C00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset.zero, radius, borderPaint);

    // refined star symbol
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    _drawStar(canvas, starPaint, radius * 0.55);
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = ((i + 0.5) * 2 * math.pi / 5) - math.pi / 2;

      final outerX = math.cos(outerAngle) * size;
      final outerY = math.sin(outerAngle) * size;
      final innerX = math.cos(innerAngle) * size * 0.45;
      final innerY = math.sin(innerAngle) * size * 0.45;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}

class FinishGate extends RectangleComponent
    with HasGameReference<DashRocketGame>, CollisionCallbacks {
  double moveSpeed = 65.0;
  double pulseTimer = 0.0;

  FinishGate() : super(size: Vector2(220, 45), anchor: Anchor.center);

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
    pulseTimer += dt * 2;

    if (position.y > game.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  bool onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is RocketPlayer) {
      game.completeGame();
      FlameAudio.play('lvl-up.mp3');
      return false;
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    // animated glow effect
    final glowIntensity = (math.sin(pulseTimer) + 1) * 0.5;
    final glowPaint = Paint()
      ..color = const Color(
        0xFF4CAF50,
      ).withValues(alpha: 0.3 + glowIntensity * 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-5, -5, size.x + 10, size.y + 10),
        const Radius.circular(15),
      ),
      glowPaint,
    );

    // professional gate design
    final gatePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF4CAF50), Color(0xFF2E7D32)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(size.toRect());

    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)),
      gatePaint,
    );

    // finish text with perfect styling
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'FINISH LINE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [
            Shadow(blurRadius: 3, color: Colors.black, offset: Offset(1, 1)),
          ],
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

  // game state
  int score = 0;
  int questionsCorrect = 0;
  int questionsTotal = 0;
  int questionsSpawned = 0;
  bool gameComplete = false;

  // streams for UI updates
  final StreamController<int> _scoreController =
      StreamController<int>.broadcast();
  final StreamController<Map<String, int>> _statsController =
      StreamController<Map<String, int>>.broadcast();
  final StreamController<bool> _gameCompleteController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isPausedController =
      StreamController<bool>.broadcast();
  final StreamController<Map<String, dynamic>> _gameStateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, int>> _finalStatsController =
      StreamController<Map<String, int>>.broadcast();

  Stream<int> get scoreStream => _scoreController.stream;
  Stream<Map<String, int>> get statsStream => _statsController.stream;
  Stream<bool> get gameCompleteStream => _gameCompleteController.stream;
  Stream<bool> get isPausedStream => _isPausedController.stream;
  Stream<Map<String, dynamic>> get gameStateStream =>
      _gameStateController.stream;
  Stream<Map<String, int>> get finalStatsStream => _finalStatsController.stream;

  final bool _isReload;
  DashRocketGame({bool isReload = false}) : _isReload = isReload;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // load all audio files for smooth gameplay
    await FlameAudio.audioCache.loadAll([
      'rocket.mp3',
      'coin.mp3',
      'correct.mp3',
      'wrong.mp3',
      'lvl-up.mp3',
      'done.mp3',
      'game.mp3',
      'launch.mp3',
      'sound.mp3',
      'notification.mp3',
      'shot.mp3',
      'page.mp3',
    ]);

    await _initializeGame();
    _updateGameState();
  }

  Future<void> _initializeGame() async {
    // space background
    add(SpaceBackground());

    // player rocket
    player = RocketPlayer();
    add(player);

    // generate diverse questions
    _generateQuestions();

    // setup balanced timers
    _setupTimers();

    // initialize UI
    _updateStats();

    // add a small delay before starting music to ensure proper initialization (only if its a reload)
    if (_isReload) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // start the quite immersive background music experience
    FlameAudio.bgm.play('game.mp3', volume: 0.4);
  }

  void _setupTimers() {
    // clean up existing timers
    children.whereType<TimerComponent>().forEach(
      (timer) => timer.removeFromParent(),
    );

    // balanced timing for engaging gameplay
    asteroidTimer = TimerComponent(
      period: 11.5, // slower pace for better engagement
      repeat: true,
      onTick: _spawnAsteroidBelt,
    );

    coinTimer = TimerComponent(
      period: 3.2, // more frequent coins for reward feedback
      repeat: true,
      onTick: _spawnCoin,
    );

    finishGateTimer = TimerComponent(
      period: 150.0, // appropriate game length perhaps??!
      repeat: false,
      onTick: _spawnFinishGate,
    );

    add(asteroidTimer);
    add(coinTimer);
    add(finishGateTimer);
  }

  void _generateQuestions() {
    final questionTemplates = [
      // diverse algebra problems for engagement
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

    questions.clear();
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
    if (questionsSpawned < 12 && !gameComplete && questions.isNotEmpty) {
      final question = questions[random.nextInt(questions.length)];
      add(AsteroidBelt(question: question));
      questionsSpawned++;

      // stop spawning after reaching limit
      if (questionsSpawned >= 12) {
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
      coinTimer.removeFromParent(); // stop coins near finish
    }
  }

  void collectCoin() {
    updateScore(2); // slightly higher reward for coins
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
      updateScore(10); // higher reward for correct answers
    } else {
      updateScore(1); // small consolation points
    }
    _updateStats();
  }

  void _updateStats() {
    final stats = {
      'correct': questionsCorrect,
      'total': questionsTotal,
      'xp': score,
    };
    _statsController.add(stats);
    _finalStatsController.add(stats); // ensure final stats are updated
  }

  void _updateGameState() {
    _gameStateController.add({'paused': paused, 'complete': gameComplete});
  }

  void completeGame() async {
    if (!gameComplete) {
      gameComplete = true;
      updateScore(25); // completion bonus

      // force update stats AFTER score update (to w9orkk) !
      Future.delayed(const Duration(milliseconds: 50), () {
        _updateStats();
        _gameCompleteController.add(true);
        _updateGameState();
      });

      // update all relevant streams
      _gameCompleteController.add(true);
      _updateGameState();
      _updateStats(); // ensure final stats include completion bonus

      // await _saveScoreToFirestore(score, questionsCorrect);
      
      // clean up timers
      children.whereType<TimerComponent>().forEach(
        (timer) => timer.removeFromParent(),
      );
      
      // stop background music
      FlameAudio.bgm.stop();
      
      // create final stats (after completion bonus is added)
      final finalStats = {
        'correct': questionsCorrect,
        'total': questionsTotal,
        'xp': score,
      };
      
      // update all streams with final values
      _scoreController.add(score);
      _statsController.add(finalStats);
      _finalStatsController.add(finalStats);
      _gameCompleteController.add(true);
      _updateGameState();
      
      // save to Firestore ONCE with final values
      try {
        await _saveScoreToFirestore(score, questionsCorrect);
        print("Game completed! Final score: $score, Questions correct: $questionsCorrect");
      } catch (e) {
        print("Error saving to Firestore: $e");
      }
    }
  }

  void pauseGame() {
    paused = true;
    _isPausedController.add(true);
    _updateGameState();
    FlameAudio.bgm.pause();
    FlameAudio.play('notification.mp3');
  }

  void resumeGame() {
    paused = false;
    _isPausedController.add(false);
    _updateGameState();
    FlameAudio.bgm.resume();
    FlameAudio.play('notification.mp3');
  }

  Future<void> resetGame() async {
    // reset all game states
    score = 0;
    questionsCorrect = 0;
    questionsTotal = 0;
    questionsSpawned = 0;
    gameComplete = false;
    // IMPORTANT: set paused to false FIRST
    paused = false;

    // stop all audio immediately?!
    FlameAudio.bgm.stop();

    // update all streams immmediatelyyy !
    _scoreController.add(0);
    _statsController.add({'correct': 0, 'total': 0, 'xp': 0});
    _finalStatsController.add({'correct': 0, 'total': 0, 'xp': 0});
    _gameCompleteController.add(false);
    _isPausedController.add(false);
    _updateGameState();

    // clean up components EXCEPT omg spacebackground // & rocketplayer
    final componentsToRemove = children
        .where(
          (component) =>
              component is! SpaceBackground, // && component is! RocketPlayer,
        )
        .toList();

    for (final component in componentsToRemove) {
      component.removeFromParent();
    }

    /*
    // remove n re-add player to ensure proper initialization??!
    player.removeFromParent();
    player = RocketPlayer();
    add(player);
    */

    // properly reset player (existing one - instead of removing/readding)
    player.position = Vector2(size.x / 2, size.y - 100);
    player.targetPosition = player.position.clone();
    player.isMoving = false;
    player.scale = Vector2.all(1.0);
    player.angle = 0.0; // reset rotation
    player.thrustParticleTimer = 0.0; // and reset animation timer

    // await player.onLoad(); // plsplsplsss force reload

    // player.removeFromParent();
    // force player to be interactive again!!! (gosh i was wondering)
    // player.scale = Vector2.all(1.0);

    /*
    // regenerate everything
    _generateQuestions();
    _setupTimers();
    */

    // restart music
    // FlameAudio.bgm.stop();

    // wait a frame to ensure everything is cleaned up
    await Future.delayed(const Duration(milliseconds: 50));

    // Completely recreate the rocket from scratch
    // await _recreateRocket();

    // regenerate questions and setup timers yadayadayada
    _generateQuestions();
    _setupTimers();

    FlameAudio.bgm.play('game.mp3', volume: 0.4);

    /*
    // add a smallll delay to ensure everything is properly initialized and ready to go!!!
    Future.delayed(const Duration(milliseconds: 100), () async {
      player = RocketPlayer();
      await add(player);

      // regenerate everything
      _generateQuestions();
      _setupTimers();

      FlameAudio.bgm.stop(); // restart music
      FlameAudio.bgm.play('game.mp3', volume: 0.4);
    });
    */
  }

  /*
  Future<void> _recreateRocket() async {
    // create a completely new rocket instance
    player = RocketPlayer();

    // ensure proper initialization (please work!)
    player.position = Vector2(size.x / 2, size.y - 100);
    player.targetPosition = player.position.clone();
    player.isMoving = false;
    player.moveSpeed = 450.0;
    player.thrustParticleTimer = 0.0;
    player.scale = Vector2.all(1.0);
    player.angle = 0.0;

    // add the rocket to the game and wait for it to load
    await add(player);

    // force the collision system to recognize the new rocket
    await player.onLoad();
  }
  */

  void reloadGameScreen(BuildContext context) {
    // stop current game
    FlameAudio.bgm.stop();

    // finally navigate back and create a new game screen
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen(isReload: true)),
    );
    /*
    .then((value) {
        FlameAudio.bgm.play('game.mp3', volume: 0.4);
    });
    */
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!gameComplete && !paused) {
      final tapPosition = event.canvasPosition;
      player.moveTo(tapPosition);
    }
  }

  @override
  void onRemove() {
    // clean up all streams
    _scoreController.close();
    _statsController.close();
    _gameCompleteController.close();
    _isPausedController.close();
    _gameStateController.close();
    _finalStatsController.close();
    FlameAudio.bgm.stop();
    super.onRemove();
  }
}
