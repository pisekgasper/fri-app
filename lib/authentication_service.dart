import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password, String studentsNumber}) async {
    try {
      final http.Response response = await http.post(
        'http://10.0.2.2:5000/api',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentsNumber': studentsNumber,
        }),
      );
      print(response);
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print(response);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}