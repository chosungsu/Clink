// ignore_for_file: unused_local_variable, must_be_immutable, non_constant_identifier_names

import 'package:clickbyme/Page/AddTemplate.dart';
import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:clickbyme/Page/Spacepage.dart';
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
  AppBarCustom({
    Key? key,
    required this.title,
    required this.righticon,
    required this.iconname,
    textEditingController,
    focusNode,
    myindex,
  }) : super(key: key);
  final String title;
  final bool righticon;
  final IconData iconname;
  int myindex = 0;
  TextEditingController textEditingController = TextEditingController();
  FocusNode searchnode = FocusNode();

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
                                child: GetBuilder<uisetting>(
                                  builder: (_) => Row(
                                    children: [
                                      Hive.box('user_setting')
                                                  .get('page_index') ==
                                              0
                                          ? uiset.pagelist.isEmpty
                                              ? Flexible(
                                                  fit: FlexFit.tight,
                                                  child: GestureDetector(
                                                    onTap: (() => func5()),
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      WidgetSpan(
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                mainTitleTextsize(),
                                                            color:
                                                                TextColor_shadowcolor()),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '빈 스페이스',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      mainTitleTextsize(),
                                                                  color:
                                                                      TextColor()),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Icon(
                                                              Icons.swap_horiz,
                                                              color:
                                                                  TextColor_shadowcolor(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ])),
                                                  ))
                                              : Flexible(
                                                  fit: FlexFit.tight,
                                                  child: GestureDetector(
                                                    onTap: (() => func5()),
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      WidgetSpan(
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                mainTitleTextsize(),
                                                            color:
                                                                TextColor_shadowcolor()),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              uiset
                                                                  .pagelist[uiset
                                                                      .mypagelistindex]
                                                                  .title,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      mainTitleTextsize(),
                                                                  color:
                                                                      TextColor(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Icon(
                                                              Icons.swap_horiz,
                                                              color:
                                                                  TextColor_shadowcolor(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ])),
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
                                          ? GestureDetector(
                                              onTap: () => func4(context),
                                              child: NeumorphicIcon(
                                                Icons.add_box,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 5,
                                                    surfaceIntensity: 0.3,
                                                    border: NeumorphicBorder(
                                                        color:
                                                            TextColor_shadowcolor(),
                                                        width: 0.5),
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ))
                                          : (Hive.box('user_setting')
                                                          .get('page_index') ==
                                                      11 ||
                                                  Hive.box('user_setting')
                                                          .get('page_index') ==
                                                      21
                                              ? GestureDetector(
                                                  onTap: () => func4(context),
                                                  child: NeumorphicIcon(
                                                    Icons.add_box,
                                                    size: 30,
                                                    style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 5,
                                                        surfaceIntensity: 0.3,
                                                        border: NeumorphicBorder(
                                                            color:
                                                                TextColor_shadowcolor(),
                                                            width: 0.5),
                                                        color: TextColor(),
                                                        lightSource: LightSource
                                                            .topLeft),
                                                  ),
                                                )
                                              : const SizedBox()),
                                      Hive.box('user_setting')
                                                  .get('page_index') ==
                                              0
                                          ? const SizedBox(
                                              width: 20,
                                            )
                                          : (uiset.searchpagemove != ''
                                              ? const SizedBox(
                                                  width: 20,
                                                )
                                              : const SizedBox()),
                                      righticon == true
                                          ? GetBuilder<uisetting>(
                                              builder: (_) => GestureDetector(
                                                  onTap: () => iconname ==
                                                          Icons
                                                              .notifications_none
                                                      ? func1()
                                                      : (iconname ==
                                                              Icons.delete
                                                          ? func2(context)
                                                          : (iconname ==
                                                                  Icons.close
                                                              ? func3()
                                                              : (iconname ==
                                                                          Icons
                                                                              .star_border ||
                                                                      iconname ==
                                                                          Icons
                                                                              .star
                                                                  ? func7(
                                                                      uiset
                                                                          .editpagelist[
                                                                              0]
                                                                          .title,
                                                                      uiset
                                                                          .editpagelist[
                                                                              0]
                                                                          .email
                                                                          .toString(),
                                                                      uiset
                                                                          .editpagelist[
                                                                              0]
                                                                          .username
                                                                          .toString(),
                                                                      uiset
                                                                          .editpagelist[
                                                                              0]
                                                                          .id
                                                                          .toString())
                                                                  : func6(
                                                                      context,
                                                                      textEditingController,
                                                                      searchnode,
                                                                      'addpage',
                                                                      '',
                                                                      99)))),
                                                  child: NeumorphicIcon(
                                                    iconname,
                                                    size: 30,
                                                    style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 5,
                                                        surfaceIntensity: 0.3,
                                                        border: NeumorphicBorder(
                                                            color:
                                                                TextColor_shadowcolor(),
                                                            width: 0.5),
                                                        color: iconname ==
                                                                Icons.star
                                                            ? Colors.yellow
                                                            : TextColor(),
                                                        lightSource: LightSource
                                                            .topLeft),
                                                  )))
                                          : const SizedBox()
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ))));
    }));
  }
}
