// ignore_for_file: camel_case_types

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';

class notishow extends GetxController {
  List listad = [];
  bool isread = false;
  List updateid = [];
  List<bool> checkboxnoti = List.empty(growable: true);
  late AnimationController noticontroller;

  void ringing(AnimationController noticontroller) {
    noticontroller.forward();
    update();
    notifyChildrens();
  }

  void setnoti(String a, String b) async {
    listad.add(CompanyPageList(title: a, date: b));
    update();
    notifyChildrens();
  }

  void resetnoti() async {
    listad.clear();
    update();
    notifyChildrens();
  }

  void setcheckboxnoti() async {
    checkboxnoti = List.filled(updateid.length, false, growable: true);
  }

  void isreadnoti({init = true}) async {
    await firestore.collection('AppNoticeByUsers').get().then((value) {
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
