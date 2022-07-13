import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../Sub/showUserSetting.dart';
import '../../Tool/ContainerDesign.dart';

SignProfileHome(String name, String email, String whatlogin,
    BuildContext context, double height) {
  var logged = "";

  switch (whatlogin) {
    case "1":
      logged = "Google 유저인증";
      break;
    case "2":
      logged = "카카오 유저인증";
      break;
  }
  /*
    id값이 있다는 의미는 로그인하였다는 것, 그 반대는 미로그인 상태인 것
  */
  return Hive.box('user_info').get('id') != null ? 
  Column(
    children: [
      SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade400,
              //backgroundImage: AssetImage('assets/images/book.png'),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.amber.shade400, shape: BoxShape.circle),
                child: Icon(
                  Icons.edit,
                  color: Colors.black45,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 30,
        child: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
              letterSpacing: 2),
        ),
      ),
    ],
  )
  : Column(
    children: [
      SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade400,
              //backgroundImage: AssetImage('assets/images/book.png'),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.amber.shade400, shape: BoxShape.circle),
                child: Icon(
                  Icons.edit,
                  color: Colors.black45,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 30,
        child: Text(
          '로그인하세요',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
              letterSpacing: 2),
        ),
      ),
    ],
  );
}