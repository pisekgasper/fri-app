import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:fri_app/buttons/accent_button.dart';
import 'package:provider/provider.dart';
import 'package:fri_app/sign_up.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _errorMessage = "";
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  bool _emailFocused = false;
  bool _passwordFocused = false;

  bool _emailEmpty = false;
  bool _passwordEmpty = false;

  bool _passwordVisibilityToggle = true;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocus);
    _passwordFocus.addListener(_onFocus);
  }

  void _onFocus() {
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
              vertical: _formFieldPaddingHorizontal / 1.5,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: _formFieldPaddingHorizontal / 2,
                    ),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Log",
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: _headingFontSize,
                              color: Colors.white.withOpacity(1.0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: " in",
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: _headingFontSize,
                              color: Colors.white.withOpacity(1.0),
                              fontWeight: FontWeight.w300,
                            ),
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
                              fontWeight: FontWeight.w400,
                            ),
                            controller: _emailController,
                            autocorrect: false,
                            cursorColor: const Color(0xffee235a),
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: _formFieldPaddingHorizontal,
                                vertical: _formFieldPaddingVertical,
                              ),
                              suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: _formFieldPaddingHorizontal,
                                  ),
                                  child: Icon(Icons.mail_rounded)),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _formFontSize,
                                color: _emailEmpty
                                    ? const Color(0xffee235a)
                                    : Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w300,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _errorFontSize,
                                color: const Color(0xffee235a),
                                fontWeight: FontWeight.w300,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
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
                      SizedBox(
                        height: _formFieldSpacer,
                      ),
                      Neumorphic(
                        duration: Duration(milliseconds: 300),
                        style: NeumorphicStyle(
                          depth: _passwordFocused ? -7.0 : 4.0,
                        ),
                        child: Container(
                          width: _formFieldWidth,
                          child: TextFormField(
                            focusNode: _passwordFocus,
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            autofocus: false,
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: _formFontSize,
                              color: Colors.white.withOpacity(1.0),
                              fontWeight: FontWeight.w400,
                            ),
                            controller: _passwordController,
                            autocorrect: false,
                            obscureText: _passwordVisibilityToggle,
                            enableSuggestions: false,
                            cursorColor: const Color(0xffee235a),
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: _formFieldPaddingHorizontal,
                                vertical: _formFieldPaddingVertical,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                  right: _formFieldPaddingHorizontal,
                                ),
                                child: InkWell(
                                  onTap: () => setState(() =>
                                      _passwordVisibilityToggle =
                                          !_passwordVisibilityToggle),
                                  child: _passwordVisibilityToggle
                                      ? Icon(Icons.visibility_off_rounded)
                                      : Icon(Icons.visibility_rounded),
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _formFontSize,
                                color: _passwordEmpty
                                    ? const Color(0xffee235a)
                                    : Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w300,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: _errorFontSize,
                                color: const Color(0xffee235a),
                                fontWeight: FontWeight.w300,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty)
                                setState(() {
                                  _passwordEmpty = true;
                                });
                              return null;
                            },
                          ),
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
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
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
                            await context.read<AuthenticationService>().signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
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
                      text: "Log In",
                      loading: _loading,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                    },
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      width: _formFieldWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: _formFieldPaddingHorizontal / 2),
                      child: Text(
                        "Don't have an account? Sign up!",
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: _formFontSize,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                        ),
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
