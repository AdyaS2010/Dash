import 'package:Dash/lesson_plan.dart';
// import 'package:Dash/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colWidth = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: const Color(0xFF210F04), // solid version of background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            //username container
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // loading
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text("User data not found");
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final username = userData['username'] ?? 'Unknown';
                final highScore = userData['highScore'] ?? 0;

                return Container(
                  width: colWidth,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8C8C8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Welcome, $username!',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF210F04),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'High Score: $highScore',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF210F04),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            //levels
            FutureBuilder(
              future: Future.wait([
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                FirebaseFirestore.instance.collection('levels').get(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data![0] == null ||
                    snapshot.data![1] == null) {
                  return const Text("Error loading levels");
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
                    final color = unlocked
                        ? const Color(0xFF3A9D5D)
                        : const Color(0xFF888888);
                    final textColor = unlocked ? Colors.white : Colors.black;

                    return GestureDetector(
                      onTap: unlocked
                          ? () {
                              // make sure to navigate to lesson plan, followed by actual game screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Level1LessonPage(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen()));
                            }
                          : null,
                      child: Container(
                        width: colWidth,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/planet.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? levelName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    data['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              unlocked
                                  ? 'assets/images/unlocked.png'
                                  : 'assets/images/locked.png',
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
