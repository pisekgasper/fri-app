import 'package:fri_app/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _errorMessage = "Sign up - Error";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _studentsNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300.00,
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
                TextFormField(
                  controller: _studentsNumberController,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText:
                  'Vpisna številka'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter vpisna številka.';
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
                      var _error = await context.read<AuthenticationService>().signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        studentsNumber: _studentsNumberController.text.trim()
                      );
                      Navigator.pop(context);
                      setState(() => _errorMessage = _error);
                    }
                  },
                  child: Text("Sign up"),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Nazad"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}