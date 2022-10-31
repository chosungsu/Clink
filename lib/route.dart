import 'package:badges/badges.dart';
import 'package:clickbyme/Page/MYPage.dart';
import 'package:clickbyme/Page/addWhole_update.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:clickbyme/providers/mongodatabase.dart';
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
import 'initScreenLoading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  //curved navi index
  late FToast fToast;
  late DateTime backbuttonpressedTime;
  //late AnimationController noticontroller;
  //late Animation animation;
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
  final uiset = Get.put(uisetting());
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
    uiset.pagenumber = widget.index;
    fToast = FToast();
    fToast.init(context);
    /*notilist.noticontroller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        value: 0,
        upperBound: 1.05,
        lowerBound: 0.95);
    animation = CurvedAnimation(
        parent: notilist.noticontroller, curve: Curves.decelerate);
    notilist.noticontroller.forward();
    // forward면 AnimationStatus.completed
    // reverse면 AnimationStatus.dismissed
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        notilist.noticontroller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        notilist.noticontroller.forward();
      }
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    //notilist.noticontroller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    //notilist.noticontroller.forward();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List pages = [
      HomePage(secondname: cal_share_person.secondname),
      const MYPage(),
      HomePage(secondname: cal_share_person.secondname),
      const ProfilePage(),
      const NotiAlarm(),
    ];

    //noticontroller.forward();
    return GetBuilder<navibool>(
        builder: (_) => GetBuilder<uisetting>(builder: ((_) {
              return Scaffold(
                  backgroundColor: BGColor(),
                  body: WillPopScope(
                      onWillPop: Hive.box('user_setting').get('page_index') == 0
                          ? _onWillPop
                          : _onWillPop2,
                      child: pages[uiset.pagenumber]),
                  bottomNavigationBar: draw.navi == 1
                      ? Container(
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border(
                                  top:
                                      BorderSide(color: draw.color, width: 1))),
                          child: BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            onTap: (_index) async {
                              //Handle button tap
                              uiset.setloading(true);
                              MongoDB.connect();

                              if (_index == 2) {
                                Hive.box('user_setting').put('page_index',
                                    Hive.box('user_setting').get('page_index'));
                                uiset.setpageindex(
                                    Hive.box('user_setting').get('page_index'));
                                /*addWhole(context, searchNode, controller, name,
                                Date, 'home', fToast);*/
                                addWhole_update(context, searchNode, controller,
                                    name, Date, 'home', fToast);
                              } else {
                                Hive.box('user_setting')
                                    .put('page_index', _index);
                                uiset.setpageindex(
                                    Hive.box('user_setting').get('page_index'));
                              }

                              uiset.setloading(false);
                            },
                            backgroundColor: BGColor(),
                            selectedFontSize: contentTextsize(),
                            unselectedFontSize: contentTextsize(),
                            selectedItemColor: NaviColor(true),
                            unselectedItemColor: NaviColor(false),
                            showSelectedLabels: true,
                            showUnselectedLabels: true,
                            currentIndex: uiset.pagenumber,
                            items: <BottomNavigationBarItem>[
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
                                  Icons.list_alt,
                                  size: 25,
                                ),
                                label: '마이룸',
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
                                      ? const Icon(
                                          Icons.notifications_none,
                                          size: 25,
                                        )
                                      : Badge(
                                          child: const Icon(
                                            Icons.notifications_none,
                                            size: 25,
                                          ),
                                        ),
                                  /*RotationTransition(
                                      turns: notilist.noticontroller,
                                      child: Badge(
                                        child: const Icon(
                                          Icons.notifications_none,
                                          size: 25,
                                        ),
                                      ),
                                    )*/
                                ),
                                label: '알림',
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ));
            })));
  }

  Future<bool> _onWillPop() async {
    if (draw.drawopen == true) {
      draw.setclose();
    }
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
    if (draw.drawopen == true) {
      draw.setclose();
      Hive.box('user_setting').put('page_opened', false);
    }
    if (draw.currentpage == 2) {
      draw.currentpage = 1;
      Hive.box('user_setting').put('page_index', 3);
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const MyHomePage(
            index: 3,
          ),
        ),
      );
    } else {
      Hive.box('user_setting').put('page_index', 0);
      MongoDB.connect();
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const MyHomePage(
            index: 0,
          ),
        ),
      );
    }
    return false;
  }
}
