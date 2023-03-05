// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

responsivewidget(widget) {
  double ratio = Get.height / Get.width;
  return ratio > 1
      ? SizedBox(
          width: Get.width,
          child: widget,
        )
      : SizedBox(
          width: Get.width * 0.8,
          child: widget,
        );
}
