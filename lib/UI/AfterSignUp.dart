import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transition/transition.dart';

import '../Sub/EcoproPage.dart';
import '../Sub/showUserSetting.dart';

showAfterSignUp(
    String name, String email, String whatlogin, BuildContext context) {
  //아래 변수들은 회원가입 완료한 유저분들에게 선보이는 Aindrop의 서비스목록이다.
  final List<String> itemPro = ['캠페인 참여', '구독 정보', '마이룸'];
  final List<String> itemImg = [
    'assets/images/eye-scanner.png',
    'assets/images/eye-scanner.png',
    'assets/images/eye-scanner.png'
  ];
  var logged = "";

  switch (whatlogin) {
    case "1":
      logged = "Google 유저인증";
      break;
    case "2":
      logged = "카카오 유저인증";
      break;
  }
  return Card(
    color: Colors.blue.shade100,
    elevation: 4.0,
    child: Container(
      //너비는 최대너비로 생성, 높이는 자식개체만큼으로 후에 변경할것임.
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Center(
        //crossAxisAlignment: CrossAxisAlignment.start,
        child: InkWell(
            onTap: () {
              //개인정보 페이지로 이동
              Navigator.push(
                  context,
                  PageTransition(
                      child: showUserSetting(
                          name: name, email: email, login: logged),
                      type: PageTransitionType.leftToRightWithFade));
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          new Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 2),
                          ),
                          const Text(
                            '님 안녕하세요',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey,
                                letterSpacing: 2),
                          ),
                        ],
                      )),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            )),
      ),
    ),
  );
}
