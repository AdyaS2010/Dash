import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP WITH EMAIL + USERNAME
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Check if username already exists
      DocumentSnapshot usernameCheck = await _firestore
          .collection('usernames')
          .doc(username)
          .get();

      if (usernameCheck.exists) {
        throw Exception("Username already in use.");
      }

      // Create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Save user profile
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'highScore': 0,
          'levelsUnlocked': {
            'level1': true,
            'level2': false,
            'level3': false,
            'level4': false,
            'level5': false,
          },
          'levelsComplete':
              0, //this is simply levelsUnlocked.values.where((value) => value == true).length - 1
          'levelCount': 0,
          'questionsCorrect': 0,
          'totalPoints': 0,
          'streak': 0,
        });

        // Save username lookup
        await _firestore.collection('usernames').doc(username).set({
          'uid': user.uid,
          'email': email,
        });
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // LOGIN WITH USERNAME (not email)
  Future<User?> loginWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('usernames')
          .doc(username)
          .get();

      if (!snapshot.exists) {
        throw Exception("Username not found.");
      }

      String email = snapshot['email'];

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // STREAM TO LISTEN TO USER STATE
  Stream<User?> get userChanges => _auth.authStateChanges();
}
