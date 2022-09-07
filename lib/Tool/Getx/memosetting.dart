import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../BGColor.dart';

class memosetting extends GetxController {
  Color color = Hive.box('user_setting').get('coloreachmemo') != null
      ? Color(Hive.box('user_setting').get('coloreachmemo'))
      : Colors.white;
  int memosort = 0;
  bool ischeckedtohideminus = false;
  List imagelist = [];
  int imageindex = 0;
  int sort = Hive.box('user_setting').get('sort_memo_card') ?? 0;

  void setsortmemo(int sortnum) {
    Hive.box('user_setting').put('sort_memo_card', sortnum);
    sort = Hive.box('user_setting').get('sort_memo_card');
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

  void setimagelist(String path) {
    imagelist.insert(0, path);
    imageindex++;
    update();
    notifyChildrens();
  }

  void deleteimagelist(int index) {
    imagelist.removeAt(index);
    setimageindex(index - 1);
    update();
    notifyChildrens();
  }

  void resetimagelist() {
    imagelist.clear();
    update();
    notifyChildrens();
  }

  void setimageindex(int index) {
    imageindex = index;
    update();
    notifyChildrens();
  }
}
