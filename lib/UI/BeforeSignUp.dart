import 'dart:ui';
import 'package:clickbyme/Page/LoginSignPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Sub/EcoproPage.dart';
import '../Sub/showUserSetting.dart';

showBeforeSignUp(BuildContext context) {
  //아래 변수들은 회원가입 완료한 유저분들에게 선보이는 Aindrop의 서비스목록이다.
  final List<String> itemPro = ['캠페인 참여', '구독 정보', '마이룸'];
  final List<String> itemImg = [
    'assets/images/eye-scanner.png',
    'assets/images/eye-scanner.png',
    'assets/images/eye-scanner.png'
  ];

  return Card(
    color: Colors.white,
    elevation: 4.0,
    child: Container(
      //너비는 최대너비로 생성, 높이는 자식개체만큼으로 후에 변경할것임.
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Center(
          //crossAxisAlignment: CrossAxisAlignment.start,
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              fit: FlexFit.tight,
              child: Text(
                '로그인이 필요합니다.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54,
                    letterSpacing: 2),
              ),
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white24.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: LoginSignPage(),
                            type: PageTransitionType.leftToRightWithFade));
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          '3초 로그인',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.amberAccent,
                              letterSpacing: 2),
                        ),
                        Icon(Icons.arrow_forward_ios_sharp),
                      ],
                    ),
                  )),
            )
          ],
        ),
      )),
    ),
  );
}
