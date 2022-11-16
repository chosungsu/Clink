import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
import 'TextSize.dart';

const kPadding = 8.0; // up to you

class Snack {
  static toast(
      {required String title,
      required Color color,
      required Color backgroundcolor,
      required FToast fToast}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundcolor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: color,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 2),
      gravity: ToastGravity.BOTTOM,
    );
  }

  static show(
      {required String title,
      required String content,
      SnackType snackType = SnackType.info,
      SnackBarBehavior behavior = SnackBarBehavior.fixed,
      required BuildContext context,
      SnackPosition position = SnackPosition.BOTTOM}) {
    Get.snackbar('', '',
        borderRadius: 20,
        titleText: Text(
          title,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.white),
        ),
        duration: const Duration(seconds: 1),
        messageText: Text(
          content,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.white),
        ),
        backgroundColor: _getSnackbarColor(snackType),
        icon: const Icon(
          Icons.info_outline,
          color: Colors.white,
          size: 25,
        ),
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(15),
        snackPosition: position);
  }

  static actionshow(
      {required String title,
      SnackType snackType = SnackType.info,
      SnackBarBehavior behavior = SnackBarBehavior.fixed,
      required BuildContext context,
      required String s}) {
    Get.snackbar('', '',
        borderRadius: 20,
        titleText: Text(
          '퀵편집 기능',
          style: TextStyle(fontSize: contentTextsize(), color: Colors.white),
        ),
        messageText: Text(
          title,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.white),
        ),
        duration: const Duration(seconds: 5),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: _getSnackbarColor(snackType),
        mainButton: TextButton(
          onPressed: () {
            s == 'cal'
                ? Get.to(
                    () => const ChooseCalendar(
                          isfromwhere: 'mypagehome',
                          index: 0,
                        ),
                    transition: Transition.rightToLeft)
                : Get.to(
                    () => const DayNoteHome(
                          title: '',
                          isfromwhere: 'mypagehome',
                        ),
                    transition: Transition.rightToLeft);
          },
          child: Text(
            'Go',
            style: TextStyle(fontSize: contentTextsize(), color: Colors.white),
          ),
        ),
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(15),
        snackPosition: SnackPosition.BOTTOM);
  }

  static closesnackbars() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.closeCurrentSnackbar();
      Future.delayed(const Duration(seconds: 2), () async {
        Get.back(result: true);
      });
    });
  }

  static isopensnacks() {
    if (Get.isSnackbarOpen) {
    } else {
      Get.back();
    }
  }

  static Color _getSnackbarColor(SnackType type) {
    if (type == SnackType.waiting) return Colors.green.shade200;
    if (type == SnackType.warning) return Colors.red.shade200;
    if (type == SnackType.info) return Colors.blue.shade200;
    return Colors.white;
  }

  static Widget _getSnackbaricon(SnackType type) {
    if (type == SnackType.waiting)
      return const Icon(Icons.hourglass_empty_outlined);
    if (type == SnackType.warning) return const Icon(Icons.warning_outlined);
    if (type == SnackType.info) return const Icon(Icons.info_outline);
    return const Icon(Icons.info_outline);
  }

  static Color _getSnackbarTextColor(SnackType type) {
    return Colors.white;
  }
}

enum SnackType { info, warning, waiting }
