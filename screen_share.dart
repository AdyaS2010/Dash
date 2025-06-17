import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ScreenShare extends StatelessWidget {
  const ScreenShare({super.key});


  // Fetch current user's username from Firestore
  Future<String?> _getCurrentUserUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;


    if (uid == null) {
      return null;
    }


    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['username']; // Return the username
      }
    } catch (e) {
      print("Error fetching username: $e");
    }


    return null; // If fetching fails, return null
  }


  // Fetch the leaderboard data
  Future<List<Map<String, dynamic>>> _getLeaderboard() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').orderBy('highScore', descending: true).limit(5).get();
    List<Map<String, dynamic>> leaderboard = [];


    for (var doc in snapshot.docs) {
      final userData = doc.data() as Map<String, dynamic>;
      leaderboard.add({
        'username': userData['username'],
        'highScore': userData['highScore'] ?? 0,
      });
    }


    return leaderboard;
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colWidth = screenWidth * 0.8;


    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // dark background to match lesson plan
      appBar: AppBar(
        title: const Text('Share High Scores'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Leaderboard section
              FutureBuilder<List<Map<String, dynamic>>>( // Fetching leaderboard data
                future: _getLeaderboard(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // loading
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No leaderboard data available.");
                  }


                  final leaderboard = snapshot.data!;


                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.leaderboard, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Leaderboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Fetch current username asynchronously using FutureBuilder
                      FutureBuilder<String?>(
                        future: _getCurrentUserUsername(),
                        builder: (context, usernameSnapshot) {
                          if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // loading
                          }
                          if (!usernameSnapshot.hasData || usernameSnapshot.data == null) {
                            return const Text("Unable to load current username.");
                          }


                          final currentUsername = usernameSnapshot.data;


                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: leaderboard.length,
                            itemBuilder: (context, index) {
                              bool isThisMe = leaderboard[index]['username'] == currentUsername;


                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: isThisMe ? Colors.deepPurpleAccent : const Color.fromARGB(255, 75, 45, 160),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribute elements evenly
                                  children: [
                                    // Row to keep icon and username close together
                                    Row(
                                      children: [
                                        Icon(
                                          index == 0 ? Icons.star : Icons.person,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),  // Add some spacing between the icon and the username
                                        Text(
                                          '${index + 1}. ${leaderboard[index]['username']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Align the score to the right
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,  // Align score to the far right
                                        child: Text(
                                          'Score: ${leaderboard[index]['highScore']}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
}





