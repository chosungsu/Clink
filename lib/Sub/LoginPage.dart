import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../route.dart';

issuccess(BuildContext context) async {
  String? userInfo = "", userInfo2 = "";
  final storage = FlutterSecureStorage();
  userInfo = await storage.read(
      key: "google_login"
  );
  userInfo2 = await storage.read(
      key: "kakao_login"
  );
  if (userInfo != null && userInfo2 == null) {
    return userInfo;
  } else if (userInfo2 != null && userInfo == null) {
    return userInfo2;
  } else {
    return userInfo;
  }
}

Timer timer(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 3), (){
    Navigator.of(context).pushReplacement(
      PageTransition(
        type: PageTransitionType.topToBottom,
        child: const MyHomePage(title: 'SuChip'),
      ),
    );
  });
  return _time;
}
success(String name, String email, BuildContext context){
  timer(context);
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2// bold
              ),
            ),
            const Text(
              '님',
              style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 3// bold
              ),
            ),
          ],
        ),
        const Text(
          '로그인이 정상적으로 완료되었습니다 :)',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        ),
        const SpinKitFadingCircle(
          color: Colors.greenAccent,
        ),
        const Text(
          '약 3초 후 메인화면으로 이동합니다.\n잠시만 기다려주세요~',
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        ),

      ],
    ),
  );
}
