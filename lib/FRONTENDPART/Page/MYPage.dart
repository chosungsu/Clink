// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types
import 'package:clickbyme/BACKENDPART/Getx/notishow.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/FRONTENDPART/Widget/buildTypeWidget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Tool/AppBarCustom.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/TextSize.dart';
import '../UI/MYPageUI.dart';
import '../Widget/BottomScreen.dart';

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
  final draw = Get.put(navibool());
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
        return Scaffold(
            backgroundColor: BGColor(),
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
                                    GetBuilder<notishow>(builder: (_) {
                                      return AppBarCustom(
                                        title: Text(
                                          'iTPLE',
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: mainTitleTextsize(),
                                              color: draw.color_textstatus),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        lefticon: false,
                                        righticon: true,
                                        doubleicon: true,
                                        lefticonname: Ionicons.add_outline,
                                        righticonname: Ionicons.add_outline,
                                        textcontroller: textcontroller,
                                        searchnode: searchNode,
                                      );
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Container(
                                          width: draw.navishow == true &&
                                                  Get.width > 1000
                                              ? Get.width - 120
                                              : Get.width,
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: ScrollConfiguration(
                                              behavior: NoBehavior(),
                                              child: LayoutBuilder(
                                                builder:
                                                    ((context, constraint) {
                                                  return SingleChildScrollView(
                                                      child: UI(
                                                          uiset
                                                              .pagelist[uiset
                                                                  .mypagelistindex]
                                                              .id,
                                                          textcontroller,
                                                          searchNode,
                                                          draw.navishow ==
                                                                      true &&
                                                                  Get.width >
                                                                      1000
                                                              ? constraint
                                                                      .maxWidth -
                                                                  120
                                                              : constraint
                                                                  .maxWidth,
                                                          constraint
                                                              .maxHeight));
                                                }),
                                              )),
                                        )),
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
