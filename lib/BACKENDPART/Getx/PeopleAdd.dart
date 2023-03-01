// ignore_for_file: unused_field

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Api/LoginApi.dart';
import '../Enums/Variables.dart';

class PeopleAdd extends GetxController {
  final loginapi = Get.put(LoginApiProvider());
  List people = [];
  String secondname = Hive.box('user_info').get('id') ?? '';
  String code = '';
  List defaulthomeviewlist = [];
  List userviewlist = [];
  List friendlist = [];

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

  void friendset() async {
    firestore
        .collection('PeopleList')
        .doc(Hive.box('user_setting').get('usercode'))
        .set({'friends': []}, SetOptions(merge: true));

    update();
    notifyChildrens();
  }

  void secondnameset(String code) {
    firestore
        .collection('User')
        .doc(Hive.box('user_setting').get('usercode'))
        .update({'nick': code});
    appnickname = code;
    update();
    notifyChildrens();
  }
}
