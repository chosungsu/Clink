// ignore_for_file: unused_local_variable, must_be_immutable, non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Enums/PageList.dart';
import '../Enums/Variables.dart';
import '../FRONTENDPART/Route/subuiroute.dart';
import '../sheets/settingpagesheets.dart';
import 'Getx/linkspacesetting.dart';
import 'Getx/navibool.dart';
import 'Getx/notishow.dart';
import 'Getx/uisetting.dart';
import 'TextSize.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AppBarCustom extends StatelessWidget {
  AppBarCustom({
    Key? key,
    required this.title,
    required this.righticon,
    required this.iconname,
    required this.doubleicon,
    textEditingController,
    focusNode,
    myindex,
    indexcnt,
    mainid,
  }) : super(key: key);
  final String title;
  final bool righticon;
  final IconData iconname;
  final bool doubleicon;
  int myindex = 0;
  TextEditingController textEditingController = TextEditingController();
  FocusNode searchnode = FocusNode();
  int indexcnt = linkspaceset.indexcnt.length;
  String mainid = Hive.box('user_setting').get('widgetid') ?? '';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var updateid = '';
    var updateusername = [];
    List<int> navinumlist = [0, 1, 2, 3];
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
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: GetBuilder<navibool>(
                        builder: (_) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            draw.navi == 0
                                ? draw.drawopen == true ||
                                        Hive.box('user_setting')
                                                .get('page_opened') ==
                                            true
                                    ? ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              draw.setclose();
                                              Hive.box('user_setting')
                                                  .put('page_opened', false);
                                            });
                                          },
                                          child: Icon(
                                            Feather.chevron_left,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                    : ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              draw.navi = 0;
                                              draw.setopen();
                                              Hive.box('user_setting')
                                                  .put('page_opened', true);
                                            });
                                          },
                                          child: Icon(
                                            Ionicons.menu,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                : const SizedBox(),
                            navinumlist.contains(Hive.box('user_setting')
                                        .get('page_index')) &&
                                    draw.navi == 0
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            Flexible(
                                child: GetBuilder<uisetting>(
                              builder: (_) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  title.toString() == ''
                                      ? Hive.box('user_setting')
                                                  .get('page_index') ==
                                              0
                                          ? uiset.pagelist.isEmpty
                                              ? Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ContainerDesign(
                                                          child:
                                                              GestureDetector(
                                                            onTap: (() =>
                                                                func5()),
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
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: contentTitleTextsize(),
                                                                              color: draw.color_textstatus),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Icon(
                                                                          AntDesign
                                                                              .swap,
                                                                          color:
                                                                              draw.color_textstatus,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ])),
                                                          ),
                                                          color: draw
                                                              .backgroundcolor)
                                                    ],
                                                  ))
                                              : Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ContainerDesign(
                                                          child:
                                                              GestureDetector(
                                                            onTap: (() =>
                                                                func5()),
                                                            child: RichText(
                                                                softWrap: true,
                                                                text: TextSpan(
                                                                    children: [
                                                                      WidgetSpan(
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .normal,
                                                                            fontSize:
                                                                                contentTitleTextsize(),
                                                                            color:
                                                                                draw.color_textstatus),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              uiset.pagelist[uiset.mypagelistindex].title,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTitleTextsize(), color: draw.color_textstatus, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Icon(
                                                                              AntDesign.swap,
                                                                              color: draw.color_textstatus,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ])),
                                                          ),
                                                          color: draw
                                                              .backgroundcolor)
                                                    ],
                                                  ))
                                          : const SizedBox()
                                      : Flexible(
                                          fit: FlexFit.tight,
                                          child: SizedBox(
                                            child: Text(
                                              title.toString(),
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: mainTitleTextsize(),
                                                  color: draw.color_textstatus),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                  righticon == true
                                      ? Row(
                                          children: [
                                            doubleicon == true
                                                ? Hive.box('user_setting').get(
                                                                'page_index') ==
                                                            11 ||
                                                        Hive.box('user_setting')
                                                                .get(
                                                                    'page_index') ==
                                                            12
                                                    ? ContainerDesign(
                                                        child: GestureDetector(
                                                          onTap: () => func4(
                                                              context,
                                                              indexcnt),
                                                          child: Icon(
                                                            Ionicons
                                                                .add_outline,
                                                            size: 30,
                                                            color: draw
                                                                .color_textstatus,
                                                          ),
                                                        ),
                                                        color: draw
                                                            .backgroundcolor)
                                                    : const SizedBox()
                                                : const SizedBox(),
                                            Hive.box('user_setting').get(
                                                            'page_index') ==
                                                        0 ||
                                                    Hive.box('user_setting')
                                                            .get(
                                                                'page_index') ==
                                                        3
                                                ? const SizedBox(
                                                    width: 10,
                                                  )
                                                : (uiset.searchpagemove != ''
                                                    ? const SizedBox(
                                                        width: 10,
                                                      )
                                                    : const SizedBox()),
                                            GetBuilder<uisetting>(
                                                builder: (_) => ContainerDesign(
                                                    child: GestureDetector(
                                                        onTap: () => iconname ==
                                                                Ionicons
                                                                    .add_outline
                                                            ? (Hive.box('user_setting').get('page_index') == 0
                                                                ? func4(
                                                                    context, indexcnt)
                                                                : func6(
                                                                    context,
                                                                    textEditingController,
                                                                    searchnode,
                                                                    'addpage',
                                                                    '',
                                                                    99,
                                                                    indexcnt))
                                                            : (iconname ==
                                                                    AntDesign
                                                                        .delete
                                                                ? func2(context)
                                                                : (iconname == Icons.star_border ||
                                                                        iconname ==
                                                                            Icons
                                                                                .star
                                                                    ? func7(
                                                                        uiset.editpagelist[0].title,
                                                                        uiset.editpagelist[0].email.toString(),
                                                                        uiset.editpagelist[0].username.toString(),
                                                                        uiset.editpagelist[0].id.toString())
                                                                    : (iconname == Icons.person_outline ? (Hive.box('user_info').get('id') == null ? GoToLogin('isnotfirst') : setUsers(context, searchnode, textEditingController, Hive.box('user_info').get('id'))) : (iconname == Icons.download ? downloadFileExample(mainid, context) : func6(context, textEditingController, searchnode, 'addpage', '', 99, indexcnt))))),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          child: Icon(
                                                            iconname,
                                                            size: 30,
                                                            color: iconname ==
                                                                    Icons.star
                                                                ? Colors.yellow
                                                                : draw
                                                                    .color_textstatus,
                                                          ),
                                                        )),
                                                    color: draw.backgroundcolor))
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                            navinumlist.contains(Hive.box('user_setting')
                                        .get('page_index')) &&
                                    draw.navi == 1
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            navinumlist.contains(Hive.box('user_setting')
                                        .get('page_index')) &&
                                    draw.navi == 1
                                ? draw.drawopen == true ||
                                        Hive.box('user_setting')
                                                .get('page_opened') ==
                                            true
                                    ? ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              draw.setclose();
                                              Hive.box('user_setting')
                                                  .put('page_opened', false);
                                            });
                                          },
                                          child: Icon(
                                            Feather.chevron_right,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                    : ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              draw.navi = 1;
                                              draw.setopen();
                                              Hive.box('user_setting')
                                                  .put('page_opened', true);
                                            });
                                          },
                                          child: Icon(
                                            Ionicons.menu,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                : const SizedBox(),
                          ],
                        ),
                      )))));
    }));
  }
}
