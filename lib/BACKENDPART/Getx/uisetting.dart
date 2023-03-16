// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/PageList.dart';
import '../Enums/Variables.dart';

class uisetting extends GetxController {
  bool loading = false;
  bool sheetloading = false;
  bool canchange = true;
  bool isfilledtextfield = true;
  int profileindex = 0;
  List profilescreen = [];
  List<String> licenses_title = List.empty(growable: true);
  List<String> licenses_content = List.empty(growable: true);
  int pagenumber = 0;
  bool showtopbutton = false;
  List updateid = [];
  List<PageList> pagelist = [];
  List<PageList> searchpagelist = [];
  List<PageList> favorpagelist = [];
  List<PageList> editpagelist = [];
  List<PageviewList> pageviewlist = [];
  int searchindex = -1;
  int favorindex = -1;
  int mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
  String searchpagemove = '';
  String textrecognizer = '';

  ///setloading
  ///
  ///모든 UI상에서 로딩중인지를 판단하는 데에 사용된다.
  void setloading(bool what, int i) {
    if (i == 0) {
      loading = what;
    } else {
      sheetloading = what;
    }

    update();
    notifyChildrens();
  }

  ///changeavailable
  ///
  ///변경 가능 시 아래에 띄워준다.
  void changeavailable(bool what) {
    canchange = what;
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

  void seteditpage(String what, String username, String id, String setting) {
    searchpagemove = what;
    editpagelist.add(
        PageList(title: what, username: username, id: id, setting: setting));
    Hive.box('user_setting').put('currenteditpage', what);
    update();
    notifyChildrens();
  }

  void setmypagelistindex(int what) {
    Hive.box('user_setting').put('currentmypage', what);
    mypagelistindex = what;
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

  ///setuserspace
  ///
  ///유저의 페이지를 생성시키는데 사용된다.
  void setuserspace({init = true}) async {
    await firestore.collection('Pinchannel').get().then((value) async {
      updateid.clear();
      pagelist.clear();
      for (var element in value.docs) {
        if (element.data()['username'] ==
            Hive.box('user_setting').get('usercode')) {
          updateid.add(element.data()['linkname']);
          pagelist.add(PageList(
              title: element.data()['linkname'],
              id: element.id,
              setting: element.data()['setting']));
        }
      }
      if (updateid.isEmpty) {
        await firestore.collection('Pinchannel').add({
          'username': Hive.box('user_setting').get('usercode'),
          'nick': appnickname,
          'linkname': '빈 스페이스',
          'setting': 'block'
        }).then((value1) {
          pagelist
              .add(PageList(title: '빈 스페이스', id: value1.id, setting: 'block'));
        });
      }
    }).whenComplete(() {
      if (init) {
        loading = false;
      }
    });

    update();
    notifyChildrens();
  }

  ///setprofilespace
  ///
  ///프로필페이지에서 컨테이너공간을 만드는데 사용된다.
  void setprofilespace({init = false}) async {
    List listopt = [
      Icons.tune,
      MaterialCommunityIcons.ab_testing,
      Icons.portrait
    ];
    List title = [
      'profilepagetitleone',
      'profilepagetitletwo',
      'profilepagetitlethird',
    ];
    List subtitles = [
      Get.width > 1000
          ? [
              'profilepagetitleonebyone',
              'profilepagetitleonebytwo',
              'profilepagetitleonebythird',
              'profilepagetitleonebyforth',
            ]
          : [
              'profilepagetitleonebyone',
              'profilepagetitleonebytwo',
            ],
      [
        'profilepagetitletwobyone',
      ],
      [
        'profilepagetitlethirdbyone',
        'profilepagetitlethirdbytwo',
        'profilepagetitlethirdbythird',
        'profilepagetitlethirdbyforth',
      ],
    ];
    profilescreen.clear();
    for (int i = 0; i < 3; i++) {
      profilescreen.add(Profile_item(
          icondata: listopt[i], title: title[i], subtitles: subtitles[i]));
    }
    if (init) {
      update();
      notifyChildrens();
    } else {}
  }

  void setlicense(String title, String content) async {
    licenses_title.insert(0, title);
    licenses_content.insert(0, content);
    update();
    notifyChildrens();
  }
}
