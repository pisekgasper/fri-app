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

  String _name;
  String _studentsNumber;

  @override
  void initState() {
    super.initState();

    getUserData().then((val) => setState(() {
          _name = val['name'];
          _studentsNumber = val['studentsNumber'].toString();
        }));
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final double _fullNameFontSize = _screenHeight / 25;
    final double _studentsNumberFontSize = _screenHeight / 40;

    final TextStyle _fullNameTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _fullNameFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    final TextStyle _studentsNumberTextStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontSize: _studentsNumberFontSize,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

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

  Future<Map<String, dynamic>> getStudentsData() async {
    Map<String, dynamic> result = new Map<String, dynamic>();
    await db.collection('users').doc(auth.currentUser.uid).get().then(
        (DocumentSnapshot documentSnapshot) =>
            {if (documentSnapshot.exists) result = documentSnapshot.data()});
    return result;
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> res = new Map<String, String>();
    await db
        .collection('users')
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) res = documentSnapshot.data();
    });
    return res;
  }
}
