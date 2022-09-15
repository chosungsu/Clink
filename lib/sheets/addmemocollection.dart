import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';

import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/selectcollection.dart';

SheetPagememoCollection(
  BuildContext context,
  String username,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
  String s,
  selectcollection scollection,
  bool isresponsive,
) {
  return SizedBox(
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(context, username, textEditingController_add_sheet,
                  searchNode_add_section, s, scollection, isresponsive)
            ],
          )));
}

content(
    BuildContext context,
    String username,
    TextEditingController textEditingController_add_sheet,
    FocusNode searchNode_add_section,
    String s,
    selectcollection scollection,
    bool isresponsive) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController pageController =
      PageController(initialPage: s == 'outside' ? 0 : 1);
  String selectvalue = '';
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
      height: isresponsive == true ? 290 * 2 - 50 : 290,
      child: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        children: [
          SizedBox.expand(
            child: Column(
              children: [
                SizedBox(
                    height: isresponsive == true ? 100 : 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('추가하기',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                      ],
                    )),
                SizedBox(
                  height: isresponsive == true ? 40 : 20,
                ),
                SizedBox(
                    height: isresponsive == true ? 60 : 30,
                    child: Row(
                      children: [
                        Text('태그 제목',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text('필수항목',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    )),
                SizedBox(
                  height: isresponsive == true ? 40 : 20,
                ),
                SizedBox(
                  height: isresponsive == true ? 80 : 40,
                  child: TextField(
                    controller: textEditingController_add_sheet,
                    maxLines: 2,
                    focusNode: searchNode_add_section,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintMaxLines: 2,
                      hintText: '추가하실 태그제목을 입력하세요',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black45),
                      isCollapsed: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: isresponsive == true ? 40 : 20,
                ),
                SizedBox(
                  height: isresponsive == true ? 50 : 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        if (textEditingController_add_sheet.text.isEmpty) {
                          /*openSnackbar(
                              'Notice', '태그 제목은 필수사항입니다.', Colors.red.shade100);*/
                          Snack.show(
                              context: context,
                              title: '경고',
                              content: '태그 제목은 필수사항입니다.',
                              snackType: SnackType.warning,
                              behavior: SnackBarBehavior.floating);
                        } else {
                          setState(() {
                            Snack.show(
                                context: context,
                                title: '로딩중',
                                content: '잠시만 기다려주세요~',
                                snackType: SnackType.waiting,
                                behavior: SnackBarBehavior.floating);
                            firestore.collection('MemoCollections').add({
                              'madeUser': username,
                              'title': textEditingController_add_sheet.text,
                            }).whenComplete(() {
                              setState(() {
                                textEditingController_add_sheet.clear();
                                Snack.show(
                                    context: context,
                                    title: '알림',
                                    content: '정상적으로 추가되었습니다.',
                                    snackType: SnackType.info,
                                    behavior: SnackBarBehavior.floating);
                              });
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
                                'MY태그에 추가',
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
                SizedBox(
                  height: isresponsive == true ? 10 : 5,
                ),
                SizedBox(
                    height: isresponsive == true ? 80 : 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('MY태그 확인은 아래로 스크롤',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Icon(
                          Icons.keyboard_double_arrow_down,
                          size: 15,
                          color: Colors.black45,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox.expand(
            child: Column(
              children: [
                SizedBox(
                    height: isresponsive == true ? 80 : 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('태그 추가는 위로 스크롤',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Icon(
                          Icons.keyboard_double_arrow_up,
                          size: 15,
                          color: Colors.black45,
                        ),
                      ],
                    )),
                SizedBox(
                  height: isresponsive == true ? 10 : 5,
                ),
                SizedBox(
                    height: isresponsive == true ? 100 : 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('MY 태그',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                      ],
                    )),
                SizedBox(
                  height: isresponsive == true ? 20 : 10,
                ),
                SizedBox(
                    height: isresponsive == true ? 220 : 110,
                    child: StatefulBuilder(builder: (_, StateSetter setState) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('MemoCollections')
                            .where('madeUser', isEqualTo: username)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isEmpty
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '생성된 메모태그가 없습니다.\n추가 버튼으로 생성해보세요~',
                                            style: const NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTitleTextsize(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
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
                                                width: 200,
                                                height: 90,
                                                child: ContainerDesign(
                                                    child: Row(
                                                      children: [
                                                        Radio(
                                                          value: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['title']
                                                              .toString(),
                                                          groupValue:
                                                              selectvalue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectvalue = value
                                                                  .toString();
                                                            });
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
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
                                                                Text(
                                                                    snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'title'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            contentTextsize())),
                                                              ],
                                                            )),
                                                        InkWell(
                                                          onTap: () {
                                                            /*openSnackbar(
                                                                'Notice',
                                                                '잠시만 기다려주세요~',
                                                                Colors.green
                                                                    .shade100);*/
                                                            Snack.show(
                                                                context:
                                                                    context,
                                                                title: '로딩중',
                                                                content:
                                                                    '잠시만 기다려주세요~',
                                                                snackType:
                                                                    SnackType
                                                                        .waiting,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating);
                                                            firestore
                                                                .collection(
                                                                    'MemoCollections')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id)
                                                                .delete()
                                                                .whenComplete(
                                                                    () {
                                                              Snack.show(
                                                                  context:
                                                                      context,
                                                                  title: '알림',
                                                                  content:
                                                                      '정상적으로 삭제가 되었습니다.',
                                                                  snackType:
                                                                      SnackType
                                                                          .info,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating);
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.delete,
                                                            size: 25,
                                                            color: Colors.red,
                                                          ),
                                                        )
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
                              children: const [
                                Center(child: CircularProgressIndicator())
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '생성된 메모태그가 없습니다.\n추가 버튼으로 생성해보세요~',
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
                SizedBox(
                  height: isresponsive == true ? 40 : 20,
                ),
                s == 'outside'
                    ? SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              Snack.show(
                                  context: context,
                                  title: '경고',
                                  content: '현재 페이지에서는 사용할 수 없는 기능입니다.',
                                  snackType: SnackType.warning,
                                  behavior: SnackBarBehavior.floating);
                            },
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
                      )
                    : SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.blue,
                            ),
                            onPressed: () {
                              if (selectvalue == '' || selectvalue == null) {
                                Snack.show(
                                    context: context,
                                    title: '경고',
                                    content: '태그가 지정되지 않았습니다.',
                                    snackType: SnackType.warning,
                                    behavior: SnackBarBehavior.floating);
                              } else {
                                Hive.box('user_setting')
                                    .put('memocollection', selectvalue);
                                scollection.setcollection();
                                Get.back();
                              }
                            },
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
            ),
          )
        ],
      ),
    );
  });
}
