import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  // Signin
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException { // errors will be shown in widgets
      rethrow;
    }
  }

  // Signup
  Future<User?> signUp({required String email, required String password}) async {
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      return user;
    } on FirebaseAuthException { // errors will be shown in widgets
      rethrow;
    }
  }

  // Signout
  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'Signed out';
    } on FirebaseAuthException { // errors will be shown in widgets
      rethrow;
    }
  }
}