import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'TextSize.dart';

const kPadding = 8.0; // up to you

class Snack {
  static show(
      {required String title,
      required String content,
      SnackType snackType = SnackType.info,
      SnackBarBehavior behavior = SnackBarBehavior.fixed,
      required BuildContext context}) {
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
        snackPosition: SnackPosition.BOTTOM);
  }

  static closesnackbars() {
    Future.delayed(Duration(seconds: 2), () {
      Get.closeCurrentSnackbar();
      Future.delayed(const Duration(seconds: 2), () async {
        Get.back();
      });
    });
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
