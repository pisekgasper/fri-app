import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavBar(
              title: 'Menu',
              back: true,
              user: true,
              refresh: false,
            ),
            StreamBuilder(
              // ignore: deprecated_member_use
              stream: Firestore.instance.collection("daily_menu").snapshots(),
              builder: (context, snapshot) {
                return (snapshot.data == null)
                    ? SizedBox()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var item in snapshot.data.documents)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Neumorphic(
                                    margin: EdgeInsets.symmetric(
                                        vertical: _screenHeight / 50),
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(30.0),
                                      ),
                                      depth: 7.0,
                                    ),
                                    child: Container(
                                      width: _screenWidth - _screenWidth / 8,
                                      height: _screenHeight / 10,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: _screenHeight / 13,
                                                width: _screenWidth / 2,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: item['name'],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Neumorphic(
                                                margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        _screenHeight / 100),
                                                style: NeumorphicStyle(
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                    BorderRadius.circular(30.0),
                                                  ),
                                                  depth: -7.0,
                                                ),
                                                child: Container(
                                                  width: _screenWidth / 5,
                                                  height: _screenHeight / 20,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(item['price']
                                                            .toString() +
                                                        "  €"),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
