import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      User? user = result.user;


      await _firestore.collection('users').doc(user!.uid).set({
        'username': username,
        'email': email,
        'highScore': 0,
        'createdAt': Timestamp.now(),
      });


      return user;
    } catch (e) {
      rethrow;
    }
  }


  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
  }


  Stream<User?> get userChanges => _auth.authStateChanges();
}
