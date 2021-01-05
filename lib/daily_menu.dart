import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fri_app/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'grades_info.dart';

class DailyMenuPage extends StatefulWidget {
  @override
  _DailyMenuPageState createState() => new _DailyMenuPageState();
}

class _DailyMenuPageState extends State<DailyMenuPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _statusBarHeight = MediaQuery.of(context).padding.top;

    final double _gradeSpacer = _screenHeight / 50;

    final double _verticalPadding = (_screenWidth / 8) / 2;

    final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;

    final double _gradeNameFontSize = _screenHeight / 50;
    final double _gradeFontSize = _screenHeight / 60;

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
      fontWeight: FontWeight.w300,
    );

    return Scaffold(
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
                  title: 'Menu',
                  back: true,
                  user: false,
                  refresh: false,
                ),
                StreamBuilder(
                  // ignore: deprecated_member_use
                  stream: FirebaseFirestore.instance
                      .collection("daily_menu")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.data == null)
                        ? SizedBox()
                        : Expanded(
                            child: Container(
                              width: _screenWidth - (_screenWidth / 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: _verticalPadding),
                              padding: EdgeInsets.symmetric(
                                  horizontal: _formFieldPaddingHorizontal),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              child: ScrollConfiguration(
                                behavior: CustomBehavior(),
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: [
                                    for (var item in snapshot.data.documents)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: _verticalPadding / 2,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 5.0,
                                                height:
                                                    _gradeNameFontSize * 2.5,
                                                margin: EdgeInsets.only(
                                                    right:
                                                        _formFieldPaddingHorizontal /
                                                            2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffee235a),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                // decoration: BoxDecoration(
                                                //   color: Colors.transparent,
                                                //   border: Border(
                                                //     left: BorderSide(
                                                //         color:
                                                //             const Color(0xffee235a),
                                                //         width: 2.0),
                                                //   ),
                                                // ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Text(
                                                  item['name'],
                                                  textAlign: TextAlign.left,
                                                  style: _gradeTextStyle,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    _formFieldPaddingHorizontal /
                                                        2,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  item['price'].toString() +
                                                      " €",
                                                  textAlign: TextAlign.right,
                                                  style: _gradeNameTextStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: _verticalPadding / 2,
                                          ),
                                          Divider(
                                            height: _gradeSpacer,
                                            color: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    // Neumorphic(
                                    //   padding: EdgeInsets.symmetric(
                                    //     horizontal:
                                    //         _formFieldPaddingHorizontal * 1.5,
                                    //     vertical:
                                    //         _formFieldPaddingHorizontal / 1.5,
                                    //   ),
                                    //   // margin: EdgeInsets.symmetric(
                                    //   //     vertical: _screenHeight / 50),
                                    //   style: NeumorphicStyle(
                                    //     boxShape: NeumorphicBoxShape.roundRect(
                                    //       BorderRadius.circular(30.0),
                                    //     ),
                                    //     depth: 2.0,
                                    //   ),
                                    //   child: Container(
                                    //     // width: _screenWidth - _screenWidth / 8,
                                    //     // height: _screenHeight / 10,
                                    //     // alignment: Alignment.center,
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceEvenly,
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         Column(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             SizedBox(
                                    //               height: _screenHeight / 13,
                                    //               width: _screenWidth / 2,
                                    //               child: Align(
                                    //                 alignment:
                                    //                     Alignment.centerLeft,
                                    //                 child: RichText(
                                    //                   text: TextSpan(
                                    //                     children: [
                                    //                       TextSpan(
                                    //                         text: item['name'],
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.center,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             Neumorphic(
                                    //               margin: EdgeInsets.symmetric(
                                    //                   vertical:
                                    //                       _screenHeight / 100),
                                    //               style: NeumorphicStyle(
                                    //                 boxShape: NeumorphicBoxShape
                                    //                     .roundRect(
                                    //                   BorderRadius.circular(
                                    //                       30.0),
                                    //                 ),
                                    //                 depth: -2.0,
                                    //               ),
                                    //               child: Container(
                                    //                 width: _screenWidth / 5,
                                    //                 height: _screenHeight / 20,
                                    //                 child: Align(
                                    //                   alignment:
                                    //                       Alignment.center,
                                    //                   child: Text(item['price']
                                    //                           .toString() +
                                    //                       "  €"),
                                    //                 ),
                                    //               ),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ],
            );
          }),
    );
  }
}
