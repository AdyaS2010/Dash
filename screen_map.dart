// ignore_for_file: avoid_print

import 'lesson_plan_1.dart';
import 'lesson_plan_2.dart';
import 'lesson_plan_3.dart';
import 'lesson_plan_4.dart';
import 'lesson_plan_5.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screen_share.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopNavBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildUserStatsContainer(),
                      const SizedBox(height: 20),
                      _buildQuestTitle(),
                      const SizedBox(height: 16),
                      _buildLevelsContainer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
        // Add subtle border for more definition
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF6A5ACD).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Enhanced logo with space theming
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5ACD), Color(0xFF9370DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9370DB).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'DASH',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(width: 4),
              // Text('🚀', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const Spacer(),
          // Enhanced navbar buttons
          _buildNavButton(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isActive: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _buildNavButton(
            icon: Icons.emoji_events,
            label: 'Leaderboard',
            isActive: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScreenShare()),
              );
            },
          ),
          const SizedBox(width: 16),
          // Enhanced logout button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6A5ACD).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF6A5ACD).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white, size: 18),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6A5ACD).withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: const Color(0xFF6A5ACD), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF9370DB) : Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.exo2(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatsContainer() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text(
            "User data not found",
            style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'] ?? 'Unknown';
        final highScore = userData['highScore'] ?? 0;
        final totalScore = userData['totalPoints'] ?? 0;
        final levelsUnlocked =
            userData['levelsUnlocked'] as Map<String, dynamic>? ?? {};
        final levelsComplete = levelsUnlocked.values
            .where((v) => v == true)
            .length;
        final dayStreak = userData['dayStreak'] ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A5ACD), Color(0xFF9370DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9370DB).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Welcome section with enhanced typography
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Welcome back, $username!',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌟', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'Level $levelsComplete • $totalScore XP',
                    style: GoogleFonts.rajdhani(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🌟', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 24),
              // Enhanced stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      value: (levelsComplete - 1).toString(),
                      label: 'Levels Complete',
                      icon: Icons.check_circle_outline,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildStatItem(
                      value: highScore.toString(),
                      label: 'High Score',
                      icon: Icons.star_outline,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    _buildStatItem(
                      value: dayStreak.toString(),
                      label: 'Day Streak',
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.rajdhani(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuestTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 90, 182, 205), Color(0xFF9370DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.explore, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Choose Your Quest',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          // const Text('🌌', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildLevelsContainer() {
    return FutureBuilder(
      future: Future.wait([
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        FirebaseFirestore.instance.collection('levels').get(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data![0] == null ||
            snapshot.data![1] == null) {
          return Text(
            "Error loading levels",
            style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 16),
          );
        }

        final userDoc = snapshot.data![0] as DocumentSnapshot;
        final levelDocs = snapshot.data![1] as QuerySnapshot;

        final levelsUnlocked =
            (userDoc['levelsUnlocked'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, value as bool),
            );

        return Column(
          children: levelDocs.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final levelName = doc.id;
            final unlocked = levelsUnlocked[levelName] ?? false;
            final isCompleted = unlocked;

            return _buildLevelCard(
              context: context,
              levelName: data['name'] ?? levelName,
              description: data['description'] ?? '',
              icon: _getLevelIcon(levelName),
              isUnlocked: unlocked,
              isCompleted: isCompleted,
              xpReward: data['xpReward'] ?? 100,
              difficulty: data['difficulty'] ?? 'Beginner',
              onTap: unlocked
                  ? () {
                      _navigateToLevelLesson(context, levelName);
                    }
                  : null,
            );
          }).toList(),
        );
      },
    );
  }

  // Add this method to handle navigation
  void _navigateToLevelLesson(BuildContext context, String levelName) {
    switch (levelName.toLowerCase()) {
      case 'level1':
      case 'level_1':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Level1LessonPage()),
        );
        break;
      case 'level2':
      case 'level_2':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Level2LessonPage()),
        );
        break;
      case 'level3':
      case 'level_3':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Level3LessonPage()),
        );
        break;
      // add more levels as needed
      case 'level4':
      case 'level_4':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Level4LessonPage()),
        );
        break;
      case 'level5':
      case 'level_5':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Level5LessonPage()),
        );
        break;
      default:
        // Show error or default page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Level $levelName not implemented yet'),
            backgroundColor: Colors.orange,
          ),
        );
    }
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String levelName,
    required String description,
    required IconData icon,
    required bool isUnlocked,
    required bool isCompleted,
    required int xpReward,
    required String difficulty,
    VoidCallback? onTap,
  }) {
    Color cardColor;
    Color textColor;
    Color accentColor;

    if (isCompleted) {
      cardColor = const Color(0xFF2A2A4A);
      textColor = Colors.white;
      accentColor = const Color(0xFF4CAF50);
    } else if (isUnlocked) {
      cardColor = const Color(0xFF2A2A4A);
      textColor = Colors.white;
      accentColor = const Color(0xFF6A5ACD);
    } else {
      cardColor = const Color(0xFF2A2A4A).withValues(alpha: 0.5);
      textColor = Colors.white54;
      accentColor = const Color(0xFF666666);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // enhanced level icon!
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? LinearGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.2),
                            accentColor.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: !isUnlocked
                      ? accentColor.withValues(alpha: 0.1)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: 18),
              // enhanced level info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      levelName,
                      style: GoogleFonts.orbitron(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.rajdhani(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            difficulty,
                            style: GoogleFonts.exo2(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.2),
                                accentColor.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: accentColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '$xpReward XP',
                                style: GoogleFonts.rajdhani(
                                  color: accentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Enhanced status indicator
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : isUnlocked
                      ? Icons.play_circle_outline
                      : Icons.lock,
                  color: accentColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getLevelIcon(String levelName) {
    switch (levelName.toLowerCase()) {
      case 'level1':
        return Icons.functions;
      case 'level2':
        return Icons.straighten;
      case 'level3':
        return Icons.timeline;
      case 'level4':
        return Icons.show_chart;
      case 'level5':
        return Icons.auto_graph;
      default:
        return Icons.school;
    }
  }
}
