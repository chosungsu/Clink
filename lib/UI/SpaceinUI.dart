// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Route/subuiroute.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../DB/Linkpage.dart';
import '../../../Enums/Variables.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/linkspacesetting.dart';
import '../../../Tool/TextSize.dart';

SpaceinUI(
  String id,
  int type,
) {
  final searchNode = FocusNode();
  final linkspaceset = Get.put(linkspacesetting());
  linkspaceset.ischecked = List.filled(10000, false);
  linkspaceset.islongchecked = List.filled(10000, false);

  return StatefulBuilder(builder: ((context, setState) {
    return GetBuilder<linkspacesetting>(
        builder: (_) => StreamBuilder<QuerySnapshot>(
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
                            placeentercode: sp.get('addname')));
                      } else {
                        for (int i = 0;
                            i < sp.get('spaceentercontent').length;
                            i++) {
                          linkspaceset.inindextreetmp.add(Linkspacepageenter(
                              placeentercode:
                                  sp.get('spaceentercontent')[i].toString(),
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
                          ? Flexible(
                              fit: FlexFit.tight,
                              child: Center(
                                child: NeumorphicText(
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
                              ))
                          : Flexible(
                              fit: FlexFit.tight,
                              child: ListView.builder(
                                  //controller: scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                                              .islongchecked[
                                                          index] ==
                                                      true) {
                                                    setState(() {
                                                      linkspaceset.islongchecked[
                                                              index] =
                                                          !linkspaceset
                                                                  .islongchecked[
                                                              index];
                                                    });
                                                  } else {
                                                    setState(() {
                                                      linkspaceset.ischecked[
                                                              index] =
                                                          !linkspaceset
                                                              .ischecked[index];
                                                    });
                                                  }
                                                },
                                                onLongPress: () {
                                                  if (linkspaceset
                                                          .ischecked[index] ==
                                                      true) {
                                                    setState(() {
                                                      linkspaceset.ischecked[
                                                              index] =
                                                          !linkspaceset
                                                              .ischecked[index];
                                                    });
                                                  } else {}
                                                  setState(() {
                                                    linkspaceset.islongchecked[
                                                            index] =
                                                        !linkspaceset
                                                                .islongchecked[
                                                            index];
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
                                                                ? Colors.blue
                                                                    .shade300
                                                                : (linkspaceset.islongchecked[
                                                                            index] ==
                                                                        true
                                                                    ? Colors.red
                                                                        .shade300
                                                                    : draw
                                                                        .backgroundcolor),
                                                            child: SizedBox(
                                                                height: 100,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    linkspaceset.ischecked[index] ==
                                                                            true
                                                                        ? Checkbox(
                                                                            activeColor:
                                                                                Colors.blue.shade300,
                                                                            value: linkspaceset.ischecked[index],
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                linkspaceset.ischecked[index] = value!;
                                                                              });
                                                                            })
                                                                        : const SizedBox(),
                                                                    linkspaceset.ischecked[index] ==
                                                                            true
                                                                        ? const SizedBox(
                                                                            width:
                                                                                10,
                                                                          )
                                                                        : const SizedBox(),
                                                                    Flexible(
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          Text(
                                                                        linkspaceset
                                                                            .inindextreetmp[
                                                                                index]
                                                                            .placeentercode
                                                                            .toString()
                                                                            .replaceAll(RegExp('https://firebasestorage.googleapis.com/v0/b/habit-tracker-8dad1.appspot.com/o/${id}%2F'),
                                                                                '')
                                                                            .split('?')[0],
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: TextStyle(
                                                                            color: draw
                                                                                .color_textstatus,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                contentTextsize(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    linkspaceset.islongchecked[index] ==
                                                                            true
                                                                        ? const SizedBox(
                                                                            width:
                                                                                10,
                                                                          )
                                                                        : const SizedBox(),
                                                                    linkspaceset.islongchecked[index] ==
                                                                            true
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              deleteFileExample(id, context);
                                                                            },
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundColor: Colors.red.shade300,
                                                                              radius: 20,
                                                                              child: const Icon(
                                                                                Icons.close,
                                                                                color: Colors.white,
                                                                                size: 25,
                                                                              ),
                                                                            ))
                                                                        : const SizedBox(),
                                                                  ],
                                                                )))),
                                                  ],
                                                ))),
                                        index ==
                                                linkspaceset
                                                        .inindextreetmp.length -
                                                    1
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
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              },
            ));
  }));
}
