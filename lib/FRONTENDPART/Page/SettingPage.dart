// ignore_for_file: non_constant_identifier_names, file_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/TextSize.dart';
import '../UI/SettingUI.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/buildTypeWidget.dart';
import '../Widget/responsiveWidget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final searchNode = FocusNode();
  final navi = Get.put(navibool());
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
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: navi.backgroundcolor,
            statusBarBrightness:
                navi.statusbarcolor == 0 ? Brightness.dark : Brightness.light,
            statusBarIconBrightness:
                navi.statusbarcolor == 0 ? Brightness.dark : Brightness.light));
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
                builder: (_) => buildtypewidget(context, ProfileBody())));
      },
    ));
  }

  Widget ProfileBody() {
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
                child: GetBuilder<uisetting>(
                  builder: (_) {
                    return Container(
                        color: navi.backgroundcolor,
                        height: navi.size.height,
                        width: navi.size.width,
                        child: GetBuilder<navibool>(
                          builder: (_) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                navi.navi == 0 &&
                                        navi.navishow == true &&
                                        navi.size.width > 1000
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
                                          'settingpagetitle'.tr,
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: mainTitleTextsize(),
                                              color: navi.color_textstatus),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        lefticon: false,
                                        lefticonname: Icons.add,
                                        righticon: true,
                                        doubleicon: false,
                                        righticonname: Octicons.person,
                                        textcontroller: _controller,
                                        searchnode: searchNode,
                                      );
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: responsivewidget(
                                          SizedBox(
                                            child: ScrollConfiguration(
                                                behavior: NoBehavior(),
                                                child: LayoutBuilder(
                                                  builder:
                                                      ((context, constraint) {
                                                    return SingleChildScrollView(
                                                        child: Column(
                                                      children: [
                                                        UI(
                                                            _controller,
                                                            searchNode,
                                                            scrollController,
                                                            navi.size.width),
                                                      ],
                                                    ));
                                                  }),
                                                )),
                                          ),
                                          navi.navishow == true &&
                                                  navi.size.width > 1000
                                              ? navi.size.width - 120
                                              : navi.size.width,
                                        )),
                                  ],
                                ),
                                navi.navi == 1 &&
                                        navi.navishow == true &&
                                        navi.size.width > 1000
                                    ? (navi.settinginsidemap.containsKey(0) ==
                                            false
                                        ? const SizedBox()
                                        : innertype())
                                    : const SizedBox(),
                              ],
                            );
                          },
                        ));
                  },
                ),
              ),
            ));
  }
}
