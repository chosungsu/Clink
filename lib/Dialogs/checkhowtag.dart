import 'package:flutter/material.dart';

checkhowtag(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "How To Tag",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '태그는 원하는 태그 작성 후 스페이스를 누르면 자동 추가됩니다.\n'
                '한 개 이상의 태그 작성을 원하시면 위 과정을 반복하시면 됩니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("확인했습니다."),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
  );
}