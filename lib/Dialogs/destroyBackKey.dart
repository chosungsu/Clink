import 'package:clickbyme/Tool/AndroidIOS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../Tool/TextSize.dart';

destroyBackKey(BuildContext context) {
  OSDialog(
      context,
      '종료',
      Text('앱을 종료하시겠습니까?',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize())),
      pressed1);
}

checkdeletecandm(BuildContext context, String s) {
  OSDialog(context, '경고', Builder(
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Text(
              s == '일정'
                  ? '정말 이 ' + s + '을 삭제하시겠습니까?'
                  : '정말 이 ' + s + '를 삭제하시겠습니까?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.blueGrey)),
        ),
      );
    },
  ), pressed2);
}

checkdeletenoti(BuildContext context) {
  OSDialog(context, '경고', Builder(
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Text('알림들을 삭제하시겠습니까?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.blueGrey)),
        ),
      );
    },
  ), pressed2);
}

checkbackincandm(BuildContext context) {
  OSDialog(context, '경고', Builder(
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Text('뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.blueGrey)),
        ),
      );
    },
  ), pressed2);
}

checkdeleteimagememo(BuildContext context) {
  OSDialog(context, '경고', Builder(
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Text('정말 이 이미지를 삭제하시겠습니까?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.blueGrey)),
        ),
      );
    },
  ), pressed2);
}

pressed1() {
  Hive.box('user_info').get('autologin') == false
      ? Hive.box('user_info').delete('id')
      : null;
  SystemNavigator.pop();
}

pressed2() {
  Get.back(result: true);
}
