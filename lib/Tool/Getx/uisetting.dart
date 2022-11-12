// ignore_for_file: camel_case_types

import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class uisetting extends GetxController {
  bool loading = false;
  int pagenumber = 0;
  bool showtopbutton = false;
  String eventtitle = '';
  String eventurl = '';
  List<PageList> pagelist = [];
  List<PageList> searchpagelist = [];
  List<PageList> favorpagelist = [];
  int mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
  int currentstepper = 0;
  String usercode = Hive.box('user_setting').get('usercode');

  void setloading(bool what) {
    loading = what;
    update();
    notifyChildrens();
  }

  void setmypagelistindex(int what) {
    Hive.box('user_setting').put('currentmypage', what);
    mypagelistindex = what;
    update();
    notifyChildrens();
  }

  void setstepperindex(int what) {
    currentstepper = what;
    update();
    notifyChildrens();
  }

  void setpageindex(int what) {
    pagenumber = what;
    update();
    notifyChildrens();
  }

  void settopbutton(bool what) {
    showtopbutton = what;
    update();
    notifyChildrens();
  }

  void seteventspace(String title, String url) {
    eventtitle = title;
    eventurl = url;
    update();
    notifyChildrens();
  }

  void setuserspace(String title, String user) {
    pagelist.add(PageList(title: title, username: user));
    update();
    notifyChildrens();
  }

  void setsearchspace(String title, String user) {
    searchpagelist.add(PageList(title: title, username: user));
    update();
    notifyChildrens();
  }

  void setfavorspace(String title, String user) {
    favorpagelist.add(PageList(title: title, username: user));
    update();
    notifyChildrens();
  }
}
