// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:flutter/material.dart';
import '../../sheets/Mainpage/appbarpersonalbtn.dart';

SettingThirdpage() {
  ///실험실 내부 공간 조성
}

SPIconclick(
  context,
  textcontroller,
  searchnode,
) {
  Widget title;
  Widget content;
  title = Widgets_settingpageiconclick(context, textcontroller, searchnode)[0];
  content =
      Widgets_settingpageiconclick(context, textcontroller, searchnode)[1];
  AddContent(context, title, content, searchnode);
}
