import 'package:flutter/material.dart';

howchangespace(BuildContext context) {
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
            '나의 현재 스페이스에는 프로버전을 구매하시지 않은 분들은 세개의 스페이스만 대시보드로 제공되며 프로버전을 구독하시면 잠금을 해제해드립니다.',
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