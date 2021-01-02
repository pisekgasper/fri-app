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
      switch (e.message) {
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          {
            return "User with this email does not exist.";
          }
          break;
        case "The password is invalid or the user does not have a password.":
          {
            return "The password is invalid.";
          }
      }
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

  Future<String> changePassword(
      {String currentPassword, String newPassword}) async {
    if (newPassword.isEmpty || newPassword == null)
      return "All fields are required!";

    var user = _firebaseAuth.currentUser;

    try {
      EmailAuthCredential credential = EmailAuthProvider.credential(
          email: user.email, password: currentPassword);
      await _firebaseAuth.currentUser.reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser.updatePassword(newPassword);
      return 'Password changed successfully!';
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          {
            return "User with this email does not exist.";
          }
          break;
        case "The password is invalid or the user does not have a password.":
          {
            return "The password is invalid.";
          }
      }
      return e.message;
    }
  }

  Future<String> changeEmail({String currentPassword, String newMail}) async {
    if (newMail.isEmpty || currentPassword.isEmpty)
      return "All fields are required!";

    var user = _firebaseAuth.currentUser;

    try {
      EmailAuthCredential credential = EmailAuthProvider.credential(
          email: user.email, password: currentPassword);
      await _firebaseAuth.currentUser.reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser.updateEmail(newMail);
      return 'Mail changed successfully!';
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          {
            return "User with this email does not exist.";
          }
          break;
        case "The password is invalid or the user does not have a password.":
          {
            return "The password is invalid.";
          }
      }
      return e.message;
    }
  }

  Future<String> changeStudentsNumber({String studentsNumber}) async {
    if (studentsNumber.isEmpty)
      return "Student's number is required!";
    else if (studentsNumber.length != 8)
      return "Student's number must be 8 numbers long!";

    var user = _firebaseAuth.currentUser;

    try {
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

      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection('users')
          .doc(user.uid)
          .update({'studentsNumber': studentsNumber});
      return "Student's number changed successfully!";
    } catch (e) {
      return e.message;
    }
  }

  Future<String> changeFullName({String fullName}) async {
    if (fullName.isEmpty) return "Name is required!";

    var user = _firebaseAuth.currentUser;

    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db.collection('users').doc(user.uid).update({'name': fullName});
      return "Name changed successfully!";
    } catch (e) {
      return e.message;
    }
  }
}
