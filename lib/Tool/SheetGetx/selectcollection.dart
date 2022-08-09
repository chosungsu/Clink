import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class selectcollection extends GetxController {
  var collection = Hive.box('user_setting').get('memocollection') ?? '';
  var memoindex;
  List memolistin = List.empty(growable: true);

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

  void addmemolist() {
    memoindex++;
    update();
    notifyChildrens();
  }

  void addmemolistin() {
    memolistin.add(Hive.box('user_setting').get('optionmemoinput'));
    update();
    notifyChildrens();
  }

  void addmemocheckboxlist(int index) {
    memolistin[index] == 999 ? memolistin[index] = 1 : memolistin[index] = 999;
    update();
    notifyChildrens();
  }

  void removelistitem(int index) {
    memolistin.removeAt(index);
    memoindex--;
    update();
    notifyChildrens();
  }

  void resetmemolist() {
    memoindex = 0;
    memolistin.clear();
    update();
    notifyChildrens();
  }
}
