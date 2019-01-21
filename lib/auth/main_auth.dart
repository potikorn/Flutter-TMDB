import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() => runApp(MainAuth());

class MainAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[850],
        canvasColor: Colors.grey[850],
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder> {
        "/signin" : (context) => LoginScreen(),
        // "/signin" : (context) => LoginScreen(),
      },
    );
  }
}
