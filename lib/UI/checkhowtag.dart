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
            '태그는 \'#\'을 입력하고 원하는 태그 작성 후 스페이스를 누르면 자동 중단됩니다.\n'
                '한 개 이상의 태그 작성을 원하시면 스페이스로 한칸 띄우신 후에 처음 작성방법을 따르시면 됩니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
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