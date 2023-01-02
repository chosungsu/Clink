// ignore_for_file: non_constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import 'TextSize.dart';

CodeByPlatform(actionandroid, actionios, actionweb) {
  if (GetPlatform.isWeb) {
    print('here');
    actionweb;
  } else {
    if (GetPlatform.isAndroid) {
      actionandroid;
    } else {
      actionios;
    }
  }
}

ReturnByPlatform(actionandroid, actionios, actionweb) {
  if (GetPlatform.isWeb) {
    return actionweb;
  } else {
    if (GetPlatform.isAndroid) {
      return actionandroid;
    } else {
      return actionios;
    }
  }
}

Responsivelayout(size, landscape, portrait) {
  if (size > 600) {
    return landscape;
  } else {
    return portrait;
  }
}

OSDialog(BuildContext context, String title, content, pressed) {
  return GetPlatform.isAndroid == true || GetPlatform.isWindows == true
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
              onPressed: pressed,
              child: Text('Yes',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ),
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
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
}

OSDialogsecond(BuildContext context, String title, content, pressed) {
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
              onPressed: pressed,
              child: Text('네. 모두 삭제할게요',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('하루만 삭제할게요',
                  style: TextStyle(
                      color: Colors.red,
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
                child: const Text("네. 모두 삭제할게요"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            CupertinoDialogAction(
                child: const Text("하루만 삭제할게요"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
}

OSDialogthird(BuildContext context, String title, content, pressed) {
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
              onPressed: pressed,
              child: Text('네 맞습니다',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('아니요',
                  style: TextStyle(
                      color: Colors.red,
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
                child: const Text("포함 해주세요"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            CupertinoDialogAction(
                child: const Text("포함 안해요"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
}
