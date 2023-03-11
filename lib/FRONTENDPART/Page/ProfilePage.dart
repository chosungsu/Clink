// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../UI/ProfileUI.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';

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
    uiset.profileindex = 0;
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
                      child: Row(
                        children: [
                          draw.navi == 0 &&
                                  draw.navishow == true &&
                                  Get.width > 1000
                              ? innertype()
                              : const SizedBox(),
                          Column(
                            children: [
                              GetBuilder<uisetting>(builder: (_) {
                                return AppBarCustom(
                                  title: '',
                                  lefticon: false,
                                  lefticonname: Icons.add,
                                  righticon:
                                      uiset.profileindex == 0 ? true : false,
                                  doubleicon: false,
                                  righticonname: Icons.person_outline,
                                  textcontroller: _controller,
                                  searchnode: searchNode,
                                );
                              }),
                              Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                  width:
                                      draw.navishow == true && Get.width > 1000
                                          ? Get.width - 120
                                          : Get.width,
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: LayoutBuilder(
                                        builder: ((context, constraint) {
                                          return UI(
                                              _controller,
                                              searchNode,
                                              scrollController,
                                              draw.navishow == true &&
                                                      Get.width > 1000
                                                  ? constraint.maxWidth - 120
                                                  : constraint.maxWidth,
                                              constraint.maxHeight);
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
                      )),
                ),
              ),
            ));
  }
}
