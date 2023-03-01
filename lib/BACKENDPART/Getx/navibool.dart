// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../Tool/MyTheme.dart';

class navibool extends GetxController {
  bool drawopen = Hive.box('user_setting').get('page_opened') ?? false;
  bool drawnoticeopen =
      Hive.box('user_setting').get('noticepage_opened') ?? false;
  int currentpage = 1;
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool navishow = Hive.box('user_setting').get('menushowing') ?? true;
  int navi = Hive.box('user_setting').get('which_menu_pick') ?? 0;
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

  void setpagecurrent(int what) {
    currentpage = what;
    update();
    notifyChildrens();
  }

  void setopennoti() {
    drawnoticeopen = true;
    Hive.box('user_setting').put('noticepage_opened', drawnoticeopen);
    update();
    notifyChildrens();
  }

  void setclosenoti() {
    drawnoticeopen = false;
    Hive.box('user_setting').put('noticepage_opened', drawnoticeopen);
    update();
    notifyChildrens();
  }

  void setopen() {
    if (navishow) {
    } else {
      if (navi == 0) {
        xoffset = 120;
      } else {
        xoffset = -120;
      }
      yoffset = 0;
      scalefactor = 1;
      drawopen = true;
      Hive.box('user_setting').put('page_opened', drawopen);
    }

    update();
    notifyChildrens();
  }

  void setclose() {
    if (navishow) {
    } else {
      xoffset = 0;
      yoffset = 0;
      scalefactor = 1;
      drawopen = false;
      Hive.box('user_setting').put('page_opened', drawopen);
    }

    update();
    notifyChildrens();
  }

  void setnavi(int what) {
    navi = what;
    Hive.box('user_setting').put('which_menu_pick', what);
    if (navishow) {
      setopen();
    } else {
      setclose();
    }

    update();
    notifyChildrens();
  }

  void setnavicolor() {
    ///setnavicolor
    ///
    ///바탕색을 결정
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

  void setts(int what) {
    ///setts
    ///
    ///글자 크기를 결정
    Hive.box('user_setting').put('which_text_size', what);
    update();
    notifyChildrens();
  }

  void setmenushowing(bool what) {
    ///setmenushowing
    ///
    ///메뉴 보이기를 결정
    Hive.box('user_setting').put('menushowing', what);
    navishow = what;
    if (what) {
      setopen();
    } else {
      setclose();
    }
    update();
    notifyChildrens();
  }
}
