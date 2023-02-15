// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:get/get.dart';
import '../../Enums/Variables.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

Future initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());

  if (usercode == '') {
    /**
     * usercodeset : user의 name, usercode를 생성함.
     */
    peopleadd.usercodeset();
  } else {}
  /**
  * friendset : user의 friendlist를 생성함.
  */
  peopleadd.friendset();
  /**
  * isreadnoti : appnoticebyusers의 db에서 read를 로드함.
  */
  notilist.isreadnoti(init: true);
  /**
  * setuserspace : pinchannel db에서 page contents를 로드함(존재하지 않는 경우 : default값).
  */
  uiset.setuserspace(init: true);
  /**
  * setprofilespace : profile 공간을 생성함.
  */
  uiset.setprofilespace(init: true);
}
