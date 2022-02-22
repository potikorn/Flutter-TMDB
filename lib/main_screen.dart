import 'package:flutter/material.dart';
import 'package:flutter_movie_db/user_profile_screen.dart';

import 'movie/screen/movie_screen.dart';
import 'package:flutter_movie_db/search_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  final List<Widget> _children = [
    MovieScreen(),
    SearchScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onTabTapped,
        children: _children,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[900],
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.grey)),
        ),
        child: BottomNavigationBar(
          fixedColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          onTap: (index) {
            this._pageController.jumpToPage(index);
          },
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
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
