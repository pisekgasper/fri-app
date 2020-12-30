import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (email.isEmpty || password.isEmpty) return "All fields are required!";
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String email,
      String password,
      String studentsNumber,
      String fullName}) async {
    if (email.isEmpty ||
        password.isEmpty ||
        studentsNumber.isEmpty ||
        fullName.isEmpty)
      return "All fields are required!";
    else if (studentsNumber.length != 8)
      return "Student's number must be 8 numbers long!";

    try {
      // if students number is ok, but email already exists, timetable will be created but user will not be created!!!!

      final http.Response response = await http.post(
        'http://pisekgasper.pythonanywhere.com/api',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentsNumber': studentsNumber,
        }),
      );
      if (response.body != "") throw Exception(response.body);

      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection('users')
          .doc(this._firebaseAuth.currentUser.uid)
          .set({'name': fullName, "studentsNumber": studentsNumber});
      return response.body;
    } catch (e) {
      return e.message;
    }
  }

  Future<String> changePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser.updatePassword(newPassword);
      return 'Password changed successfully!';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
