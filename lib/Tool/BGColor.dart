// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Color BGColor() {
  Color color_bg = Colors.white;
  Hive.box('user_setting').get('which_color_background') == null
      ? color_bg = MyTheme.colorWhite
      : (Hive.box('user_setting').get('which_color_background') == 0
          ? color_bg = MyTheme.colorWhite
          : color_bg = MyTheme.colorblack);
  return color_bg;
}

Color BGColor_shadowcolor() {
  Color color_bgstatus = Colors.white;
  Hive.box('user_setting').get('which_color_background') == null
      ? color_bgstatus = MyTheme.colorWhitestatus
      : (Hive.box('user_setting').get('which_color_background') == 0
          ? color_bgstatus = MyTheme.colorWhitestatus
          : color_bgstatus = MyTheme.colorblackstatus);
  return color_bgstatus;
}

Color ButtonColor() {
  Color color_btn = Colors.blue;
  return color_btn;
}

Color StatusColor() {
  Color color_status = Colors.white60;
  Hive.box('user_setting').get('which_color_background') == null
      ? color_status = MyTheme.colorWhitestatus
      : (Hive.box('user_setting').get('which_color_background') == 0
          ? color_status = MyTheme.colorWhitestatus
          : color_status = MyTheme.colorblackstatus);
  return color_status;
}

Color TextColor() {
  Color color_text = Colors.white;
  Hive.box('user_setting').get('which_color_background') == null
      ? color_text = MyTheme.colorblack
      : (Hive.box('user_setting').get('which_color_background') == 0
          ? color_text = MyTheme.colorblack
          : color_text = MyTheme.colorWhite);
  return color_text;
}

Color TextColor_shadowcolor() {
  Color color_textstatus = Colors.white;
  Hive.box('user_setting').get('which_color_background') == null
      ? color_textstatus = MyTheme.colorblackstatus
      : (Hive.box('user_setting').get('which_color_background') == 0
          ? color_textstatus = MyTheme.colorblackstatus
          : color_textstatus = MyTheme.colorWhitestatus);
  return color_textstatus;
}

Color NaviColor(bool select) {
  Color color_navi = Colors.white;
  select == true
      ? (Hive.box('user_setting').get('which_color_background') == null
          ? color_navi = MyTheme.colorselected_drawer
          : (Hive.box('user_setting').get('which_color_background') == 0
              ? color_navi = MyTheme.colorselected_drawer
              : color_navi = MyTheme.colorselected_black_drawer))
      : (Hive.box('user_setting').get('which_color_background') == null
          ? color_navi = MyTheme.colornotselected_drawer
          : (Hive.box('user_setting').get('which_color_background') == 0
              ? color_navi = MyTheme.colornotselected_drawer
              : color_navi = MyTheme.colornotselected_black_drawer));
  return color_navi;
}
