import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Page/LoginSignPage.dart';
import '../route.dart';

UserCheck(BuildContext context) {

}
ChangeLoading(BuildContext context) {
  FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData == false) {
        return const Text(
          '로그인 페이지 이동 중...',
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        );
      }
      else {
        //String name = snapshot.data.toString().split("/")[1];
        //String email = snapshot.data.toString().split("/")[3];
        //return success(name, email, context);
        return const Text(
          '어서오세요',
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        );
      }
    },
    future: issuccess(context),
  );
}
GoToMain (BuildContext context){
  Timer? _time = Timer(const Duration(seconds: 0), (){
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const MyHomePage(title: 'SuChip'),
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