import 'package:fri_app/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fri_app/sign_up.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  String _errorMessage = "Error";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 250.00,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText:
                  'Password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter password.';
                    }
                    return null;
                  },
                ),
                Text(
                  _errorMessage,
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                        var _error = await context.read<AuthenticationService>().signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        );
                        setState(() => _errorMessage = _error);
                    }
                  },
                  child: Text("Sign in"),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage())
                    );
                  },
                  child: Text("Don't have an account? Sign up"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}