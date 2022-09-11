import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../MyTheme.dart';

class navibool extends GetxController {
  bool drawopen = Hive.box('user_setting').get('page_opened') ?? false;
  int navi = Hive.box('user_setting').get('which_menu_pick') ?? 1;
  Color color =
      Hive.box('user_setting').get('which_color_background') ?? Colors.white;

  void setopen() {
    drawopen = true;
    Hive.box('user_setting').put('page_opened', drawopen);
    update();
    notifyChildrens();
  }

  void setclose() {
    drawopen = false;
    Hive.box('user_setting').put('page_opened', drawopen);
    update();
    notifyChildrens();
  }

  void setnavi() {
    Hive.box('user_setting').get('which_menu_pick') == null
        ? navi = 1
        : (Hive.box('user_setting').get('which_menu_pick') == 0
            ? navi = 0
            : navi = 1);
    update();
    notifyChildrens();
  }

  void setnavicolor() {
    Hive.box('user_setting').get('which_color_background') == null
        ? color = MyTheme.colorWhite
        : (Hive.box('user_setting').get('which_color_background') == 0
            ? color = MyTheme.colorWhite
            : color = MyTheme.colorblack);
    update();
    notifyChildrens();
  }
}
