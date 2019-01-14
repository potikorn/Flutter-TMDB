import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
              ),
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey[900],
          canvasColor: Colors.grey[900],
        ),
        home: MainScreen());
  }
}
