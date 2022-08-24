import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class navibool extends GetxController {
  bool drawopen = Hive.box('user_setting').get('page_opened') ?? false;

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
}
