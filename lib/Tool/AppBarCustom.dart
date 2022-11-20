// ignore_for_file: unused_local_variable, must_be_immutable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../DB/PageList.dart';
import '../Enums/Variables.dart';
import '../Route/subuiroute.dart';
import '../sheets/settingpagesheets.dart';
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
    indexcnt,
    mainid,
  }) : super(key: key);
  final String title;
  final bool righticon;
  final IconData iconname;
  int myindex = 0;
  TextEditingController textEditingController = TextEditingController();
  FocusNode searchnode = FocusNode();
  int indexcnt = linkspaceset.indexcnt.length;
  String mainid = '';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var updateid = '';
    var updateusername = [];
    List<PageList> pagenamelist = [];
    final notilist = Get.put(notishow());
    final linkspaceset = Get.put(linkspacesetting());
    final uiset = Get.put(uisetting());
    final draw = Get.put(navibool());
    StatusBarControl.setColor(draw.backgroundcolor, animated: true);

    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SafeArea(
              child: SizedBox(
                  height: 60,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 10, top: 5, bottom: 5),
                      child: GetBuilder<navibool>(
                        builder: (_) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            draw.navi == 0
                                ? draw.drawopen == true ||
                                        Hive.box('user_setting')
                                                .get('page_opened') ==
                                            true
                                    ? IconButton(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            draw.setclose();
                                            Hive.box('user_setting')
                                                .put('page_opened', false);
                                          });
                                        },
                                        icon: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          alignment: Alignment.center,
                                          child: NeumorphicIcon(
                                            Icons.keyboard_arrow_left,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.concave,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: draw.color_textstatus,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))
                                    : IconButton(
                                        padding:
                                            const EdgeInsets.only(right: 10),
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
                                                color: draw.color_textstatus,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))
                                : const SizedBox(),
                            Flexible(
                                /*width: draw.navi == 0
                                ? MediaQuery.of(context).size.width - 80
                                : MediaQuery.of(context).size.width - 30,*/
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GetBuilder<uisetting>(
                                      builder: (_) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Hive.box('user_setting')
                                                      .get('page_index') ==
                                                  0
                                              ? uiset.pagelist.isEmpty
                                                  ? ContainerDesign(
                                                      child: GestureDetector(
                                                        onTap: (() => func5()),
                                                        child: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              WidgetSpan(
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        contentTitleTextsize(),
                                                                    color: draw
                                                                        .color_textstatus),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '빈 스페이스',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              contentTitleTextsize(),
                                                                          color:
                                                                              draw.color_textstatus),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .swap_horiz,
                                                                      color: draw
                                                                          .color_textstatus,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ])),
                                                      ),
                                                      color:
                                                          draw.backgroundcolor)
                                                  : ContainerDesign(
                                                      child: GestureDetector(
                                                        onTap: (() => func5()),
                                                        child: RichText(
                                                            softWrap: true,
                                                            text: TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            contentTitleTextsize(),
                                                                        color: draw
                                                                            .color_textstatus),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          uiset
                                                                              .pagelist[uiset.mypagelistindex]
                                                                              .title,
                                                                          maxLines:
                                                                              1,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: contentTitleTextsize(),
                                                                              color: draw.color_textstatus,
                                                                              overflow: TextOverflow.clip),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .swap_horiz,
                                                                          color:
                                                                              draw.color_textstatus,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ])),
                                                      ),
                                                      color:
                                                          draw.backgroundcolor)
                                              : (title.toString() == ''
                                                  ? const SizedBox()
                                                  : Text(
                                                      title.toString(),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              mainTitleTextsize(),
                                                          color: draw
                                                              .color_textstatus),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                          Row(
                                            children: [
                                              Hive.box('user_setting')
                                                          .get('page_index') ==
                                                      0
                                                  ? ContainerDesign(
                                                      child: GestureDetector(
                                                        onTap: () => func4(
                                                            context, indexcnt),
                                                        child: Icon(
                                                          Icons.add_outlined,
                                                          size: 30,
                                                          color: draw
                                                              .color_textstatus,
                                                        ),
                                                      ),
                                                      color:
                                                          draw.backgroundcolor)
                                                  : (Hive.box('user_setting').get(
                                                                  'page_index') ==
                                                              11 ||
                                                          Hive.box('user_setting')
                                                                  .get(
                                                                      'page_index') ==
                                                              12
                                                      ? ContainerDesign(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () => func4(
                                                                context,
                                                                indexcnt),
                                                            child: Icon(
                                                              Icons
                                                                  .add_outlined,
                                                              size: 30,
                                                              color: draw
                                                                  .color_textstatus,
                                                            ),
                                                          ),
                                                          color: draw
                                                              .backgroundcolor)
                                                      : (Hive.box('user_setting')
                                                                  .get(
                                                                      'page_index') ==
                                                              3
                                                          ? ContainerDesign(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () => func6(
                                                                    context,
                                                                    textEditingController,
                                                                    searchnode,
                                                                    'addpage',
                                                                    '',
                                                                    99,
                                                                    indexcnt),
                                                                child: Icon(
                                                                  Icons
                                                                      .add_outlined,
                                                                  size: 30,
                                                                  color: draw
                                                                      .color_textstatus,
                                                                ),
                                                              ),
                                                              color: draw
                                                                  .backgroundcolor)
                                                          : (Hive.box('user_setting')
                                                                      .get('page_index') ==
                                                                  5
                                                              ? ContainerDesign(
                                                                  child: GestureDetector(
                                                                    onTap: () =>
                                                                        func2(
                                                                            context),
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                      size: 30,
                                                                      color: draw
                                                                          .color_textstatus,
                                                                    ),
                                                                  ),
                                                                  color: draw.backgroundcolor)
                                                              : const SizedBox()))),
                                              Hive.box('user_setting').get(
                                                              'page_index') ==
                                                          0 ||
                                                      Hive.box('user_setting')
                                                              .get(
                                                                  'page_index') ==
                                                          3 ||
                                                      Hive.box('user_setting')
                                                              .get(
                                                                  'page_index') ==
                                                          5
                                                  ? const SizedBox(
                                                      width: 10,
                                                    )
                                                  : (uiset.searchpagemove != ''
                                                      ? const SizedBox(
                                                          width: 10,
                                                        )
                                                      : const SizedBox()),
                                              righticon == true
                                                  ? GetBuilder<uisetting>(
                                                      builder: (_) =>
                                                          ContainerDesign(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () => iconname ==
                                                                        Icons
                                                                            .notifications_none
                                                                    ? func1()
                                                                    : (iconname ==
                                                                            Icons
                                                                                .delete
                                                                        ? func2(
                                                                            context)
                                                                        : (iconname == Icons.keyboard_double_arrow_up
                                                                            ? func3(
                                                                                context)
                                                                            : (iconname == Icons.star_border || iconname == Icons.star
                                                                                ? func7(uiset.editpagelist[0].title, uiset.editpagelist[0].email.toString(), uiset.editpagelist[0].username.toString(), uiset.editpagelist[0].id.toString())
                                                                                : (iconname == Icons.person_outline ? (Hive.box('user_info').get('id') == null ? GoToLogin('isnotfirst') : setUsers(context, searchnode, textEditingController, Hive.box('user_info').get('id'))) : (iconname == Icons.download ? downloadFileExample(mainid, context) : func6(context, textEditingController, searchnode, 'addpage', '', 99, indexcnt)))))),
                                                                child: Icon(
                                                                  iconname,
                                                                  size: 30,
                                                                  color: iconname ==
                                                                          Icons
                                                                              .star
                                                                      ? Colors
                                                                          .yellow
                                                                      : draw
                                                                          .color_textstatus,
                                                                ),
                                                              ),
                                                              color: draw
                                                                  .backgroundcolor))
                                                  : const SizedBox()
                                            ],
                                          )
                                        ],
                                      ),
                                    ))),
                          ],
                        ),
                      )))));
    }));
  }
}
