import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'TextSize.dart';

OSDialog(BuildContext context, String title, content, pressed) {
  return GetPlatform.isAndroid == true
      ? AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ),
            TextButton(
              onPressed: pressed,
              child: Text('Yes',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ),
          ],
        )
      : CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
          content: content,
          actions: [
            CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
}
