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
      : SizedBox(
          width: width * 0.6,
          child: widget,
        );
}
