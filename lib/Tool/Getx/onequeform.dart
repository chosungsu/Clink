import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../DB/SpaceList.dart';

class onequeform extends GetxController {
  int cnt = Hive.box('user_setting').get('count_formcard') ?? 5;
  DateTime dt = DateTime.now();

  void setcnt() {
    cnt = Hive.box('user_setting').get('count_formcard') ?? 5;
    //cnt = 5;

    update();
    notifyChildrens();
  }

  void minuscnt() {
    cnt--;
    Hive.box('user_setting').put('count_formcard', cnt);
    print('minusresult ' + cnt.toString());
    update();
    notifyChildrens();
  }

  void setresetcnt() {
    dt.hour == 0 && dt.minute == 0
        ? cnt = 5
        : cnt = Hive.box('user_setting').get('count_formcard') ?? 5;
    Hive.box('user_setting').put('count_formcard', cnt);
    print('reset ' + cnt.toString());
    update();
    notifyChildrens();
  }
}
