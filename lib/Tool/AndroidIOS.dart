// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'TextSize.dart';

CodeByPlatform(actionandroid, actionios, actionweb) {
  if (GetPlatform.isWeb) {
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

Responsivelayout(landscape, portrait) {
  if (Device.orientation == Orientation.landscape) {
    return landscape;
  } else {
    return portrait;
  }
}

getHeight(GlobalKey key) {
  if (key.currentContext != null) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    double height = renderBox.size.height;
    return height;
  }
}

getWidth(GlobalKey key) {
  if (key.currentContext != null) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    double width = renderBox.size.width;
    return width;
  }
}

OSDialog(context, title, content, pressed) {
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

OSDialogsecond(context, title, content, pressed) {
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

OSDialogthird(context, title, content, pressed) {
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

OSDialogforth(context, title, content, pressed) {
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
              child: Text('네',
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
                child: const Text("네"),
                onPressed: pressed),
            CupertinoDialogAction(
                child: const Text("아니요"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
}

OSDialogWithoutaction(BuildContext context, String title, content) {
  return GetPlatform.isAndroid == true || GetPlatform.isWeb == true
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
        )
      : CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
          content: content,
        );
}
