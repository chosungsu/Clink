// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Drawer_item.dart';
import 'package:clickbyme/BACKENDPART/Getx/UserInfo.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../sheets/BSContents/appbarplusbtn.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
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
          height: Get.height,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: draw.color_textstatus,
                      width: draw.navi == 1 ? 1 : 0),
                  right: BorderSide(
                      color: draw.color_textstatus,
                      width: draw.navi == 0 ? 1 : 0)),
              color: draw.backgroundcolor),
          child: View(context, drawerItems_view, textcontroller, searchNode));
    });
  }
}

View(BuildContext context, List<Map> drawerItems, textcontroller, searchnode) {
  return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                  child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: drawerItems.map((element) {
                    return GetBuilder<navibool>(
                        builder: (_) => Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: InkWell(
                              onTap: () {
                                if (element
                                    .containsValue(AntDesign.paperclip)) {
                                  draw.setclose();
                                  uiset.setmypagelistindex(
                                      Hive.box('user_setting')
                                              .get('currentmypage') ??
                                          0);
                                  uiset.setpageindex(0);
                                } else if (element
                                    .containsValue(AntDesign.plus)) {
                                  draw.setclose();
                                  plusBtn(context, textcontroller, searchnode);
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
                                  color: drawerItems.indexOf(element) ==
                                          uiset.pagenumber
                                      ? MyTheme.colorpastelpurple
                                      : draw.color_textstatus,
                                ),
                              ),
                            )));
                  }).toList(),
                ),
              )),
            ),
          ]));
}
