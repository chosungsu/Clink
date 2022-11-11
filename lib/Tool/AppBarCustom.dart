// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:clickbyme/Page/AddTemplate.dart';
import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/sheets/movetolinkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/linksettingsheet.dart';
import 'AndroidIOS.dart';
import 'Getx/linkspacesetting.dart';
import 'Getx/navibool.dart';
import 'Getx/notishow.dart';
import 'Getx/uisetting.dart';
import 'TextSize.dart';

class AppBarCustom extends StatelessWidget {
  AppBarCustom(
      {Key? key,
      required this.title,
      required this.righticon,
      required this.iconname,
      textEditingController,
      focusNode})
      : super(key: key);
  final String title;
  final bool righticon;
  final IconData iconname;
  TextEditingController textEditingController = TextEditingController();
  FocusNode searhnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var updateid = '';
    var updateusername = [];
    List<PageList> pagenamelist = [];
    final notilist = Get.put(notishow());
    final draw = Get.put(navibool());
    final linkspaceset = Get.put(linkspacesetting());
    final uiset = Get.put(uisetting());
    String name = Hive.box('user_info').get('id');
    String usercode = Hive.box('user_setting').get('usercode');
    bool serverstatus = Hive.box('user_info').get('server_status');
    StatusBarControl.setColor(BGColor(), animated: true);

    func1() => Get.to(() => const NotiAlarm(), transition: Transition.upToDown);
    func2() async {
      final reloadpage = await Get.dialog(OSDialog(
              context,
              '경고',
              Text('알림들을 삭제하시겠습니까?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: Colors.blueGrey)),
              pressed2)) ??
          false;
      if (reloadpage) {
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (element.get('sharename').toString().contains(name) == true) {
              updateid = element.id;
              updateusername =
                  element.get('sharename').toString().split(',').toList();
              if (updateusername.length == 1) {
                firestore.collection('AppNoticeByUsers').doc(updateid).delete();
              } else {
                updateusername.removeWhere(
                    (element) => element.toString().contains(name));
                firestore
                    .collection('AppNoticeByUsers')
                    .doc(updateid)
                    .update({'sharename': updateusername});
              }
            } else {
              if (element.get('username').toString() == name) {
                updateid = element.id;
                firestore.collection('AppNoticeByUsers').doc(updateid).delete();
              } else {}
            }
          }
        }).whenComplete(() {
          notilist.isreadnoti();
        });
      }
    }

    func3() => Future.delayed(const Duration(seconds: 0), () {
          if (linkspaceset.color == BGColor()) {
            StatusBarControl.setColor(BGColor(), animated: true);
          } else {
            StatusBarControl.setColor(linkspaceset.color, animated: true);
          }
          Get.back();
        });
    func4() =>
        Get.to(() => const AddTemplate(), transition: Transition.upToDown);

    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SafeArea(
              child: SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        draw.navi == 0
                            ? draw.drawopen == true
                                ? IconButton(
                                    padding: const EdgeInsets.only(right: 10),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      setState(() {
                                        draw.setclose();
                                        Hive.box('user_setting')
                                            .put('page_opened', false);
                                      });
                                    },
                                    icon: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      alignment: Alignment.center,
                                      child: NeumorphicIcon(
                                        Icons.keyboard_arrow_left,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.concave,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    ))
                                : IconButton(
                                    padding: const EdgeInsets.only(right: 10),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      setState(() {
                                        draw.setopen();
                                        Hive.box('user_setting')
                                            .put('page_opened', true);
                                      });
                                    },
                                    icon: Container(
                                      alignment: Alignment.center,
                                      child: NeumorphicIcon(
                                        Icons.menu,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.concave,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    ))
                            : const SizedBox(),
                        Flexible(
                            /*width: draw.navi == 0
                                ? MediaQuery.of(context).size.width - 80
                                : MediaQuery.of(context).size.width - 30,*/
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Hive.box('user_setting')
                                                .get('page_index') ==
                                            0
                                        ? serverstatus == true
                                            ? GetBuilder<linkspacesetting>(
                                                builder: (_) => FutureBuilder(
                                                    future: MongoDB.getData(
                                                            collectionname:
                                                                'pinchannel')
                                                        .then((value) {
                                                      uiset.pagelist.clear();
                                                      for (int j = 0;
                                                          j < value.length;
                                                          j++) {
                                                        final messageuser =
                                                            value[j]
                                                                ['username'];
                                                        final messagetitle =
                                                            value[j]
                                                                ['linkname'];
                                                        final messagecolor =
                                                            value[j]['color'];
                                                        if (messageuser ==
                                                            usercode) {
                                                          uiset.pagelist.add(PageList(
                                                              title:
                                                                  messagetitle,
                                                              color:
                                                                  messagecolor,
                                                              username:
                                                                  messageuser));
                                                        }
                                                      }
                                                    }),
                                                    builder:
                                                        ((context, snapshot) {
                                                      return uiset
                                                              .pagelist.isEmpty
                                                          ? Flexible(
                                                              fit:
                                                                  FlexFit.tight,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  movetolinkspace(
                                                                      context,
                                                                      uiset
                                                                          .pagelist,
                                                                      textEditingController,
                                                                      searhnode);
                                                                },
                                                                child: RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      WidgetSpan(
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .normal,
                                                                            fontSize:
                                                                                mainTitleTextsize(),
                                                                            color:
                                                                                TextColor_shadowcolor()),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              '빈 스페이스',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainTitleTextsize(), color: TextColor()),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.swap_horiz,
                                                                              color: TextColor_shadowcolor(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ])),
                                                              ))
                                                          : Flexible(
                                                              fit:
                                                                  FlexFit.tight,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  movetolinkspace(
                                                                      context,
                                                                      uiset
                                                                          .pagelist,
                                                                      textEditingController,
                                                                      searhnode);
                                                                },
                                                                child: RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      WidgetSpan(
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .normal,
                                                                            fontSize:
                                                                                mainTitleTextsize(),
                                                                            color:
                                                                                TextColor_shadowcolor()),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              uiset.pagelist[0].title,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainTitleTextsize(), color: TextColor(), overflow: TextOverflow.clip),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Icon(
                                                                              Icons.swap_horiz,
                                                                              color: TextColor_shadowcolor(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ])),
                                                              ));
                                                    })))
                                            : GetBuilder<linkspacesetting>(
                                                builder:
                                                    (_) => StreamBuilder<
                                                            QuerySnapshot>(
                                                          stream: firestore
                                                              .collection(
                                                                  'Pinchannel')
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              uiset.pagelist
                                                                  .clear();
                                                              final valuespace =
                                                                  snapshot.data!
                                                                      .docs;
                                                              for (var sp
                                                                  in valuespace) {
                                                                final messageuser =
                                                                    sp.get(
                                                                        'username');
                                                                final messagetitle =
                                                                    sp.get(
                                                                        'linkname');
                                                                final messagecolor =
                                                                    sp.get(
                                                                        'color');
                                                                if (messageuser ==
                                                                    usercode) {
                                                                  uiset.pagelist.add(PageList(
                                                                      title:
                                                                          messagetitle,
                                                                      color:
                                                                          messagecolor,
                                                                      username:
                                                                          messageuser));
                                                                }
                                                              }

                                                              return uiset
                                                                      .pagelist
                                                                      .isEmpty
                                                                  ? Flexible(
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          movetolinkspace(
                                                                              context,
                                                                              uiset.pagelist,
                                                                              textEditingController,
                                                                              searhnode);
                                                                        },
                                                                        child: RichText(
                                                                            text: TextSpan(children: [
                                                                          WidgetSpan(
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: mainTitleTextsize(),
                                                                                color: TextColor_shadowcolor()),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  '빈 스페이스',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainTitleTextsize(), color: TextColor()),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Icon(
                                                                                  Icons.swap_horiz,
                                                                                  color: TextColor_shadowcolor(),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ])),
                                                                      ))
                                                                  : Flexible(
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          movetolinkspace(
                                                                              context,
                                                                              uiset.pagelist,
                                                                              textEditingController,
                                                                              searhnode);
                                                                        },
                                                                        child: RichText(
                                                                            text: TextSpan(children: [
                                                                          WidgetSpan(
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: mainTitleTextsize(),
                                                                                color: TextColor_shadowcolor()),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(
                                                                                  uiset.pagelist[0].title,
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: mainTitleTextsize(), color: TextColor()),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Icon(
                                                                                  Icons.swap_horiz,
                                                                                  color: TextColor_shadowcolor(),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ])),
                                                                      ));
                                                            }
                                                            return LinearProgressIndicator(
                                                              backgroundColor:
                                                                  BGColor(),
                                                              valueColor:
                                                                  const AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            );
                                                          },
                                                        ))
                                        : Flexible(
                                            fit: FlexFit.tight,
                                            child: NeumorphicText(
                                              title.toString(),
                                              textAlign: TextAlign.start,
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.flat,
                                                  depth: 3,
                                                  color: TextColor()),
                                              textStyle: NeumorphicTextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: mainTitleTextsize(),
                                              ),
                                            ),
                                          ),
                                    Hive.box('user_setting')
                                                .get('page_index') ==
                                            0
                                        ? IconButton(
                                            padding: EdgeInsets.zero, // 패딩 설정
                                            constraints: const BoxConstraints(),
                                            onPressed: (() => func4()),
                                            icon: Container(
                                              alignment: Alignment.center,
                                              child: NeumorphicIcon(
                                                Icons.add_box,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.concave,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            ))
                                        : const SizedBox(),
                                    Hive.box('user_setting')
                                                .get('page_index') ==
                                            0
                                        ? const SizedBox(
                                            width: 20,
                                          )
                                        : const SizedBox(),
                                    righticon == true
                                        ? IconButton(
                                            padding: EdgeInsets.zero, // 패딩 설정
                                            constraints: const BoxConstraints(),
                                            onPressed: () => iconname ==
                                                    Icons.notifications_none
                                                ? func1()
                                                : (iconname == Icons.delete
                                                    ? func2()
                                                    : func3()),
                                            icon: Container(
                                              alignment: Alignment.center,
                                              child: NeumorphicIcon(
                                                iconname,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.concave,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            ))
                                        : const SizedBox()
                                  ],
                                ))),
                      ],
                    ),
                  ))));
    }));
  }
}
