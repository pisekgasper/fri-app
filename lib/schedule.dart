import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => new _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  double _selected;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String _studentsNumber;
  Map<int, List<dynamic>> _timetable = {
    0: new List<dynamic>(),
    1: new List<dynamic>(),
    2: new List<dynamic>(),
    3: new List<dynamic>(),
    4: new List<dynamic>()
  };

  Map<String, Color> _colorMap = new Map<String, Color>();
  List<Color> _colors = [
    Color(0xff00ccff).withOpacity(0.5),
    Color(0xffff006d).withOpacity(0.4),
    Color(0xffffee00).withOpacity(0.5),
    Color(0xff00ffcc).withOpacity(0.5),
    Color(0xffff00cc).withOpacity(0.5),
    Color(0xffffff00).withOpacity(0.5),
    Color(0xffcc00ff).withOpacity(0.5),
    Color(0xff8cff00).withOpacity(0.5),
    Color(0xffff8100).withOpacity(0.5),
  ];

  @override
  void initState() {
    super.initState();

    getStudentsNumber().then((value) {
      setState(() => _studentsNumber = value);

      getTimetable(_studentsNumber, 0).then((value) => setState(() {
            _timetable[0].addAll(value);
          }));
      getTimetable(_studentsNumber, 1).then((value) => setState(() {
            _timetable[1].addAll(value);
          }));
      getTimetable(_studentsNumber, 2).then((value) => setState(() {
            _timetable[2].addAll(value);
          }));
      getTimetable(_studentsNumber, 3).then((value) => setState(() {
            _timetable[3].addAll(value);
          }));
      getTimetable(_studentsNumber, 4).then((value) {
        setState(() => _timetable[4].addAll(value));
      });
    });

    _selected = (DateTime.now().weekday - 1).toDouble() > 4.0
        ? 0.0
        : (DateTime.now().weekday - 1).toDouble();
  }

  List<bool> barray = new List<bool>.filled(25, false);

  GlobalKey _fractionallySizedBox = GlobalKey();

  double getSize() {
    final RenderBox renderBoxRed =
        _fractionallySizedBox.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    return size.height;
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final double _verticalPadding = (_screenWidth / 8) / 2;
    final double _horizontalPadding = (_screenWidth / 10) / 2;

    final double _subjectWidth =
        (_screenWidth - (_horizontalPadding * 2) - (_horizontalPadding * 3));

    final double _dayFontSize = _screenHeight / 60;
    final double _subjectFontSmall = _screenHeight / 75;
    final double _subjectFontBig = _screenHeight / 60;

    final TextStyle _dayTextStyle = TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: _dayFontSize,
        color: Colors.white,
        fontWeight: FontWeight.w400);

    final TextStyle _hoursTextStyle = TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: _subjectFontSmall,
        color: Colors.white.withOpacity(0.5),
        fontWeight: FontWeight.w300);

    final TextStyle _subjectTextStyleSmall = TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: _subjectFontSmall,
        color: Colors.white,
        fontWeight: FontWeight.w300);

    final TextStyle _subjectTextStyleBig = TextStyle(
        fontFamily: 'SF Pro Display',
        fontSize: _subjectFontBig,
        color: Colors.white,
        fontWeight: FontWeight.w700);

    final double _daysRowWidth = _screenWidth - (_horizontalPadding * 2);
    final double _daysRowWithPadding = _daysRowWidth - (2 * _horizontalPadding);
    final double _dayContainerWidth =
        (_screenWidth - (4 * _horizontalPadding)) / 5;
    final double _sliderOffset = _dayContainerWidth;

    int index = 0;
    for (int i = 0; i < _timetable.length; i++) {
      for (int j = 0; j < _timetable[i].length; j++) {
        if (index < _colors.length) {
          if (!_colorMap.containsKey(_timetable[i][j]['code'])) {
            _colorMap[_timetable[i][j]['code']] = _colors[index];
            index++;
          }
        } else {
          _colorMap[_timetable[i][j]['code']] = const Color(0xffee235a);
          index++;
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(children: [
        NavBar(title: "Schedule", back: true, user: true, refresh: false),
        Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              Neumorphic(
                child: Container(
                  width: _screenWidth - (_horizontalPadding * 2),
                  height: _screenHeight / 20,
                  decoration: BoxDecoration(
                    color: const Color(0xff2c2f34),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              Positioned(
                left: _dayContainerWidth / 4,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  width: ((_screenWidth - (_horizontalPadding * 2)) / 5),
                  height: _screenHeight / 20 + (_screenHeight / 20 * 0.20),
                  transform: Matrix4.translationValues(
                      _sliderOffset * _selected, 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment(-0.52, -1.0),
                      end: Alignment(0.38, 1.0),
                      colors: [
                        const Color(0xffee235a),
                        const Color(0xff9f2042)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffee235a)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffee235a),
                        offset: Offset(0, 0),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: _screenWidth - (_horizontalPadding * 2),
                height: _screenHeight / 20.0,
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: _screenHeight / 20.0,
                      width: (_screenWidth - (4 * _horizontalPadding)) / 5,
                      child: Text("Mon",
                          textAlign: TextAlign.center, style: _dayTextStyle),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: _screenHeight / 20.0,
                      width: (_screenWidth - (4 * _horizontalPadding)) / 5,
                      child: Text("Tue",
                          textAlign: TextAlign.center, style: _dayTextStyle),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: _screenHeight / 20.0,
                      width: (_screenWidth - (4 * _horizontalPadding)) / 5,
                      child: Text("Wed",
                          textAlign: TextAlign.center, style: _dayTextStyle),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: _screenHeight / 20.0,
                      width: (_screenWidth - (4 * _horizontalPadding)) / 5,
                      child: Text("Thu",
                          textAlign: TextAlign.center, style: _dayTextStyle),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: _screenHeight / 20.0,
                      width: (_screenWidth - (4 * _horizontalPadding)) / 5,
                      child: Text("Fri",
                          textAlign: TextAlign.center, style: _dayTextStyle),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _daysRowWithPadding,
                height: _screenHeight / 20.0,
                child: SliderTheme(
                  child: Slider(
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    autofocus: false,
                    value: _selected,
                    min: 0,
                    max: 4,
                    divisions: 4,
                    label: null,
                    onChanged: (double value) {
                      setState(() {
                        _selected = value;
                      });
                    },
                  ),
                  data: SliderTheme.of(context).copyWith(
                      trackHeight: _screenHeight / 20.0,
                      thumbColor: Colors.transparent,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 0.0),
                      overlayColor: Colors.white,
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 0.0)),
                ),
              )
            ]),
        Expanded(
          child: Neumorphic(
              margin: EdgeInsets.symmetric(vertical: _verticalPadding),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                depth: 4.0,
              ),
              child: Container(
                width: _screenWidth - (_horizontalPadding * 2),
                padding: EdgeInsets.symmetric(
                    vertical: _verticalPadding,
                    horizontal: _horizontalPadding * 1.5),
                child: Stack(alignment: Alignment.topRight, children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 7; i <= 21; i++)
                          Row(
                            children: [
                              Container(
                                width: (_screenWidth -
                                        (_horizontalPadding * 2) -
                                        (_horizontalPadding * 3)) *
                                    0.1,
                                child: Text(i.toString() + ":00",
                                    textAlign: TextAlign.right,
                                    style: _hoursTextStyle),
                              ),
                              Container(
                                width: (_screenWidth -
                                        (_horizontalPadding * 2) -
                                        (_horizontalPadding * 3)) *
                                    0.85,
                                height: 1,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                      ]),
                  FractionallySizedBox(
                    key: _fractionallySizedBox,
                    heightFactor: 1.0,
                    child: Container(
                      color: Colors.transparent,
                      width: (_screenWidth -
                              (_horizontalPadding * 2) -
                              (_horizontalPadding * 3)) *
                          0.85,
                      margin: EdgeInsets.symmetric(
                          vertical: (_subjectFontSmall + 1.0) / 2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int i = 0; i < _timetable[_selected].length; i++)
                            Positioned(
                              top: (int.parse(_timetable[_selected][i]['start']
                                          .split(":")[0]) -
                                      7) *
                                  ((getSize() - (_subjectFontSmall + 1.0)) /
                                      14),
                              child: Listener(
                                onPointerDown: (PointerDownEvent event) {
                                  setState(() {
                                    barray[i] = true;
                                  });
                                },
                                onPointerUp: (PointerUpEvent event) {
                                  setState(() {
                                    barray[i] = false;
                                  });
                                },
                                child: Neumorphic(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.elasticIn,
                                  style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(20.0)),
                                    depth: (barray[i]) ? 2.0 : -3.0,
                                  ),
                                  child: Container(
                                    width: _subjectWidth * 0.70,
                                    height: ((getSize() -
                                                    (_subjectFontSmall + 1.0)) /
                                                14) *
                                            (int.parse(_timetable[_selected][i]
                                                        ['end']
                                                    .split(":")[0]) -
                                                int.parse(_timetable[_selected]
                                                        [i]['start']
                                                    .split(":")[0])) -
                                        1.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff2c2f34),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 88,
                                          child: Stack(
                                            children: [
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 380),
                                                curve: Curves.easeInExpo,
                                                opacity:
                                                    (barray[i]) ? 1.0 : 0.0,
                                                child: Container(
                                                  width: ((_screenWidth -
                                                              (_horizontalPadding *
                                                                  2) -
                                                              (_horizontalPadding *
                                                                  3)) *
                                                          0.70) -
                                                      (((_screenWidth -
                                                                  (_horizontalPadding *
                                                                      2) -
                                                                  (_horizontalPadding *
                                                                      3)) *
                                                              0.70) *
                                                          0.12),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        width: ((_screenWidth -
                                                                    (_horizontalPadding *
                                                                        2) -
                                                                    (_horizontalPadding *
                                                                        3)) *
                                                                0.70) -
                                                            (((_screenWidth -
                                                                        (_horizontalPadding *
                                                                            2) -
                                                                        (_horizontalPadding *
                                                                            3)) *
                                                                    0.70) *
                                                                0.24),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                  _timetable[_selected]
                                                                          [i][
                                                                      'full_name'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      _subjectTextStyleBig),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 380),
                                                curve: Curves.easeInExpo,
                                                opacity:
                                                    (barray[i]) ? 0.0 : 1.0,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: (((getSize() -
                                                                            (_subjectFontSmall +
                                                                                1.0)) /
                                                                        14) *
                                                                    (int.parse(_timetable[_selected][i]['end'].split(":")[
                                                                            0]) -
                                                                        int.parse(
                                                                            _timetable[_selected][i]['start'].split(":")[0])) -
                                                                1.0) /
                                                            2,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Container(
                                                            width: ((_screenWidth -
                                                                        (_horizontalPadding *
                                                                            2) -
                                                                        (_horizontalPadding *
                                                                            3)) *
                                                                    0.70) -
                                                                (((_screenWidth -
                                                                            (_horizontalPadding *
                                                                                2) -
                                                                            (_horizontalPadding *
                                                                                3)) *
                                                                        0.70) *
                                                                    0.24),
                                                            height: (((getSize() - (_subjectFontSmall + 1.0)) /
                                                                            14) *
                                                                        (int.parse(_timetable[_selected][i]['end'].split(":")[0]) -
                                                                            int.parse(_timetable[_selected][i]['start'].split(":")[0])) -
                                                                    1.0) *
                                                                0.375,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    _timetable[_selected]
                                                                            [i][
                                                                        'subject'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        _subjectTextStyleBig),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              _horizontalPadding),
                                                                  child: Text(
                                                                      _timetable[_selected]
                                                                              [
                                                                              i]
                                                                          [
                                                                          'classroom'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          _subjectTextStyleBig),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: (((getSize() -
                                                                            (_subjectFontSmall +
                                                                                1.0)) /
                                                                        14) *
                                                                    (int.parse(_timetable[_selected][i]['end'].split(":")[
                                                                            0]) -
                                                                        int.parse(
                                                                            _timetable[_selected][i]['start'].split(":")[0])) -
                                                                1.0) /
                                                            2,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Container(
                                                            width: ((_screenWidth -
                                                                        (_horizontalPadding *
                                                                            2) -
                                                                        (_horizontalPadding *
                                                                            3)) *
                                                                    0.70) -
                                                                (((_screenWidth -
                                                                            (_horizontalPadding *
                                                                                2) -
                                                                            (_horizontalPadding *
                                                                                3)) *
                                                                        0.70) *
                                                                    0.24),
                                                            height: (((getSize() - (_subjectFontSmall + 1.0)) /
                                                                            14) *
                                                                        (int.parse(_timetable[_selected][i]['end'].split(":")[0]) -
                                                                            int.parse(_timetable[_selected][i]['start'].split(":")[0])) -
                                                                    1.0) *
                                                                0.375,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    _timetable[_selected]
                                                                            [i][
                                                                        'teacher'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        _subjectTextStyleSmall),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 12,
                                          child: Container(
                                            child: Container(
                                              color: _colorMap[
                                                  _timetable[_selected][i]
                                                      ['code']],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ]),
              )),
        ),
      ]),
    );
  }

  Future<List<dynamic>> getTimetable(String _studentsNumber, int _day) async {
    var result = new List<dynamic>();
    String day = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'][_day];
    await db
        .collection('timetable')
        .doc(_studentsNumber)
        .collection(day)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                result.add(element.data());
              })
            });
    return result;
  }

  Future<String> getStudentsNumber() async {
    String result = "";
    await db
        .collection('users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              if (documentSnapshot.exists)
                result = documentSnapshot.data()['studentsNumber'].toString()
            });
    return result;
  }
}

class ButtonCurve extends Curve {
  @override
  double transformInternal(double t) {
    double c5 = (2 * pi) / 4.5;
    return t == 0
        ? 0
        : t == 1
            ? 1
            : t < 0.5
                ? -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
                : (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1;
  }
}
