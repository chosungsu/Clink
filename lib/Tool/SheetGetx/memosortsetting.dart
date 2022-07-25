import 'package:get/get.dart';

class memosortsetting extends GetxController {
  int memosort = 0;

  void sort1() {
    memosort = 0;
    update();
    notifyChildrens();
  }
  void sort2() {
    memosort = 1;
    update();
    notifyChildrens();
  }
}