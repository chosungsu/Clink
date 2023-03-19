import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../LocalNotiPlatform/NotificationApi.dart';
import 'PeopleAdd.dart';

class memosetting extends GetxController {
  final peopleadd = Get.put(PeopleAdd());
  Color color = Hive.box('user_setting').get('coloreachmemo') != null
      ? Color(Hive.box('user_setting').get('coloreachmemo'))
      : Colors.white;
  Color colorfont = Hive.box('user_setting').get('coloreachmemofont') != null
      ? Color(Hive.box('user_setting').get('coloreachmemofont'))
      : Colors.black;
  int memosort = 0;
  bool ischeckedtohideminus = false;
  bool isseveralmemoalarm = false;
  bool ischeckedpushmemoalarm = false;
  List imagelist = [];
  List voicelist = [];
  List drawinglist = [];
  int imageindex = 0;
  int voiceindex = 0;
  int drawingindex = 0;
  String username = Hive.box('user_info').get(
        'id',
      ) ??
      '';
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
      print('cancel : ' + title.hashCode.toString());
      if (isseveralmemoalarm == false) {
        firestore.collection('MemoDataBase').doc(id).get().then((value) => value
                    .exists ==
                false
            ? null
            : value.data()!['alarmok'] == false
                ? null
                : NotificationApi.cancelNotification(id: 1 + title.hashCode));
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
            .doc(peopleadd.usrcode)
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
      Hive.box('user_setting').put('alarm_memo_hour', hour.toString());
      Hive.box('user_setting').put('alarm_memo_minute', minute.toString());
      hour2 = Hive.box('user_setting').get('alarm_memo_hour');
      minute2 = Hive.box('user_setting').get('alarm_memo_minute');
      firestore
          .collection('MemoAllAlarm')
          .doc(peopleadd.usrcode)
          .update({'alarmtime': hour2.toString() + ':' + minute2.toString()});
    }
    update();
    notifyChildrens();
  }

  Future<void> setalarmmemotimetable(
      String hour, String minute, String title, String id) async {
    if (title != '') {
      isseveralmemoalarm = Hive.box('user_setting').get('alarm_memo_$title');
      firestore.collection('MemoDataBase').doc(id).update({
        'alarmok': true,
      });
      await NotificationApi.cancelNotification(id: 1 + title.hashCode);
      NotificationApi.showDailyNotification_severalnotes(
          id: 1 + title.hashCode,
          title: '띵동! $title 메모알림이에요',
          body: '메모알림끄기는 [메모 길게클릭]->[알람Off]',
          payload: 'memo',
          scheduledate: DateTime.utc(now.year, now.month, now.day,
              int.parse(hour), int.parse(minute), 0));
    } else {
      ischeckedpushmemoalarm = Hive.box('user_setting').get('alarm_memo');
      firestore.collection('MemoAllAlarm').doc(peopleadd.usrcode).update({
        'ok': true,
      });
      await firestore.collection('MemoAllAlarm').doc(peopleadd.usrcode).update({
        'ok': false,
      });
      NotificationApi.showDailyNotification(
          title: '띵동! 메모 알림이에요',
          body: '메모알림끄기는 [일상메모]->[톱니바퀴]->[해제]',
          payload: 'memo',
          scheduledate: DateTime.utc(now.year, now.month, now.day,
              int.parse(hour), int.parse(minute), 0));
      firestore
          .collection('MemoAllAlarm')
          .doc(peopleadd.usrcode)
          .update({'ok': true});
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

  void setcolorfont() {
    colorfont = Color(Hive.box('user_setting').get('coloreachmemofont'));
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
    imageindex--;
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

  void setvoicelist(String path) {
    voicelist.insert(0, path);
    voiceindex++;
    update();
    notifyChildrens();
  }

  void deletevoicelist(int index) {
    voicelist.removeAt(index);
    voiceindex--;
    update();
    notifyChildrens();
  }

  void setdrawinglist(String path) {
    drawinglist.insert(0, path);
    drawingindex++;
    update();
    notifyChildrens();
  }

  void deletedrawinglist(int index) {
    drawinglist.removeAt(index);
    drawingindex--;
    update();
    notifyChildrens();
  }
}
