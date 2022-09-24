import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../Tool/FlushbarStyle.dart';
import '../../../Tool/TextSize.dart';

CreateCalandmemoSuccessFlushbar(String s, FToast fToast) {
  return Snack.toast(
      title: s,
      color: Colors.white,
      backgroundcolor: Colors.greenAccent,
      fToast: fToast);
}

CreateCalandmemoSuccessFlushbarSub(BuildContext context, String s) {
  Future.delayed(const Duration(seconds: 0), () async {
    await Snack.show(
        context: context,
        title: '알림',
        content: s == '메모' ? '메모가 정상적으로 입력되었습니다.' : s + '이 정상적으로 입력되었습니다.',
        snackType: SnackType.info,
        behavior: SnackBarBehavior.floating);
    //Snack.closesnackbars();
  });
}

CreateCalandmemoFlushbardelete(BuildContext context, String s) {
  Future.delayed(const Duration(seconds: 0), () async {
    await Snack.show(
        context: context,
        title: '알림',
        content: s == '메모' ? s + '가 정상적으로 삭제되었습니다.' : s + '이 정상적으로 삭제되었습니다.',
        snackType: SnackType.info,
        behavior: SnackBarBehavior.floating);
    //Snack.closesnackbars();
  });
}

CreateCalandmemoFailSaveTitle(BuildContext context) {
  return Snack.show(
      context: context,
      title: '경고',
      content: '제목은 필수 입력사항입니다!',
      snackType: SnackType.warning,
      behavior: SnackBarBehavior.floating);
}

CreateCalandmemoFailSaveTimeCal(BuildContext context) {
  return Snack.show(
      context: context,
      title: '경고',
      content: '시작시각은 필수 입력사항입니다!',
      snackType: SnackType.warning,
      behavior: SnackBarBehavior.floating);
}

CreateCalandmemoFailSaveCategory(BuildContext context) {
  return Snack.show(
      context: context,
      title: '경고',
      content: '카테고리는 필수 선택사항입니다.',
      snackType: SnackType.warning,
      behavior: SnackBarBehavior.floating);
}
