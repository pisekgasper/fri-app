import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String _studentsNumber;

  @override
  void initState() {
    super.initState();

    getUserData().then(
      (val) => setState(
        () {
          _studentsNumber = val['studentsNumber'].toString();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> res = new Map<String, dynamic>();
    await db
        .collection('users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) res = documentSnapshot.data();
    });
    return res;
  }

  Future<Map<String, dynamic>> getUserGrades(String sn) async {
    Map<String, dynamic> res = new Map<String, String>();
    await db.collection('grades').doc(sn).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) res = documentSnapshot.data();
      },
    );
    return res;
  }
}
