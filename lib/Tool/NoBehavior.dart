import 'package:flutter/cupertino.dart';

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