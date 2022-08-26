import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../Tool/TextSize.dart';
import '../UI/Sign/UserCheck.dart';

checkdeletecandm(BuildContext context, String s) {
  return AlertDialog(
    title: Text('경고',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: Colors.redAccent,
        )),
    content: Text('정말 이 ' + s + '를 삭제하시겠습니까?',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize(),
            color: Colors.blueGrey)),
    actions: <Widget>[
      TextButton(
        child: Text(
          '아니요',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize(),
              color: Colors.blue),
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
      TextButton(
        child: Text(
          '네',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize(),
              color: Colors.red),
        ),
        onPressed: () {
          Get.back(result: true);
        },
      )
    ],
  );
}
