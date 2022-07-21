import 'package:clickbyme/Page/AnalyticPage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'Dialogs/destroyBackKey.dart';
import 'Page/FeedPage.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //curved navi index
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late DateTime backbuttonpressedTime;
  int navi = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.index;
    navi = NaviWhere();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      HomePage(colorbackground: BGColor(), coloritems: TextColor()),
      //FeedPage(),
      AnalyticPage(colorbackground: BGColor(), coloritems: TextColor()),
      ProfilePage(colorbackground: BGColor(), coloritems: TextColor()),
    ];

    return Scaffold(
        backgroundColor: BGColor(),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: navi == 0 ? pages[widget.index] : pages[_selectedIndex],
        ),
        bottomNavigationBar: navi == 1
            ? Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: TextColor(), width: 2))
              ),
              child: BottomNavigationBar(
                onTap: (_index) {
                  //Handle button tap
                  setState(() {
                    _selectedIndex = _index;
                  });
                },
                backgroundColor: BGColor(),
                selectedFontSize: contentTitleTextsize(),
                unselectedFontSize: contentTitleTextsize(),
                selectedItemColor: NaviColor(true),
                unselectedItemColor: NaviColor(false),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: _selectedIndex,
                key: _bottomNavigationKey,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 25),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart, size: 25),
                    label: '분석',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined, size: 25),
                    label: '설정',
                  ),
                ],
              ),
            )
            /*CurvedNavigationBar(
                height: 50,
                index: widget.index,
                backgroundColor: Colors.deepPurpleAccent.shade100,
                color: Colors.white,
                key: _bottomNavigationKey,
                items: const <Widget>[
                  Icon(Icons.home, size: 25),
                  Icon(Icons.widgets, size: 25),
                  Icon(Icons.account_circle, size: 25),
                ],
                onTap: (_index) {
                  //Handle button tap
                  setState(() {
                    _selectedIndex = _index;
                  });
                },
              )*/
            : const SizedBox(
                height: 0,
              ));
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}
