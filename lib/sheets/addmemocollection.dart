import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';

import '../Tool/SheetGetx/onequeform.dart';

SheetPagememoCollection(
  BuildContext context,
  String username,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
) {
  return SizedBox(
      height: 530,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(
                context,
              ),
              const SizedBox(
                height: 20,
              ),
              content(context, username, textEditingController_add_sheet,
                  searchNode_add_section)
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text('추가하기',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ],
      ));
}

content(
  BuildContext context,
  String username,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text('컬렉션 제목',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                const SizedBox(
                  width: 20,
                ),
                const Text('필수항목',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          child: TextField(
            controller: textEditingController_add_sheet,
            maxLines: 2,
            focusNode: searchNode_add_section,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintMaxLines: 2,
              hintText: '추가하실 컬렉션제목을 입력하세요',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45),
              isCollapsed: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.blue,
              ),
              onPressed: () {
                if (textEditingController_add_sheet.text.isEmpty) {
                  Flushbar(
                    backgroundColor: Colors.red.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('컬렉션 제목은 필수사항입니다.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    icon: const Icon(
                      Icons.info_outline,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    duration: const Duration(seconds: 1),
                    leftBarIndicatorColor: Colors.red.shade100,
                  ).show(context);
                } else {
                  setState(() {
                    Flushbar(
                      backgroundColor: Colors.green.shade400,
                      titleText: Text('Notice',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: contentTitleTextsize(),
                            fontWeight: FontWeight.bold,
                          )),
                      messageText: Text('잠시만 기다려주세요~',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: contentTextsize(),
                            fontWeight: FontWeight.bold,
                          )),
                      icon: const Icon(
                        Icons.info_outline,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      duration: const Duration(seconds: 1),
                      leftBarIndicatorColor: Colors.green.shade100,
                    ).show(context);
                    firestore.collection('MemoCollections').add({
                      'madeUser': username,
                      'title': textEditingController_add_sheet.text,
                    }).whenComplete(() {
                      Flushbar(
                        backgroundColor: Colors.blue.shade400,
                        titleText: Text('Notice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: contentTitleTextsize(),
                              fontWeight: FontWeight.bold,
                            )),
                        messageText: Text('정상적으로 추가되었습니다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: contentTextsize(),
                              fontWeight: FontWeight.bold,
                            )),
                        icon: const Icon(
                          Icons.info_outline,
                          size: 25.0,
                          color: Colors.white,
                        ),
                        duration: const Duration(seconds: 2),
                        leftBarIndicatorColor: Colors.blue.shade100,
                      ).show(context);
                    });
                  });
                }
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        'MY컬렉션에 추가',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 50,
          child: Text('MY 컬렉션',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 110,
            child: StatefulBuilder(builder: (_, StateSetter setState) {
              return StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('MemoCollections')
                    .where('madeUser', isEqualTo: username)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? ContainerDesign(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '생성된 메모컬렉션이 없습니다.\n추가 버튼으로 생성해보세요~',
                                    style: const NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Colors.green,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            color: Colors.white)
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    40) *
                                                0.6,
                                        height: 90,
                                        child: ContainerDesign(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: NeumorphicIcon(
                                                    Icons.verified,
                                                    size: 30,
                                                    style:
                                                        const NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: Colors.blue,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('제목',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTitleTextsize())),
                                                        Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['title'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTitleTextsize())),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            color: Colors.white),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              );
                            });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '생성된 메모컬렉션이 없습니다.\n추가 버튼으로 생성해보세요~',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            })),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.blue,
              ),
              onPressed: () {},
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '지정하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  });
}
