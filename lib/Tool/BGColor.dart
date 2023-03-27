// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../BACKENDPART/Getx/navibool.dart';

final navi = Get.put(navibool());

Color BGColor() {
  Color color_bg = Colors.white;
  navi.backgroundcolor == MyTheme.colorWhite
      ? color_bg = MyTheme.colorWhite
      : color_bg = MyTheme.colorblack;
  return color_bg;
}

Color BGColor_shadowcolor() {
  Color color_bgstatus = Colors.white;
  navi.backgroundcolor == MyTheme.colorWhite
      ? color_bgstatus = MyTheme.colorWhitestatus
      : color_bgstatus = MyTheme.colorblackstatus;
  return color_bgstatus;
}

Color ButtonColor() {
  Color color_btn = Colors.blue;
  return color_btn;
}

Color TextColor() {
  Color color_text = Colors.white;
  navi.backgroundcolor == MyTheme.colorblack
      ? color_text = MyTheme.colorblack
      : color_text = MyTheme.colorWhite;
  return color_text;
}

Color TextColor_shadowcolor() {
  Color color_textstatus = Colors.white;
  navi.backgroundcolor == MyTheme.colorblack
      ? color_textstatus = MyTheme.colorblackstatus
      : color_textstatus = MyTheme.colorWhitestatus;
  return color_textstatus;
}
