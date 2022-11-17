// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../DB/Linkpage.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/linksettingsheet.dart';

PageUI1(String title, String id) {
  print(id);
  return GetBuilder<linkspacesetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('PageView').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                linkspaceset.indextreetmp.clear();
                linkspaceset.indexcnt.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  pagename = sp.get('pagename');
                  spacename = sp.get('spacename');
                  type = sp.get('type');
                  if (sp.get('id') == id) {
                    print('here');
                    linkspaceset.indextreetmp.add(List.empty(growable: true));
                    linkspaceset.indexcnt.add(Linkspacepage(
                        type: sp.get('type'),
                        placestr: sp.get('spacename'),
                        uniquecode: sp.get('id')));
                  }
                }
                linkspaceset.indexcnt.sort(((a, b) {
                  return a.placestr.compareTo(b.placestr);
                }));
                return linkspaceset.indexcnt.isEmpty
                    ? Flexible(
                        fit: FlexFit.tight,
                        child: Center(
                          child: NeumorphicText(
                            '텅! 비어있어요~',
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
                        ))
                    : ListView.builder(
                        //controller: scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        physics: const NeverScrollableScrollPhysics(),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    linkspaceset.indexcnt[index]
                                                        .placestr,
                                                    style: TextStyle(
                                                        color: draw
                                                            .color_textstatus,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    linkmadetreeplace(
                                                        context,
                                                        usercode,
                                                        uiset.pagelist[0].title,
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .placestr,
                                                        index,
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .uniquecode);
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    color:
                                                        draw.color_textstatus,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    linkplacechangeoptions(
                                                        context,
                                                        usercode,
                                                        uiset.pagelist[0].title,
                                                        index,
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .placestr,
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .uniquecode,
                                                        linkspaceset
                                                            .indexcnt[index]
                                                            .type);
                                                  },
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color:
                                                        draw.color_textstatus,
                                                  ),
                                                )
                                              ]),
                                          /*const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder(
                                                future: MongoDB.getData(
                                                  collectionname: 'PageView',
                                                ).then((value) {
                                                  linkspaceset
                                                      .indextreetmp[index]
                                                      .clear();
                                                  if (value.isEmpty) {
                                                  } else {
                                                    for (var sp in value) {
                                                      pagename =
                                                          sp.get('pagename');
                                                      spacename =
                                                          sp.get('spacename');
                                                      type = sp.get('type');
                                                      spacein =
                                                          sp.get('urllist');
                                                          
                                                      if (linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .type ==
                                                              type &&
                                                          linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr ==
                                                              spacename) {
                                                        linkspaceset
                                                            .indextreetmp[index]
                                                            .add(Linkspacetreepage(
                                                                subindex: linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length,
                                                                placestr: sp[
                                                                    'addname'],
                                                                uniqueid: sp[
                                                                    'id']));
                                                      }
                                                    }
                                                    linkspaceset
                                                        .indextreetmp[index]
                                                        .sort(((a, b) {
                                                      return a.placestr
                                                          .compareTo(
                                                              b.placestr);
                                                    }));
                                                  }
                                                }),
                                                builder: ((context, snapshot) {
                                                  if (linkspaceset
                                                      .indextreetmp[index]
                                                      .isNotEmpty) {
                                                    return SizedBox(
                                                        height: linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr ==
                                                                'board'
                                                            ? (linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length) *
                                                                200
                                                            : (linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .placestr ==
                                                                    'card'
                                                                ? (linkspaceset
                                                                        .indextreetmp[
                                                                            index]
                                                                        .length) *
                                                                    130
                                                                : (linkspaceset
                                                                        .indextreetmp[
                                                                            index]
                                                                        .length) *
                                                                    130),
                                                        child: ListView.builder(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10,
                                                              right: 10,
                                                            ),
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ScrollPhysics(),
                                                            itemCount: linkspaceset
                                                                .indextreetmp[
                                                                    index]
                                                                .length,
                                                            itemBuilder:
                                                                ((context,
                                                                    index2) {
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ContainerDesign(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          SizedBox(
                                                                        height: linkspaceset.indexcnt[index].placestr ==
                                                                                'board'
                                                                            ? 150
                                                                            : (linkspaceset.indexcnt[index].placestr == 'card'
                                                                                ? 80
                                                                                : 80),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                _controller.text = linkspaceset.indextreetmp[index][index2].placestr == '' ? '' : linkspaceset.indextreetmp[index][index2].placestr;
                                                                                linkplacenamechange(context, usercode, linkspaceset.indextreetmp[index][index2].uniqueid, index2, linkspaceset.indextreetmp[index][index2].placestr, searchNode, _controller, linkspaceset.indexcnt[index].placestr);
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Flexible(
                                                                                    fit: FlexFit.tight,
                                                                                    child: Text(
                                                                                      linkspaceset.indextreetmp[index][index2].placestr == '' ? '제목없음' : linkspaceset.indextreetmp[index][index2].placestr,
                                                                                      textAlign: TextAlign.start,
                                                                                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  const Icon(
                                                                                    Icons.edit,
                                                                                    color: Colors.black45,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              );
                                                            })));
                                                  } else {
                                                    return SizedBox(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              linkspaceset
                                                                          .indexcnt[
                                                                              index]
                                                                          .placestr ==
                                                                      'board'
                                                                  ? '보드 공간은 이미지모음, 메모를 클립보드 형식으로 보여주는 공간입니다.'
                                                                  : (linkspaceset
                                                                              .indexcnt[index]
                                                                              .placestr ==
                                                                          'card'
                                                                      ? '카드 공간은 링크 및 파일을 바로가기 카드뷰로 보여주는 공간입니다.'
                                                                      : '캘린더 공간은 캘린더 형식만을 보여주는 공간입니다.'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize()),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }))*/
                                        ],
                                      )))),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }));
              } else if (!snapshot.hasData) {
                return Flexible(
                    fit: FlexFit.tight,
                    child: Center(
                      child: NeumorphicText(
                        '텅! 비어있어요~',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: TextColor_shadowcolor(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ));
              }
              return SizedBox(
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: BGColor(),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            },
          ));
}
