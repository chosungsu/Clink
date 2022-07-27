import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../DB/SpaceList.dart';

class Spacesetting extends GetxController {
  List def_space = [
    '날씨공간',
    '일정공간',
    '루틴공간',
    '메모공간',
    '운동공간'
  ];
  List space = [];

  void setspace() {
    space = Hive.box('user_setting').get('space_name') ?? def_space;
    update();
    notifyChildrens();
  }
}