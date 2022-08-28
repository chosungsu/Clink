import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../BGColor.dart';

class memosetting extends GetxController {
  Color color = Hive.box('user_setting').get('coloreachmemo') != null
      ? Color(Hive.box('user_setting').get('coloreachmemo'))
      : BGColor();
  int memosort = 0;
  bool ischeckedtohideminus = false;

  void sort1() {
    memosort = 0;
    update();
    notifyChildrens();
  }

  void sort2() {
    memosort = 1;
    update();
    notifyChildrens();
  }

  void setcolor() {
    color = Color(Hive.box('user_setting').get('coloreachmemo'));
    update();
    notifyChildrens();
  }

  void sethideminus(bool b) {
    ischeckedtohideminus = b;
    update();
    notifyChildrens();
  }
}
