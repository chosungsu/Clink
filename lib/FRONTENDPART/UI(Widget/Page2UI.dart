// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/FIREBASE/PersonalVP.dart';
import '../../Tool/AndroidIOS.dart';
import '../../sheets/movetolinkspace.dart';
import '../Route/mainroute.dart';

UI2(id, controller, searchnode, maxWidth, maxHeight) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());

  return GetBuilder<linkspacesetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: PageViewStreamParent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PageViewRes1_1(id, snapshot);
                return linkspaceset.indexcnt.isEmpty
                    ? NotInPageScreen(
                        maxHeight, maxWidth, controller, searchnode)
                    : SizedBox(
                        height: maxHeight,
                        width: maxWidth,
                        child: Responsivelayout(
                            maxWidth,
                            PageUI0(context, id, controller, searchnode,
                                maxHeight, maxWidth),
                            PageUI1(context, id, controller, searchnode,
                                maxHeight, maxWidth)),
                      );
              } else if (!snapshot.hasData) {
                return NotInPageScreen(
                    maxHeight, maxWidth, controller, searchnode);
              }
              return CircularProgressIndicator(
                color: draw.color_textstatus,
              );
            },
          ));
}

PageUI0(context, id, controller, searchnode, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());
  return Row(
    children: [
      Container(
        width: maxWidth * 0.2,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: LSOtherRoom(maxHeight, maxWidth * 0.2, controller, searchnode),
      ),
      VerticalDivider(
        width: maxWidth * 0.1,
        color: draw.backgroundcolor,
      ),
      SizedBox(
          width: maxWidth * 0.7,
          child: WhatInPageScreen(id, controller, searchNode))
    ],
  );
}

PageUI1(context, id, controller, searchnode, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());
  return SingleChildScrollView(
    physics: const ScrollPhysics(),
    child: Column(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PROtherRoom(maxHeight, maxWidth, controller, searchnode),
        ),
        const SizedBox(
          height: 20,
        ),
        WhatInPageScreen(id, controller, searchNode)
      ],
    ),
  );
}

LSOtherRoom(maxHeight, maxWidth, controller, searchnode) {
  return GetBuilder<linkspacesetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: SpacepageStreamParent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SpacepageChild1(snapshot);

                return uiset.pagelist.isEmpty
                    ? SizedBox(
                        height: maxHeight,
                        width: maxWidth,
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
                              '해당 페이지는 비어있습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: draw.color_textstatus),
                            ),
                          ],
                        ),
                      )
                    : UserRoomScreen(
                        maxHeight, maxWidth, controller, searchnode, 'ls');
              }
              return CircularProgressIndicator(
                color: draw.color_textstatus,
              );
            },
          ));
}

PROtherRoom(maxHeight, maxWidth, controller, searchnode) {
  return GetBuilder<linkspacesetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: SpacepageStreamParent(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SpacepageChild1(snapshot);

                return uiset.pagelist.isEmpty
                    ? SizedBox(
                        width: maxWidth,
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
                              '해당 페이지는 비어있습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: draw.color_textstatus),
                            ),
                          ],
                        ),
                      )
                    : UserRoomScreen(
                        maxHeight, maxWidth, controller, searchnode, 'pr');
              }
              return CircularProgressIndicator(
                color: draw.color_textstatus,
              );
            },
          ));
}

UserRoomScreen(maxHeight, maxWidth, controller, searchnode, position) {
  return Container(
    width: position == 'pr' ? maxWidth : maxWidth - 40,
    height: position == 'pr' ? 100 : maxHeight,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: draw.color_textstatus, width: 1)),
    child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: position == 'pr' ? Axis.horizontal : Axis.vertical,
        shrinkWrap: true,
        itemCount: uiset.pagelist.length + 1,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: index == 0 && position == 'pr' ? 0 : 5,
                  right: 5,
                  top: 5,
                  bottom: 5),
              child: Container(
                height: 88,
                width: 70,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: draw.color_textstatus, width: 1)),
                      child: GestureDetector(
                          onTap: () {
                            if (index == 0) {
                            } else {
                              uiset.setmypagelistindex(index - 1);
                              StatusBarControl.setColor(BGColor(),
                                  animated: true);
                              draw.setnavi();
                              Get.offAll(() => const mainroute(index: 0),
                                  transition: Transition.fade);
                            }
                          },
                          onLongPress: () {
                            if (index == 0) {
                            } else {
                              settingseparatedlinkspace(context, uiset.pagelist,
                                  controller, searchnode, index - 1);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: draw.backgroundcolor),
                            child: index == 0
                                ? const Icon(
                                    Ionicons.add_outline,
                                    size: 30,
                                    color: Colors.blue,
                                  )
                                : const Icon(
                                    Ionicons.ios_folder_open_outline,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                          )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 70,
                      height: 30,
                      child: Text(
                        index == 0 ? 'New' : uiset.pagelist[index - 1].title,
                        softWrap: true,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.15,
                            color: draw.color_textstatus,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()),
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
              ));
        }),
  );
}

NotInPageScreen(maxHeight, maxWidth, controller, searchnode) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: Responsivelayout(
        maxWidth,
        SizedBox(
          height: maxHeight,
          width: maxWidth,
          child: Row(
            children: [
              Container(
                  width: maxWidth * 0.2,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: UserRoomScreen(
                      maxHeight, maxWidth, controller, searchnode, 'ls')),
              VerticalDivider(
                width: maxWidth * 0.1,
                color: draw.backgroundcolor,
              ),
              SizedBox(
                width: maxWidth * 0.7,
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
                      '해당 페이지는 비어있습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: maxHeight,
          width: maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: UserRoomScreen(
                      maxHeight, maxWidth, controller, searchnode, 'pr')),
              SizedBox(
                height: maxHeight - 100,
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
                      '해당 페이지는 비어있습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
  );
}

WhatInPageScreen(id, controller, searchNode) {
  return ListView.builder(
      //controller: scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      physics: const ScrollPhysics(),
      itemCount: linkspaceset.indexcnt.length,
      itemBuilder: ((context, index) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () async {},
                child: ContainerDesign(
                    color: draw.backgroundcolor,
                    child: SizedBox(
                        child: Column(
                      children: [
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  linkspaceset.indexcnt[index].placestr,
                                  style: TextStyle(
                                      color: draw.color_textstatus,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize()),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  PageViewStreamChild1(context, id, index);
                                },
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: draw.color_textstatus,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  PageViewStreamChild2(context, id, index,
                                      controller, searchNode);
                                },
                                child: Icon(
                                  Icons.more_horiz,
                                  color: draw.color_textstatus,
                                ),
                              )
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: PageViewStreamParent2(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                PageViewRes2(id, snapshot, index);
                                if (linkspaceset
                                    .indextreetmp[index].isNotEmpty) {
                                  return SizedBox(
                                      height: (linkspaceset
                                              .indextreetmp[index].length) *
                                          140,
                                      child: ListView.builder(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: linkspaceset
                                              .indextreetmp[index].length,
                                          itemBuilder: ((context, index2) {
                                            return Column(
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    PageViewStreamChild3(
                                                        context,
                                                        id,
                                                        index,
                                                        index2);
                                                  },
                                                  child: ContainerDesign(
                                                      color:
                                                          draw.backgroundcolor,
                                                      child: SizedBox(
                                                        height: 100,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Flexible(
                                                                  fit: FlexFit
                                                                      .tight,
                                                                  child: Text(
                                                                    linkspaceset
                                                                        .indextreetmp[
                                                                            index]
                                                                            [
                                                                            index2]
                                                                        .placestr,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: draw
                                                                            .color_textstatus,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            contentTextsize()),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    PageViewStreamChild4(
                                                                        context,
                                                                        id,
                                                                        index,
                                                                        index2,
                                                                        controller,
                                                                        searchNode,
                                                                        snapshot);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .more_horiz,
                                                                    color: draw
                                                                        .color_textstatus,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          })));
                                } else {
                                  return SizedBox(
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            linkspaceset.indexcnt[index].type ==
                                                    0
                                                ? '이 공간은 이미지, 파일을 보여주는 공간입니다.'
                                                : (linkspaceset.indexcnt[index]
                                                            .type ==
                                                        1
                                                    ? '이 공간은 캘린더 일정을 보여주는 공간입니다.'
                                                    : (linkspaceset
                                                                .indexcnt[index]
                                                                .type ==
                                                            2
                                                        ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                        : '이 공간은 메모를 보여주는 공간입니다.')),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize()),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: SpinKitThreeBounce(
                                          size: 25,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: Colors.blue.shade200,
                                                  shape: BoxShape.circle),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          linkspaceset.indexcnt[index].type == 0
                                              ? '이 공간은 이미지, 파일, URL링크를 클립보드 형식으로 보여주는 공간입니다.'
                                              : (linkspaceset.indexcnt[index]
                                                          .type ==
                                                      1
                                                  ? '이 공간은 캘린더 바로가기를 보여주는 공간입니다.'
                                                  : (linkspaceset
                                                              .indexcnt[index]
                                                              .type ==
                                                          2
                                                      ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                      : '이 공간은 메모를 보여주는 공간입니다.')),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize()),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }))
                      ],
                    )))),
            index == linkspaceset.indexcnt.length - 1
                ? const SizedBox(
                    height: 50,
                  )
                : const SizedBox(
                    height: 10,
                  ),
          ],
        );
      }));
}
