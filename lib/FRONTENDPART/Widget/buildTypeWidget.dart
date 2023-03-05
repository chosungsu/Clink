import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/Loader.dart';
import '../Page/DrawerScreen.dart';
import '../Page/NotiAlarm.dart';

buildtypewidget(context, widget) {
  double ratio = Get.height / Get.width;
  double width =
      Get.width < 1000 || ratio > 1 ? Get.width * 0.7 : Get.width * 0.5;
  double height = Get.height > 1500 ? Get.height * 0.5 : Get.height;
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());
  return draw.drawopen == true
      ? Stack(
          children: [
            responsive(),
            widget,
            uiset.loading == true
                ? const Loader(
                    wherein: 'route',
                  )
                : Container()
          ],
        )
      : (draw.drawnoticeopen == true
          ? Stack(
              children: [
                widget,
                const Barrier(),
                Positioned(
                  right: 0,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: NotiAlarm(
                      width: width,
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                widget,
                uiset.loading == true
                    ? const Loader(
                        wherein: 'route',
                      )
                    : Container()
              ],
            ));
}

responsive() {
  final draw = Get.put(navibool());
  return Get.width < 800
      ? (draw.navi == 0
          ? Positioned(
              left: 0,
              child: SizedBox(
                width: 60,
                height: Get.height - 60,
                child: const DrawerScreen(),
              ),
            )
          : Positioned(
              right: 0,
              child: SizedBox(
                width: 60,
                height: Get.height - 60,
                child: const DrawerScreen(),
              ),
            ))
      : (draw.navi == 0
          ? Positioned(
              left: 0,
              child: SizedBox(
                width: 120,
                height: Get.height - 60,
                child: const DrawerScreen(),
              ),
            )
          : Positioned(
              right: 0,
              child: SizedBox(
                width: 120,
                height: Get.height - 60,
                child: const DrawerScreen(),
              ),
            ));
}

innertype() {
  return Get.width < 800
      ? SizedBox(
          width: 60,
          height: Get.height - 60,
          child: const DrawerScreen(),
        )
      : SizedBox(
          width: 120,
          height: Get.height - 60,
          child: const DrawerScreen(),
        );
}
