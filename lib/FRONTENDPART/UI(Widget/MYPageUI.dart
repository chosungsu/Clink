// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/FIREBASE/PersonalVP.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/Getx/uisetting.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());

UI(id, controller, searchnode, maxWidth, maxHeight) {
  return GetBuilder<uisetting>(
    builder: (_) {
      return StreamBuilder<QuerySnapshot>(
        stream: PageViewStreamParent1(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PageViewRes1_1(id, snapshot);
            return linkspaceset.indexcnt.isEmpty
                ? NotInPageScreen(maxHeight, maxWidth, controller, searchnode)
                : SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: Responsivelayout(
                        PageUI0(context, id, controller, searchnode, maxHeight,
                            maxWidth),
                        PageUI1(context, id, controller, searchnode, maxHeight,
                            maxWidth)),
                  );
          } else if (!snapshot.hasData) {
            return NotInPageScreen(maxHeight, maxWidth, controller, searchnode);
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

PageUI0(context, id, controller, searchnode, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  return GetBuilder<linkspacesetting>(
    builder: (_) {
      return Row(
        children: [
          Container(
            width: 220,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Room(maxHeight, 220, controller, searchnode, 'ls'),
          ),
          VerticalDivider(
            width: maxWidth * 0.1,
            color: draw.backgroundcolor,
          ),
          SizedBox(
              width: maxWidth - 220 - maxWidth * 0.1,
              height: maxHeight,
              child: WhatInPageScreen(context, id, controller, searchNode,
                  maxWidth - 220 - maxWidth * 0.1, maxHeight))
        ],
      );
    },
  );
}

PageUI1(context, id, controller, searchnode, maxHeight, maxWidth) {
  final searchNode = FocusNode();
  return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: GetBuilder<linkspacesetting>(
        builder: (_) {
          return Column(
            children: [
              Container(
                height: 120,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Room(120, maxWidth, controller, searchnode, 'pr'),
              ),
              const SizedBox(
                height: 20,
              ),
              WhatInPageScreen(
                  context, id, controller, searchNode, maxWidth, maxHeight)
            ],
          );
        },
      ));
}

Room(maxHeight, maxWidth, controller, searchnode, string) {
  return GetBuilder<uisetting>(
    builder: (_) {
      return StreamBuilder<QuerySnapshot>(
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
                          '페이지가 없습니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: contentTextsize(),
                              color: draw.color_textstatus),
                        ),
                      ],
                    ),
                  )
                : UserRoomScreen(
                    maxHeight, maxWidth, controller, searchnode, string);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: draw.color_textstatus,
                ),
              )
            ],
          );
        },
      );
    },
  );
}

UserRoomScreen(maxHeight, maxWidth, controller, searchnode, position) {
  Widget title;
  Widget content;
  Widget btn;
  return ContainerDesign(
    color: draw.backgroundcolor,
    child: SizedBox(
      width: maxWidth + .0,
      height: maxHeight + .0,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: position == 'pr' ? Axis.horizontal : Axis.vertical,
          shrinkWrap: false,
          itemCount: uiset.pagelist.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: position == 'pr'
                    ? const EdgeInsets.only(left: 5, right: 5)
                    : const EdgeInsets.only(top: 5, bottom: 5),
                child: position == 'pr'
                    ? Container(
                        height: 90,
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
                                      color: index == uiset.mypagelistindex
                                          ? Colors.pink.shade300
                                          : draw.color_textstatus,
                                      width: 1)),
                              child: GestureDetector(
                                  onTap: () {
                                    uiset.setmypagelistindex(index);
                                  },
                                  onLongPress: () {
                                    title = Widgets_editpageconsole(context,
                                        controller, searchnode, index)[0];
                                    content = Widgets_editpageconsole(context,
                                        controller, searchnode, index)[1];
                                    AddContent(
                                        context, title, content, searchnode);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: draw.backgroundcolor),
                                    child: const Icon(
                                      Ionicons.ios_folder_open_outline,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                width: 70,
                                height: 30,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ScrollPhysics(),
                                  child: Text(
                                    uiset.pagelist[index].title,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1,
                                        color: draw.color_textstatus,
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize()),
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Container(
                        height: 50,
                        width: 220,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: index == uiset.mypagelistindex
                                          ? Colors.pink.shade300
                                          : draw.color_textstatus,
                                      width: 1)),
                              child: GestureDetector(
                                  onTap: () {
                                    uiset.setmypagelistindex(index);
                                  },
                                  onLongPress: () {
                                    title = Widgets_editpageconsole(context,
                                        controller, searchnode, index)[0];
                                    content = Widgets_editpageconsole(context,
                                        controller, searchnode, index)[1];
                                    AddContent(
                                        context, title, content, searchnode);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: draw.backgroundcolor),
                                    child: const Icon(
                                      Ionicons.ios_folder_open_outline,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: 90,
                                height: 50,
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ScrollPhysics(),
                                  child: Text(
                                    uiset.pagelist[index].title,
                                    softWrap: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1,
                                        color: draw.color_textstatus,
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize()),
                                  ),
                                ))
                          ],
                        ),
                      ));
          }),
    ),
  );
}

NotInPageScreen(maxHeight, maxWidth, controller, searchnode) {
  return SizedBox(
    width: maxWidth,
    height: maxHeight,
    child: Responsivelayout(
        SizedBox(
          height: maxHeight,
          width: maxWidth,
          child: Row(
            children: [
              Container(
                  width: 220,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: UserRoomScreen(
                      maxHeight, 220, controller, searchnode, 'ls')),
              VerticalDivider(
                width: maxWidth * 0.1,
                color: draw.backgroundcolor,
              ),
              SizedBox(
                width: maxWidth - 220 - maxWidth * 0.1,
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
                  height: 120,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: UserRoomScreen(
                      120, maxWidth, controller, searchnode, 'pr')),
              SizedBox(
                height: maxHeight - 120,
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

WhatInPageScreen(context, id, controller, searchNode, maxWidth, maxHeight) {
  return Responsivelayout(
      SizedBox(
        width: maxWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: List.generate(linkspaceset.indexcnt.length, (index) {
                return Container(
                  width: maxWidth,
                  margin: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () async {},
                          child: ContainerDesign(
                              color: draw.backgroundcolor,
                              child: SizedBox(
                                  child: Column(
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: const ScrollPhysics(),
                                              child: Text(
                                                linkspaceset
                                                    .indexcnt[index].placestr,
                                                style: TextStyle(
                                                    color:
                                                        draw.color_textstatus,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                              ),
                                            )),
                                        InkWell(
                                          onTap: () async {
                                            pageaddlogic(context, id, index);
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
                                            pageeditlogic(context, id, index,
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
                                                        .indextreetmp[index]
                                                        .length) *
                                                    140,
                                                child: ListView.builder(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount: linkspaceset
                                                        .indextreetmp[index]
                                                        .length,
                                                    itemBuilder:
                                                        ((context, index2) {
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
                                                            child:
                                                                ContainerDesign(
                                                                    color: draw
                                                                        .backgroundcolor,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Flexible(
                                                                                fit: FlexFit.tight,
                                                                                child: Text(
                                                                                  linkspaceset.indextreetmp[index][index2].placestr,
                                                                                  textAlign: TextAlign.start,
                                                                                  style: TextStyle(color: draw.color_textstatus, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  PageViewStreamChild4(context, id, index, index2, controller, searchNode, snapshot);
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.more_horiz,
                                                                                  color: draw.color_textstatus,
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
                                                      linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .type ==
                                                              0
                                                          ? '이 공간은 이미지, 파일을 보여주는 공간입니다.'
                                                          : (linkspaceset
                                                                      .indexcnt[
                                                                          index]
                                                                      .type ==
                                                                  1
                                                              ? '이 공간은 캘린더 일정을 보여주는 공간입니다.'
                                                              : (linkspaceset
                                                                          .indexcnt[
                                                                              index]
                                                                          .type ==
                                                                      2
                                                                  ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                                  : '이 공간은 메모를 보여주는 공간입니다.')),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: SpinKitThreeBounce(
                                                    size: 25,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade200,
                                                                shape: BoxShape
                                                                    .circle),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    linkspaceset.indexcnt[index]
                                                                .type ==
                                                            0
                                                        ? '이 공간은 이미지, 파일, URL링크를 클립보드 형식으로 보여주는 공간입니다.'
                                                        : (linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .type ==
                                                                1
                                                            ? '이 공간은 캘린더 바로가기를 보여주는 공간입니다.'
                                                            : (linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .type ==
                                                                    2
                                                                ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                                : '이 공간은 메모를 보여주는 공간입니다.')),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      }))
                                ],
                              )))),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              })),
        ),
      ),
      ListView.builder(
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
                                      pageaddlogic(context, id, index);
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
                                      pageeditlogic(context, id, index,
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
                                                          color: draw
                                                              .backgroundcolor,
                                                          child: SizedBox(
                                                            height: 100,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Flexible(
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          Text(
                                                                        linkspaceset
                                                                            .indextreetmp[index][index2]
                                                                            .placestr,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: TextStyle(
                                                                            color:
                                                                                draw.color_textstatus,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: contentTextsize()),
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
                                                                      child:
                                                                          Icon(
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
                                                linkspaceset.indexcnt[index]
                                                            .type ==
                                                        0
                                                    ? '이 공간은 이미지, 파일을 보여주는 공간입니다.'
                                                    : (linkspaceset
                                                                .indexcnt[index]
                                                                .type ==
                                                            1
                                                        ? '이 공간은 캘린더 일정을 보여주는 공간입니다.'
                                                        : (linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .type ==
                                                                2
                                                            ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                            : '이 공간은 메모를 보여주는 공간입니다.')),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: SpinKitThreeBounce(
                                              size: 25,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade200,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              linkspaceset.indexcnt[index]
                                                          .type ==
                                                      0
                                                  ? '이 공간은 이미지, 파일, URL링크를 클립보드 형식으로 보여주는 공간입니다.'
                                                  : (linkspaceset
                                                              .indexcnt[index]
                                                              .type ==
                                                          1
                                                      ? '이 공간은 캘린더 바로가기를 보여주는 공간입니다.'
                                                      : (linkspaceset
                                                                  .indexcnt[
                                                                      index]
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
          })));
}
