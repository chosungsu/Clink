import 'package:flutter/material.dart';

addcalendartodo(BuildContext context, TextEditingController eventController,
    Map<DateTime, List<dynamic>> events, DateTime date) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "할일",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "내용",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextField(
                controller: eventController,
                decoration: const InputDecoration(
                  hintText: "일정"
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("작성 취소"),
              onPressed: () {
                eventController.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("작성 완료"),
              onPressed: () {
                if (eventController.text.isEmpty) {

                } else {
                  events[date]!.add(eventController.text);
                }
                eventController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
  );
}