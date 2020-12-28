import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/nav_bar.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getUserData().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(
        children: [
          NavBar(title: "", back: true, user: false),
          Container(
            width: _screenWidth,
            height: _screenHeight - 130,
            child: Column(
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: 7.0,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 50.0),
                  child: Container(
                    width: _screenWidth - 40.0,
                    height: (_screenWidth - 40.0) / 1.7,
                    padding: EdgeInsets.all(30.0),
                    color: Colors.black,
                    child: Text(
                      auth.currentUser.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 14,
                          color: Colors.white.withOpacity(1.0),
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> res = new Map<String, String>();
    db.collection('users').doc(auth.currentUser.uid).get()
      .then((DocumentSnapshot documentSnapshot) {
        if(documentSnapshot.exists)
          res = documentSnapshot.data();
    });
    return res;
  }
}