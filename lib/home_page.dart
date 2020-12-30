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

  String _fullName;
  String _studentsNumber;

  @override
  void initState() {
    super.initState();
    getStudentsData().then((value) => setState(() {
          _fullName = value['name'];
          _studentsNumber = value['studentsNumber'].toString();
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
        Container(
          height: _fullNameFontSize * 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: _fullNameFontSize * 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        (_fullName != null) ? _fullName : "",
                        style: _fullNameTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        (_studentsNumber != null) ? _studentsNumber : "",
                        style: _studentsNumberTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.calendar_today_rounded)),
                  Container(
                      width: _screenWidth / 2,
                      height: _screenWidth / 2,
                      child: HugeButton(icon: Icons.directions_bus_rounded)),
                ]),
                Column(children: [
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
}
