// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/UI/NotiUI.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Api/NoticeApi.dart';
import '../../BACKENDPART/Getx/notishow.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/AppBarCustom.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/NoBehavior.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';

class NotiAlarm extends StatefulWidget {
  const NotiAlarm({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm> {
  final draw = Get.put(navibool());
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
        return Scaffold(
            backgroundColor: draw.backgroundcolor,
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
                    Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                      ..scale(draw.scalefactor),
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    draw.drawopen == true && draw.navishow == false
                        ? setState(() {
                            draw.drawopen = false;
                            draw.setclose();
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
                            color: draw.backgroundcolor,
                            child: Row(
                              children: [
                                draw.navi == 0 &&
                                        draw.navishow == true &&
                                        Get.width > 1000
                                    ? innertype()
                                    : const SizedBox(),
                                Column(
                                  children: [
                                    AppBarCustom(
                                      title: 'Notice',
                                      lefticon: false,
                                      righticon: false,
                                      doubleicon: false,
                                      lefticonname: Ionicons.add_outline,
                                      righticonname: Ionicons.ios_close,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SetBoxUI(
                                      draw.navishow == true && Get.width > 1000
                                          ? Get.width - 120
                                          : Get.width,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SizedBox(
                                        width: draw.navishow == true &&
                                                Get.width > 1000
                                            ? Get.width - 120
                                            : Get.width,
                                        child: ScrollConfiguration(
                                            behavior: NoBehavior(),
                                            child: LayoutBuilder(
                                              builder: ((context, constraint) {
                                                return UI(
                                                  draw.navishow == true &&
                                                          Get.width > 1000
                                                      ? constraint.maxWidth -
                                                          120
                                                      : constraint.maxWidth,
                                                );
                                              }),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                draw.navi == 1 &&
                                        draw.navishow == true &&
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
