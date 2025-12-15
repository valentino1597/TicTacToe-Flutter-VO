import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for this email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      }
      return e.message ?? 'An error occurred during sign up.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }
  
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else if (e.code == 'user-disabled') {
        return 'This user account has been disabled.';
      }
      return e.message ?? 'An error occurred during sign in.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
  
  String get username {
    return currentUser?.displayName ?? 'Player';
  }
  
  String get userId {
    return currentUser?.uid ?? '';
  }
}