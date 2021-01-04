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

    final double _verticalPadding = (_screenWidth / 8) / 2;

    final double _formFontSize = _screenHeight / 55;
    final double _errorFontSize = _screenHeight / 70;

    final double _formFieldWidth =
        _screenWidth - (_screenWidth / 10) - (_screenWidth / 7);
    final double _formFieldSpacer = _screenHeight / 50;

    final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;
    final double _formFieldPaddingVertical = (_screenWidth / 7) / 4;

    final double _fullNameFontSize = _screenHeight / 40;
    final double _studentsNumberFontSize = _screenHeight / 55;

    final TextStyle _fullNameTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _fullNameFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    final TextStyle _studentsNumberTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _studentsNumberFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

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
              depth: 4.0,
            ),
            margin: EdgeInsets.symmetric(vertical: _verticalPadding),
            child: Container(
              width: _screenWidth - (_screenWidth / 10),
              height: (_screenWidth - (_screenWidth / 10)) / 2.3,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("hej"),
                    SizedBox(
                      height: _formFontSize / 2,
                    ),
                    Text("hej"),
                  ],
                ),
              ),
            ),
          ),
          // (_grades != null) ? listGrades() : [],
          Neumorphic(
            style: NeumorphicStyle(depth: 3.0),
            child: Container(
              width: 240.0,
              height: 70.0,
              // color: Colors.green,
              child: NeumorphicButton(
                onPressed: () {
                  setState(() {});
                },
                style: NeumorphicStyle(depth: 3.0),
                child: Text(
                  "hej",
                  textAlign: TextAlign.center,
                ),
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
