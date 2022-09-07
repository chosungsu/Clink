import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/TextSize.dart';

SortMenuHolder(int sort, String s) {
  final cal_sort = Get.put(calendarsetting());
  final controll_memo = Get.put(memosetting());

  return StatefulBuilder(builder: ((context, setState) {
    return FocusedMenuHolder(
        child: IconBtn(
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: NeumorphicIcon(
                Icons.filter_alt,
                size: 30,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: TextColor(),
                    lightSource: LightSource.topLeft),
              ),
            ),
            color: TextColor()),
        onPressed: () {},
        duration: const Duration(seconds: 0),
        animateMenuItems: true,
        menuOffset: 20,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        bottomOffsetHeight: 10,
        menuWidth: 160,
        openWithTap: true,
        menuItems: [
          FocusedMenuItem(
              title: Text('날짜내림차순',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  if (s == '캘린더') {
                    cal_sort.setsortcal(0);
                  } else {
                    controll_memo.setsortmemo(0);
                  }
                });
              }),
          FocusedMenuItem(
              title: Text('날짜오름차순',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  if (s == '캘린더') {
                    cal_sort.setsortcal(1);
                  } else {
                    controll_memo.setsortmemo(1);
                  }
                });
              }),
        ]);
  }));
}
