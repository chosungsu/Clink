// ignore_for_file: camel_case_types

import 'package:get/get.dart';
import '../Enums/PageList.dart';
import '../Enums/Variables.dart';

class notishow extends GetxController {
  int clicker = 0;
  bool allcheck = false;
  List listappnoti = [];
  bool isread = true;
  List updateid = [];
  List checkread = [];
  List<bool> checkboxnoti = List.empty(growable: true);

  void setclicker(what) async {
    clicker = what;
    update();
    notifyChildrens();
  }

  void setnoti(String a, String b) async {
    listappnoti.add(Companynoti(title: a, content: b));
    update();
    notifyChildrens();
  }

  void resetnoti() async {
    listappnoti.clear();
    update();
    notifyChildrens();
  }

  void setcheckboxnoti() async {
    allcheck = true;
    checkboxnoti.clear();
    checkboxnoti = List.filled(listappnoti.length, true, growable: true);
    update();
    notifyChildrens();
  }

  void resetcheckboxnoti() async {
    allcheck = false;
    checkboxnoti.clear();
    checkboxnoti = List.filled(listappnoti.length, false, growable: true);
    update();
    notifyChildrens();
  }

  void isreadnoti({init = true}) async {
    await firestore.collection('AppNoticeByUsers').get().then((value) {
      updateid.clear();
      for (var element in value.docs) {
        if (element.data()['username'] == appnickname ||
            element.data()['sharename'].toString().contains(appnickname)) {
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
