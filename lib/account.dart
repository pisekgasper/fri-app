import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/buttons/round_button.dart';
import 'package:fri_app/nav_bar.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //String _errorMessage = "";
  //bool _loading = false;

  //final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //FocusNode _emailFocus = new FocusNode();
  //FocusNode _passwordFocus = new FocusNode();
  //bool _emailFocused = false;
  //bool _passwordFocused = false;

  //bool _emailEmpty = false;
  //bool _passwordEmpty = false;

  String _name;
  String _studentsNumber;

  @override
  void initState() {
    super.initState();
    getUserData().then((val) => setState(() {
          _name = val['name'];
          _studentsNumber = val['studentsNumber'].toString();
        }));
    //_emailFocus.addListener(_onFocus);
    //_passwordFocus.addListener(_onFocus);
  }

  /*void _onFocus() {
    if (_emailFocus.hasFocus) {
      setState(() => _emailFocused = true);
    } else {
      setState(() => _emailFocused = false);
    }
    if (_passwordFocus.hasFocus) {
      setState(() => _passwordFocused = true);
    } else {
      setState(() => _passwordFocused = false);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final double _fullNameFontSize = _screenHeight / 30;
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

    final double _verticalPadding = (_screenWidth / 8) / 2;

    //final double _formFontSize = _screenHeight / 55;
    //final double _headingFontSize = _screenHeight / 25;
    //final double _errorFontSize = _screenHeight / 70;

    //final double _formFieldWidth = _screenWidth - (_screenWidth / 10) - (_screenWidth / 7);
    //final double _formFieldSpacer = _screenHeight / 50;

    //final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;
    //final double _formFieldPaddingVertical = (_screenWidth / 7) / 4;

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(children: [
        NavBar(title: "Account", back: true, user: false),
        Expanded(
          child: Container(
            child: Column(children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 7.0,
                ),
                margin: EdgeInsets.symmetric(vertical: _verticalPadding),
                child: Container(
                  width: _screenWidth - (_screenWidth / 10),
                  height: (_screenWidth - 40.0) / 2,
                  padding: EdgeInsets.only(
                      left: 45.0, right: 30.0, top: 25.0, bottom: 25.0),
                  child: Column(children: [
                    Expanded(
                      flex: 1,
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((_name != null) ? _name : "",
                                  textAlign: TextAlign.left,
                                  style: _fullNameTextStyle),
                              Text(
                                  (_studentsNumber != null)
                                      ? _studentsNumber
                                      : "",
                                  textAlign: TextAlign.left,
                                  style: _studentsNumberTextStyle),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RoundButton(
                              icon: Icons.logout,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ]),
                ),
              ),
              /*Expanded(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 7.0,
                  ),
                  margin: EdgeInsets.only(bottom: _verticalPadding),
                  child: Container(
                    width: _screenWidth - (_screenWidth / 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Neumorphic(
                              duration: Duration(milliseconds: 300),
                              style: NeumorphicStyle(
                                depth: _emailFocused ? -7.0 : 4.0,
                              ),
                              child: Container(
                                width: _formFieldWidth,
                                child: TextFormField(
                                  focusNode: _emailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontSize: _formFontSize,
                                      color: Colors.white.withOpacity(1.0),
                                      fontWeight: FontWeight.w400),
                                  controller: _emailController,
                                  autocorrect: false,
                                  cursorColor: const Color(0xffee235a),
                                  autovalidateMode: AutovalidateMode.disabled,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: _formFieldPaddingHorizontal,
                                        vertical: _formFieldPaddingVertical),
                                    suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: _formFieldPaddingHorizontal),
                                        child: Icon(Icons.mail_rounded)),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _formFontSize,
                                        color: _emailEmpty
                                            ? const Color(0xffee235a)
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _errorFontSize,
                                        color: const Color(0xffee235a),
                                        fontWeight: FontWeight.w300),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      setState(() {
                                        _emailEmpty = true;
                                      });
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Neumorphic(
                              duration: Duration(milliseconds: 300),
                              style: NeumorphicStyle(
                                depth: _emailFocused ? -7.0 : 4.0,
                              ),
                              child: Container(
                                width: _formFieldWidth,
                                child: TextFormField(
                                  focusNode: _emailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontSize: _formFontSize,
                                      color: Colors.white.withOpacity(1.0),
                                      fontWeight: FontWeight.w400),
                                  controller: _emailController,
                                  autocorrect: false,
                                  cursorColor: const Color(0xffee235a),
                                  autovalidateMode: AutovalidateMode.disabled,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: _formFieldPaddingHorizontal,
                                        vertical: _formFieldPaddingVertical),
                                    suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: _formFieldPaddingHorizontal),
                                        child: Icon(Icons.mail_rounded)),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _formFontSize,
                                        color: _emailEmpty
                                            ? const Color(0xffee235a)
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _errorFontSize,
                                        color: const Color(0xffee235a),
                                        fontWeight: FontWeight.w300),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      setState(() {
                                        _emailEmpty = true;
                                      });
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Neumorphic(
                              duration: Duration(milliseconds: 300),
                              style: NeumorphicStyle(
                                depth: _emailFocused ? -7.0 : 4.0,
                              ),
                              child: Container(
                                width: _formFieldWidth,
                                child: TextFormField(
                                  focusNode: _emailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontSize: _formFontSize,
                                      color: Colors.white.withOpacity(1.0),
                                      fontWeight: FontWeight.w400),
                                  controller: _emailController,
                                  autocorrect: false,
                                  cursorColor: const Color(0xffee235a),
                                  autovalidateMode: AutovalidateMode.disabled,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: _formFieldPaddingHorizontal,
                                        vertical: _formFieldPaddingVertical),
                                    suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: _formFieldPaddingHorizontal),
                                        child: Icon(Icons.mail_rounded)),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _formFontSize,
                                        color: _emailEmpty
                                            ? const Color(0xffee235a)
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w300),
                                    errorStyle: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        fontSize: _errorFontSize,
                                        color: const Color(0xffee235a),
                                        fontWeight: FontWeight.w300),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      setState(() {
                                        _emailEmpty = true;
                                      });
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
            ]),
          ),
        ),
      ]),
    );
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
