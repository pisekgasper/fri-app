import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'bus_info_model.dart';
import 'get_bus.dart';

class BusPage extends StatefulWidget {
  @override
  _BusPageState createState() => new _BusPageState();
}

class _BusPageState extends State<BusPage> with TickerProviderStateMixin {
  void refresh() {
    setState(() => {});
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

    final double _headingFontSize = _screenHeight / 30;
    final double _buttonPadding = (_screenWidth / 10) / 2;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(
          // ...
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
                    alignment: Alignment.center,
                    child: Text(
                      "Bus",
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: _headingFontSize,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                              child: Icon(Icons.refresh_rounded,
                                  color: Colors.white, size: _iconSize),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
            Neumorphic(
              margin: EdgeInsets.symmetric(vertical: 40),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                depth: 4.0,
              ),
              child: Container(
                height: _screenHeight / 4,
                width: _screenWidth - _screenWidth / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<BusInfo>(
                      future: fetchBusTo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _screenHeight / 110),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'TO ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: 'CENTER')
                                    ]),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: snapshot.data.busId + " ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: snapshot.data.busNameTo),
                                  ]),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var x in snapshot.data.arrivals)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Neumorphic(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          30.0)),
                                              depth: -7.0,
                                            ),
                                            child: Container(
                                                height: _screenHeight / 15,
                                                width: _screenWidth / 5,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: x + " min",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]),
                                                  ),
                                                )),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("No bus from center.");
                        }
                        return SpinKitWave(
                          color: Colors.white,
                          size: _screenHeight / 55,
                          controller: AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 1200)),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Neumorphic(
              margin: EdgeInsets.symmetric(vertical: 40),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                depth: 4.0,
              ),
              child: Container(
                height: _screenHeight / 4,
                width: _screenWidth - _screenWidth / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<BusInfo>(
                      future: fetchBusFrom(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: _screenHeight / 110),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'FROM ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: 'CENTER')
                                    ]),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: snapshot.data.busId + " ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: snapshot.data.busNameTo),
                                  ]),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var x in snapshot.data.arrivals)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Neumorphic(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            style: NeumorphicStyle(
                                              boxShape:
                                                  NeumorphicBoxShape.roundRect(
                                                      BorderRadius.circular(
                                                          30.0)),
                                              depth: -7.0,
                                            ),
                                            child: Container(
                                                height: _screenHeight / 15,
                                                width: _screenWidth / 5,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: x + " min",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ]),
                                                  ),
                                                )),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("No bus from center.");
                        }
                        return SpinKitWave(
                          color: Colors.white,
                          size: _screenHeight / 55,
                          controller: AnimationController(
                              vsync: this,
                              duration: const Duration(milliseconds: 1200)),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ]
          // ...
          ),
    );
  }
}
