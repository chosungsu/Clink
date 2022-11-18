// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../DB/Linkpage.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/linksettingsheet.dart';

PageUI1(String id, TextEditingController controller) {
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
                    linkspaceset.indextreetmp.add(List.empty(growable: true));
                    linkspaceset.indexcnt.add(Linkspacepage(
                        type: sp.get('type'),
                        placestr: sp.get('spacename'),
                        uniquecode: sp.get('id'),
                        familycode: sp.id));
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
                                                  onTap: () async {
                                                    await firestore
                                                        .collection(
                                                            'Pinchannel')
                                                        .doc(id)
                                                        .get()
                                                        .then(
                                                      (value) {
                                                        if (value.get(
                                                                'username') ==
                                                            usercode) {
                                                          linkmadetreeplace(
                                                            context,
                                                            usercode,
                                                            uiset.pagelist[0]
                                                                .title,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .placestr,
                                                            linkspaceset
                                                                .indextreetmp[
                                                                    index]
                                                                .length,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .familycode,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .type,
                                                          );
                                                        } else {
                                                          if (value.get(
                                                                  'setting') ==
                                                              'block') {
                                                          } else {
                                                            linkmadetreeplace(
                                                              context,
                                                              usercode,
                                                              uiset.pagelist[0]
                                                                  .title,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr,
                                                              linkspaceset
                                                                  .indextreetmp[
                                                                      index]
                                                                  .length,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .familycode,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .type,
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
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
                                                  onTap: () async {
                                                    await firestore
                                                        .collection(
                                                            'Pinchannel')
                                                        .doc(id)
                                                        .get()
                                                        .then(
                                                      (value) {
                                                        if (value.get(
                                                                'username') ==
                                                            usercode) {
                                                          linkplacechangeoptions(
                                                              context,
                                                              index,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .uniquecode,
                                                              linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .type,
                                                              controller,
                                                              searchNode,
                                                              'pinchannel');
                                                        } else {
                                                          if (value.get(
                                                                  'setting') ==
                                                              'block') {
                                                          } else {
                                                            linkplacechangeoptions(
                                                                context,
                                                                index,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .uniquecode,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .type,
                                                                controller,
                                                                searchNode,
                                                                'pinchannel');
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.more_horiz,
                                                    color:
                                                        draw.color_textstatus,
                                                  ),
                                                )
                                              ]),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                              stream: firestore
                                                  .collection('Pinchannelin')
                                                  .snapshots(),
                                              builder: ((context, snapshot) {
                                                if (snapshot.hasData) {
                                                  linkspaceset
                                                      .indextreetmp[index]
                                                      .clear();
                                                  final valuespace =
                                                      snapshot.data!.docs;
                                                  for (var sp in valuespace) {
                                                    spacename =
                                                        sp.get('addname');
                                                    if (linkspaceset
                                                            .indexcnt[index]
                                                            .familycode ==
                                                        sp.get('uniquecode')) {
                                                      linkspaceset
                                                          .indextreetmp[index]
                                                          .add(Linkspacetreepage(
                                                              subindex: sp
                                                                  .get('index'),
                                                              placestr:
                                                                  spacename,
                                                              uniqueid: sp.get(
                                                                  'uniquecode')));
                                                    }
                                                  }
                                                  linkspaceset
                                                      .indextreetmp[index]
                                                      .sort(((a, b) {
                                                    return a.subindex
                                                        .compareTo(b.subindex);
                                                  }));
                                                  if (linkspaceset
                                                      .indextreetmp[index]
                                                      .isNotEmpty) {
                                                    return SizedBox(
                                                        height: (linkspaceset
                                                                .indextreetmp[
                                                                    index]
                                                                .length) *
                                                            140,
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
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Flexible(
                                                                                  fit: FlexFit.tight,
                                                                                  child: Text(
                                                                                    linkspaceset.indextreetmp[index][index2].placestr,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: TextStyle(color: draw.color_textstatus, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    await firestore.collection('Pinchannel').doc(id).get().then(
                                                                                      (value) {
                                                                                        if (value.get('username') == usercode) {
                                                                                          linkplacechangeoptions(context, index2, linkspaceset.indextreetmp[index][index2].placestr, linkspaceset.indextreetmp[index][index2].uniqueid, 0, controller, searchNode, 'pinchannelin');
                                                                                        } else {
                                                                                          if (value.get('setting') == 'block') {
                                                                                          } else {
                                                                                            linkplacechangeoptions(context, index2, linkspaceset.indextreetmp[index][index2].placestr, linkspaceset.indextreetmp[index][index2].uniqueid, 0, controller, searchNode, 'pinchannelin');
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                    );
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
                                                                          .type ==
                                                                      0
                                                                  ? '이 공간은 이미지, 파일, URL링크를 클립보드 형식으로 보여주는 공간입니다.'
                                                                  : (linkspaceset
                                                                              .indexcnt[
                                                                                  index]
                                                                              .type ==
                                                                          1
                                                                      ? '이 공간은 캘린더 바로가기를 보여주는 공간입니다.'
                                                                      : (linkspaceset.indexcnt[index].type ==
                                                                              2
                                                                          ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                                          : '이 공간은 메모를 보여주는 공간입니다.')),
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
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(
                                                    height: 150,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child:
                                                              SpinKitThreeBounce(
                                                            size: 25,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return DecoratedBox(
                                                                decoration: BoxDecoration(
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
                                                                        .type ==
                                                                    0
                                                                ? '이 공간은 이미지, 파일, URL링크를 클립보드 형식으로 보여주는 공간입니다.'
                                                                : (linkspaceset
                                                                            .indexcnt[
                                                                                index]
                                                                            .type ==
                                                                        1
                                                                    ? '이 공간은 캘린더 바로가기를 보여주는 공간입니다.'
                                                                    : (linkspaceset.indexcnt[index].type ==
                                                                            2
                                                                        ? '이 공간은 투두리스트를 보여주는 공간입니다.'
                                                                        : '이 공간은 메모를 보여주는 공간입니다.')),
                                                            textAlign: TextAlign
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
                                              }))
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
