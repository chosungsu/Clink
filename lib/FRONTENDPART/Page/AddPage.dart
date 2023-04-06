// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:clickbyme/FRONTENDPART/UI/AddUI.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/TextSize.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';
import '../Widget/responsiveWidget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List<PageController> pageController = [];
  List<TextEditingController> controllersall = [];
  List<FocusNode> searchNodeall = [];
  final navi = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  int count = 0;

  @override
  void initState() {
    super.initState();
    AddPageinit();
    uiset.addpagecontroll == 0 ? count = 3 : count = 4;
    for (int i = 0; i < count; i++) {
      controllersall.insert(i, TextEditingController());
      searchNodeall.insert(i, FocusNode());
    }
    pageController.insert(
        0,
        PageController(
            initialPage:
                linkspaceset.pageviewnum == 0 ? 0 : linkspaceset.pageviewnum));
    pageController.insert(1, PageController());
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controllersall.length; i++) {
      controllersall[i].dispose();
    }
    scrollController.dispose();
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
        pageController[0] = PageController(
            initialPage:
                linkspaceset.pageviewnum == 0 ? 0 : linkspaceset.pageviewnum);
        return Scaffold(
            backgroundColor: navi.backgroundcolor,
            bottomNavigationBar: uiset.loading
                ? const SizedBox()
                : (Get.width < 1000 ? const BottomScreen() : const SizedBox()),
            body: GetBuilder<navibool>(
                builder: (_) => buildtypewidget(context, AddBody())));
      },
    ));
  }

  Widget AddBody() {
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(navi.xoffset, navi.yoffset, 0)
                    ..scale(navi.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  for (int i = 0; i < searchNodeall.length; i++) {
                    searchNodeall[i].unfocus();
                  }

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
                      child: GetBuilder<navibool>(
                        builder: (_) {
                          return Row(
                            children: [
                              navi.navi == 0 &&
                                      navi.navishow == true &&
                                      Get.width > 1000
                                  ? (navi.settinginsidemap.containsKey(0) ==
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
                                              color: navi.color_textstatus),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        lefticon: false,
                                        lefticonname: Icons.add,
                                        righticon: false,
                                        doubleicon: false,
                                        righticonname: Feather.check_circle);
                                  }),
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
                                              return Column(
                                                children: [
                                                  responsivewidget(
                                                      UI(
                                                          controllersall,
                                                          searchNodeall,
                                                          pageController,
                                                          scrollController,
                                                          navi.navishow ==
                                                                      true &&
                                                                  Get.width >
                                                                      1000
                                                              ? constraint
                                                                      .maxWidth -
                                                                  120
                                                              : constraint
                                                                  .maxWidth,
                                                          constraint.maxHeight),
                                                      Get.width),
                                                ],
                                              );
                                            }),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              navi.navi == 1 &&
                                      navi.navishow == true &&
                                      Get.width > 1000
                                  ? (navi.settinginsidemap.containsKey(0) ==
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
