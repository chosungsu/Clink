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
  const SettingSubPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _SettingSubPageState();
}

class _SettingSubPageState extends State<SettingSubPage>
    with TickerProviderStateMixin {
  final searchNode = FocusNode();
  final navi = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    uiset.showboxlist = false;
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
            backgroundColor: navi.backgroundcolor,
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
                  Matrix4.translationValues(navi.xoffset, navi.yoffset, 0)
                    ..scale(navi.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchNode.unfocus();
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
                  child: Container(
                      color: navi.backgroundcolor,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              GetBuilder<uisetting>(builder: (_) {
                                return AppBarCustom(
                                  title: Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        widget.title,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: mainTitleTextsize(),
                                            color: navi.color_textstatus),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
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
                                child: SizedBox(
                                  width: Get.width,
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: LayoutBuilder(
                                        builder: ((context, constraint) {
                                          return SingleChildScrollView(
                                              child: Column(
                                            children: [
                                              responsivewidget(
                                                  UI(constraint.maxWidth,
                                                      constraint.maxHeight),
                                                  Get.width),
                                            ],
                                          ));
                                        }),
                                      )),
                                ),
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
