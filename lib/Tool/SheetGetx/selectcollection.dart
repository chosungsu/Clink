import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class selectcollection extends GetxController {
  var collection = Hive.box('user_setting').get('memocollection') ?? '';

  void setcollection() {
    collection = Hive.box('user_setting').get('memocollection');
    update();
    notifyChildrens();
  }

  void resetcollection() {
    collection = '';
    update();
    notifyChildrens();
  }
}
