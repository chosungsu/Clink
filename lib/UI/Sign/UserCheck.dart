import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Page/LoginSignPage.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../route.dart';

GoToMain(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 0), () {
    Get.to(() => MyHomePage(index: 0), transition: Transition.leftToRight);
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
