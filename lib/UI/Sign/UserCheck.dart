import 'dart:async';
import 'package:clickbyme/Sub/DayLog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../../Page/LoginSignPage.dart';
import '../../route.dart';

GoToMain(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const MyHomePage(
          title: 'BOnd',
          index: 0,
        ),
      ),
    );
    Hive.box('user_setting').put('page_index', 0);
  });
  return _time;
}

GoToLogin(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginSignPage()));
  });

  return _time;
}

GoToDayLog(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: DayLog(),
      ),
    );
  });
  return _time;
}
