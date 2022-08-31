import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../Tool/TextSize.dart';
import '../UI/Sign/UserCheck.dart';

checkbackincandm(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: Text('경고',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: Colors.redAccent,
        )),
    content: Builder(
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
    ),
    actions: <Widget>[
      TextButton(
        child: Text(
          '머무를게요',
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
          '나가기',
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
