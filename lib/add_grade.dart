import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fri_app/buttons/accent_button.dart';
import 'package:provider/provider.dart';

class AddGrade {
  final FirebaseAuth _firebaseAuth;

  AddGrade(this._firebaseAuth);

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<String> addGrade({
    String name,
    String grade,
    String percent,
    String subjectId,
  }) async {
    if (name.isEmpty || grade.isEmpty)
      return "Two fields are required!";
    else if (isNumeric(grade)) return "Grade must be a number!";

    try {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      await _db
          .collection('grades')
          .doc(this._firebaseAuth.currentUser.uid)
          .collection(subjectId)
          .add(
        {
          'name': name,
          "grade": grade,
          "percent": percent,
        },
      ).then((value) {});

      return "Added new grade.";
    } catch (e) {
      return e.message;
    }
  }
}

class AddGradePage extends StatefulWidget {
  final String subjectName;
  final String subjectCode;
  AddGradePage({Key key, this.subjectName, this.subjectCode}) : super(key: key);

  @override
  _AddGradePageState createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  String _errorMessage = "";
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _nameFocus = new FocusNode();
  FocusNode _gradeFocus = new FocusNode();
  FocusNode _percentFocus = new FocusNode();
  bool _nameFocused = false;
  bool _gradeFocused = false;
  bool _percentFocused = false;

  bool _nameEmpty = false;
  bool _gradeEmpty = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_onFocus);
    _gradeFocus.addListener(_onFocus);
    _percentFocus.addListener(_onFocus);
  }

  void _onFocus() {
    if (_nameFocus.hasFocus) {
      setState(() => _nameFocused = true);
    } else {
      setState(() => _nameFocused = false);
    }
    if (_gradeFocus.hasFocus) {
      setState(() => _gradeFocused = true);
    } else {
      setState(() => _gradeFocused = false);
    }
    if (_percentFocus.hasFocus) {
      setState(() => _percentFocused = true);
    } else {
      setState(() => _percentFocused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    final double _formFontSize = _screenHeight / 55;
    final double _headingFontSize = _screenHeight / 25;
    final double _errorFontSize = _screenHeight / 70;

    final double _formFieldWidth =
        _screenWidth - (_screenWidth / 10) - (_screenWidth / 7);
    final double _formFieldSpacer = _screenHeight / 50;

    final double _formFieldPaddingHorizontal = (_screenWidth / 7) / 2;
    final double _formFieldPaddingVertical = (_screenWidth / 7) / 4;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: 4.0,
          ),
          child: Container(
            height: _screenWidth - (_screenWidth / 10),
            width: _screenWidth - (_screenWidth / 10),
            padding: EdgeInsets.symmetric(
                vertical: _formFieldPaddingHorizontal / 1.5),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: _formFieldPaddingHorizontal / 2),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Add",
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: _headingFontSize,
                                color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: " grade",
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: _headingFontSize,
                                color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Neumorphic(
                        duration: Duration(milliseconds: 300),
                        style: NeumorphicStyle(
                          depth: _nameFocused ? -7.0 : 4.0,
                        ),
                        child: Container(
                          width: _formFieldWidth,
                          child: TextFormField(
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            autofocus: false,
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _formFontSize,
                                color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w400),
                            controller: _nameController,
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
                                child: Container(
                                  width: 30,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerRight,
                                  child: FaIcon(FontAwesomeIcons.font),
                                ),
                              ),
                              hintText: "e.g. Exam, Homework,...",
                              hintStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: _formFontSize,
                                  color: _nameEmpty
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
                                setState(
                                  () {
                                    _nameEmpty = true;
                                  },
                                );
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
                          depth: _gradeFocused ? -7.0 : 4.0,
                        ),
                        child: Container(
                          width: _formFieldWidth,
                          child: TextFormField(
                            focusNode: _gradeFocus,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            autofocus: false,
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _formFontSize,
                                color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w400),
                            controller: _gradeController,
                            autocorrect: false,
                            enableSuggestions: false,
                            cursorColor: const Color(0xffee235a),
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: _formFieldPaddingHorizontal,
                                  vertical: _formFieldPaddingVertical),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: _formFieldPaddingHorizontal),
                                child: Container(
                                  width: 30,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerRight,
                                  child: FaIcon(FontAwesomeIcons.hashtag),
                                ),
                              ),
                              hintText: "Grade from 1-10",
                              hintStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: _formFontSize,
                                  color: _gradeEmpty
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
                                setState(
                                  () {
                                    _gradeEmpty = true;
                                  },
                                );
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
                          depth: _percentFocused ? -7.0 : 4.0,
                        ),
                        child: Container(
                          width: _formFieldWidth,
                          child: TextFormField(
                            focusNode: _percentFocus,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            autofocus: false,
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _formFontSize,
                                color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w400),
                            controller: _percentController,
                            autocorrect: false,
                            enableSuggestions: false,
                            cursorColor: const Color(0xffee235a),
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: _formFieldPaddingHorizontal,
                                  vertical: _formFieldPaddingVertical),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: _formFieldPaddingHorizontal),
                                child: Container(
                                  width: 30,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerRight,
                                  child: FaIcon(FontAwesomeIcons.percentage),
                                ),
                              ),
                              hintText: "Grade % from 0-100",
                              hintStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: _formFontSize,
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w300),
                              errorStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: _errorFontSize,
                                  color: const Color(0xffee235a),
                                  fontWeight: FontWeight.w300),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            FocusScope.of(context).unfocus();
                            var _error =
                                await context.read<AddGrade>().addGrade(
                                      name: _nameController.text.trim(),
                                      grade: _gradeController.text.trim(),
                                      percent: _percentController.text.trim(),
                                      subjectId: widget.subjectCode,
                                    );
                            if (this.mounted) {
                              setState(() {
                                _errorMessage = _error;
                                _loading = false;
                              });
                            }
                          }
                        },
                        child: AccentButton(
                          width: _formFieldWidth,
                          height: _screenHeight / 20,
                          text: "Add",
                          loading: _loading,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: (_errorMessage != ""),
                    child: SizedBox(
                      width: _formFieldWidth - _formFieldPaddingHorizontal,
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
      ),
    );
  }
}
