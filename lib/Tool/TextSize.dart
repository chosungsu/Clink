import 'package:hive_flutter/hive_flutter.dart';

double mainTitleTextsize() {
  double ts = 0;
  Hive.box('user_setting').get('which_text_size') == null
      ? ts = 25
      : (Hive.box('user_setting').get('which_text_size') == 0
          ? ts = 25
          : ts = 27);
  return ts;
}

double secondTitleTextsize() {
  double ts = 0;
  Hive.box('user_setting').get('which_text_size') == null
      ? ts = 23
      : (Hive.box('user_setting').get('which_text_size') == 0
          ? ts = 23
          : ts = 25);
  return ts;
}

double contentTitleTextsize() {
  double ts = 0;
  Hive.box('user_setting').get('which_text_size') == null
      ? ts = 20
      : (Hive.box('user_setting').get('which_text_size') == 0
          ? ts = 20
          : ts = 22);
  return ts;
}

double contentTextsize() {
  double ts = 0;
  Hive.box('user_setting').get('which_text_size') == null
      ? ts = 18
      : (Hive.box('user_setting').get('which_text_size') == 0
          ? ts = 18
          : ts = 20);
  return ts;
}
