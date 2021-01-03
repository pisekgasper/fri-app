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

  List<String> _subjects;

  @override
  void initState() {
    super.initState();

    getSubjects().then(
      (val) {
        _subjects = val;
        print(_subjects.toString());
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
            children: [
              if (_subjects != null)
                for (var s in _subjects)
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GradesInfo(
                            subject: s.toString(),
                          ),
                        ),
                      );
                    },
                    child: Text(s.toString()),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> getSubjects() async {
    List<String> res = new List<String>();
    await db
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('subjects')
        .get()
        .then(
      (QuerySnapshot qs) {
        qs.docs.forEach(
          (el) {
            res.add(el['subject'].toString());
          },
        );
      },
    );
    print(res.toString());
    return res;
  }
}
