// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../DB/PageList.dart';

class notishow extends GetxController {
  List listad = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isread = false;
  List updateid = [];
  String name = Hive.box('user_info').get('id') ?? '';
  int whatnoticepagenum = 0;
  late AnimationController noticontroller;

  void ringing(AnimationController noticontroller) {
    noticontroller.forward();
    update();
    notifyChildrens();
  }

  void setnoti(String a, String b) async {
    listad.add(CompanyPageList(title: a, url: b));
    update();
    notifyChildrens();
  }

  void resetnoti() async {
    listad.clear();
    update();
    notifyChildrens();
  }

  void noticepageset(int num) async {
    whatnoticepagenum = num;
    update();
    notifyChildrens();
  }

  void isreadnoti() async {
    firestore.collection('AppNoticeByUsers').get().then((value) {
      updateid.clear();
      for (var element in value.docs) {
        if (element.data()['username'] == name ||
            element.data()['sharename'].toString().contains(name)) {
          updateid.add(element.data()['read']);
        }
      }
      if (updateid.contains('no')) {
        isread = false;
      } else {
        isread = true;
      }
    });
    update();
    notifyChildrens();
  }

  void updatenoti(String id) async {
    firestore.collection('AppNoticeByUsers').doc(id).update({'read': 'yes'});
    update();
    notifyChildrens();
  }
}
