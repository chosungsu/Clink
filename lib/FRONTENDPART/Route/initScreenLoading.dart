// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:clickbyme/BACKENDPART/Api/LoginApi.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Api/NoticeApi.dart';
import '../../BACKENDPART/FIREBASE/SettingVP.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

Future initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());

  if (Hive.box('user_setting').get('usercode') == '') {
    /**
     * createTasks : user의 name, usercode를 생성함.
     */
    LoginApiProvider().createTasks();
  } else {}
  /**
  * fetchTasks : user 정보를 백엔드에서 불러옴.
  */
  LoginApiProvider().fetchTasks();
  /**
  * friendset : user의 friendlist를 생성함.
  */
  peopleadd.friendset();
  /**
  * setprofilespace : profile 공간을 생성함.
  */
  uiset.setprofilespace(init: true);
  Settinglicensepage();
  /**
  * setuserspace : pinchannel db에서 page contents를 로드함(존재하지 않는 경우 : default값).
  */
  uiset.setuserspace(init: true);
}
