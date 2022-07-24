import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_db/utils/override_color.dart';
import 'package:flutter_movie_db/widget/modal_loader.dart';

import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: <Widget>[
                  AccentColorOverride(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'This field must not empty';
                        }
                        return '';
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  AccentColorOverride(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'This field must not empty';
                        }
                        return '';
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  AccentColorOverride(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'This field must not empty';
                        }
                        return '';
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  AccentColorOverride(
                    color: Colors.white,
                    child: TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password Confirm',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'This field must not empty';
                        }
                        return '';
                      },
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      var isValid = _formKey.currentState.validate();
                      if (isValid) {
                        setState(() {
                          _isLoading = true;
                        });
                        requestResigter().then((onValue) {
                          Navigator.pop(context, true);
                        }).catchError((onError) {
                          setState(() {
                            _isLoading = false;
                          });
                          debugPrint(onError.toString());
                        });
                      }
                    },
                    child: Text('Confirm'),
                  ),
                ],
              ),
            ),
            (_isLoading) ? ModalLoader() : Container(),
          ],
        ),
      ),
    );
  }

  Future<bool> requestResigter() async {
    var response = await http.post(
      Uri.parse("https://hapia.herokuapp.com/users/register"),
      body: {
        "name": _nameController.text.trim(),
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim(),
        "repassword": _passwordConfirmController.text.trim(),
      },
    );
    if (response.statusCode == 200) {
      // return AuthResponse.fromJson(json.decode(response.body));
      final Map<String, dynamic> result = json.decode(response.body);
      final paresed = result.keys.where((test) => test == 'success');
      print('${paresed.toString()}');
      return true;
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}
