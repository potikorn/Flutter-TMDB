import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/dao/auth_response.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Text(
                'TMDB',
                style: Theme.of(context).textTheme.headline,
              ),
              SizedBox(height: 32.0),
              AccentColorOverride(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              AccentColorOverride(
                color: Colors.white,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              RaisedButton(
                onPressed: () {
                  var isValidate = _formKey.currentState.validate();
                  if (isValidate) {
                    requestLogin().then((onValue) {
                      print(onValue.toJson());
                      prefs.then((onValue) {
                        onValue.setBool('is_login', true);
                      });
                      Navigator.pop(context, true);
                    }).catchError((onError) {
                      debugPrint(onError.toString());
                    });
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 12.0),
              Center(
                child: Text('Don\'t have one? create now!',
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AuthResponse> requestLogin() async {
    var response = await http.post(
      "https://hapia.herokuapp.com/users/login",
      body: {
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim(),
      },
    );
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  bool validateForm() {
    if (_usernameController.text.isEmpty) {
      return false;
    }
    if (_passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        primaryColor: color,
        hintColor: color,
        accentColor: color,
        cursorColor: color,
      ),
    );
  }
}
