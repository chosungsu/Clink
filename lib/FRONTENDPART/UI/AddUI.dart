// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, file_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/BSContents/appbarplusbtn.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AndroidIOS.dart';
import '../../sheets/BottomSheet/AddContent.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final peopleadd = Get.put(UserInfo());
final draw = Get.put(navibool());

///UI
///
///AddPage의 UI
UI(controller, searchnode, scrollcontroller, maxWidth, maxHeight) {
  return GetBuilder<linkspacesetting>(builder: (_) {
    return SingleChildScrollView(
        controller: scrollcontroller,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Responsivelayout(
                      PageUI0(context, maxWidth - 40, maxHeight, searchnode,
                          controller),
                      PageUI1(context, maxWidth - 40, maxHeight, searchnode,
                          controller))
                ],
              ));
        }));
  });
}

PageUI0(context, maxWidth, maxHeight, searchnode, controller) {
  List optionname = [
    'Upload',
    'Preview',
  ];
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: maxHeight,
        width: 100,
        child: ListView.builder(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
      ),
      const SizedBox(
        width: 20,
      ),
      Flexible(
          fit: FlexFit.tight,
          child: View(context, maxWidth, maxHeight, searchnode, controller))
    ],
  );
}

PageUI1(context, maxWidth, maxHeight, searchnode, controller) {
  return View(context, maxWidth, maxHeight, searchnode, controller);
}

///View
///
///ProfilePage의 기본UI
View(context, maxWidth, maxHeight, searchnode, controller) {
  return SizedBox(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSpace(searchnode[0], controller[0]),
        ThumbnailSpace(context, searchnode[2]),
        AvailablecheckSpace(),
        MakeUrlSpace(searchnode[1], controller[1]),
        GestureDetector(
          onTap: () {},
          child: Text(
            uiset.addpagecontroll == 0 ? '페이지만들기' : '박스만들기',
            softWrap: true,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: draw.color_textstatus,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
          ),
        )
      ],
    ),
  );
}

TitleSpace(searchnode, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '제목',
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      ContainerTextFieldDesign(
          searchNodeAddSection: searchnode,
          string: '이곳에 입력해주세요',
          textEditingControllerAddSheet: controller),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

AvailablecheckSpace() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '공유여부',
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: GestureDetector(
              onTap: () {
                linkspaceset.setshareoption('yes');
              },
              child: ContainerDesign(
                  child: Text(
                    'Y',
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                  color: linkspaceset.shareoption == 'yes'
                      ? Colors.blue.shade200
                      : draw.backgroundcolor),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: GestureDetector(
              onTap: () {
                linkspaceset.setshareoption('no');
              },
              child: ContainerDesign(
                  child: Text(
                    'N',
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: draw.color_textstatus,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                  color: linkspaceset.shareoption == 'no'
                      ? Colors.blue.shade200
                      : draw.backgroundcolor),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

MakeUrlSpace(searchnode, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'URL 설정',
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          SizedBox(
            height: 50,
            child: ContainerDesign(
                child: Text(
                  'http://pinset.co.kr',
                  softWrap: true,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: draw.color_textstatus,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize()),
                ),
                color: draw.backgroundcolor),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                height: 50,
                child: ContainerTextFieldDesign(
                    searchNodeAddSection: searchnode,
                    string: '원하는 url 네임을 작성해주세요',
                    textEditingControllerAddSheet: controller),
              ))
        ],
      ),
      const SizedBox(
        height: 100,
      ),
    ],
  );
}

ThumbnailSpace(context, searchnode) {
  Widget title;
  Widget content;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '썸네일 이미지 설정',
        softWrap: true,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: draw.color_textstatus,
            fontWeight: FontWeight.bold,
            fontSize: contentTextsize()),
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 100,
        width: 100,
        child: GestureDetector(
          onTap: () {
            title = Widgets_pagethumnail(context)[0];
            content = Widgets_pagethumnail(context)[1];
            AddContent(context, title, content, searchnode);
          },
          child: ContainerDesign(
              child: const Icon(Ionicons.add), color: draw.backgroundcolor),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 50,
        child: InfoContainerDesign(
            child: Text(
              '안내 - 페이지 썸네일은 1장으로 제한됩니다.',
              softWrap: true,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: contentsmallTextsize()),
            ),
            color: Colors.red.shade200),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}
