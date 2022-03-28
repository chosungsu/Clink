import 'package:flutter/material.dart';

checkhowdaylog(BuildContext context) {
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
            '일정을 추가하시려면 오른쪽의 추가버튼을 클릭하시면 됩니다. 일정에 대해 세부사항 보기 및 내용 변경은 해당 일정카드를 클릭하시면 됩니다.',
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