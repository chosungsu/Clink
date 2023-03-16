// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, empty_catches

import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';
import '../../BACKENDPART/Enums/Linkpage.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/calendarsetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import 'DayContentHome.dart';

/*SpaceinUI(
  String id,
  int type,
  bool isinit,
) {
  return StatefulBuilder(builder: ((context, setState) {
    return GetBuilder<linkspacesetting>(
        builder: (_) => isinit == false
            ? DefaultUI(
                id,
                type,
              )
            : DayContentHome(id));
  }));
}

DefaultUI(id, type) {
  final searchNode = FocusNode();
  final peopleadd = Get.put(PeopleAdd());
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final controll_cals = Get.put(calendarsetting());
  final linkspaceset = Get.put(linkspacesetting());
  linkspaceset.ischecked = List.filled(10000, false);
  linkspaceset.islongchecked = List.filled(10000, false);

  return StatefulBuilder(builder: ((context, setState) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('Pinchannelin').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          linkspaceset.inindextreetmp.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            spacefamilyid = sp.id;
            spacefamilytype = sp.get('type');
            spacefamilyindex = sp.get('index');
            if (spacefamilyid == id) {
              if (type == 1) {
                linkspaceset.inindextreetmp.add(Linkspacepageenter(
                    placeentercode: sp.get('spaceentercontent'),
                    addname: sp.get('addname')));
              } else {
                for (int i = 0; i < sp.get('spaceentercontent').length; i++) {
                  linkspaceset.inindextreetmp.add(Linkspacepageenter(
                      placeentercode: sp.get('spaceentercontent')[i].toString(),
                      substrcode: sp
                          .get('spaceentercontent')[i]
                          .toString()
                          .replaceAll(
                              RegExp(
                                  'https://firebasestorage.googleapis.com/v0/b/habit-tracker-8dad1.appspot.com/o/${id}%2F'),
                              '')
                          .split('?')[0]));
                }
              }
            }
          }

          return linkspaceset.inindextreetmp.isEmpty
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
              : (type == 1
                  ? (linkspaceset.inindextreetmp[0].placeentercode == ''
                      ? Flexible(
                          fit: FlexFit.tight,
                          child: Center(
                            child: GestureDetector(
                              onTap: () async {
                                Snack.snackbars(
                                    context: context,
                                    title: '불러오는 중입니다.',
                                    backgroundcolor: Colors.green,
                                    bordercolor: draw.backgroundcolor);
                                await firestore
                                    .collection('Pinchannelin')
                                    .doc(id)
                                    .update({
                                  'spaceentercontent': usercode
                                }).whenComplete(() async {
                                  await firestore.collection('Calendar').add({
                                    'parentid': id,
                                    'allowance_change_set': false,
                                    'allowance_share': false,
                                    'calname':
                                        linkspaceset.inindextreetmp[0].addname,
                                    'date': DateTime.now(),
                                    'madeUser': appnickname,
                                    'themesetting': 0,
                                    'viewsetting': 0,
                                    'share': []
                                  }).whenComplete(() {
                                    uiset.setloading(false, 0);
                                  });
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 20.0),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: Colors.blue.shade400,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade50
                                              .withOpacity(.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.open_in_new,
                                            color: Colors.blue,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            '일정표 생성',
                                            style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: draw.color_textstatus),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ))
                      : Flexible(
                          fit: FlexFit.tight,
                          child: Center(
                            child: NeumorphicText(
                              linkspaceset.inindextreetmp[0].placeentercode! +
                                  '\n' +
                                  '캘린더 공간 준비중입니다.',
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
                          )))
                  : Flexible(
                      fit: FlexFit.tight,
                      child: ListView.builder(
                          //controller: scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          physics: const ScrollPhysics(),
                          itemCount: linkspaceset.inindextreetmp.length,
                          itemBuilder: ((context, index) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<linkspacesetting>(
                                    builder: (_) => GestureDetector(
                                        onTap: () {
                                          if (linkspaceset
                                                  .islongchecked[index] ==
                                              true) {
                                            setState(() {
                                              linkspaceset
                                                      .islongchecked[index] =
                                                  !linkspaceset
                                                      .islongchecked[index];
                                            });
                                          } else {
                                            setState(() {
                                              linkspaceset.ischecked[index] =
                                                  !linkspaceset
                                                      .ischecked[index];
                                            });
                                          }
                                        },
                                        onLongPress: () {
                                          if (linkspaceset.ischecked[index] ==
                                              true) {
                                            setState(() {
                                              linkspaceset.ischecked[index] =
                                                  !linkspaceset
                                                      .ischecked[index];
                                            });
                                          } else {}
                                          setState(() {
                                            linkspaceset.islongchecked[index] =
                                                !linkspaceset
                                                    .islongchecked[index];
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: ContainerDesign(
                                                    color: linkspaceset
                                                                    .ischecked[
                                                                index] ==
                                                            true
                                                        ? Colors.blue.shade300
                                                        : (linkspaceset.islongchecked[
                                                                    index] ==
                                                                true
                                                            ? Colors
                                                                .red.shade300
                                                            : draw
                                                                .backgroundcolor),
                                                    child: SizedBox(
                                                        height: 100,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            linkspaceset.ischecked[
                                                                        index] ==
                                                                    true
                                                                ? Checkbox(
                                                                    activeColor:
                                                                        Colors
                                                                            .blue
                                                                            .shade300,
                                                                    value: linkspaceset
                                                                            .ischecked[
                                                                        index],
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        linkspaceset.ischecked[index] =
                                                                            value!;
                                                                      });
                                                                    })
                                                                : const SizedBox(),
                                                            linkspaceset.ischecked[
                                                                        index] ==
                                                                    true
                                                                ? const SizedBox(
                                                                    width: 10,
                                                                  )
                                                                : const SizedBox(),
                                                            Flexible(
                                                              fit:
                                                                  FlexFit.tight,
                                                              child: Text(
                                                                linkspaceset
                                                                    .inindextreetmp[
                                                                        index]
                                                                    .placeentercode
                                                                    .toString()
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            'https://firebasestorage.googleapis.com/v0/b/habit-tracker-8dad1.appspot.com/o/${id}%2F'),
                                                                        '')
                                                                    .split(
                                                                        '?')[0],
                                                                maxLines: 1,
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
                                                                        contentTextsize(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            linkspaceset.islongchecked[
                                                                        index] ==
                                                                    true
                                                                ? const SizedBox(
                                                                    width: 10,
                                                                  )
                                                                : const SizedBox(),
                                                            linkspaceset.islongchecked[
                                                                        index] ==
                                                                    true
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      deleteFileExample(
                                                                          id,
                                                                          context);
                                                                    },
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red
                                                                              .shade300,
                                                                      radius:
                                                                          20,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                    ))
                                                                : const SizedBox(),
                                                          ],
                                                        )))),
                                          ],
                                        ))),
                                index == linkspaceset.inindextreetmp.length - 1
                                    ? const SizedBox(
                                        height: 50,
                                      )
                                    : const SizedBox(
                                        height: 10,
                                      ),
                              ],
                            );
                          }))));
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
    );
  }));
}*/
