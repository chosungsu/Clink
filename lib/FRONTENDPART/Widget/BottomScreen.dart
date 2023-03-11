// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Drawer_item.dart';
import 'package:clickbyme/BACKENDPART/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(builder: (_) {
      return Container(
          alignment: Alignment.center,
          height: 60,
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: draw.color_textstatus, width: 1),
              ),
              color: draw.backgroundcolor),
          child: View(context, drawerItems_view));
    });
  }
}

View(BuildContext context, List<Map> drawerItems) {
  return Container(
    padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: drawerItems.map((element) {
        return GetBuilder<navibool>(
            builder: (_) => Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: InkWell(
                  onTap: () {
                    if (element.containsValue(SimpleLineIcons.home)) {
                      draw.setclose();
                      uiset.setmypagelistindex(
                          Hive.box('user_setting').get('currentmypage') ?? 0);
                      uiset.setpageindex(0);
                    } else if (element
                        .containsValue(Ionicons.ios_search_outline)) {
                      draw.setclose();
                      uiset.setpageindex(1);
                    } else if (element.containsValue(
                      notilist.isread == true
                          ? Ionicons.notifications_outline
                          : MaterialCommunityIcons.bell_badge_outline,
                    )) {
                      draw.setclose();
                      uiset.setpageindex(2);
                    } else if (element
                        .containsValue(Ionicons.settings_outline)) {
                      draw.setclose();
                      uiset.setpageindex(3);
                    }
                    //Get.to(() => const mainroute(), transition: Transition.fade);
                  },
                  child: Icon(
                    element['icon'],
                    color: drawerItems.indexOf(element) == uiset.pagenumber
                        ? MyTheme.colorpastelpurple
                        : draw.color_textstatus,
                  ),
                )));
      }).toList(),
    ),
  );
}
