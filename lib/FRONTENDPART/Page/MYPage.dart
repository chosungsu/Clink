// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types
import 'package:clickbyme/BACKENDPART/Getx/notishow.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/FRONTENDPART/Widget/buildTypeWidget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Tool/AppBarCustom.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/TextSize.dart';
import '../UI/MYPageChangeUI.dart';
import '../Widget/BottomScreen.dart';
import '../Widget/responsiveWidget.dart';

class MYPage extends StatefulWidget {
  const MYPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> with TickerProviderStateMixin {
  ScrollController? scrollController;
  final searchNode = FocusNode();
  TextEditingController? textcontroller;
  final navi = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final notilist = Get.put(notishow());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    uiset.pagenumber = 0;
    uiset.searchpagemove = '';
    uiset.mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
    textcontroller = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    textcontroller!.dispose();
    scrollController!.dispose();
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
                builder: (_) => buildtypewidget(context, MainBody())));
      },
    ));
  }

  Widget MainBody() {
    return OrientationBuilder(builder: ((context, orientation) {
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
                    child: GetBuilder<uisetting>(
                      builder: (_) {
                        return Container(
                            color: navi.backgroundcolor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                navi.navi == 0 &&
                                        navi.navishow == true &&
                                        Get.width > 1000
                                    ? innertype()
                                    : const SizedBox(),
                                Column(
                                  children: [
                                    GetBuilder<notishow>(builder: (_) {
                                      return AppBarCustom(
                                        title: uiset.changesearchbar == true
                                            ? SearchBox(
                                                textcontroller, searchNode)
                                            : Text(
                                                'Pinset',
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        mainTitleTextsize(),
                                                    color:
                                                        navi.color_textstatus),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        lefticon: false,
                                        righticon: true,
                                        doubleicon: true,
                                        lefticonname: Ionicons.add_outline,
                                        righticonname:
                                            uiset.changesearchbar == true
                                                ? Ionicons.close
                                                : Ionicons.search,
                                        textcontroller: textcontroller,
                                        searchnode: searchNode,
                                      );
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: responsivewidget(
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: ScrollConfiguration(
                                                behavior: NoBehavior(),
                                                child: LayoutBuilder(
                                                  builder:
                                                      ((context, constraint) {
                                                    return SingleChildScrollView(
                                                        child: UI(
                                                            context,
                                                            uiset
                                                                .pagelist[uiset
                                                                    .mypagelistindex]
                                                                .id,
                                                            textcontroller,
                                                            searchNode,
                                                            constraint.maxWidth,
                                                            constraint
                                                                .maxHeight));
                                                  }),
                                                )),
                                          ),
                                          navi.navishow == true &&
                                                  Get.width > 1000
                                              ? Get.width - 120
                                              : Get.width,
                                        )),
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
