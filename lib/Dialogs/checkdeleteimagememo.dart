import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Tool/TextSize.dart';

checkdeleteimagememo(BuildContext context) {
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
            child: Text('정말 이 이미지를 삭제하시겠습니까?',
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
