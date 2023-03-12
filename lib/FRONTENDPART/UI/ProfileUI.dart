// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/BACKENDPART/FIREBASE/SettingVP.dart';
import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Tool/BGColor.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(PeopleAdd());
final draw = Get.put(navibool());

///UI
///
///ProfilePage의 UI
UI(controller, searchnode, scrollcontroller, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(builder: (_) {
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  View(context, maxWidth, maxHeight, searchnode, controller),
                ],
              ));
        }));
  });
}

///View
///
///ProfilePage의 기본UI
View(context, maxWidth, maxHeight, searchnode, controller) {
  return GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [view(context, maxWidth, searchnode, controller)],
      ),
    ),
  );
}

view(context, maxWidth, searchnode, controller) {
  return responsivewidget(
      Column(
        children: [
          UserBoard(controller, searchnode),
          const Divider(
            height: 20,
            color: Colors.grey,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Content(controller, searchnode),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
      maxWidth);
}

///UserBoard
///
///user의 각종 현황을 대시보드형태로 보여줌
UserBoard(controller, searchnode) {
  Widget title;
  Widget content;
  return StatefulBuilder(
    builder: (context, setState) {
      return SizedBox(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border:
                            Border.all(color: draw.color_textstatus, width: 1)),
                    child: Icon(
                      Octicons.person,
                      size: 30,
                      color: draw.color_textstatus,
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Hive.box('user_info').get('id'),
                              maxLines: 3,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: draw.color_textstatus),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  controller.clear();
                                  title = Widgets_personchange(
                                      context, controller, searchnode)[0];
                                  content = Widgets_personchange(
                                      context, controller, searchnode)[1];
                                  AddContent(
                                      context, title, content, searchnode);
                                },
                                child: Icon(
                                  FontAwesome.pencil_square_o,
                                  size: 30,
                                  color: draw.color_textstatus,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Text(
                                      'userpeedone'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '10',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus),
                                    ),
                                  ],
                                )),
                            Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Text(
                                      'userpeedtwo'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '3',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: draw.color_textstatus),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ));
    },
  );
}

///ShopContent
///
///상점을 보여줌
Content(controller, searchnode) {
  Widget title;
  Widget content;
  return StatefulBuilder(
    builder: (context, setState) {
      return StaggeredGrid.count(
        crossAxisCount: Get.width > 1000 ? 2 : 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(5, (index) {
          return SizedBox(
            width: Get.width > 1000
                ? (Get.width - 40) * 0.6 * 0.4
                : Get.width - 40,
            height: 100,
            child: ContainerDesign(
              child: const SizedBox(),
              color: draw.backgroundcolor,
            ),
          );
        }),
      );
    },
  );
}
