// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Drawer_item.dart';
import 'package:clickbyme/BACKENDPART/Getx/UserInfo.dart';
import 'package:clickbyme/BACKENDPART/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/sheets/BSContents/appbarplusbtn.dart';
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
  final peopleadd = Get.put(UserInfo());
  final searchNode = FocusNode();
  TextEditingController textcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    textcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textcontroller.dispose();
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
          child: View(context, drawerItems_view, textcontroller, searchNode));
    });
  }
}

View(BuildContext context, List<Map> drawerItems, textcontroller, searchnode) {
  return Container(
    padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: drawerItems.map((element) {
        return GetBuilder<navibool>(
            builder: (_) => InkWell(
                  onTap: () {
                    if (element.containsValue(AntDesign.paperclip)) {
                      draw.setclose();
                      uiset.setmypagelistindex(
                          Hive.box('user_setting').get('currentmypage') ?? 0);
                      uiset.setpageindex(0);
                    } else if (element.containsValue(AntDesign.plus)) {
                      if (uiset.pagenumber == 1) {
                      } else {
                        draw.setclose();
                        plusBtn(context, textcontroller, searchnode);
                      }
                    } else if (element
                        .containsValue(Ionicons.settings_outline)) {
                      draw.setclose();
                      uiset.setpageindex(2);
                    }
                    uiset.setappbarwithsearch(init: true);
                    linkspacesetting().setmainoption(0);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 10, top: 10, left: 10, right: 10),
                    child: Icon(
                      element['icon'],
                      color: drawerItems.indexOf(element) == uiset.pagenumber
                          ? MyTheme.colorpastelpurple
                          : draw.color_textstatus,
                    ),
                  ),
                ));
      }).toList(),
    ),
  );
}
