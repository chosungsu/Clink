import 'package:badges/badges.dart';
import 'package:clickbyme/Page/MYPage.dart';
import 'package:clickbyme/Page/addWhole_update.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'Dialogs/destroyBackKey.dart';
import 'Page/HomePage.dart';
import 'Page/ProfilePage.dart';
import 'Tool/AndroidIOS.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/memosetting.dart';
import 'Tool/Getx/navibool.dart';
import 'Tool/Getx/notishow.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //curved navi index
  int _selectedIndex = 0;
  late FToast fToast;
  late DateTime backbuttonpressedTime;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();
  final draw = Get.put(navibool());
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());
  final controll_memo = Get.put(memosetting());
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.index;
    fToast = FToast();
    fToast.init(context);
    firestore.collection('User').doc(name).get().then((value) {
      if (value.exists) {
        peopleadd.secondnameset(value.data()!['subname']);
      }
    });
    firestore
        .collection('HomeViewCategories')
        .doc(Hive.box('user_setting').get('usercode'))
        .get()
        .then((value) {
      peopleadd.defaulthomeviewlist.clear();
      peopleadd.userviewlist.clear();
      if (value.exists) {
        print(1);
        for (int i = 0; i < value.data()!['viewcategory'].length; i++) {
          peopleadd.defaulthomeviewlist.add(value.data()!['viewcategory'][i]);
        }
        for (int j = 0; j < value.data()!['hidecategory'].length; j++) {
          peopleadd.userviewlist.add(value.data()!['hidecategory'][j]);
        }
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      } else {
        print(2);
        peopleadd.defaulthomeviewlist.add(defaulthomeviewlist);
        peopleadd.userviewlist.add(userviewlist);
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      }
    });
    firestore.collection('AppNoticeByUsers').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['username'] == name ||
            element.data()['sharename'].toString().contains(name)) {
          updateid.add(element.data()['read']);
        }
      }
      if (updateid.contains('no')) {
        isread = false;
        notilist.isread = false;
      } else {
        isread = true;
        notilist.isread = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      MYPage(),
      HomePage(secondname: cal_share_person.secondname),
      HomePage(secondname: cal_share_person.secondname),
      ProfilePage(),
      NotiAlarm(),
    ];

    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: BGColor(),
            body: WillPopScope(
                onWillPop: Hive.box('user_setting').get('page_index') == 1
                    ? _onWillPop
                    : _onWillPop2,
                child: pages[_selectedIndex]),
            bottomNavigationBar: draw.navi == 1
                ? Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: draw.color, width: 1))),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      onTap: (_index) {
                        //Handle button tap
                        setState(() {
                          if (_index == 2) {
                            Hive.box('user_setting').put('page_index',
                                Hive.box('user_setting').get('page_index'));
                            _selectedIndex =
                                Hive.box('user_setting').get('page_index');
                            /*addWhole(context, searchNode, controller, name,
                                Date, 'home', fToast);*/
                            controll_memo.loading = false;
                            addWhole_update(context, searchNode, controller,
                                name, Date, 'home', fToast);
                          } else {
                            Hive.box('user_setting').put('page_index', _index);
                            _selectedIndex =
                                Hive.box('user_setting').get('page_index');
                          }
                        });
                      },
                      backgroundColor: BGColor(),
                      selectedFontSize: contentTitleTextsize(),
                      unselectedFontSize: contentTitleTextsize(),
                      selectedItemColor: NaviColor(true),
                      unselectedItemColor: NaviColor(false),
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      currentIndex: _selectedIndex,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          backgroundColor: BGColor(),
                          icon: const Icon(
                            Icons.list_alt,
                            size: 25,
                          ),
                          label: 'MY',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: BGColor(),
                          icon: const Icon(
                            Icons.home,
                            size: 25,
                          ),
                          label: '홈',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: BGColor(),
                          icon: const Icon(
                            Icons.add_outlined,
                            size: 25,
                          ),
                          label: '추가',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: BGColor(),
                          icon: const Icon(
                            Icons.account_circle_outlined,
                            size: 25,
                          ),
                          label: '설정',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: BGColor(),
                          icon: GetBuilder<notishow>(
                              builder: (_) => notilist.isread == true
                                  ? IconButton(
                                      onPressed: () {
                                        Get.to(() => NotiAlarm(),
                                            transition: Transition.zoom);
                                      },
                                      icon: Container(
                                        alignment: Alignment.center,
                                        width: 25,
                                        height: 25,
                                        child: const Icon(
                                          Icons.notifications_none,
                                          size: 25,
                                        ),
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        Get.to(() => NotiAlarm(),
                                            transition: Transition.zoom);
                                      },
                                      icon: Container(
                                          alignment: Alignment.center,
                                          width: 25,
                                          height: 25,
                                          child: Badge(
                                            child: const Icon(
                                              Icons.notifications_none,
                                              size: 25,
                                            ),
                                          )),
                                    )),
                          label: '알림',
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  )));
  }

  Future<bool> _onWillPop() async {
    return await Get.dialog(OSDialog(
            context,
            '종료',
            Text('앱을 종료하시겠습니까?',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            pressed1)) ??
        false;
  }

  Future<bool> _onWillPop2() async {
    Hive.box('user_setting').get('page_index') == 0
        ? Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MyHomePage(
                index: 1,
              ),
            ),
          )
        : Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: const MyHomePage(
                index: 1,
              ),
            ),
          );
    Hive.box('user_setting').put('page_index', 1);
    return false;
  }
}
