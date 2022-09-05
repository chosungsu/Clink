import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Page/LoginSignPage.dart';
import '../../route.dart';

GoToMain(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    /*Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const MyHomePage(
          index: 0,
        ),
      ),
    );*/
    Get.to(
      () => const MyHomePage(
        index: 0,
      ),
    );
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
