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

SpaceinUI(
  String id,
) {
  final searchNode = FocusNode();
  return GetBuilder<linkspacesetting>(
      builder: (_) => StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('PageViewin').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                linkspaceset.inindextreetmp.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  spacepagename = sp.get('spacelist');
                  if (sp.get('id') == id) {
                    for (int i = 0; i < spacepagename.length; i++) {
                      linkspaceset.inindextreetmp.add(Linkspacepageenter(
                          placestr: spacepagename[i].toString()));
                    }
                  }
                }
                linkspaceset.inindextreetmp.sort(((a, b) {
                  return a.placestr.compareTo(b.placestr);
                }));
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
                                  GestureDetector(
                                      onTap: () async {},
                                      child: ContainerDesign(
                                          color: draw.backgroundcolor,
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        linkspaceset
                                                            .inindextreetmp[
                                                                index]
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
                                                  ]),
                                            ],
                                          )))),
                                  index ==
                                          linkspaceset.inindextreetmp.length - 1
                                      ? const SizedBox(
                                          height: 50,
                                        )
                                      : const SizedBox(
                                          height: 10,
                                        ),
                                ],
                              );
                            })));
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
