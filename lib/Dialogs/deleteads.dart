import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../UI/UserCheck.dart';

deleteads(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "알림",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '부가기능 > 기본값 설정 > \'광고성 페이지 가리기\'에서 변경 가능합니다.\n'
            '이 뷰를 가리시겠습니까?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("아니요"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("네"),
              onPressed: () {
                //사용자가 이 페이지를 보기 싫어한다는 의미로 로컬에 불린값 저장
                Navigator.pop(context);
                Hive.box('user_setting').put('no_show_tip_page', true);
                GoToMain(context);
              },
            ),
          ],
        );
      });
}
