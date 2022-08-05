import 'package:get/get.dart';

class calendarshowsetting extends GetxController {
  int showcalendar = 0;

  void setcals1w() {
    showcalendar = 0;
    update();
    notifyChildrens();
  }

  void setcals2w() {
    showcalendar = 1;
    update();
    notifyChildrens();
  }

  void setcals1m() {
    showcalendar = 2;
    update();
    notifyChildrens();
  }
}
