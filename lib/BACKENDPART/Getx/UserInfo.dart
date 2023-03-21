// ignore_for_file: unused_field, file_names

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/Variables.dart';

class UserInfo extends GetxController {
  final box = GetStorage();
  bool ispro = false;
  List people = [];
  String nickname = '';
  String usrcode = '';
  String usrimgurl = '';
  String code = '';
  String langCode = '';
  List defaulthomeviewlist = [];
  List userviewlist = [];
  List friendlist = [];
  Locale? locale;

  checkusrinfo() async {
    nickname = box.read('nick') ?? '';
    usrcode = box.read('code') ?? '';
    usrimgurl = box.read('picture') ?? '';
    loadLocale();
  }

  ///setusrimg
  ///
  ///유저의 이미지를 생성하는 데에 사용된다.
  void setusrimg(String imgurl) {
    usrimgurl = imgurl;

    update();
    notifyChildrens();
  }

  ///loadLocale
  ///
  ///사용자의 기기 내 locale 정보를 얻는 데에 사용된다.
  void loadLocale() async {
    locale = box.read('locale') == null
        ? Get.deviceLocale
        : Locale('${box.read('locale')}', '');
    if (locale!.languageCode == 'en') {
      locale = const Locale('en', '');
    } else if (locale!.languageCode == 'ko') {
      locale = const Locale('ko', '');
    } else {
      locale = const Locale('ja', '');
    }

    update();
    notifyChildrens();
  }

  ///changeLocale
  ///
  ///사용자의 기기 내 locale 정보를 변경하는 데에 사용된다.
  void changeLocale(context, newlocale) async {
    if (newlocale!.languageCode == 'en') {
      locale = const Locale('en', '');
    } else if (newlocale!.languageCode == 'ko') {
      locale = const Locale('ko', '');
    } else {
      locale = const Locale('ja', '');
    }
    box.write('locale', locale!.languageCode.toString());
    locale = Locale('${box.read('locale')}', '');
    loadLocale();

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

  void friendset() async {
    firestore
        .collection('PeopleList')
        .doc(usrcode)
        .set({'friends': []}, SetOptions(merge: true));

    update();
    notifyChildrens();
  }

  void secondnameset(String code) {
    firestore.collection('User').doc(usrcode).update({'nick': code});
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
