// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Getx/navibool.dart';
import '../Route/mainroute.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final draw = Get.put(navibool());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: draw.backgroundcolor, width: 1)),
            color: BGColor()),
        child: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: View(context, drawerItems_view, widget.index)),
        ));
  }
}

View(BuildContext context, List<Map> drawerItems, int index) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: drawerItems.map((element) {
      return GetBuilder<navibool>(
          builder: (_) => Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: InkWell(
                onTap: () {
                  if (element.containsValue(Entypo.basecamp)) {
                    draw.setclose();
                    uiset.setmypagelistindex(
                        Hive.box('user_setting').get('currentmypage') ?? 0);
                    uiset.setpageindex(0);
                  } else if (element
                      .containsValue(Ionicons.ios_search_outline)) {
                    draw.setclose();
                    uiset.setpageindex(1);
                  } else if (element
                      .containsValue(Ionicons.notifications_outline)) {
                    draw.setclose();
                    uiset.setpageindex(2);
                  } else if (element.containsValue(Ionicons.settings_outline)) {
                    draw.setclose();
                    uiset.setpageindex(3);
                  }
                  Get.to(() => const mainroute(), transition: Transition.fade);
                },
                child: Column(
                  children: [
                    Icon(
                      element['icon'],
                      color: drawerItems.indexOf(element) == index
                          ? Colors.purple.shade300
                          : draw.color_textstatus,
                    ),
                  ],
                ),
              )));
    }).toList(),
  );
}
