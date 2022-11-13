// ignore_for_file: camel_case_types

import 'package:clickbyme/DB/PageList.dart';
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
  List<PageList> editpagelist = [];
  int searchindex = 0;
  int favorindex = 0;
  int mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
  int currentstepper = 0;
  String searchpagemove = '';
  String usercode = Hive.box('user_setting').get('usercode');

  void setloading(bool what) {
    loading = what;
    update();
    notifyChildrens();
  }

  void setsearchpageindex(int index) {
    searchindex = index;
    update();
    notifyChildrens();
  }

  void setfavorpageindex(int index) {
    favorindex = index;
    update();
    notifyChildrens();
  }

  void seteditpage(String what, String username, String email) {
    searchpagemove = what;
    editpagelist.add(PageList(title: what, email: email, username: username));
    Hive.box('user_setting').put('currenteditpage', what);
    update();
    notifyChildrens();
  }

  void setsearchpage(String what, String username, String email) {
    searchpagemove = what;
    searchpagelist.add(PageList(title: what, email: email, username: username));
    update();
    notifyChildrens();
  }

  void resetsearchpage() {
    searchpagelist.clear();
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

  void setuserspace(String title, String user, String email) {
    pagelist.add(PageList(title: title, username: user, email: email));
    update();
    notifyChildrens();
  }

  void setfavorspace(String title, String user, String email) {
    searchpagemove = title;
    favorpagelist.add(PageList(title: title, username: user, email: email));
    update();
    notifyChildrens();
  }

  void resetfavorpage() {
    favorpagelist.clear();
    update();
    notifyChildrens();
  }
}
