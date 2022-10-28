import 'package:clickbyme/Tool/AndroidIOS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void pressed1() {
  Hive.box('user_info').get('autologin') == false
      ? Hive.box('user_info').delete('id')
      : null;
  SystemNavigator.pop();
}

void pressed2() {
  Get.back(result: true);
}
