// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../BGColor.dart';

class linkspacesetting extends GetxController {
  List spacelink = [];
  List indexcnt = [];
  List indextreecnt = [];
  bool iscompleted = false;
  Color color = Hive.box('user_setting').get('colorlinkpage') != null
      ? Color(Hive.box('user_setting').get('colorlinkpage'))
      : BGColor();

  void setspacelink(String title) {
    spacelink.add(title);
    update();
    notifyChildrens();
  }

  void resetspacelink() {
    spacelink.clear();
    update();
    notifyChildrens();
  }

  void setcompleted(bool what) {
    iscompleted = what;
    update();
    notifyChildrens();
  }

  void resetcompleted() {
    iscompleted = false;
    update();
    notifyChildrens();
  }

  void setcolor() {
    color = Color(Hive.box('user_setting').get('colorlinkpage'));
    update();
    notifyChildrens();
  }

  void setspacein(dynamic dynamics) {
    indexcnt.add(dynamics);
    update();
    notifyChildrens();
  }

  void setspecificspacein(int index, dynamic dynamics) {
    indexcnt.insert(index, dynamics);
    update();
    notifyChildrens();
  }

  void minusspacein(int index) {
    indexcnt.removeAt(index);
    update();
    notifyChildrens();
  }

  void setspacetreein(dynamic dynamics) {
    indextreecnt.add(dynamics);
    update();
    notifyChildrens();
  }

  void setspecificspacetreein(int index, dynamic dynamics) {
    indextreecnt.insert(index, dynamics);
    update();
    notifyChildrens();
  }

  void minusspacetreein(int index) {
    indextreecnt.removeAt(index);
    update();
    notifyChildrens();
  }
}