import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isseveralmemoalarm = false;
  bool ischeckedpushmemoalarm =
      Hive.box('user_setting').get('alarm_memo') ?? false;
  List imagelist = [];
  int imageindex = 0;
  String username = Hive.box('user_info').get(
    'id',
  );
  int sort = Hive.box('user_setting').get('sort_memo_card') ?? 0;
  DateTime now = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int hour1 = 99;
  int minute1 = 99;
  String hour2 = '99';
  String minute2 = '99';

  void setpagetext() {
    ischeckedpushmemoalarm = Hive.box('user_setting').get('alarm_memo');
    update();
    notifyChildrens();
  }

  void setalarmmemo(String title, String id) {
    if (title != '') {
      isseveralmemoalarm = Hive.box('user_setting').get('alarm_memo_$title');
      if (isseveralmemoalarm == false) {
        NotificationApi.cancelNotification(
            id: 1 +
                int.parse(Hive.box('user_setting')
                    .get('alarm_memo_hour_$title')
                    .toString()) +
                int.parse(Hive.box('user_setting')
                    .get('alarm_memo_minute_$title')
                    .toString()) +
                title.hashCode);
        firestore
            .collection('MemoDataBase')
            .doc(id)
            .update({'alarmok': false, 'alarmtime': '99:99'});
      }
    } else {
      ischeckedpushmemoalarm = Hive.box('user_setting').get('alarm_memo');
      if (ischeckedpushmemoalarm == false) {
        NotificationApi.cancelNotification(id: 1);
        firestore
            .collection('MemoAllAlarm')
            .doc(username)
            .update({'ok': false, 'alarmtime': '99:99'});
      }
    }
    update();
    notifyChildrens();
  }

  void settimeminute(int hour, int minute, String title, String id) {
    if (title != '') {
      Hive.box('user_setting').put('alarm_memo_hour_$title', hour);
      Hive.box('user_setting').put('alarm_memo_minute_$title', minute);
      hour1 = Hive.box('user_setting').get('alarm_memo_hour_$title');
      minute1 = Hive.box('user_setting').get('alarm_memo_minute_$title');
      firestore
          .collection('MemoDataBase')
          .doc(id)
          .update({'alarmtime': hour1.toString() + ':' + minute1.toString()});
    } else {
      print(hour.toString() + ' : ' + minute.toString());
      Hive.box('user_setting').put('alarm_memo_hour', hour.toString());
      Hive.box('user_setting').put('alarm_memo_minute', minute.toString());
      hour2 = Hive.box('user_setting').get('alarm_memo_hour');
      minute2 = Hive.box('user_setting').get('alarm_memo_minute');
      firestore
          .collection('MemoAllAlarm')
          .doc(username)
          .update({'alarmtime': hour2.toString() + ':' + minute2.toString()});
    }
  }

  void setalarmmemotimetable(
      String hour, String minute, String title, String id) {
    if (title != '') {
      isseveralmemoalarm = Hive.box('user_setting').get('alarm_memo_$title');
      firestore.collection('MemoDataBase').doc(id).update({
        'alarmok': true,
      });
      NotificationApi.showDailyNotification_severalnotes(
          id: 1 + int.parse(hour) + int.parse(minute) + title.hashCode,
          title: '띵동! $title 메모알림이에요',
          body: '메모알림끄기는 [메모 길게클릭]->[알람Off]',
          scheduledate: DateTime.utc(now.year, now.month, now.day,
              int.parse(hour), int.parse(minute), 0));
    } else {
      ischeckedpushmemoalarm = Hive.box('user_setting').get('alarm_memo');
      firestore.collection('MemoAllAlarm').doc(username).update({
        'ok': true,
      });
      NotificationApi.showDailyNotification(
          title: '띵동! 메모 알림이에요',
          body: '메모알림끄기는 [일상메모]->[톱니바퀴]->[해제]',
          scheduledate: DateTime.utc(now.year, now.month, now.day,
              int.parse(hour), int.parse(minute), 0));
    }
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
