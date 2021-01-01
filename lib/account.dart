import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fri_app/nav_bar.dart';

import 'authentication_service.dart';
import 'package:provider/provider.dart';
import 'buttons/accent_button.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String _errorMessage = "";
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailCurrentPasswordController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _studentsNumberController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _studentsNumberFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fullNameFormKey = GlobalKey<FormState>();

  FocusNode _emailFocus = new FocusNode();
  FocusNode _emailCurrentPasswordFocus = new FocusNode();
  FocusNode _currentPasswordFocus = new FocusNode();
  FocusNode _newPasswordFocus = new FocusNode();
  FocusNode _studentsNumberFocus = new FocusNode();
  FocusNode _fullNameFocus = new FocusNode();

  bool _emailFocused = false;
  bool _emailCurrentPasswordFocused = false;
  bool _currentPasswordFocused = false;
  bool _newPasswordFocused = false;
  bool _studentsNumberFocused = false;
  bool _fullNameFocused = false;

  bool _emailEmpty = false;
  bool _emailCurrentPasswordEmpty = false;
  bool _currentPasswordEmpty = false;
  bool _newPasswordEmpty = false;
  bool _studentsNumberEmpty = false;
  bool _fullNameEmpty = false;

  String _name;
  String _studentsNumber;

  bool _logoutPressed = false;
  int _selected = 0;

  bool _passwordVisibilityToggle1 = true;
  bool _passwordVisibilityToggle2 = true;
  bool _passwordVisibilityToggle3 = true;

  bool _userIsABrokeMf = false;

  @override
  void initState() {
    super.initState();
    getUserData().then((val) => setState(() {
          _name = val['name'];
          _studentsNumber = val['studentsNumber'].toString();
        }));
    _emailFocus.addListener(_onFocus);
    _emailCurrentPasswordFocus.addListener(_onFocus);
    _currentPasswordFocus.addListener(_onFocus);
    _newPasswordFocus.addListener(_onFocus);
    _studentsNumberFocus.addListener(_onFocus);
    _fullNameFocus.addListener(_onFocus);
  }

  void _onFocus() {
    if (_emailFocus.hasFocus) {
      setState(() => _emailFocused = true);
    } else {
      setState(() => _emailFocused = false);
    }
    if (_emailCurrentPasswordFocus.hasFocus) {
      setState(() => _emailCurrentPasswordFocused = true);
    } else {
      setState(() => _emailCurrentPasswordFocused = false);
    }
    if (_currentPasswordFocus.hasFocus) {
      setState(() => _currentPasswordFocused = true);
    } else {
      setState(() => _currentPasswordFocused = false);
    }
    if (_newPasswordFocus.hasFocus) {
      setState(() => _newPasswordFocused = true);
    } else {
      setState(() => _newPasswordFocused = false);
    }
    if (_studentsNumberFocus.hasFocus) {
      setState(() => _studentsNumberFocused = true);
    } else {
      setState(() => _studentsNumberFocused = false);
    }
    if (_fullNameFocus.hasFocus) {
      setState(() => _fullNameFocused = true);
    } else {
      setState(() => _fullNameFocused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    if (_screenHeight / _screenWidth < 1.7) _userIsABrokeMf = true;

    final double _fullNameFontSize = _screenHeight / 40;
    final double _studentsNumberFontSize = _screenHeight / 55;

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

    final double _formFontSize = _screenHeight / 55;
    final double _errorFontSize = _screenHeight / 70;

    final double _buttonSize = _screenWidth / 9;

    final double _formFieldWidth =
        _screenWidth - (_screenWidth / 10) - (_screenWidth / 7);
    final double _formFieldSpacer = _screenHeight / 50;

    final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;
    final double _formFieldPaddingVertical = (_screenWidth / 7) / 4;

    bool _keyboardOpen = (MediaQuery.of(context).viewInsets.bottom != 0);

    return Scaffold(
      backgroundColor: const Color(0xff2c2f34),
      body: Column(children: [
        Visibility(
            visible: !(_keyboardOpen && _userIsABrokeMf),
            child: NavBar(
                title: "Account", back: true, user: false, refresh: false)),
        Expanded(
          child: Center(
            child: Container(
              child: Column(children: [
                Visibility(
                  visible: !_keyboardOpen,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 7.0,
                    ),
                    margin: EdgeInsets.only(top: _verticalPadding),
                    child: Container(
                      width: _screenWidth - (_screenWidth / 10),
                      height: (_screenWidth - (_screenWidth / 10)) / 2.3,
                      padding: EdgeInsets.only(
                          left: _formFieldPaddingHorizontal * 1.5,
                          right: _formFieldPaddingHorizontal,
                          top: _formFieldPaddingHorizontal,
                          bottom: _formFieldPaddingHorizontal),
                      child: Column(children: [
                        Expanded(
                          flex: 1,
                          child: Row(children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((_name != null) ? _name : "",
                                      textAlign: TextAlign.left,
                                      style: _fullNameTextStyle),
                                  SizedBox(
                                    height: _formFontSize / 2,
                                  ),
                                  Text(
                                      (auth.currentUser != null)
                                          ? auth.currentUser.email
                                          : "",
                                      textAlign: TextAlign.left,
                                      style: _studentsNumberTextStyle),
                                  SizedBox(
                                    height: _formFontSize / 2,
                                  ),
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
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Listener(
                                  onPointerUp: (PointerUpEvent event) {
                                    setState(() {
                                      _logoutPressed = false;
                                    });
                                    context
                                        .read<AuthenticationService>()
                                        .signOut();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  onPointerDown: (PointerDownEvent event) {
                                    setState(() {
                                      _logoutPressed = true;
                                    });
                                  },
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0)),
                                      depth: _logoutPressed ? 0.0 : 4.0,
                                    ),
                                    child: AnimatedContainer(
                                      height: _buttonSize * 1.2,
                                      width: _buttonSize * 1.2,
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 80),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.94, 0.92),
                                          end: Alignment(-0.88, -0.89),
                                          colors: (_logoutPressed)
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
                                      child: Icon(
                                        Icons.logout,
                                        size: _formFontSize * 1.5,
                                        color: Colors.white.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 4.0,
                    ),
                    margin: EdgeInsets.only(
                        bottom: _verticalPadding, top: _verticalPadding),
                    child: Container(
                      width: _screenWidth - (_screenWidth / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: _verticalPadding * 2),
                            color: Colors.transparent,
                            width: _formFieldWidth,
                            height: _buttonSize * 1.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Listener(
                                  onPointerUp: (PointerUpEvent event) =>
                                      setState(() {
                                    _selected = 0;

                                    _currentPasswordController.clear();
                                    _currentPasswordFocused = false;
                                    _currentPasswordEmpty = false;

                                    _newPasswordController.clear();
                                    _newPasswordFocused = false;
                                    _newPasswordEmpty = false;

                                    _studentsNumberController.clear();
                                    _studentsNumberFocused = false;
                                    _studentsNumberEmpty = false;

                                    _fullNameController.clear();
                                    _fullNameFocused = false;
                                    _fullNameEmpty = false;

                                    _errorMessage = "";
                                  }),
                                  child: Neumorphic(
                                    duration: const Duration(milliseconds: 80),
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0)),
                                      depth: (_selected == 0) ? -4.0 : 4.0,
                                    ),
                                    child: AnimatedContainer(
                                      height: _buttonSize * 1.2,
                                      width: _buttonSize * 1.2,
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 80),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.94, 0.92),
                                          end: Alignment(-0.88, -0.89),
                                          colors: (_selected == 0)
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
                                      child: Icon(
                                        Icons.mail_rounded,
                                        size: _formFontSize * 1.2,
                                        color: Colors.white.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Listener(
                                  onPointerUp: (PointerUpEvent event) =>
                                      setState(() {
                                    _selected = 1;

                                    _emailController.clear();
                                    _emailFocused = false;
                                    _emailEmpty = false;

                                    _emailCurrentPasswordController.clear();
                                    _emailCurrentPasswordFocused = false;
                                    _emailCurrentPasswordEmpty = false;

                                    _studentsNumberController.clear();
                                    _studentsNumberFocused = false;
                                    _studentsNumberEmpty = false;

                                    _fullNameController.clear();
                                    _fullNameFocused = false;
                                    _fullNameEmpty = false;

                                    _errorMessage = "";
                                  }),
                                  child: Neumorphic(
                                    duration: const Duration(milliseconds: 80),
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0)),
                                      depth: (_selected == 1) ? -4.0 : 4.0,
                                    ),
                                    child: AnimatedContainer(
                                      height: _buttonSize * 1.2,
                                      width: _buttonSize * 1.2,
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 80),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.94, 0.92),
                                          end: Alignment(-0.88, -0.89),
                                          colors: (_selected == 1)
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
                                      child: Icon(
                                        Icons.lock_rounded,
                                        size: _formFontSize * 1.2,
                                        color: Colors.white.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Listener(
                                  onPointerUp: (PointerUpEvent event) =>
                                      setState(() {
                                    _selected = 2;

                                    _emailController.clear();
                                    _emailFocused = false;
                                    _emailEmpty = false;

                                    _emailCurrentPasswordController.clear();
                                    _emailCurrentPasswordFocused = false;
                                    _emailCurrentPasswordEmpty = false;

                                    _currentPasswordController.clear();
                                    _currentPasswordFocused = false;
                                    _currentPasswordEmpty = false;

                                    _newPasswordController.clear();
                                    _newPasswordFocused = false;
                                    _newPasswordEmpty = false;

                                    _fullNameController.clear();
                                    _fullNameFocused = false;
                                    _fullNameEmpty = false;

                                    _errorMessage = "";
                                  }),
                                  child: Neumorphic(
                                    duration: const Duration(milliseconds: 80),
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0)),
                                      depth: (_selected == 2) ? -4.0 : 4.0,
                                    ),
                                    child: AnimatedContainer(
                                      height: _buttonSize * 1.2,
                                      width: _buttonSize * 1.2,
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 80),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.94, 0.92),
                                          end: Alignment(-0.88, -0.89),
                                          colors: (_selected == 2)
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
                                      child: FaIcon(
                                        FontAwesomeIcons.hashtag,
                                        size: _formFontSize * 1.2,
                                        color: Colors.white.withOpacity(1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Listener(
                                  onPointerUp: (PointerUpEvent event) =>
                                      setState(() {
                                    _selected = 3;

                                    _emailController.clear();
                                    _emailFocused = false;
                                    _emailEmpty = false;

                                    _emailCurrentPasswordController.clear();
                                    _emailCurrentPasswordFocused = false;
                                    _emailCurrentPasswordEmpty = false;

                                    _currentPasswordController.clear();
                                    _currentPasswordFocused = false;
                                    _currentPasswordEmpty = false;

                                    _newPasswordController.clear();
                                    _newPasswordFocused = false;
                                    _newPasswordEmpty = false;

                                    _studentsNumberController.clear();
                                    _studentsNumberFocused = false;
                                    _studentsNumberEmpty = false;

                                    _errorMessage = "";
                                  }),
                                  child: Neumorphic(
                                    duration: const Duration(milliseconds: 80),
                                    style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30.0)),
                                      depth: (_selected == 3) ? -4.0 : 4.0,
                                    ),
                                    child: AnimatedContainer(
                                      height: _buttonSize * 1.2,
                                      width: _buttonSize * 1.2,
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 80),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(0.94, 0.92),
                                          end: Alignment(-0.88, -0.89),
                                          colors: (_selected == 3)
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
                                      child: Icon(
                                        Icons.person_pin_rounded,
                                        color: Colors.white.withOpacity(1.0),
                                        size: _formFontSize * 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: (_selected == 0),
                            child: Expanded(
                              child: Form(
                                key: _emailFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth: _emailCurrentPasswordFocused
                                                ? -7.0
                                                : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode:
                                                  _emailCurrentPasswordFocus,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller:
                                                  _emailCurrentPasswordController,
                                              autocorrect: false,
                                              obscureText:
                                                  _passwordVisibilityToggle3,
                                              enableSuggestions: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          _formFieldPaddingHorizontal),
                                                  child: InkWell(
                                                      onTap: () => setState(() =>
                                                          _passwordVisibilityToggle3 =
                                                              !_passwordVisibilityToggle3),
                                                      child: _passwordVisibilityToggle3
                                                          ? Icon(Icons
                                                              .visibility_off_rounded)
                                                          : Icon(Icons
                                                              .visibility_rounded)),
                                                ),
                                                hintText: "Current password",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color:
                                                        _emailCurrentPasswordEmpty
                                                            ? const Color(
                                                                0xffee235a)
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty)
                                                  setState(() {
                                                    _emailCurrentPasswordEmpty =
                                                        true;
                                                  });
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: _formFieldSpacer,
                                        ),
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth: _emailFocused ? -7.0 : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode: _emailFocus,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller: _emailController,
                                              autocorrect: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            _formFieldPaddingHorizontal),
                                                    child: Icon(
                                                        Icons.mail_rounded)),
                                                hintText: "New email",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color: _emailEmpty
                                                        ? const Color(
                                                            0xffee235a)
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
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
                                        Visibility(
                                          visible: (_errorMessage != ""),
                                          child: SizedBox(
                                            height: _formFieldSpacer,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (_errorMessage != ""),
                                      child: SizedBox(
                                        width: _formFieldWidth -
                                            _formFieldPaddingHorizontal,
                                        child: Text(
                                          _errorMessage,
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: _errorFontSize,
                                              color: const Color(0xffee235a),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_selected == 1),
                            child: Expanded(
                              child: Form(
                                key: _passwordFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth: _currentPasswordFocused
                                                ? -7.0
                                                : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode: _currentPasswordFocus,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller:
                                                  _currentPasswordController,
                                              autocorrect: false,
                                              obscureText:
                                                  _passwordVisibilityToggle1,
                                              enableSuggestions: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          _formFieldPaddingHorizontal),
                                                  child: InkWell(
                                                      onTap: () => setState(() =>
                                                          _passwordVisibilityToggle1 =
                                                              !_passwordVisibilityToggle1),
                                                      child: _passwordVisibilityToggle1
                                                          ? Icon(Icons
                                                              .visibility_off_rounded)
                                                          : Icon(Icons
                                                              .visibility_rounded)),
                                                ),
                                                hintText: "Current password",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color: _currentPasswordEmpty
                                                        ? const Color(
                                                            0xffee235a)
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty)
                                                  setState(() {
                                                    _currentPasswordEmpty =
                                                        true;
                                                  });
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: _formFieldSpacer,
                                        ),
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth: _newPasswordFocused
                                                ? -7.0
                                                : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode: _newPasswordFocus,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller:
                                                  _newPasswordController,
                                              autocorrect: false,
                                              obscureText:
                                                  _passwordVisibilityToggle2,
                                              enableSuggestions: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          _formFieldPaddingHorizontal),
                                                  child: InkWell(
                                                      onTap: () => setState(() =>
                                                          _passwordVisibilityToggle2 =
                                                              !_passwordVisibilityToggle2),
                                                      child: _passwordVisibilityToggle2
                                                          ? Icon(Icons
                                                              .visibility_off_rounded)
                                                          : Icon(Icons
                                                              .visibility_rounded)),
                                                ),
                                                hintText: "New password",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color: _newPasswordEmpty
                                                        ? const Color(
                                                            0xffee235a)
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty)
                                                  setState(() {
                                                    _newPasswordEmpty = true;
                                                  });
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (_errorMessage != ""),
                                          child: SizedBox(
                                            height: _formFieldSpacer,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (_errorMessage != ""),
                                      child: SizedBox(
                                        width: _formFieldWidth -
                                            _formFieldPaddingHorizontal,
                                        child: Text(
                                          _errorMessage,
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: _errorFontSize,
                                              color: const Color(0xffee235a),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_selected == 2),
                            child: Expanded(
                              child: Form(
                                key: _studentsNumberFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth: _studentsNumberFocused
                                                ? -7.0
                                                : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode: _studentsNumberFocus,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller:
                                                  _studentsNumberController,
                                              autocorrect: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            _formFieldPaddingHorizontal),
                                                    child: Container(
                                                        width: 30,
                                                        color:
                                                            Colors.transparent,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .hashtag))),
                                                hintText:
                                                    "New student's number",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color: _studentsNumberEmpty
                                                        ? const Color(
                                                            0xffee235a)
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty)
                                                  setState(() {
                                                    _studentsNumberEmpty = true;
                                                  });
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (_errorMessage != ""),
                                          child: SizedBox(
                                            height: _formFieldSpacer,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (_errorMessage != ""),
                                      child: SizedBox(
                                        width: _formFieldWidth -
                                            _formFieldPaddingHorizontal,
                                        child: Text(
                                          _errorMessage,
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: _errorFontSize,
                                              color: const Color(0xffee235a),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_selected == 3),
                            child: Expanded(
                              child: Form(
                                key: _fullNameFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Neumorphic(
                                          duration: Duration(milliseconds: 300),
                                          style: NeumorphicStyle(
                                            depth:
                                                _fullNameFocused ? -7.0 : 4.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            width: _formFieldWidth,
                                            child: TextFormField(
                                              focusNode: _fullNameFocus,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontFamily: 'SF Pro Text',
                                                  fontSize: _formFontSize,
                                                  color: Colors.white
                                                      .withOpacity(1.0),
                                                  fontWeight: FontWeight.w400),
                                              controller: _fullNameController,
                                              autocorrect: false,
                                              cursorColor:
                                                  const Color(0xffee235a),
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _formFieldPaddingHorizontal,
                                                    vertical:
                                                        _formFieldPaddingVertical),
                                                suffixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            _formFieldPaddingHorizontal),
                                                    child: Icon(Icons
                                                        .person_pin_rounded)),
                                                hintText: "New name",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _formFontSize,
                                                    color: _fullNameEmpty
                                                        ? const Color(
                                                            0xffee235a)
                                                        : Colors.white
                                                            .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                errorStyle: TextStyle(
                                                    fontFamily: 'SF Pro Text',
                                                    fontSize: _errorFontSize,
                                                    color:
                                                        const Color(0xffee235a),
                                                    fontWeight:
                                                        FontWeight.w300),
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty)
                                                  setState(() {
                                                    _fullNameEmpty = true;
                                                  });
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: (_errorMessage != ""),
                                          child: SizedBox(
                                            height: _formFieldSpacer,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (_errorMessage != ""),
                                      child: SizedBox(
                                        width: _formFieldWidth -
                                            _formFieldPaddingHorizontal,
                                        child: Text(
                                          _errorMessage,
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: _errorFontSize,
                                              color: const Color(0xffee235a),
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              switch (_selected) {
                                case 0:
                                  {
                                    if (_emailFormKey.currentState.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                      var _error = await context
                                          .read<AuthenticationService>()
                                          .changeEmail(
                                              currentPassword:
                                                  _emailCurrentPasswordController
                                                      .text
                                                      .trim(),
                                              newMail:
                                                  _emailController.text.trim());
                                      setState(() {
                                        _errorMessage = _error;
                                        _loading = false;
                                      });
                                    }
                                  }
                                  break;

                                case 1:
                                  {
                                    if (_passwordFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                      var _error = await context
                                          .read<AuthenticationService>()
                                          .changePassword(
                                              currentPassword:
                                                  _currentPasswordController
                                                      .text
                                                      .trim(),
                                              newPassword:
                                                  _newPasswordController.text
                                                      .trim());
                                      setState(() {
                                        _errorMessage = _error;
                                        _loading = false;
                                      });
                                    }
                                  }
                                  break;

                                case 2:
                                  {
                                    if (_studentsNumberFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                      var _error = await context
                                          .read<AuthenticationService>()
                                          .changeStudentsNumber(
                                              studentsNumber:
                                                  _studentsNumberController.text
                                                      .trim());
                                      setState(() {
                                        getUserData()
                                            .then((val) => setState(() {
                                                  _name = val['name'];
                                                  _studentsNumber =
                                                      val['studentsNumber']
                                                          .toString();
                                                }));
                                        _errorMessage = _error;
                                        _loading = false;
                                      });
                                    }
                                  }
                                  break;

                                case 3:
                                  {
                                    if (_fullNameFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      FocusScope.of(context).unfocus();
                                      var _error = await context
                                          .read<AuthenticationService>()
                                          .changeFullName(
                                              fullName: _fullNameController.text
                                                  .trim());
                                      setState(() {
                                        getUserData()
                                            .then((val) => setState(() {
                                                  _name = val['name'];
                                                  _studentsNumber =
                                                      val['studentsNumber']
                                                          .toString();
                                                }));
                                        _errorMessage = _error;
                                        _loading = false;
                                      });
                                    }
                                  }
                                  break;
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: _verticalPadding * 2),
                              child: AccentButton(
                                width: _formFieldWidth,
                                height: _screenHeight / 20,
                                text: "Save changes",
                                loading: _loading,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
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
