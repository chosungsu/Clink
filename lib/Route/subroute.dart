import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../Page/LoginSignPage.dart';
import 'mainroute.dart';

void pressed1() {
  Hive.box('user_info').get('autologin') == false
      ? Hive.box('user_info').delete('id')
      : null;
  SystemNavigator.pop();
}

void pressed2() {
  Get.back(result: true);
}

GoToMain(BuildContext context) async {
  //await initScreen();
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => mainroute(index: 0), transition: Transition.leftToRight);
    Hive.box('user_setting').put('page_index', 0);
  });
  return _time;
}

GoToLogin(BuildContext context, String s) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => LoginSignPage(first: s));
    /*Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginSignPage()));*/
  });

  return _time;
}
