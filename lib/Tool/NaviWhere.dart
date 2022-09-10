import 'package:hive_flutter/hive_flutter.dart';

int NaviWhere() {
  int navi = 0;
  Hive.box('user_setting').get('which_menu_pick') == null
      ? navi = 1
      : (Hive.box('user_setting').get('which_menu_pick') == 0
          ? navi = 0
          : navi = 1);
  return navi;
}
