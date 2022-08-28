import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Tool/TextSize.dart';

CreateCalandmemoSuccessFlushbar(BuildContext context) {
  return Flushbar(
    backgroundColor: Colors.green.shade400,
    titleText: Text('Uploading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTitleTextsize(),
          fontWeight: FontWeight.bold,
        )),
    messageText: Text('잠시만 기다려주세요~',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTextsize(),
          fontWeight: FontWeight.bold,
        )),
    icon: const Icon(
      Icons.info_outline,
      size: 25.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 1),
    leftBarIndicatorColor: Colors.green.shade100,
  ).show(context);
}

CreateCalandmemoSuccessFlushbarSub(BuildContext context, String s) {
  Future.delayed(const Duration(seconds: 2), () {
    Flushbar(
      backgroundColor: Colors.blue.shade400,
      titleText: Text('Notice',
          style: TextStyle(
            color: Colors.white,
            fontSize: contentTitleTextsize(),
            fontWeight: FontWeight.bold,
          )),
      messageText: Text(s + '이 정상적으로 입력되었습니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: contentTextsize(),
            fontWeight: FontWeight.bold,
          )),
      icon: const Icon(
        Icons.info_outline,
        size: 25.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 1),
      leftBarIndicatorColor: Colors.blue.shade100,
    ).show(context).whenComplete(() => Get.back());
  });
}

CreateCalandmemoFailFlushbarSaveMemo(BuildContext context) {
  return Future.delayed(const Duration(seconds: 2), () {
    Flushbar(
      backgroundColor: Colors.blue.shade400,
      titleText: Text('Notice',
          style: TextStyle(
            color: Colors.white,
            fontSize: contentTitleTextsize(),
            fontWeight: FontWeight.bold,
          )),
      messageText: Text('메모가 정상적으로 삭제되었습니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: contentTextsize(),
            fontWeight: FontWeight.bold,
          )),
      icon: const Icon(
        Icons.info_outline,
        size: 25.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 2),
      leftBarIndicatorColor: Colors.blue.shade100,
    ).show(context).whenComplete(() => Get.back());
  });
}

CreateCalandmemoFailSaveTitle(BuildContext context) {
  return Flushbar(
    backgroundColor: Colors.red.shade400,
    titleText: Text('Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTitleTextsize(),
          fontWeight: FontWeight.bold,
        )),
    messageText: Text('제목은 필수 입력사항입니다!',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTextsize(),
          fontWeight: FontWeight.bold,
        )),
    icon: const Icon(
      Icons.info_outline,
      size: 25.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 1),
    leftBarIndicatorColor: Colors.red.shade100,
  ).show(context);
}

CreateCalandmemoFailSaveTimeCal(BuildContext context) {
  return Flushbar(
    backgroundColor: Colors.red.shade400,
    titleText: Text('Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTitleTextsize(),
          fontWeight: FontWeight.bold,
        )),
    messageText: Text('시작시각은 필수 입력사항입니다!',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTextsize(),
          fontWeight: FontWeight.bold,
        )),
    icon: const Icon(
      Icons.info_outline,
      size: 25.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 1),
    leftBarIndicatorColor: Colors.red.shade100,
  ).show(context);
}

CreateCalandmemoFailSaveCategory(BuildContext context) {
  return Flushbar(
    backgroundColor: Colors.red.shade400,
    titleText: Text('Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTitleTextsize(),
          fontWeight: FontWeight.bold,
        )),
    messageText: Text('카테고리는 필수 선택사항입니다.',
        style: TextStyle(
          color: Colors.white,
          fontSize: contentTextsize(),
          fontWeight: FontWeight.bold,
        )),
    icon: const Icon(
      Icons.info_outline,
      size: 25.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 1),
    leftBarIndicatorColor: Colors.red.shade100,
  ).show(context);
}
