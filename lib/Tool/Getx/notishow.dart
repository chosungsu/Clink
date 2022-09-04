import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../DB/PageList.dart';

class notishow extends GetxController {
  List listad = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void setnoti(String a, String b) async {
    listad.add(PageList(title: a, sub: b));
    update();
    notifyChildrens();
  }

  void resetnoti() async {
    listad.clear();
    update();
    notifyChildrens();
  }
}
