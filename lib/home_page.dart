import 'package:flutter/services.dart';
import 'package:fri_app/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:fri_app/buttons/huge_button.dart';
import 'package:fri_app/nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body:
      Column(
        children: [
          NavBar(title: "", back: false, user: true),
          Container(
            width: _screenWidth,
            height: (_screenHeight - _screenWidth) / 2 - 50,
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    child: Column(
                      children: [
                        Text(
                          'Gašper',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 30,
                            color: const Color(0xffffffff),
                            letterSpacing: 1.7999999999999998,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '63190226',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 20,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
          child: Container(
            width: _screenWidth,
            height: _screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: _screenWidth/2,
                      height: _screenWidth/2,
                      child: HugeButton(icon: Icons.calendar_today_rounded)
                    ),
                    Container(
                      width: _screenWidth/2,
                      height: _screenWidth/2,
                      child: HugeButton(icon: Icons.directions_bus_rounded)
                    ),
                  ]
                ),
                Column(
                  children: [
                    Container(
                      width: _screenWidth/2,
                      height: _screenWidth/2,
                      child: HugeButton(icon: Icons.fastfood_rounded)
                    ),
                    Container(
                      width: _screenWidth/2,
                      height: _screenWidth/2,
                      child: HugeButton(icon: Icons.sticky_note_2_rounded)
                    ),
                  ]
                ),
              ],
            ),
          ),
        ), ]
      ),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HOME"),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),*/
    );
  }
}