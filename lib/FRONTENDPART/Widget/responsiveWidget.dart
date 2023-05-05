// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../BACKENDPART/Getx/navibool.dart';

responsivewidget(widget, width) {
  final navi = Get.put(navibool());
  double ratio = navi.size.height / navi.size.width;
  return ratio > 1 && width < 1000
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
