// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, file_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../BACKENDPART/Api/PageApi.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());
final draw = Get.put(navibool());
final linkspaceset = Get.put(linkspacesetting());

///UI
///
///MYPage의 UI
UI(context, id, controller, searchnode, maxWidth, maxHeight) {
  return GetBuilder<linkspacesetting>(builder: (_) {
    return Container(
      height: maxHeight,
      width: maxWidth,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Responsivelayout(
          PageUI0(
              context, id, controller, searchnode, maxHeight, maxWidth - 40),
          PageUI1(
              context, id, controller, searchnode, maxHeight, maxWidth - 40)),
    );
  });
}

PageUI0(context, id, controller, searchnode, maxHeight, maxWidth) {
  //landscape
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [OptionBox(maxWidth)],
  );
}

PageUI1(context, id, controller, searchnode, maxHeight, maxWidth) {
  //portrait
  return Column(
    children: [
      OptionBox(maxWidth),
      const SizedBox(
        height: 20,
      ),
      View(maxHeight - 80, maxWidth)
    ],
  );
}

SearchBox(controller, searchnode) {
  return SizedBox(
      height: 50,
      width: 60.w,
      child: ContainerDesign(
          color: draw.backgroundcolor,
          child: StatefulBuilder(
            builder: ((context, setState) {
              return TextField(
                onChanged: ((value) {
                  uiset.settextrecognizer(value);
                }),
                autofocus: false,
                controller: controller,
                maxLines: 1,
                focusNode: searchnode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: draw.color_textstatus,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: draw.backgroundcolor,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: 'search'.tr,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: draw.color_textstatus),
                  isCollapsed: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: draw.color_textstatus,
                  ),
                ),
              );
            }),
          )));
}

OptionBox(maxWidth) {
  return SizedBox(
    height: 60,
    width: maxWidth,
    child: ListView.builder(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  linkspaceset.setmainoption(index);
                  PageApiProvider().getTasks();
                },
                child: Container(
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: index == linkspaceset.clickmainoption
                              ? Colors.pink.shade300
                              : draw.color_textstatus,
                          width: 1)),
                  child: Text(
                    optionname[index],
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }),
  );
}

View(maxHeight, maxWidth) {
  return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: linkspaceset.alllist.isEmpty
          ? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AntDesign.frowno,
                    color: Colors.orange,
                    size: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '텅 비어있습니다!!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: draw.color_textstatus),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: linkspaceset.alllist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          //uiset.setmainoption(index);
                        },
                        child: SizedBox(
                          height: 150,
                          child: ContainerDesign(
                            child: Text(
                              linkspaceset.alllist[index].title,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: draw.color_textstatus,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                            ),
                            color: draw.backgroundcolor,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }));
}
