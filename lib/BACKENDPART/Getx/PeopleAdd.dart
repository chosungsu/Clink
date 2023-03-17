// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/Variables.dart';

class PeopleAdd extends GetxController {
  bool ispro = false;
  List people = [];
  String nickname = Hive.box('user_info').get('id') ?? '';
  String usrcode = Hive.box('user_setting').get('usercode') ?? '';
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

  void setpro() {
    ispro = !ispro;
    update();
    notifyChildrens();
  }
}
