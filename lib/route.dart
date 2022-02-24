import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Page/FeedPage.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //curved navi index
  int _selectedIndex = 1;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  List pages = [
    FeedPage(),
    HomePage(),
    ProfilePage(),
  ];
  late DateTime backbuttonpressedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          index: _selectedIndex,
          backgroundColor: Colors.blueAccent,
          key: _bottomNavigationKey,
          items: const <Widget>[
            Icon(Icons.widgets, size: 25),
            Icon(Icons.home, size: 25),
            Icon(Icons.account_circle, size: 25),
          ],
          onTap: (index) {
            //Handle button tap
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: pages[_selectedIndex],
    );
  }

}
