// ignore_for_file: unused_local_variable, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:clickbyme/BACKENDPART/ViewPoints/SettingVP.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../BACKENDPART/Enums/PageList.dart';
import '../BACKENDPART/Enums/Variables.dart';
import '../FRONTENDPART/Route/subuiroute.dart';
import '../BACKENDPART/Getx/linkspacesetting.dart';
import '../BACKENDPART/Getx/navibool.dart';
import '../BACKENDPART/Getx/notishow.dart';
import '../BACKENDPART/Getx/uisetting.dart';
import 'TextSize.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AppBarCustom extends StatelessWidget {
  AppBarCustom({
    Key? key,
    required this.title,
    required this.lefticon,
    required this.lefticonname,
    required this.righticon,
    required this.righticonname,
    required this.doubleicon,
    this.textcontroller,
    this.searchnode,
  }) : super(key: key);
  final Widget title;
  final bool righticon;
  final IconData righticonname;
  final bool doubleicon;
  final bool lefticon;
  final IconData lefticonname;
  var textcontroller;
  var searchnode;
  int myindex = 0;
  int indexcnt = linkspaceset.indexcnt.length;
  String mainid = Hive.box('user_setting').get('widgetid') ?? '';

  @override
  Widget build(BuildContext context) {
    var updateid = '';
    var updateusername = [];
    List<int> navinumlist = [0, 1, 2, 3];
    List<PageList> pagenamelist = [];
    final notilist = Get.put(notishow());
    final linkspaceset = Get.put(linkspacesetting());
    final uiset = Get.put(uisetting());
    final draw = Get.put(navibool());
    StatusBarControl.setColor(draw.backgroundcolor, animated: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:
            draw.statusbarcolor == 0 ? Brightness.dark : Brightness.light));

    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SafeArea(
              child: SizedBox(
                  height: 60,
                  width: draw.navishow == true &&
                          Get.width > 1000 &&
                          draw.settinginsidemap.containsKey(0) == true
                      ? Get.width - 120
                      : Get.width,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: GetBuilder<navibool>(
                        builder: (_) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            navinumlist.contains(uiset.pagenumber) &&
                                    draw.navi == 0 &&
                                    draw.navishow == false &&
                                    Get.width > 1000 &&
                                    draw.settinginsidemap.containsKey(0) == true
                                ? draw.drawopen == true ||
                                        Hive.box('user_setting')
                                                .get('page_opened') ==
                                            true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            draw.setclose();
                                            Hive.box('user_setting')
                                                .put('page_opened', false);
                                          });
                                        },
                                        child: ContainerDesign(
                                            child: Icon(
                                              Feather.chevron_left,
                                              size: 30,
                                              color: draw.color_textstatus,
                                            ),
                                            color: draw.backgroundcolor))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            draw.navi = 0;
                                            draw.setopen();
                                            Hive.box('user_setting')
                                                .put('page_opened', true);
                                          });
                                        },
                                        child: ContainerDesign(
                                            child: Icon(
                                              Ionicons.menu,
                                              size: 30,
                                              color: draw.color_textstatus,
                                            ),
                                            color: draw.backgroundcolor))
                                : const SizedBox(),
                            navinumlist.contains(uiset.pagenumber) &&
                                    draw.navi == 0 &&
                                    draw.navishow == false &&
                                    Get.width > 1000 &&
                                    draw.settinginsidemap.containsKey(0) == true
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            lefticon == true
                                ? Row(
                                    children: [
                                      GetBuilder<uisetting>(
                                          builder: (_) => GestureDetector(
                                              onTap: () {
                                                if (draw.settinginsidemap
                                                        .containsKey(1) ==
                                                    true) {
                                                  draw.clicksettinginside(
                                                      0, false);
                                                } else if (draw.settinginsidemap
                                                        .containsKey(2) ==
                                                    true) {
                                                  uiset
                                                      .checkprofilepageindex(0);
                                                  draw.clicksettinginside(
                                                      1, true);
                                                }
                                                Get.back();
                                              },
                                              child: ContainerDesign(
                                                color: draw.backgroundcolor,
                                                child: Icon(
                                                  lefticonname,
                                                  size: 30,
                                                  color: draw.color_textstatus,
                                                ),
                                              )))
                                    ],
                                  )
                                : const SizedBox(),
                            Flexible(
                                child: GetBuilder<uisetting>(
                              builder: (_) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: SizedBox(child: title)),
                                  righticon == true
                                      ? Row(
                                          children: [
                                            doubleicon == true
                                                ? uiset.pagenumber == 11 ||
                                                        uiset.pagenumber == 12
                                                    ? GestureDetector(
                                                        onTap: () => func4(
                                                              context,
                                                              textcontroller,
                                                              searchnode,
                                                              'addpage',
                                                              '',
                                                              99,
                                                            ),
                                                        child: ContainerDesign(
                                                            child: Icon(
                                                              Ionicons
                                                                  .add_outline,
                                                              size: 30,
                                                              color: draw
                                                                  .color_textstatus,
                                                            ),
                                                            color: draw
                                                                .backgroundcolor))
                                                    : const SizedBox()
                                                : const SizedBox(),
                                            /*uiset.pagenumber == 0 ||
                                                    uiset.pagenumber == 3
                                                ? const SizedBox(
                                                    width: 10,
                                                  )
                                                : (uiset.searchpagemove != ''
                                                    ? const SizedBox(
                                                        width: 10,
                                                      )
                                                    : const SizedBox()),*/
                                            GestureDetector(
                                                onTap: () {
                                                  OnClickedRightIcons(
                                                      context, righticonname);
                                                },
                                                child: Get.width < 1000
                                                    ? ContainerDesign(
                                                        color: draw
                                                            .backgroundcolor,
                                                        child: Icon(
                                                          righticonname,
                                                          size: 30,
                                                          color: righticonname ==
                                                                  Icons.star
                                                              ? Colors.yellow
                                                              : draw
                                                                  .color_textstatus,
                                                        ),
                                                      )
                                                    : ContainerDesign(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              child: Icon(
                                                                righticonname,
                                                                size: 30,
                                                                color: righticonname ==
                                                                        Icons
                                                                            .star
                                                                    ? Colors
                                                                        .yellow
                                                                    : draw
                                                                        .color_textstatus,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              RightIconText(
                                                                  righticonname),
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'DancingScript',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      contentTextsize(),
                                                                  color: draw
                                                                      .color_textstatus),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        color: draw
                                                            .backgroundcolor))
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            )),
                            navinumlist.contains(uiset.pagenumber) &&
                                    draw.navi == 1 &&
                                    draw.navishow == false &&
                                    Get.width > 1000 &&
                                    draw.settinginsidemap.containsKey(0) == true
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            navinumlist.contains(uiset.pagenumber) &&
                                    draw.navi == 1 &&
                                    draw.navishow == false &&
                                    Get.width > 1000 &&
                                    draw.settinginsidemap.containsKey(0) == true
                                ? draw.drawopen == true ||
                                        Hive.box('user_setting')
                                                .get('page_opened') ==
                                            true
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            draw.setclose();
                                            Hive.box('user_setting')
                                                .put('page_opened', false);
                                          });
                                        },
                                        child: ContainerDesign(
                                            child: Icon(
                                              Feather.chevron_right,
                                              size: 30,
                                              color: draw.color_textstatus,
                                            ),
                                            color: draw.backgroundcolor))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            draw.navi = 1;
                                            draw.setopen();
                                            Hive.box('user_setting')
                                                .put('page_opened', true);
                                          });
                                        },
                                        child: ContainerDesign(
                                            child: Icon(
                                              Ionicons.menu,
                                              size: 30,
                                              color: draw.color_textstatus,
                                            ),
                                            color: draw.backgroundcolor))
                                : const SizedBox(),
                          ],
                        ),
                      )))));
    }));
  }

  OnClickedRightIcons(context, righticonname) {
    return righticonname == Ionicons.add_outline
        ? func4(
            context,
            textcontroller,
            searchnode,
            'addpage',
            '',
            99,
          )
        : (righticonname == SimpleLineIcons.grid
            ? null
            : (righticonname == Icons.star_border || righticonname == Icons.star
                ? func7()
                : (righticonname == Ionicons.settings_outline
                    ? GoToSettingPage()
                    : (righticonname == Icons.download
                        ? downloadFileExample(mainid, context)
                        : null))));
  }

  RightIconText(righticonname) {
    return righticonname == Ionicons.add_outline
        ? '추가'
        : (righticonname == SimpleLineIcons.grid
            ? '옵션'
            : (righticonname == Icons.star_border || righticonname == Icons.star
                ? '즐겨찾기'
                : (righticonname == Ionicons.settings_outline
                    ? '설정'
                    : (righticonname == Icons.download
                        ? ''
                        : (righticonname == Ionicons.ios_close ? '닫기' : '')))));
  }
}
