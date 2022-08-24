import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PeopleAdd extends GetxController {
  List people = [];

  void peoplecalendar() {
    people = Hive.box('user_setting').get('share_cal_person');
    update();
    notifyChildrens();
  }

  void peoplecalendarrestart() {
    Hive.box('user_setting').put('share_cal_person', '');
    people = [];
    update();
    notifyChildrens();
  }
}
