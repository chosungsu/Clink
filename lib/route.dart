import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/addWhole.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Dialogs/destroyBackKey.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //curved navi index
  int _selectedIndex = 0;
  int page_index = Hive.box('user_setting').get('page_index') ?? 0;
  late DateTime backbuttonpressedTime;
  int navi = 0;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.index;
    navi = NaviWhere();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      HomePage(),
      HomePage(),
      ProfilePage(),
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
                    border: Border(
                        top: BorderSide(
                            color: BGColor_shadowcolor(), width: 1))),
                child: BottomNavigationBar(
                  onTap: (_index) {
                    //Handle button tap
                    setState(() {
                      if (_index == 1) {
                        Hive.box('user_setting').put('page_index',
                            Hive.box('user_setting').get('page_index'));
                        addWhole(context, searchNode, controller, name, Date,
                            'home');
                      } else {
                        Hive.box('user_setting').put('page_index', _index);
                      }
                      _selectedIndex =
                          Hive.box('user_setting').get('page_index');
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
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 25),
                      label: '홈',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_outlined, size: 25),
                      label: '추가',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined, size: 25),
                      label: '설정',
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
              ));
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}
