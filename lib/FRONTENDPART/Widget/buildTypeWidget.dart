import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/Loader.dart';
import '../Page/DrawerScreen.dart';

buildtypewidget(context, widget) {
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
      : Stack(
          children: [
            widget,
            uiset.loading == true
                ? const Loader(
                    wherein: 'route',
                  )
                : Container()
          ],
        );
}

responsive() {
  final draw = Get.put(navibool());
  return Get.width < 800
      ? (draw.navi == 0
          ? Positioned(
              left: 0,
              child: SizedBox(
                width: 60,
                height: Get.height,
                child: const DrawerScreen(),
              ),
            )
          : Positioned(
              right: 0,
              child: SizedBox(
                width: 60,
                height: Get.height,
                child: const DrawerScreen(),
              ),
            ))
      : (draw.navi == 0
          ? Positioned(
              left: 0,
              child: SizedBox(
                width: 120,
                height: Get.height,
                child: const DrawerScreen(),
              ),
            )
          : Positioned(
              right: 0,
              child: SizedBox(
                width: 120,
                height: Get.height,
                child: const DrawerScreen(),
              ),
            ));
}

innertype() {
  return Get.width < 800
      ? SizedBox(
          width: 60,
          height: Get.height,
          child: const DrawerScreen(),
        )
      : SizedBox(
          width: 120,
          height: Get.height,
          child: const DrawerScreen(),
        );
}
