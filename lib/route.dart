import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'Dialogs/destroyBackKey.dart';
import 'Page/FeedPage.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.index})
      : super(key: key);
  final String title;
  final int index;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //curved navi index
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late DateTime backbuttonpressedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      HomePage(title: widget.title),
      FeedPage(),
      ProfilePage(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: pages[widget.index],
      ),
      /*bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        index: _selectedIndex,
        backgroundColor: Colors.deepPurpleAccent.shade100,
        color: Colors.white,
        key: _bottomNavigationKey,
        items: const <Widget>[
          Icon(Icons.home, size: 25),
          Icon(Icons.widgets, size: 25),
          Icon(Icons.account_circle, size: 25),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _selectedIndex = index;
          });
        },
      )*/
    );
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}
