// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

ResponsiveMainUI(landscapechild, portraitchild, orientation) {
  return Device.screenType == ScreenType.desktop
      ? SizedBox(
          // Widget for desktop
          width: 100.w,
          height: 100.h,
          child: orientation == Orientation.landscape
              ? landscapechild
              : portraitchild,
        )
      : (Device.screenType == ScreenType.mobile
          ? SizedBox(
              // Widget for mobile
              width: 100.w,
              height: 100.h,
              child: orientation == Orientation.landscape
                  ? landscapechild
                  : portraitchild,
            )
          : SizedBox(
              // Widget for tablet
              width: 100.w,
              height: 100.h,
              child: orientation == Orientation.landscape
                  ? landscapechild
                  : portraitchild,
            ));
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
