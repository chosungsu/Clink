// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../DB/PageList.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/Getx/uisetting.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../secondContentNet/ShowTips.dart';
import 'PageUI.dart';

SearchUI(scrollController, controller, double height, controller2) {
  return uiset.searchpagemove == ''
      ? Flexible(
          fit: FlexFit.tight,
          child: SizedBox(
            child: ScrollConfiguration(
              behavior: NoBehavior(),
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: StatefulBuilder(builder: (_, StateSetter setState) {
                    return GetBuilder<uisetting>(
                        builder: (_) => Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Se_Container0(height, controller),
                                SizedBox(
                                  height: 20,
                                ),
                                Se_Container01(height),
                                SizedBox(
                                  height: 20,
                                ),
                                Se_Container1(height),
                                SizedBox(
                                  height: 20,
                                ),
                                Se_Container11(height),
                                SizedBox(
                                  height: 20,
                                ),
                                Se_Container3(height),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ));
                  })),
            ),
          ))
      : ScrollConfiguration(
          behavior: NoBehavior(),
          child: Se_Container2(uiset.editpagelist[0].id.toString(),
              uiset.editpagelist[0].setting.toString(), controller2));
}

Se_Container0(double height, controller) {
  //프로버전 구매시 보이지 않게 함
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerDesign(
              color: draw.backgroundcolor,
              child: StatefulBuilder(
                builder: ((context, setState) {
                  return TextField(
                    onChanged: ((value) {
                      /*setState(() {
                        textchangelistener = value;
                      });*/
                      uiset.settextrecognizer(value);
                    }),
                    controller: controller,
                    maxLines: 1,
                    focusNode: searchNode,
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
                      hintText: '탐색하실 페이지 제목 입력',
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
              ))
        ],
      ),
    ),
  );
}

Se_Container01(
  double height,
) {
  return GetBuilder<uisetting>(
      builder: (_) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Pinchannel').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  uiset.searchpagelist.clear();
                  uiset.editpagelist.clear();
                  final valuespace = snapshot.data!.docs;
                  for (var sp in valuespace) {
                    final messageuser = sp.get('username');
                    final messagetitle = sp.get('linkname');
                    final messageemail = sp.get('email');
                    final messagesetting = sp.get('setting');
                    if (uiset.textrecognizer == '') {
                    } else {
                      if (messagetitle
                          .toString()
                          .contains(uiset.textrecognizer)) {
                        if (messagetitle == '빈 스페이스') {
                        } else {
                          uiset.searchpagelist.add(PageList(
                              title: messagetitle,
                              username: messageuser,
                              email: messageemail,
                              id: sp.id,
                              setting: messagesetting));
                        }
                      }
                    }
                  }

                  return uiset.searchpagelist.isEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerDesign(
                                child: SizedBox(
                                  height: 40.h,
                                  child: Center(
                                    child: NeumorphicText(
                                      '검색 결과 없음',
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: draw.color_textstatus,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                color: draw.backgroundcolor)
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerDesign(
                                color: draw.backgroundcolor,
                                child: GetBuilder<uisetting>(
                                  builder: (_) => ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: uiset.searchpagelist.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  searchNode.unfocus();
                                                  Hive.box('user_setting')
                                                      .put('page_index', 11);
                                                  uiset.setsearchpageindex(
                                                      index);
                                                  uiset.seteditpage(
                                                      uiset
                                                          .searchpagelist[index]
                                                          .title,
                                                      uiset
                                                          .searchpagelist[index]
                                                          .username
                                                          .toString(),
                                                      uiset
                                                          .searchpagelist[index]
                                                          .email
                                                          .toString(),
                                                      uiset
                                                          .searchpagelist[index]
                                                          .id
                                                          .toString(),
                                                      uiset
                                                          .searchpagelist[index]
                                                          .setting
                                                          .toString());
                                                },
                                                child: ContainerDesign(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                          fit: FlexFit.tight,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                uiset
                                                                    .searchpagelist[
                                                                        index]
                                                                    .title,
                                                                softWrap: true,
                                                                maxLines: 2,
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
                                                              Text(
                                                                uiset
                                                                    .searchpagelist[
                                                                        index]
                                                                    .email
                                                                    .toString(),
                                                                softWrap: true,
                                                                maxLines: 2,
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
                                                              )
                                                            ],
                                                          )),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: draw
                                                            .color_textstatus,
                                                      ),
                                                    ],
                                                  ),
                                                  color: draw.backgroundcolor,
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      }),
                                ))
                          ],
                        );
                }
                return ContainerDesign(
                    child: SizedBox(
                      height: 40.h,
                      child: Center(
                        child: NeumorphicText(
                          '검색 결과 없음',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: draw.color_textstatus,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    color: draw.backgroundcolor);
              },
            ),
          ));
}

Se_Container1(
  double height,
) {
  //프로버전 구매시 보이지 않게 함
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  '즐겨찾기 페이지',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: draw.color_textstatus),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Se_Container11(
  double height,
) {
  return GetBuilder<uisetting>(
      builder: (_) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Favorplace').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  uiset.favorpagelist.clear();
                  uiset.editpagelist.clear();
                  final valuespace = snapshot.data!.docs;
                  for (var sp in valuespace) {
                    final messageuser = sp.get('originuser');
                    final messagetitle = sp.get('title');
                    final messageadduser = sp.get('favoradduser');
                    final messageemail = sp.get('email');
                    final messageid = sp.get('id');
                    final messagesetting = sp.get('setting');
                    if (messageadduser == usercode) {
                      uiset.favorpagelist.add(PageList(
                          title: messagetitle,
                          email: messageemail,
                          username: messageuser,
                          id: messageid,
                          setting: messagesetting));
                    }
                  }

                  return uiset.favorpagelist.isEmpty
                      ? ContainerDesign(
                          child: SizedBox(
                            height: 40.h,
                            child: Center(
                              child: NeumorphicText(
                                '즐겨찾기 설정하신 페이지가 없네요',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: draw.color_textstatus,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          color: draw.backgroundcolor)
                      : ContainerDesign(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: uiset.favorpagelist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        searchNode.unfocus();
                                        Hive.box('user_setting')
                                            .put('page_index', 21);
                                        uiset.setfavorpageindex(index);
                                        uiset.seteditpage(
                                            uiset.favorpagelist[index].title,
                                            uiset.favorpagelist[index].username
                                                .toString(),
                                            uiset.favorpagelist[index].email
                                                .toString(),
                                            uiset.favorpagelist[index].id
                                                .toString(),
                                            uiset.favorpagelist[index].setting
                                                .toString());
                                      },
                                      child: ContainerDesign(
                                        color: draw.backgroundcolor,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      uiset.favorpagelist[index]
                                                          .title,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: draw
                                                              .color_textstatus,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      uiset.favorpagelist[index]
                                                          .email
                                                          .toString(),
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: draw
                                                              .color_textstatus,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                )),
                                            Icon(
                                              Icons.chevron_right,
                                              color: draw.color_textstatus,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),
                          color: draw.backgroundcolor,
                        );
                }
                return ContainerDesign(
                    child: SizedBox(
                      height: 40.h,
                      child: Center(
                        child: NeumorphicText(
                          '즐겨찾기 설정하신 페이지가 없네요',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: draw.color_textstatus,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    color: draw.backgroundcolor);
              },
            ),
          ));
}

Se_Container2(String id, String setting, TextEditingController controller) {
  return PageUI1(id, controller);
}

Se_Container3(
  double height,
) {
  //프로버전 구매시 보이지 않게 함
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  '페이지 팁',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: draw.color_textstatus),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ShowTips(
            height: height,
            pageindex: 0,
          ),
        ],
      ),
    ),
  );
}
