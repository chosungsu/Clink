// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:clickbyme/Page/MYPage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/mongoDB/mongodatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'subuiroute.dart';
import '../Page/HomePage.dart';
import '../Page/ProfilePage.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';

class mainroute extends StatefulWidget {
  const mainroute({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<mainroute> createState() => _mainrouteState();
}

class _mainrouteState extends State<mainroute>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late FToast fToast;
  late DateTime backbuttonpressedTime;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();
  final draw = Get.put(navibool());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());
  final uiset = Get.put(uisetting());
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    uiset.pagenumber = widget.index;
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    //notilist.noticontroller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<bool> _onWillPop() async {
    final draw = Get.put(navibool());
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
    final draw = Get.put(navibool());
    if (draw.drawopen == true) {
      draw.setclose();
      Hive.box('user_setting').put('page_opened', false);
    }
    if (draw.currentpage == 2) {
      draw.currentpage = 1;
      Hive.box('user_setting').put('page_index', 2);
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const mainroute(
            index: 2,
          ),
        ),
      );
    } else {
      Hive.box('user_setting').put('page_index', 0);

      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: const mainroute(
            index: 0,
          ),
        ),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    MongoDB.connect();
    List pages = [
      //HomePage(secondname: cal_share_person.secondname),
      const MYPage(),
      HomePage(secondname: cal_share_person.secondname),
      const ProfilePage(),
    ];
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
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: draw.color, width: 1))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ADSHOW(),
                            BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              onTap: (_index) async {
                                //Handle button tap
                                uiset.setloading(true);
                                /*if (_index == 2) {
                                    Hive.box('user_setting').put(
                                        'page_index',
                                        Hive.box('user_setting')
                                            .get('page_index'));
                                    uiset.setpageindex(Hive.box('user_setting')
                                        .get('page_index'));
                                    /*addWhole(context, searchNode, controller, name,
                                Date, 'home', fToast);*/
                                    addWhole_update(context, searchNode,
                                        controller, name, Date, 'home', fToast);
                                  } */
                                Hive.box('user_setting')
                                    .put('page_index', _index);
                                uiset.setpageindex(
                                    Hive.box('user_setting').get('page_index'));

                                uiset.setloading(false);
                              },
                              backgroundColor: BGColor(),
                              selectedFontSize: 18,
                              unselectedFontSize: 18,
                              selectedItemColor: NaviColor(true),
                              unselectedItemColor: NaviColor(false),
                              showSelectedLabels: false,
                              showUnselectedLabels: false,
                              currentIndex: uiset.pagenumber,
                              items: <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  backgroundColor: BGColor(),
                                  icon: const Icon(
                                    Icons.view_stream,
                                    size: 25,
                                  ),
                                  label: '홈',
                                ),
                                BottomNavigationBarItem(
                                  backgroundColor: BGColor(),
                                  icon: const Icon(
                                    Icons.search,
                                    size: 25,
                                  ),
                                  label: '검색',
                                ),
                                BottomNavigationBarItem(
                                  backgroundColor: BGColor(),
                                  icon: const Icon(
                                    Icons.settings,
                                    size: 25,
                                  ),
                                  label: '설정',
                                ),
                                /*BottomNavigationBarItem(
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
                              ),*/
                              ],
                            ),
                          ],
                        ))
                    : ADSHOW(),
              );
            })));
  }
}
