import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/nav_bar.dart';

import 'add_grade.dart';

class GradesInfo extends StatefulWidget {
  final String subjectCode;
  final String subjectName;
  GradesInfo({Key key, this.subjectCode, this.subjectName}) : super(key: key);

  @override
  _GradesInfoState createState() {
    return _GradesInfoState();
  }
}

class _GradesInfoState extends State<GradesInfo> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _grades;

  @override
  void initState() {
    super.initState();

    getUserGrades().then(
      (val) {
        setState(() {
          _grades = val;
        });
      },
    );
  }

  bool _isPressedLeft = false;
  bool _isPressedRight = false;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _statusBarHeight = MediaQuery.of(context).padding.top;

    final double _buttonSize = _screenWidth / 9;
    final double _iconSize = _screenWidth / 16;
    final double _iconSizeLeft = _screenWidth / 14;
    final double _buttonPadding = (_screenWidth / 10) / 2;

    print(_grades);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: _screenWidth,
            color: Colors.transparent,
            margin: EdgeInsets.only(
                top: _statusBarHeight + (_screenHeight / 70),
                bottom: _buttonPadding),
            height: _screenWidth / 9,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: _buttonPadding),
                        child: Listener(
                          onPointerDown: (PointerDownEvent event) {
                            setState(() {
                              _isPressedLeft = true;
                            });
                          },
                          onPointerUp: (PointerUpEvent event) {
                            setState(() {
                              _isPressedLeft = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Neumorphic(
                            duration: const Duration(milliseconds: 80),
                            style: NeumorphicStyle(
                                depth: !_isPressedLeft ? 5.0 : 0.0,
                                boxShape: NeumorphicBoxShape.circle()),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 80),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.94, 0.92),
                                  end: Alignment(-0.88, -0.89),
                                  colors: _isPressedLeft
                                      ? [
                                          const Color(0xff2c2f34),
                                          const Color(0xff2c2f34)
                                        ]
                                      : [
                                          const Color(0xff282a2f),
                                          const Color(0xff2f3238)
                                        ],
                                  stops: [0.0, 1.0],
                                ),
                              ),
                              width: _buttonSize,
                              height: _buttonSize,
                              child: Icon(Icons.chevron_left_rounded,
                                  color: Colors.white, size: _iconSizeLeft),
                            ),
                          ),
                        ))),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: _buttonPadding),
                      child: Listener(
                        onPointerDown: (PointerDownEvent event) {
                          setState(() {
                            _isPressedRight = true;
                          });
                        },
                        onPointerUp: (PointerUpEvent event) {
                          setState(() {
                            _isPressedRight = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGradePage(
                                        subjectCode: widget.subjectCode,
                                        subjectName: widget.subjectName,
                                      )));
                        },
                        child: Neumorphic(
                          duration: const Duration(milliseconds: 80),
                          style: NeumorphicStyle(
                              depth: !_isPressedRight ? 5.0 : 0.0,
                              boxShape: NeumorphicBoxShape.circle()),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 80),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.94, 0.92),
                                end: Alignment(-0.88, -0.89),
                                colors: _isPressedRight
                                    ? [
                                        const Color(0xff2c2f34),
                                        const Color(0xff2c2f34)
                                      ]
                                    : [
                                        const Color(0xff282a2f),
                                        const Color(0xff2f3238)
                                      ],
                                stops: [0.0, 1.0],
                              ),
                            ),
                            width: _buttonSize,
                            height: _buttonSize,
                            child: Icon(Icons.add,
                                color: Colors.white, size: _iconSize),
                          ),
                        ),
                      )),
                )
              ],
            ),
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
                children: (_grades != null) ? listGrades() : [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> listGrades() {
    List<Widget> list = new List();
    _grades.forEach((gradeInfo) {});
    return list;
  }

  Future<List<Map<String, dynamic>>> getUserGrades() async {
    List<Map<String, dynamic>> result = new List<Map<String, dynamic>>();
    await db
        .collection('grades')
        .doc(auth.currentUser.uid)
        .collection(widget.subjectCode)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (element) {
                result.add(element.data());
              },
            )
          },
        );
    return result;
  }
}
