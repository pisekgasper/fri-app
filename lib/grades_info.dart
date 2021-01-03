import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/nav_bar.dart';

class GradesInfo extends StatefulWidget {
  final String subject;
  GradesInfo({Key key, this.subject}) : super(key: key);

  @override
  _GradesInfoState createState() {
    return _GradesInfoState();
  }
}

class _GradesInfoState extends State<GradesInfo> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Map<String, Map<String, dynamic>> _grades;

  @override
  void initState() {
    super.initState();

    getUserGrades(widget.subject).then(
      (val) {
        _grades = val;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavBar(
            title: widget.subject.toString(),
            back: true,
            user: false,
            refresh: false,
          ),
          Neumorphic(
            style: NeumorphicStyle(
              depth: 7.0,
            ),
            padding: EdgeInsets.only(top: _screenHeight / 15),
            child: Container(
              height: _screenHeight / 5,
              width: _screenWidth - _screenWidth / 4,
              child: Column(
                children: [
                  if (_grades != null)
                    for (var k in _grades[widget.subject].keys)
                      Text(k.toString() +
                          " " +
                          _grades[widget.subject][k].toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, Map<String, dynamic>>> getUserGrades(String sub) async {
    Map<String, Map<String, dynamic>> res =
        new Map<String, Map<String, dynamic>>();
    await db
        .collection('grades')
        .doc(auth.currentUser.uid)
        .collection(sub)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (element) {
                res[element.id.toString()] = element.data();
              },
            )
          },
        );
    return res;
  }
}
