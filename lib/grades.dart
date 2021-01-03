import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fri_app/grades_info.dart';
import 'package:fri_app/nav_bar.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Map<String, String> _subjects;

  @override
  void initState() {
    super.initState();

    getSubjects().then(
      (val) {
        setState(
          () {
            _subjects = val;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(
        children: [
          NavBar(
            title: "Grades",
            back: true,
            user: false,
            refresh: false,
          ),
          Column(
            children: (_subjects != null) ? listSubjects() : [],
          ),
        ],
      ),
    );
  }

  List<Widget> listSubjects() {
    List<Widget> list = new List();
    _subjects.forEach((code, name) {
      list.add(
        new InkWell(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GradesInfo(
                  subjectCode: code.toString(),
                  subjectName: name.toString(),
                ),
              ),
            );
          },
          child: Text(name.toString()),
        ),
      );
    });
    return list;
  }

  Future<Map<String, String>> getSubjects() async {
    Map<String, String> result = new Map<String, String>();
    await db
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('subjects')
        .get()
        .then(
      (QuerySnapshot qs) {
        qs.docs.forEach(
          (el) {
            result.addAll({el.id.toString(): el['subject'].toString()});
          },
        );
      },
    );
    return result;
  }
}
