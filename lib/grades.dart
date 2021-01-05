import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fri_app/grades_info.dart';
import 'package:fri_app/nav_bar.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

class _GradesPageState extends State<GradesPage> with TickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Map<String, String> _subjects;
  List<String> _codeList;
  List<bool> barr;

  int _selected = -1;

  @override
  void initState() {
    super.initState();

    getSubjects().then(
      (val) {
        setState(
          () {
            _subjects = val;
            _codeList = val.entries.map((e) => e.key).toList();
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
    final double _statusBarHeight = MediaQuery.of(context).padding.top;

    final double _gradeFontSize = _screenHeight / 60;

    final TextStyle _gradeBoldTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _gradeFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  NavBar(title: "", user: false, back: true, refresh: false),
                  Expanded(
                    child: Container(
                      transform: Matrix4.translationValues(
                          0.0, -(_statusBarHeight + (_screenHeight / 70)), 0.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No internet connection!"),
                            SizedBox(
                              height: 10.0,
                            ),
                            SpinKitWave(
                              color: Colors.white,
                              size: 20.0,
                              controller: AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 1200)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            var result = snapshot.data;
            if (result == ConnectivityResult.none) {
              return Column(
                children: [
                  NavBar(title: "", user: false, back: true, refresh: false),
                  Expanded(
                    child: Container(
                      transform: Matrix4.translationValues(
                          0.0, -(_statusBarHeight + (_screenHeight / 70)), 0.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No internet connection!"),
                            SizedBox(
                              height: 10.0,
                            ),
                            SpinKitWave(
                              color: Colors.white,
                              size: 20.0,
                              controller: AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 1200)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Column(
              children: [
                NavBar(
                  title: "Grades",
                  back: true,
                  user: false,
                  refresh: false,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ScrollConfiguration(
                      behavior: CustomBehavior(),
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: (_screenWidth / 10) / 2),
                        children: [
                          if (_codeList != null)
                            for (int i = 0; i < _codeList.length; i++)
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(
                                    () {
                                      _selected = i;
                                    },
                                  );
                                },
                                onTapUp: (_) {
                                  setState(
                                    () {
                                      _selected = -1;
                                    },
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GradesInfo(
                                        subjectCode: _codeList[i].toString(),
                                        subjectName:
                                            _subjects[_codeList[i]].toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Neumorphic(
                                  duration: Duration(milliseconds: 80),
                                  margin: EdgeInsets.symmetric(
                                      vertical: _screenHeight / 50),
                                  style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(25.0),
                                    ),
                                    depth: (i == _selected) ? 0.0 : 4.0,
                                  ),
                                  child: Container(
                                    width: _screenWidth - _screenWidth / 8,
                                    height: _screenHeight / 11,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: (_screenWidth / 15.0)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                _subjects[_codeList[i]]
                                                    .toString(),
                                                style: _gradeBoldTextStyle),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: (_screenWidth / 15.0)),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
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
