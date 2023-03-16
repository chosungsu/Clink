// ignore_for_file: non_constant_identifier_names

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
import '../UI/ProfileUI.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';
import '../Widget/responsiveWidget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final searchNode = FocusNode();
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    uiset.searchpagemove = '';
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
            backgroundColor: BGColor(),
            bottomNavigationBar: uiset.loading
                ? const SizedBox()
                : (Get.width < 1000 ? const BottomScreen() : const SizedBox()),
            body: GetBuilder<navibool>(
                builder: (_) => buildtypewidget(context, ProfileBody())));
      },
    ));
  }

  Widget ProfileBody() {
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
                      child: GetBuilder<navibool>(
                        builder: (_) {
                          return Row(
                            children: [
                              draw.navi == 0 &&
                                      draw.navishow == true &&
                                      Get.width > 1000
                                  ? (draw.settinginsidemap.containsKey(0) ==
                                          false
                                      ? const SizedBox()
                                      : innertype())
                                  : const SizedBox(),
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
                                      lefticon: false,
                                      lefticonname: Icons.add,
                                      righticon: true,
                                      doubleicon: false,
                                      righticonname: Ionicons.settings_outline,
                                    );
                                  }),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: responsivewidget(
                                        SizedBox(
                                          width: draw.navishow == true &&
                                                  Get.width > 1000
                                              ? Get.width - 120
                                              : Get.width,
                                          child: ScrollConfiguration(
                                              behavior: NoBehavior(),
                                              child: LayoutBuilder(
                                                builder:
                                                    ((context, constraint) {
                                                  return UI(
                                                      _controller,
                                                      searchNode,
                                                      scrollController,
                                                      draw.navishow == true &&
                                                              Get.width > 1000
                                                          ? constraint
                                                                  .maxWidth -
                                                              120
                                                          : constraint.maxWidth,
                                                      constraint.maxHeight);
                                                }),
                                              )),
                                        ),
                                        Get.width),
                                  ),
                                ],
                              ),
                              draw.navi == 1 &&
                                      draw.navishow == true &&
                                      Get.width > 1000
                                  ? (draw.settinginsidemap.containsKey(0) ==
                                          false
                                      ? const SizedBox()
                                      : innertype())
                                  : const SizedBox(),
                            ],
                          );
                        },
                      )),
                ),
              ),
            ));
  }
}
