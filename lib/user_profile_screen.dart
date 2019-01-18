import 'package:flutter/material.dart';
import 'package:flutter_movie_db/model/UserProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 120.0,
          height: 120.0,
          color: Colors.blue,
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name'),
            ],
          ),
        ),
      ],
    );
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
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Ok I\'m out!',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
