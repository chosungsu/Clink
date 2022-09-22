import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PeopleAdd extends GetxController {
  List people = [];
  String secondname = Hive.box('user_info').get('id');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String code = '';
  String codes = '';
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  void setcode() {
    firestore
        .collection('User')
        .doc(Hive.box('user_info').get('id'))
        .get()
        .then((value) {
      if (value.exists) {
        code = value.data()!['code'];
        Hive.box('user_setting').put('usercode', code);
      } else {}
    });
    update();
    notifyChildrens();
  }

  void peoplecalendar() {
    people = Hive.box('user_setting').get('share_cal_person');
    update();
    notifyChildrens();
  }

  void peoplecalendarrestart() {
    Hive.box('user_setting').put('share_cal_person', '');
    people = [];
    update();
    notifyChildrens();
  }

  void secondnameset(String name) {
    firestore
        .collection('User')
        .doc(Hive.box('user_info').get('id'))
        .update({'subname': name});

    secondname = name;
    update();
    notifyChildrens();
  }
}
