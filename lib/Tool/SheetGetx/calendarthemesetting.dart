import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class calendarthemesetting extends GetxController {
  int themecalendar = 0;

  void themecals1() {
    themecalendar = 0;
    update();
    notifyChildrens();
  }
  void themecals2() {
    themecalendar = 1;
    update();
    notifyChildrens();
  }
}