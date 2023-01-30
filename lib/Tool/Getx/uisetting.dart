// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:clickbyme/Enums/Profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';

class uisetting extends GetxController {
  bool loading = false;
  bool isfilledtextfield = true;
  int profileindex = 0;
  List profilescreen = [];
  List<String> licenses_title = List.empty(growable: true);
  List<String> licenses_content = List.empty(growable: true);
  int pagenumber = 0;
  bool showtopbutton = false;
  String eventtitle = '';
  String eventurl = '';
  List updateid = [];
  List<PageList> pagelist = [];
  List<PageList> searchpagelist = [];
  List<PageList> favorpagelist = [];
  List<PageList> editpagelist = [];
  List<PageviewList> pageviewlist = [];
  int searchindex = 0;
  int favorindex = 0;
  int mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
  int currentstepper = 0;
  String searchpagemove = '';
  String textrecognizer = '';

  ///setloading
  ///
  ///모든 UI상에서 로딩중인지를 판단하는 데에 사용된다.
  void setloading(bool what) {
    loading = what;
    update();
    notifyChildrens();
  }

  ///checktf
  ///
  ///텍스트필드가 비어있는 경우 경고문구를 버튼 아래에 띄워준다.
  void checktf(bool what) {
    isfilledtextfield = what;
    update();
    notifyChildrens();
  }

  ///checkprofilepageindex
  ///
  ///프로필페이지에서 UI 변경 시에 사용된다.
  void checkprofilepageindex(int what) {
    profileindex = what;
    update();
    notifyChildrens();
  }

  void settextrecognizer(String what) {
    textrecognizer = what;
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

  void removeeditpage() {
    editpagelist.clear();
    update();
    notifyChildrens();
  }

  void seteditpage(
      String what, String username, String email, String id, String setting) {
    searchpagemove = what;
    editpagelist.add(PageList(
        title: what,
        email: email,
        username: username,
        id: id,
        setting: setting));
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

  ///setuserspace
  ///
  ///유저의 페이지를 생성시키는데 사용된다.
  void setuserspace({init = true}) async {
    await firestore.collection('Pinchannel').get().then((value) async {
      updateid.clear();
      pagelist.clear();
      for (var element in value.docs) {
        if (element.data()['username'] == usercode) {
          updateid.add(element.data()['linkname']);
          pagelist.add(PageList(
              title: element.data()['linkname'],
              id: element.id,
              setting: element.data()['setting']));
        }
      }
      if (updateid.isEmpty) {
        await firestore.collection('Pinchannel').add({
          'username': usercode,
          'linkname': '빈 스페이스',
          'email': useremail,
          'setting': 'block'
        }).then((value1) {
          pagelist
              .add(PageList(title: '빈 스페이스', id: value1.id, setting: 'block'));
        });
      }
    }).whenComplete(() {
      if (init) {
        GoToMain();
      }
    });

    update();
    notifyChildrens();
  }

  ///setprofilespace
  ///
  ///프로필페이지에서 컨테이너공간을 만드는데 사용된다.
  void setprofilespace({init = true}) async {
    List listopt = [
      Icons.tune,
      AntDesign.notification,
      MaterialCommunityIcons.ab_testing,
      MaterialCommunityIcons.account_group,
      Icons.portrait
    ];
    List title = [
      'profilepagetitleone',
      'profilepagetitletwo',
      'profilepagetitlethird',
      'profilepagetitleforth',
      'profilepagetitlefifth'
    ];
    List subtitles = [
      [
        'profilepagetitleonebyone',
        'profilepagetitleonebytwo',
        'profilepagetitleonebythird',
      ],
      [
        'profilepagetitletwobyone',
        'profilepagetitletwobytwo',
      ],
      [
        'profilepagetitlethirdbyone',
      ],
      [
        'profilepagetitleforthbyone',
      ],
      ['profilepagetitlefifthbyone', 'profilepagetitlefifthbytwo']
    ];
    for (int i = 0; i < 5; i++) {
      profilescreen.add(Profile_item(
          icondata: listopt[i], title: title[i], subtitles: subtitles[i]));
    }
    update();
    notifyChildrens();
  }

  void setlicense(String title, String content) async {
    licenses_title.insert(0, title);
    licenses_content.insert(0, content);
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
