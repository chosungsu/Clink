import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../LocalNotiPlatform/NotificationApi.dart';
import '../BGColor.dart';

class memosetting extends GetxController {
  Color color = Hive.box('user_setting').get('coloreachmemo') != null
      ? Color(Hive.box('user_setting').get('coloreachmemo'))
      : Colors.white;
  int memosort = 0;
  bool ischeckedtohideminus = false;
  bool ischeckedpushmemoalarm =
      Hive.box('user_setting').get('alarm_memo') ?? false;
  List imagelist = [];
  int imageindex = 0;
  int sort = Hive.box('user_setting').get('sort_memo_card') ?? 0;
  DateTime now = DateTime.now();

  void setalarmmemo() {
    ischeckedpushmemoalarm = Hive.box('user_setting').get('alarm_memo');
    if (ischeckedpushmemoalarm == false) {
      NotificationApi.cancelNotification(id: 1);
    }
    update();
    notifyChildrens();
  }

  void setalarmmemotimetable(String hour, String minute) {
    Hive.box('user_setting').put('alarm_memo_hour', hour);
    Hive.box('user_setting').put('alarm_memo_minute', minute);
    NotificationApi.showDailyNotification(
        title: '띵동! 메모 알림이에요',
        body: '지금 바로 메모를 확인해보세요 (메모알림끄기는 [일상메모]->[톱니바퀴]->[해제])',
        scheduledate: DateTime.utc(
            now.year,
            now.month,
            now.day,
            int.parse(Hive.box('user_setting').get('alarm_memo_hour')),
            int.parse(Hive.box('user_setting').get('alarm_memo_minute')),
            0));
    update();
    notifyChildrens();
  }

  void setsortmemo(int sortnum) {
    Hive.box('user_setting').put('sort_memo_card', sortnum);
    sort = Hive.box('user_setting').get('sort_memo_card');
    update();
    notifyChildrens();
  }

  void setcolor() {
    color = Color(Hive.box('user_setting').get('coloreachmemo'));
    update();
    notifyChildrens();
  }

  void sethideminus(bool b) {
    ischeckedtohideminus = b;
    update();
    notifyChildrens();
  }

  void setimagelist(String path) {
    imagelist.insert(0, path);
    imageindex++;
    update();
    notifyChildrens();
  }

  void deleteimagelist(int index) {
    imagelist.removeAt(index);
    setimageindex(index - 1);
    update();
    notifyChildrens();
  }

  void resetimagelist() {
    imagelist.clear();
    update();
    notifyChildrens();
  }

  void setimageindex(int index) {
    imageindex = index;
    update();
    notifyChildrens();
  }
}
