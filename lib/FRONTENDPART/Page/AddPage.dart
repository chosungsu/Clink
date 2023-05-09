// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Getx/linkspacesetting.dart';
import 'package:clickbyme/BACKENDPART/Getx/navibool.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:clickbyme/FRONTENDPART/UI/AddUI.dart';
import 'package:clickbyme/FRONTENDPART/Widget/BottomScreen.dart';
import 'package:clickbyme/FRONTENDPART/Widget/buildTypeWidget.dart';
import 'package:clickbyme/FRONTENDPART/Widget/responsiveWidget.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final uiset = Get.put(uisetting());
  final navi = Get.put(navibool());
  final linkspaceset = Get.put(linkspacesetting());
  int count = 0;

  @override
  void initState() {
    super.initState();
    AddPageinit();
    uisetting().addpagecontroll == 0 ? count = 3 : count = 4;
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
        /**
        * setpagesize : app의 크기를 지정해줌.
        */
        navi.size = MediaQuery.of(context).size;
        return Scaffold(
            backgroundColor: navi.backgroundcolor,
            bottomNavigationBar: uiset.loading
                ? const SizedBox()
                : (navi.size.width < 1000
                    ? const BottomScreen()
                    : const SizedBox()),
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

                  if (uiset.showboxlist.contains(true)) {
                    uiset.changeshowboxtype(init: true, change: false);
                  }

                  navi.drawopen == true && navi.navishow == false
                      ? setState(() {
                          navi.drawopen = false;
                          navi.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: Container(
                    height: navi.size.height,
                    width: navi.size.width,
                    color: navi.backgroundcolor,
                    child: GetBuilder<uisetting>(
                      builder: (_) {
                        return Row(
                          children: [
                            navi.navi == 0 &&
                                    navi.navishow == true &&
                                    navi.size.width > 1000
                                ? (navi.settinginsidemap.containsKey(0) == false
                                    ? const SizedBox()
                                    : innertype())
                                : const SizedBox(),
                            Column(
                              children: [
                                /*GetBuilder<uisetting>(builder: (_) {
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
                                  }),*/
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: SizedBox(
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
                                                        navi.navishow == true &&
                                                                navi.size
                                                                        .width >
                                                                    1000
                                                            ? navi.size.width -
                                                                120
                                                            : navi.size.width),
                                                    navi.size.width),
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
                                    navi.size.width > 1000
                                ? (navi.settinginsidemap.containsKey(0) == false
                                    ? const SizedBox()
                                    : innertype())
                                : const SizedBox(),
                          ],
                        );
                      },
                    )),
              ),
            ));
  }
}
