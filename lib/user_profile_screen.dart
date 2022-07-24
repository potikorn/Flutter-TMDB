import 'package:flutter/material.dart';
import 'package:flutter_movie_db/auth/login_screen.dart';
import 'package:flutter_movie_db/dao/auth_response.dart';
import 'package:flutter_movie_db/model/UserProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool _isLogin = false;
  AuthResponse _authDao = AuthResponse();

  @override
  void initState() {
    super.initState();
    prefs.then((p) {
      setState(() {
        _isLogin = p.getBool(IS_LOGIN);
        _authDao
          ..token = p.getString(USER_TOKEN)
          ..name = p.getString(NAME);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLogin ?? false
            ? ListView(
                padding: const EdgeInsets.all(24.0),
                children: <Widget>[
                  _buildUserProfile(),
                  SizedBox(height: 16.0),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Logout'),
                    ),
                    onTap: _logout,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text('Please Sign in!'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('TODO: fix backend'),
                          duration: Duration(milliseconds: 1000),
                        ),
                      );
                      // FIXME please fix backend
                      // _navigateToAuthScreen();
                    },
                    child: Text('Sign in plz.'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // FIXME IF YOU WANT IMAGE PROFILE.
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${(_authDao.name) ?? 'NAME'}"),
            ],
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  _navigateToAuthScreen() async {
    final AuthResponse result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    if (result?.token != null) {
      _isLogin = true;
      _authDao..name = result.name;
    } else {
      _isLogin = false;
    }
  }

  _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout?',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ok I\'m out!',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLogin = false;
                });
                prefs.then((p) {
                  p.setBool(IS_LOGIN, false);
                  p.setString(USER_TOKEN, null);
                  p.setString(USERNAME, null);
                  p.setString(NAME, null);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
