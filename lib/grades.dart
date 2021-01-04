import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
  List<bool> barr;

  @override
  void initState() {
    super.initState();

    getSubjects().then(
      (val) {
        setState(
          () {
            _subjects = val;
            barr = new List<bool>.filled(_subjects.length, false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(
              title: "Grades",
              back: true,
              user: false,
              refresh: false,
            ),
            Column(
              children: (_subjects != null)
                  ? listSubjects(_screenHeight, _screenWidth)
                  : [],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> listSubjects(double _sH, double _sW) {
    List<Widget> list = new List();
    _subjects.forEach(
      (code, name) {
        list.add(
          GestureDetector(
            onTapDown: (_) {
              setState(
                () {},
              );
            },
            onTapUp: (_) {
              setState(
                () {},
              );
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
            child: Neumorphic(
              margin: EdgeInsets.symmetric(vertical: _sH / 50),
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(30.0),
                ),
                depth: 2.0,
              ),
              child: Container(
                width: _sW - _sW / 8,
                height: _sH / 11,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: (_sW / 15.0)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(name.toString()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: (_sW / 15.0)),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
