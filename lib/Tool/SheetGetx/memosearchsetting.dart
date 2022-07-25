import 'package:get/get.dart';

class memosearchsetting extends GetxController {
  int memosearch = 0;

  void setmemo1() {
    memosearch = 0;
    update();
    notifyChildrens();
  }
  void setmemo2() {
    memosearch = 1;
    update();
    notifyChildrens();
  }
  void setmemo3() {
    memosearch = 2;
    update();
    notifyChildrens();
  }
}