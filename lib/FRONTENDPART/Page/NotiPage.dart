// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/UI/NotiUI.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AppBarCustom.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/MyTheme.dart';
import '../../Tool/NoBehavior.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../Tool/TextSize.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';
import '../Widget/responsiveWidget.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  final navi = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final notilist = Get.put(notishow());

  @override
  void initState() {
    super.initState();
    notilist.clicker = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: OrientationBuilder(
      builder: (context, orientation) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: navi.backgroundcolor,
            statusBarBrightness:
                navi.statusbarcolor == 0 ? Brightness.dark : Brightness.light,
            statusBarIconBrightness:
                navi.statusbarcolor == 0 ? Brightness.dark : Brightness.light));
        return Scaffold(
            backgroundColor: navi.backgroundcolor,
            bottomNavigationBar: uiset.loading
                ? const SizedBox()
                : (Get.width < 1000 ? const BottomScreen() : const SizedBox()),
            body: GetBuilder<navibool>(
                builder: (_) => buildtypewidget(context, NotiBody())));
      },
    ));
  }

  Widget NotiBody() {
    return OrientationBuilder(builder: ((context, orientation) {
      return GetBuilder<navibool>(
          builder: (_) => AnimatedContainer(
                transform:
                    Matrix4.translationValues(navi.xoffset, navi.yoffset, 0)
                      ..scale(navi.scalefactor),
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    navi.drawopen == true && navi.navishow == false
                        ? setState(() {
                            navi.drawopen = false;
                            navi.setclose();
                            Hive.box('user_setting').put('page_opened', false);
                          })
                        : null;
                  },
                  child: SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: GetBuilder<uisetting>(
                      builder: (_) {
                        return Container(
                            color: navi.backgroundcolor,
                            child: Row(
                              children: [
                                navi.navi == 0 &&
                                        navi.navishow == true &&
                                        Get.width > 1000
                                    ? innertype()
                                    : const SizedBox(),
                                Column(
                                  children: [
                                    AppBarCustom(
                                      title: GetBuilder<notishow>(builder: (_) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  notilist.setclicker(0);
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'notipagecompanytitle'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'NanumMyeongjo',
                                                          fontSize:
                                                              mainTitleTextsize(),
                                                          color: notilist
                                                                      .clicker ==
                                                                  0
                                                              ? MyTheme
                                                                  .colorpastelpurple
                                                              : MyTheme
                                                                  .colorgrey),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                      child: Divider(
                                                        height: 3,
                                                        color: notilist
                                                                    .clicker ==
                                                                0
                                                            ? MyTheme
                                                                .colorpastelpurple
                                                            : navi
                                                                .backgroundcolor,
                                                        thickness: 2,
                                                        indent: 0,
                                                        endIndent: 0,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  notilist.setclicker(1);
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'notipageusertitle'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'NanumMyeongjo',
                                                          fontSize:
                                                              mainTitleTextsize(),
                                                          color: notilist
                                                                      .clicker ==
                                                                  1
                                                              ? MyTheme
                                                                  .colorpastelpurple
                                                              : MyTheme
                                                                  .colorgrey),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                      child: Divider(
                                                        height: 3,
                                                        color: notilist
                                                                    .clicker ==
                                                                1
                                                            ? MyTheme
                                                                .colorpastelpurple
                                                            : navi
                                                                .backgroundcolor,
                                                        thickness: 2,
                                                        indent: 0,
                                                        endIndent: 0,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        );
                                      }),
                                      lefticon: false,
                                      righticon: false,
                                      doubleicon: false,
                                      lefticonname: Ionicons.add_outline,
                                      righticonname: Ionicons.ios_close,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SizedBox(
                                        width: navi.navishow == true &&
                                                Get.width > 1000
                                            ? Get.width - 120
                                            : Get.width,
                                        child: ScrollConfiguration(
                                            behavior: NoBehavior(),
                                            child: LayoutBuilder(
                                              builder: ((context, constraint) {
                                                notilist.listappnoti.clear();
                                                return SingleChildScrollView(
                                                    child: Column(
                                                  children: [
                                                    responsivewidget(
                                                        UI(
                                                            navi.navishow == true &&
                                                                    Get.width >
                                                                        1000
                                                                ? constraint
                                                                        .maxWidth -
                                                                    120
                                                                : constraint
                                                                    .maxWidth,
                                                            constraint
                                                                .maxHeight),
                                                        Get.width),
                                                  ],
                                                ));
                                              }),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                navi.navi == 1 &&
                                        navi.navishow == true &&
                                        Get.width > 1000
                                    ? innertype()
                                    : const SizedBox(),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
              ));
    }));
  }
}
