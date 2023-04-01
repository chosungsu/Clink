// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, file_names

import 'dart:io';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/datecheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../BACKENDPART/Api/PageApi.dart';
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      OptionBox(maxWidth, maxHeight, 'ls'),
      const SizedBox(
        width: 20,
      ),
      View(maxHeight, maxWidth - 120, 'ls')
    ],
  );
}

PageUI1(context, id, controller, searchnode, maxHeight, maxWidth) {
  //portrait
  return Column(
    children: [
      OptionBox(maxWidth, maxHeight, 'pr'),
      const SizedBox(
        height: 20,
      ),
      View(maxHeight - 80, maxWidth, 'pr')
    ],
  );
}

SearchBox(controller, searchnode) {
  return SizedBox(
      height: 50,
      width: 50.w,
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

OptionBox(maxWidth, maxHeight, position) {
  List optionname = [
    'MYPageOption1'.tr,
    'MYPageOption2'.tr,
    'MYPageOption3'.tr,
  ];
  return position == 'pr'
      ? SizedBox(
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
        )
      : SizedBox(
          height: maxHeight,
          width: 100,
          child: ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
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
                      height: 10,
                    )
                  ],
                );
              }),
        );
}

View(maxHeight, maxWidth, pageoption) {
  return SizedBox(
      height: maxHeight,
      width: pageoption == 'ls' ? maxWidth * 0.6 : maxWidth,
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
          : StaggeredGrid.count(
              crossAxisCount: pageoption == 'pr' ? 2 : 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(linkspaceset.alllist.length, (index) {
                return GestureDetector(
                    onTap: () {
                      //uiset.setmainoption(index);
                    },
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 200, // 최소 세로 크기
                        maxHeight: 300, // 최대 세로 크기
                      ),
                      child: ContainerDesign(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Image.file(
                                    File(linkspaceset.alllist[index].image
                                                .contains('media') ==
                                            true
                                        ? linkspaceset.alllist[index].image
                                            .toString()
                                            .substring(6)
                                        : linkspaceset.alllist[index].image),
                                    width: pageoption == 'ls'
                                        ? maxWidth * 0.6
                                        : maxWidth,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                linkspaceset.alllist[index].title,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: draw.color_textstatus,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize(),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  linkspaceset.alllist[index].owner,
                                  softWrap: true,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: draw.color_textstatus,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize()),
                                ),
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      color: draw.color_textstatus,
                                      shape: BoxShape.circle),
                                ),
                                Text(
                                  datecheck(DateTime.parse(
                                      linkspaceset.alllist[index].date)),
                                  softWrap: true,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: draw.color_textstatus,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize()),
                                ),
                              ],
                            )
                          ],
                        ),
                        color: draw.backgroundcolor,
                      ),
                    ));
              }),
            ));
}
