import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
    final double _gradeSpacer = _screenHeight / 50;

    final double _verticalPadding = (_screenWidth / 8) / 2;

    final double _formFontSize = _screenHeight / 55;

    final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;

    final double _subjectNameFontSize = _screenHeight / 40;
    final double _subjectCodeFontSize = _screenHeight / 50;
    final double _gradeNameFontSize = _screenHeight / 50;
    final double _gradeFontSize = _screenHeight / 60;

    final TextStyle _subjectNameTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _subjectNameFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    final TextStyle _subjectCodeTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _subjectCodeFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

    final TextStyle _gradeNameTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _gradeNameFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    final TextStyle _gradeTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _gradeFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

    final TextStyle _gradeBoldTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _gradeFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

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
                        onPointerUp: (PointerUpEvent event) async {
                          setState(() {
                            _isPressedRight = false;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddGradePage(
                                subjectCode: widget.subjectCode,
                                subjectName: widget.subjectName,
                              ),
                            ),
                          ).then((value) {
                            getUserGrades().then(
                              (val) {
                                setState(() {
                                  _grades = val;
                                });
                              },
                            );
                          });
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
            margin: EdgeInsets.symmetric(vertical: _verticalPadding / 2),
            child: Container(
              width: _screenWidth - (_screenWidth / 10),
              height: (_screenWidth - (_screenWidth / 10)) / 2.5,
              padding: EdgeInsets.symmetric(
                vertical: _formFieldPaddingHorizontal,
                horizontal: _formFieldPaddingHorizontal * 1.5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subjectName,
                    style: _subjectNameTextStyle,
                  ),
                  SizedBox(
                    height: _formFontSize,
                  ),
                  Text(
                    widget.subjectCode,
                    style: _subjectCodeTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: _screenWidth - (_screenWidth / 10),
              margin: EdgeInsets.symmetric(vertical: _verticalPadding),
              padding:
                  EdgeInsets.symmetric(horizontal: _formFieldPaddingHorizontal),
              decoration: (_grades != null && _grades.isNotEmpty)
                  ? BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 1.0),
                          bottom: BorderSide(color: Colors.grey, width: 1.0)),
                    )
                  : null,
              child: ScrollConfiguration(
                behavior: CustomBehavior(),
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: (_grades != null)
                      ? listGrades(
                          _gradeSpacer,
                          _gradeNameTextStyle,
                          _gradeTextStyle,
                          _gradeBoldTextStyle,
                          _formFieldPaddingHorizontal,
                          _buttonSize,
                          _gradeFontSize,
                          _gradeFontSize)
                      : [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> listGrades(
      double _gradeSpacer,
      TextStyle _gradeNameTextStyle,
      TextStyle _gradeTextStyle,
      TextStyle _gradeBoldTextStyle,
      double _formFieldPaddingHorizontal,
      double _buttonSize,
      double _gradeNameFontSize,
      double _gradeFontSize) {
    List<Widget> list = new List();
    _grades.forEach((gradeInfo) {
      list.add(Dismissible(
        key: Key(gradeInfo['id']),
        onDismissed: (_) async {
          setState(() {
            _grades.remove(gradeInfo);
          });
          await deleteGrade(gradeInfo['id'])
              .then((value) => setState(() => {}));
        },
        confirmDismiss: (_) async {
          bool res;
          await confirmDelete(_gradeNameFontSize, _gradeFontSize)
              .then((value) => res = value);
          return res;
        },
        child: Neumorphic(
          style: NeumorphicStyle(depth: 0.0),
          padding: EdgeInsets.symmetric(
            horizontal: _formFieldPaddingHorizontal,
            vertical: _formFieldPaddingHorizontal / 1.5,
          ),
          child: Container(
              color: Colors.transparent,
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gradeInfo['name'],
                        textAlign: TextAlign.left,
                        style: _gradeNameTextStyle,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "Grade: ", style: _gradeTextStyle),
                          TextSpan(
                              text: gradeInfo['grade'].toString(),
                              style: _gradeBoldTextStyle),
                          TextSpan(
                              text:
                                  " (" + gradeInfo['percent'].toString() + "%)",
                              style: _gradeTextStyle)
                        ]),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   width: _buttonSize,
                //   height: _buttonSize,
                //   child: InkWell(
                //     onTap: () {

                //     },
                //     child: Icon(
                //       Icons.delete_rounded,
                //       color: Colors.white54,
                //       size: _buttonSize / 2,
                //     ),
                //   ),
                // )
              ])),
        ),
      ));
      list.add(
        Divider(
          height: _gradeSpacer,
        ),
      );
    });
    if (list.isNotEmpty) list.removeLast();
    return list;
  }

  Future<List<Map<String, dynamic>>> getUserGrades() async {
    List<Map<String, dynamic>> result = new List<Map<String, dynamic>>();
    Map<String, dynamic> tmp = new Map<String, dynamic>();
    await db
        .collection('grades')
        .doc(auth.currentUser.uid)
        .collection(widget.subjectCode)
        .get()
        .then(
          (QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach(
              (element) {
                tmp = element.data();
                tmp.addAll({"id": element.id});
                result.add(tmp);
              },
            )
          },
        );
    return result;
  }

  Future<void> deleteGrade(String id) async {
    await db
        .collection('grades')
        .doc(auth.currentUser.uid)
        .collection(widget.subjectCode)
        .doc(id)
        .delete();
  }

  Future<bool> confirmDelete(
      double _gradeNameFontSize, double _gradeFontSize) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final _screenWidth = MediaQuery.of(context).size.width;
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: _screenWidth - (_screenWidth / 10),
              height: (_screenWidth - (_screenWidth / 10)) / 2,
              padding: EdgeInsets.symmetric(
                  vertical: (_screenWidth / 12),
                  horizontal: (_screenWidth / 10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin: Alignment(-0.52, -1.0),
                  end: Alignment(0.38, 1.0),
                  colors: [const Color(0xffee235a), const Color(0xff9f2042)],
                  stops: [0.0, 1.0],
                ),
                border: Border.all(width: 1.0, color: const Color(0xffee235a)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffee235a),
                    offset: Offset(0, 0),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Are you sure you want to delete this grade?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: _gradeNameFontSize * 1.4,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              "Yes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: _gradeFontSize * 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: _gradeFontSize * 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
