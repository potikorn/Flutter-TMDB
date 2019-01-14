import 'package:flutter/material.dart';

import 'movie/screen/movie_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MovieScreen(),
    Container(
      child: Center(
        child: Text('Search'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Settings'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.grey)),
        ),
        child: BottomNavigationBar(
          fixedColor: Colors.white,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            )
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
