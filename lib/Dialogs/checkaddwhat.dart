import 'package:flutter/material.dart';

checkaddwhat(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "설명",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '사진을 추가하시면 자동으로 첫번째 사진이 메인사진으로 채택됩니다.\n'
                '링크는 포스팅 하시는 글 하단에 자동 작성이 됩니다.',
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