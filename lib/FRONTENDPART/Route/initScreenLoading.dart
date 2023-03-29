// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:clickbyme/BACKENDPART/Api/LicenseApi.dart';
import 'package:clickbyme/BACKENDPART/Api/LoginApi.dart';
import 'package:clickbyme/BACKENDPART/Getx/navibool.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../BACKENDPART/Api/PageApi.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

Future initScreen() async {
  final peopleadd = Get.put(UserInfo());
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final navi = Get.put(navibool());
  final box = GetStorage();
  /**
  * checkusrinfo : user 정보를 기기에서 읽어옴.
  */
  peopleadd.checkusrinfo();
  /**
  * fetchTasks : user 정보를 백엔드에서 불러옴.
  */
  await LoginApiProvider().fetchTasks();
  /**
   * licenselist를 생성함.
   */
  LicenseApiProvider().createTasks();
  if (box.read('nick') == '' || box.read('nick') == null) {
    /**
     * createTasks : name, usercode, licenselist를 생성함.
     */
    LoginApiProvider().createTasks();
  } else {}
  /**
  * getTasks : user의 alllist를 생성함.
  */
  PageApiProvider().getTasks();
  /**
  * setappbox : app의 색상을 지정해줌.
  */
  navi.setappbox();
  /**
  * setprofilespace : profile 공간을 생성함.
  */
  uiset.setprofilespace(init: true);
  /**
  * setuserspace : pinchannel db에서 page contents를 로드함(존재하지 않는 경우 : default값).
  */
  uiset.setuserspace(init: true);
}
