import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'Getx/uisetting.dart';

/*
  NoBehavior는 스크롤 뷰에서 상하부 모션을 삭제하는 클래스
 */
class NoBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void scrollToTop(ScrollController scrollController) {
  final uiset = Get.put(uisetting());

  scrollController.animateTo(0,
      duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  if (scrollController.offset == 0) {
    uiset.settopbutton(false); // show the back-to-top button
  }
}
