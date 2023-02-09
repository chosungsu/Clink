// ignore_for_file: camel_case_types

import 'package:get/get.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';

class notishow extends GetxController {
  bool allcheck = false;
  List listad = [];
  bool isread = true;
  List updateid = [];
  List checkread = [];
  List<bool> checkboxnoti = List.empty(growable: true);

  void setnoti(String a, String b) async {
    listad.add(NotiList(title: a, date: b));
    update();
    notifyChildrens();
  }

  void resetnoti() async {
    listad.clear();
    update();
    notifyChildrens();
  }

  void setcheckboxnoti() async {
    allcheck = true;
    checkboxnoti.clear();
    checkboxnoti = List.filled(listad.length, true, growable: true);
    update();
    notifyChildrens();
  }

  void resetcheckboxnoti() async {
    allcheck = false;
    checkboxnoti.clear();
    checkboxnoti = List.filled(listad.length, false, growable: true);
    update();
    notifyChildrens();
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
    if (init) {
      update();
      notifyChildrens();
    } else {}
  }

  void checknoti(List a) async {
    checkread = a;
    update();
    notifyChildrens();
  }

  void updatenoti(String id) async {
    firestore.collection('AppNoticeByUsers').doc(id).update({'read': 'yes'});
    update();
    notifyChildrens();
  }
}
