// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../MyTheme.dart';

class navibool extends GetxController {
  bool drawopen = Hive.box('user_setting').get('page_opened') ?? false;
  int currentpage = 1;
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  int navi = Hive.box('user_setting').get('which_menu_pick') ?? 1;
  Color backgroundcolor =
      Hive.box('user_setting').get('which_color_background') == null
          ? MyTheme.colorWhite
          : (Hive.box('user_setting').get('which_color_background') == 0
              ? MyTheme.colorWhite
              : MyTheme.colorblack);
  Color color_textstatus =
      Hive.box('user_setting').get('which_color_background') == null
          ? MyTheme.colorblack_drawer
          : (Hive.box('user_setting').get('which_color_background') == 0
              ? MyTheme.colorblack_drawer
              : MyTheme.colorWhite_drawer);
  var color_navi;

  void setpagecurrent(int what) {
    currentpage = what;
    update();
    notifyChildrens();
  }

  void setopen() {
    if (navi == 0) {
      xoffset = 80;
    } else {
      xoffset = -80;
    }
    yoffset = 0;
    scalefactor = 1;
    drawopen = true;
    Hive.box('user_setting').put('page_opened', drawopen);
    update();
    notifyChildrens();
  }

  void setclose() {
    xoffset = 0;
    yoffset = 0;
    scalefactor = 1;
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
        ? backgroundcolor = MyTheme.colorWhite
        : (Hive.box('user_setting').get('which_color_background') == 0
            ? backgroundcolor = MyTheme.colorWhite
            : backgroundcolor = MyTheme.colorblack);

    Hive.box('user_setting').get('which_color_background') == null
        ? color_textstatus = MyTheme.colorblack_drawer
        : (Hive.box('user_setting').get('which_color_background') == 0
            ? color_textstatus = MyTheme.colorblack_drawer
            : color_textstatus = MyTheme.colorWhite_drawer);
    StatusBarControl.setColor(backgroundcolor, animated: true);
    update();
    notifyChildrens();
  }
}
