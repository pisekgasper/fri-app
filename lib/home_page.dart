import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fri_app/buttons/huge_button.dart';
import 'package:fri_app/nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(children: [
        NavBar(title: "", back: false, user: true, refresh: false),
        Expanded(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.calendar_today_rounded)),
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.directions_bus_rounded)),
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.fastfood_rounded)),
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.sticky_note_2_rounded)),
                ]),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
