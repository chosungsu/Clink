import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Page/LoginSignPage.dart';
import '../route.dart';


GoToMain (BuildContext context){
  Timer? _time = Timer(const Duration(seconds: 0), (){
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const MyHomePage(title: 'HabitMind'),
      ),
    );
  });
  return _time;
}
GoToLogin (BuildContext context){
  Timer? _time = Timer(const Duration(seconds: 0), (){
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const LoginSignPage(),
      ),
    );
  });
  return _time;
}