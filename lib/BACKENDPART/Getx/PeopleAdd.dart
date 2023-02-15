// ignore_for_file: unused_field

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../Enums/Variables.dart';

class PeopleAdd extends GetxController {
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

  void usercodeset() async {
    var _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String code = '';

    //내부 저장으로 로그인 정보 저장
    code = 'User#' +
        String.fromCharCodes(Iterable.generate(
            5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    if (usercode == '') {
      await firestore.collection('User').doc(code).set(
          {'nick': code, 'email': '', 'code': code},
          SetOptions(merge: true)).whenComplete(() async {
        await Hive.box('user_info').put('id', code);
        await Hive.box('user_info').put('email', '');
        await Hive.box('user_setting').put('usercode', code);
      });
    } else {}

    update();
    notifyChildrens();
  }

  void friendset() async {
    firestore
        .collection('PeopleList')
        .doc(usercode)
        .set({'friends': []}, SetOptions(merge: true));

    update();
    notifyChildrens();
  }

  void secondnameset(String code) {
    firestore.collection('User').doc(usercode).update({'nick': code});
    appnickname = code;
    update();
    notifyChildrens();
  }
}
