import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/auth/signup_screen.dart';
import 'package:flutter_movie_db/dao/auth_response.dart';
import 'package:flutter_movie_db/model/UserProfileModel.dart';
import 'package:flutter_movie_db/utils/override_color.dart';
import 'package:flutter_movie_db/widget/modal_loader.dart';
import 'package:flutter_movie_db/dao/base_response.dart';

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

  final _snackbar = SnackBar(content: Text('Something went wrong'));

  BuildContext _scaffoldContext;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        _scaffoldContext = context;
        return SafeArea(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(24.0),
                  children: <Widget>[
                    SizedBox(height: 80.0),
                    Text(
                      'TMDB',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: 32.0),
                    AccentColorOverride(
                      color: Colors.white,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return '';
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
                          return '';
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
                      onPressed: _loginAction,
                      child: Text('Login'),
                    ),
                    SizedBox(height: 12.0),
                    Center(
                      child: GestureDetector(
                        child: Text(
                          'Don\'t have one? create now!',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: _navigateToSignupScreen,
                      ),
                    ),
                  ],
                ),
              ),
              (_isLoading) ? ModalLoader() : Container(),
            ],
          ),
        );
      }),
    );
  }

  Future<BaseResponse<AuthResponse>> requestLogin() async {
    var response = await http.post(
      "https://hapia.herokuapp.com/users/login",
      body: {
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim(),
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> parsingJson = json.decode(response.body);
      var data = parsingJson['data'];
      var encodeRes = json.encode(data);
      var base = BaseResponse().setData(
        response,
        AuthResponse.fromJson(json.decode(encodeRes)),
      );
      return base;
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }

  _loginAction() {
    var isValidate = _formKey.currentState.validate();
    if (isValidate) {
      setState(() {
        _isLoading = true;
      });
      requestLogin().then((onValue) {
        // print(onValue.data.toJson());
        var authResponse = AuthResponse();
        prefs.then((prefs) {
          prefs.setBool('is_login', true);
          prefs.setString(USER_TOKEN, onValue.data.token);
          prefs.setString(NAME, onValue.data.name);
          authResponse
            ..token = onValue.data.token
            ..name = onValue.data.name;
          Navigator.pop(
            _scaffoldContext,
            AuthResponse(
              token: authResponse.token,
              name: authResponse.name,
            ),
          );
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
        });
        debugPrint(onError.toString());
        Scaffold.of(_scaffoldContext).showSnackBar(_snackbar);
      });
    }
  }

  _navigateToSignupScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
    // if (result) {}
  }
}
