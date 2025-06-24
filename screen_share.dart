// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenShare extends StatefulWidget {
  const ScreenShare({super.key});

  @override
  State<ScreenShare> createState() => _ScreenShareState();
}

class _ScreenShareState extends State<ScreenShare>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fetch current user's username from Firestore
  Future<String?> _getCurrentUserUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return null;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['username'];
      }
    } catch (e) {
      print("Error fetching username: $e");
    }

    return null;
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
              Text(
                '🚀',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
          // Enhanced navbar buttons
          _buildNavButton(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isActive: false,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
          _buildNavButton(
            icon: Icons.emoji_events,
            label: 'Leaderboard',
            isActive: true,
            onTap: () {},
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
                      '/',
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

  Future<List<Map<String, dynamic>>> _getLeaderboard() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .get();

    List<Map<String, dynamic>> leaderboard = [];

    for (var doc in snapshot.docs) {
      final userData = doc.data();
      final levelsUnlocked =
          userData['levelsUnlocked'] as Map<String, dynamic>? ?? {};

      int levelsCompleted;
      levelsCompleted =
          (levelsUnlocked['level1'] == true ? 1 : 0) +
          (levelsUnlocked['level2'] == true ? 1 : 0) +
          (levelsUnlocked['level3'] == true ? 1 : 0) +
          (levelsUnlocked['level4'] == true ? 1 : 0) +
          (levelsUnlocked['level5'] == true ? 1 : 0)
          - 1;
      if (levelsCompleted < 0) {
        levelsCompleted = 0;
      }

      leaderboard.add({
        'username': userData['username'] ?? 'Unknown',
        'totalPoints': userData['totalPoints'] ?? 0,
        'levelsCompleted': levelsCompleted,
        'dayStreak': userData['dayStreak'] ?? 0,
        'highScore': userData['highScore'] ?? 0,
        'avatarUrl':
            userData['avatarUrl'] ??
            'https://upload.wikimedia.org/wikipedia/commons/2/24/Missing_avatar.svg',
      });
    }

    return leaderboard;
  }

  Widget _buildShareButton(
    String currentUsername,
    int userRank,
    int totalPoints,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton.icon(
        onPressed: () async {
          final rankText = userRank == 1
              ? "I'm #1 on the leaderboard"
              : "I'm ranked #$userRank";

          await SharePlus.instance.share(
            ShareParams(
              text:
                  'I have $totalPoints XP in Dash! $rankText. Let\'s get Dashing! 🚀\n\nJoin me and start your learning journey!',
              subject: 'Check out my progress in Dash!',
            ),
          );
        },
        icon: const Icon(Icons.share, color: Colors.white),
        label: Text(
          'Share My Stats',
          style: GoogleFonts.exo2(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A5ACD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF6A5ACD).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5ACD), Color(0xFF9370DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Intergalactic Leaderboard',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Compete with your fellow space explorers!',
                  style: GoogleFonts.exo2(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingCard({
    required int rank,
    required String username,
    required int totalPoints,
    required int levelsCompleted,
    required int dayStreak,
    required bool isCurrentUser,
    required int index,
  }) {
    final isFirstPlace = rank == 1;
    final cardHeight = isCurrentUser ? 110.0 : (isFirstPlace ? 100.0 : 90.0);

    // ignore: unused_local_variable
    Color cardColor;
    Color accentColor;
    Color rankColor;
    Color xpColor;
    List<Color> gradientColors;

    if (isCurrentUser) {
      gradientColors = [const Color(0xFF7B68EE), const Color(0xFF9370DB)];
      accentColor = const Color(0xFF9370DB);
      rankColor = const Color.fromARGB(255, 122, 58, 218); // Cyan for current user rank - space/neon theme
      xpColor = const Color.fromARGB(255, 123, 0, 255);   // Cyan for current user XP - futuristic glow
    } else if (isFirstPlace) {
      gradientColors = [
        const Color(0xFFFFD700).withValues(alpha: 0.3),
        const Color(0xFF6A5ACD),
      ];
      accentColor = const Color(0xFFFFD700);
      rankColor = const Color(0xFFFFD700);
      xpColor = const Color(0xFFFFD700);
    } else {
      gradientColors = [const Color(0xFF2A2A4A), const Color(0xFF2A2A4A)];
      accentColor = const Color(0xFF6A5ACD);
      rankColor = accentColor;
      xpColor = accentColor;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: isCurrentUser ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: isCurrentUser ? 0.4 : 0.2),
              blurRadius: isCurrentUser ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Rank and Crown
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (isCurrentUser ? const Color.fromARGB(255, 181, 108, 215) : accentColor).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: (isCurrentUser ? const Color.fromARGB(255, 85, 0, 255) : accentColor).withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isFirstPlace)
                    const Icon(
                      Icons.rocket_launch,
                      color: Color(0xFFFFD700),
                      size: 24,
                    )
                  else
                    Text(
                      '$rank',
                      style: GoogleFonts.orbitron(
                        color: rankColor,
                        fontSize: isCurrentUser ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          username,
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: isCurrentUser ? 18 : 16,
                            fontWeight: isCurrentUser
                                ? FontWeight.bold
                                : FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'YOU',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: xpColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '$totalPoints XP',
                            style: GoogleFonts.exo2(
                              color: xpColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$levelsCompleted levels',
                            style: GoogleFonts.exo2(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      if (dayStreak > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$dayStreak day streak',
                              style: GoogleFonts.exo2(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Trophy for first place
            if (isFirstPlace)
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 32,
              ),
          ],
        ),
      ),
    );
  }

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
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _getLeaderboard(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6A5ACD),
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    size: 64,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No cosmic explorers found yet.",
                                    style: GoogleFonts.exo2(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Begin your journey to be the first! 🚀",
                                    style: GoogleFonts.rajdhani(
                                      color: Colors.white54,
                                      fontSize: 14,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final leaderboard = snapshot.data!;

                          return Column(
                            children: [
                              _buildLeaderboardHeader(),
                              FutureBuilder<String?>(
                                future: _getCurrentUserUsername(),
                                builder: (context, usernameSnapshot) {
                                  if (usernameSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final currentUsername = usernameSnapshot.data;
                                  int userRank = 0;
                                  int userPoints = 0;

                                  // Find current user's rank
                                  for (int i = 0; i < leaderboard.length; i++) {
                                    if (leaderboard[i]['username'] ==
                                        currentUsername) {
                                      userRank = i + 1;
                                      userPoints =
                                          leaderboard[i]['totalPoints'];
                                      break;
                                    }
                                  }

                                  return Expanded(
                                    child: Column(
                                      children: [
                                        if (currentUsername != null &&
                                            userRank > 0)
                                          _buildShareButton(
                                            currentUsername,
                                            userRank,
                                            userPoints,
                                          ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: leaderboard.length,
                                            itemBuilder: (context, index) {
                                              final user = leaderboard[index];
                                              final isCurrentUser =
                                                  user['username'] ==
                                                  currentUsername;

                                              return _buildRankingCard(
                                                rank: index + 1,
                                                username: user['username'],
                                                totalPoints:
                                                    user['totalPoints'],
                                                levelsCompleted:
                                                    user['levelsCompleted'],
                                                dayStreak: user['dayStreak'],
                                                isCurrentUser: isCurrentUser,
                                                index: index,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
