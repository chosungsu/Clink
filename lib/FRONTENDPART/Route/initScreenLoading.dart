// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:get/get.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';

Future initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());

  if (name == '') {
  } else {
    /**
     * secondnameload : user의 db에서 subname, usercode를 로드함.
     */
    peopleadd.secondnameload(init: true);
    /**
     * isreadnoti : appnoticebyusers의 db에서 read를 로드함.
     */
    notilist.isreadnoti(init: true);
    /**
     * setuserspace : pinchannel db에서 page contents를 로드함(존재하지 않는 경우 : default값).
     */
    uiset.setuserspace(init: true);
    /**
     * setuserspace : pinchannel db에서 page contents를 로드함(존재하지 않는 경우 : default값).
     */
    uiset.setprofilespace(init: true);
  }
}
