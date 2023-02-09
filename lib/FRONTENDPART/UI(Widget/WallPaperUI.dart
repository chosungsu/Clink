// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/FIREBASE/PaperVP.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());
final draw = Get.put(navibool());

UI(id, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(
    builder: (_) {
      return StreamBuilder<QuerySnapshot>(
        stream: PaperViewStreamParent1(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PaperViewRes1(id, snapshot);
            return linkspaceset.inpapertreetmp.isEmpty
                ? NotInPageScreen(context, maxHeight, maxWidth)
                : SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: Responsivelayout(
                        PageUI0(context, id, maxHeight, maxWidth),
                        PageUI1(context, id, maxHeight, maxWidth)),
                  );
          } else if (!snapshot.hasData) {
            return NotInPageScreen(
              context,
              maxHeight,
              maxWidth,
            );
          }
          return LinearProgressIndicator(
            backgroundColor: draw.backgroundcolor,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          );
        },
      );
    },
  );
}

PageUI0(context, id, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  return GetBuilder<linkspacesetting>(
    builder: (_) {
      return Row(
        children: [],
      );
    },
  );
}

PageUI1(context, id, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: GetBuilder<linkspacesetting>(
        builder: (_) {
          return Column(
            children: [],
          );
        },
      ));
}

NotInPageScreen(context, maxHeight, maxWidth) {
  return SizedBox(
    height: maxHeight,
    width: maxWidth,
    child: Responsivelayout(
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }, scrollbars: true),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              child: GetBuilder<linkspacesetting>(
                builder: (_) {
                  return SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          ContainerDesign(
                            color: draw.backgroundcolor,
                            child: SizedBox(
                              width: (maxWidth - 90) * 0.4,
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              child: ContainerDesign(
                                color: draw.backgroundcolor,
                                child: SizedBox(),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Column(
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
                    '해당 페이지는 비어있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: draw.color_textstatus),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: ButtonColor(),
                        ),
                        onPressed: () async {},
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '템플릿 선택하기',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        )),
  );
}
