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

    _selected = (DateTime.now().weekday - 1).toDouble() > 4.0 ? 0.0 : (DateTime.now().weekday - 1).toDouble();
  }

  List<bool> barray = new List<bool>.filled(25, false);

  void _onPointerDown(int index, PointerDownEvent event) {
    setState(() {
      barray[index] = true;
    });
  }

  void _onPointerUp(int index, PointerUpEvent event) {
    setState(() {
      barray[index] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final double _sliderOffset = (_screenWidth - 40.0 - 17.5) / 5;
    final double _hourHeight = (_screenHeight - 170.0 - 80.0) / 16;

    int index = 0;
    for (int i = 0; i < _timetable.length; i++) {
      for(int j = 0; j < _timetable[i].length; j++) {
        if(index < _colors.length) {
          if(!_colorMap.containsKey(_timetable[i][j]['code'])) {
            _colorMap[_timetable[i][j]['code']] = _colors[index];
            index++;
          }
        }
        else {
          _colorMap[_timetable[i][j]['code']] = const Color(0xffee235a);
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body:
      Column(
        children: [
          NavBar(title: "Urnik", back: true, user: true),
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              Neumorphic(
                child: Container(
                  width: _screenWidth - 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff2c2f34),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  width: (_screenWidth - 40) / 5 + 17.5,
                  height: 45.0,
                  transform: Matrix4.translationValues(_sliderOffset * _selected, 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
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
                ),
              ),
              Container(
                width: _screenWidth - 40.0,
                height: 40.0,
                padding: EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pon"),
                    Text("Tor"),
                    Text("Sre"),
                    Text("Čet"),
                    Text("Pet")
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _screenWidth - 78,
                height: 40.0,
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
                    trackHeight: 45.0,
                    thumbColor: Colors.transparent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                    overlayColor: Colors.transparent,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0)
                  ),
                ),
              )
            ]
          ),

          Neumorphic(
            margin: EdgeInsets.symmetric(vertical: 40),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
              depth: 7.0,
            ),
            child: Container(
              height: _screenHeight - 170.0 - 80.0,
              width: _screenWidth - 40.0,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 7; i <= 21; i++)
                        Row(
                          children: [
                            Container(
                              width: (_screenWidth - 40.0 - 30.0) * 0.1,
                              child: Text(
                                i.toString() + ":00",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ),
                            Container(
                              width: (_screenWidth - 40.0 - 30.0) * 0.75,
                              height: 0.5,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                    ]
                  ),
                  Container(
                    width: (_screenWidth - 40.0 - 30.0) * 0.75,
                    height: _screenHeight - 170.0 - 80.0 - (_hourHeight * 2) + 1.0,
                    margin: EdgeInsets.only(top: (_screenHeight - 170.0 - 80.0) / 16 / 2 - 0.5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                      for(int i = 0; i < _timetable[_selected].length; i++)
                        Positioned(
                          top: (int.parse(_timetable[_selected][i]['start'].split(":")[0]) - 7) * _hourHeight + 1.0,
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
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20.0)),
                                depth: (barray[i]) ? 4.0 : -3.0,
                              ),
                              child: Container(
                                width: (_screenWidth - 40.0 - 30.0) * 0.60,
                                height: _hourHeight * (int.parse(_timetable[_selected][i]['end'].split(":")[0]) - int.parse(_timetable[_selected][i]['start'].split(":")[0])) - 1.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xff2c2f34),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: 0.12,
                                      heightFactor: 1.0,
                                      child: Container(
                                        color: _colorMap[_timetable[_selected][i]['code']],
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 0.88,
                                      heightFactor: 1.0,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                AnimatedOpacity(
                                                  opacity: (barray[i]) ? 0.0 : 1.0,
                                                  duration: Duration(milliseconds: 280),
                                                  curve: Curves.easeInExpo,
                                                  child: Text(
                                                    _timetable[_selected][i]['subject'],
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily: 'SF Pro Display',
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                ),
                                                AnimatedOpacity(
                                                  opacity: (barray[i]) ? 1.0 : 0.0,
                                                  duration: Duration(milliseconds: 280),
                                                  curve: Curves.easeInExpo,
                                                  child: Text(
                                                    (barray[i]) ? _timetable[_selected][i]['full_name'] : "",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily: 'SF Pro Display',
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ),
                                            Text(
                                              (barray[i]) ? "" : "\n" + _timetable[_selected][i]['teacher'] + "\n" + _timetable[_selected][0]['classroom'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ]
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
                  )
                ]
              ),
            )
          ),
        ]
      ),

    );
  }

  Future<List<dynamic>> getTimetable(String _studentsNumber, int _day) async {
    var result = new List<dynamic>();
    String day = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'][_day];
    await db.collection('timetable').doc(_studentsNumber).collection(day).get()
      .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((element) {
          result.add(element.data());
        })
    });
    return result;
  }

  Future<String> getStudentsNumber() async {
    String result = "";
    await db.collection('users').doc(auth.currentUser.uid).get()
        .then((DocumentSnapshot documentSnapshot) => {
          if(documentSnapshot.exists)
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