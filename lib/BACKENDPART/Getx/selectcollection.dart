import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class selectcollection extends GetxController {
  var collection = Hive.box('user_setting').get('memocollection') ?? '';
  var memoindex = 0;
  List collectionlink = List.empty(growable: true);
  List memolistin = List.empty(growable: true);
  List memolistcontentin = List.empty(growable: true);
  int cursornow = 0;
  List<TextEditingController> controllersall = [];

  void setcursor() {
    cursornow = Hive.box('user_setting').get('cursorposition');
    update();
    notifyChildrens();
  }

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

  void addmemolist(int length) {
    memoindex += length;
    update();
    notifyChildrens();
  }

  void resetcollectionlink() {
    collectionlink.clear();
    update();
    notifyChildrens();
  }

  void addmemolistlink(String str) {
    collectionlink.add(str);
    update();
    notifyChildrens();
  }

  void addmemolistin(int index) {
    memolistin.insert(index, Hive.box('user_setting').get('optionmemoinput'));
    memoindex++;
    update();
    notifyChildrens();
  }

  void addmemolistcontentin(int index) {
    String str = '';
    Hive.box('user_setting').get('optionmemocontentinput') == null
        ? str = ''
        : str = Hive.box('user_setting').get('optionmemocontentinput');

    memolistcontentin.insert(index, str);
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
    memolistcontentin.removeAt(index);
    memoindex--;
    update();
    notifyChildrens();
  }

  void resetmemolist() {
    memoindex = 0;
    memolistin.clear();
    memolistcontentin.clear();
    update();
    notifyChildrens();
  }

  void addmemotextfield() {
    print(controllersall.length);
    controllersall.insert(controllersall.length, TextEditingController());
    update();
    notifyChildrens();
  }
}
