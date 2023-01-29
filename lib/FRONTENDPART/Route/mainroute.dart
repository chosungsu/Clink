// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Page/MYPage.dart';
import '../Page/NotiAlarm.dart';
import 'subuiroute.dart';
import '../Page/SearchPage.dart';
import '../Page/ProfilePage.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/navibool.dart';

class mainroute extends StatefulWidget {
  const mainroute({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<mainroute> createState() => _mainrouteState();
}

class _mainrouteState extends State<mainroute>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());
  final draw = Get.put(navibool());
  final searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    uiset.mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
    WidgetsBinding.instance.addObserver(this);
    uiset.pagenumber = widget.index;
    uiset.searchpagemove = '';
    uiset.textrecognizer = '';
  }

  @override
  void dispose() {
    super.dispose();
    //notilist.noticontroller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<bool> onWillPop() async {
    uiset
        .setmypagelistindex(Hive.box('user_setting').get('currentmypage') ?? 0);
    if (draw.drawopen == true) {
      draw.setclose();
    }
    if (uiset.profileindex != 0) {
      uiset.checkprofilepageindex(0);
    } else if (uiset.searchpagemove != '') {
      uiset.searchpagemove = '';
      uiset.textrecognizer = '';
      searchNode.unfocus();
      Hive.box('user_setting').put('page_index', 1);
    } else if (uiset.pagenumber != 0) {
      Get.to(() => const mainroute(index: 0), transition: Transition.fade);
    } else {
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
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      const MYPage(),
      SearchPage(secondname: peopleadd.secondname),
      const NotiAlarm(),
      const ProfilePage(),
    ];
    return GetBuilder<navibool>(
        builder: (_) => GetBuilder<uisetting>(builder: ((_) {
              return Scaffold(
                backgroundColor: draw.backgroundcolor,
                body: WillPopScope(
                    onWillPop: onWillPop, child: pages[uiset.pagenumber]),
                bottomNavigationBar: ADSHOW(),
              );
            })));
  }
}
