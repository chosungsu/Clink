// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/TextSize.dart';
import '../Route/subuiroute.dart';
import '../UI/SettingSubUI.dart';

class SettingSubPage extends StatefulWidget {
  const SettingSubPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SettingSubPageState();
}

class _SettingSubPageState extends State<SettingSubPage>
    with TickerProviderStateMixin {
  final searchNode = FocusNode();
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
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
            backgroundColor: BGColor(),
            body: WillPopScope(
                onWillPop: () => onWillPop(context),
                child: GetBuilder<navibool>(builder: (_) => Body())));
      },
    ));
  }

  Widget Body() {
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchNode.unfocus();
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
                  child: Container(
                      color: draw.backgroundcolor,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              GetBuilder<uisetting>(builder: (_) {
                                return AppBarCustom(
                                  title: Text(
                                    '',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: mainTitleTextsize(),
                                        color: draw.color_textstatus),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  lefticon: true,
                                  lefticonname: MaterialIcons.chevron_left,
                                  righticon: false,
                                  doubleicon: false,
                                  righticonname: Icons.person_outline,
                                );
                              }),
                              Flexible(
                                fit: FlexFit.tight,
                                child: responsivewidget(
                                    SizedBox(
                                      child: ScrollConfiguration(
                                          behavior: NoBehavior(),
                                          child: LayoutBuilder(
                                            builder: ((context, constraint) {
                                              return UI(constraint.maxWidth,
                                                  constraint.maxHeight);
                                            }),
                                          )),
                                    ),
                                    Get.width),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ));
  }
}
