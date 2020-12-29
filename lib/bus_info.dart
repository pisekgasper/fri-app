import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'bus_info_model.dart';
import 'get_bus.dart';
import 'nav_bar.dart';

class BusPage extends StatefulWidget {
  @override
  _BusPageState createState() => new _BusPageState();
}

class _BusPageState extends State<BusPage> {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(
          // ...
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavBar(
              title: "Avtobus",
              back: true,
              user: false,
            ),
            Neumorphic(
              margin: EdgeInsets.symmetric(vertical: 40),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30.0)),
                depth: 7.0,
              ),
              child: Container(
                height: _screenHeight / 4,
                width: _screenWidth - _screenWidth / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'TO ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: 'CENTER')
                      ]),
                    ),
                    FutureBuilder<BusInfo>(
                      future: fetchBusTo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
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
                depth: 7.0,
              ),
              child: Container(
                height: _screenHeight / 4,
                width: _screenWidth - _screenWidth / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'FROM ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: 'CENTER')
                      ]),
                    ),
                    FutureBuilder<BusInfo>(
                      future: fetchBusFrom(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
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
