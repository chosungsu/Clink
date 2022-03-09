import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  late DateTime backbuttonpressedTime;
  //bottomnavi hide
  bool bottomvisible = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      FeedPage(),
      HomePage(title: widget.title),
      ProfilePage(),
    ];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: NotificationListener<UserScrollNotification> (
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!bottomvisible) {
              setState(() {
                bottomvisible = true;
              });
            }
          } else if (notification.direction == ScrollDirection.reverse) {
            if (bottomvisible) {
              setState(() {
                bottomvisible = false;
              });
            }
          }
          return true;
        },
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: bottomvisible ? CurvedNavigationBar(
        height: 50,
        index: _selectedIndex,
        backgroundColor: Colors.deepPurpleAccent.shade100,
        color: Colors.grey.shade100,
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
      ) : null
    );
  }

}