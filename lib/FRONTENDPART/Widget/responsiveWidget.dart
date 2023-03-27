// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

responsivewidget(widget, width) {
  double ratio = Get.height / Get.width;
  return ratio > 1
      ? SizedBox(
          width: width,
          child: widget,
        )
      : Container(
          alignment: Alignment.center,
          width: width * 0.8,
          child: widget,
        );
}
