import 'package:flutter/material.dart';


checkSave (BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "경고",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '지금 작성중이신 내용은 따로 저장이 되지 않기 때문에 나가시면 복구는 불가합니다.\n'
                '이대로 나가시겠습니까?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.red,
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
                Navigator.popUntil(
                    context,
                        (route) => route.isFirst
                );
              },
            ),
          ],
        );
      }
  );
}