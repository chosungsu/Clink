import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class calendarthemesetting extends GetxController {
  int themecalendar = Hive.box('user_setting').get('origorpastel') ?? 0;

  void themecals1() {
    themecalendar = 0;
    Hive.box('user_setting').put('origorpastel', 0);
    update();
    notifyChildrens();
  }
  void themecals2() {
    themecalendar = 1;
    Hive.box('user_setting').put('origorpastel', 1);
    update();
    notifyChildrens();
  }
}