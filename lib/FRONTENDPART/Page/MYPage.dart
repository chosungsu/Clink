// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types
import 'package:clickbyme/FRONTENDPART/Page/NotiAlarm.dart';
import 'package:clickbyme/BACKENDPART/Getx/notishow.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Tool/AppBarCustom.dart';
import '../../BACKENDPART/Getx/navibool.dart';
import '../../Tool/Loader.dart';
import '../../Tool/NoBehavior.dart';
import '../UI(Widget/MYPageUI.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  const MYPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> with TickerProviderStateMixin {
  var scrollController;
  final searchNode = FocusNode();
  var textcontroller = TextEditingController();
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
    draw.navi = Hive.box('user_setting').get('which_menu_pick') ?? 0;
    textcontroller = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    textcontroller.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width < 1000 ? Get.width * 0.7 : Get.width * 0.5;
    double height = Get.height > 1500 ? Get.height * 0.5 : Get.height;

    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: draw.backgroundcolor,
            body: SafeArea(
                child: draw.drawopen == true
                    ? Stack(
                        children: [
                          draw.navi == 0
                              ? const Positioned(
                                  left: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(),
                                  ),
                                )
                              : const Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(),
                                  ),
                                ),
                          MainBody(context),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      )
                    : (draw.drawnoticeopen == true
                        ? Stack(
                            children: [
                              MainBody(context),
                              const Barrier(),
                              Positioned(
                                right: 0,
                                child: SizedBox(
                                  width: width,
                                  height: height,
                                  child: const NotiAlarm(),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              MainBody(context),
                              uiset.loading == true
                                  ? const Loader(
                                      wherein: 'route',
                                    )
                                  : Container()
                            ],
                          )))));
  }

  Widget MainBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return OrientationBuilder(builder: ((context, orientation) {
      return GetBuilder<navibool>(
          builder: (_) => AnimatedContainer(
                transform:
                    Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                      ..scale(draw.scalefactor),
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    draw.drawopen == true
                        ? setState(() {
                            draw.drawopen = false;
                            draw.setclose();
                            Hive.box('user_setting').put('page_opened', false);
                          })
                        : (draw.drawnoticeopen == true
                            ? setState(() {
                                draw.drawnoticeopen = false;
                                draw.setclosenoti();
                                notilist.isreadnoti(init: false);
                                Hive.box('user_setting')
                                    .put('noticepage_opened', false);
                                uiset.pagenumber = 0;
                              })
                            : null);
                  },
                  child: SizedBox(
                    height: height,
                    child: GetBuilder<uisetting>(
                      builder: (_) {
                        return Container(
                            color: draw.backgroundcolor,
                            child: Column(
                              children: [
                                GetBuilder<notishow>(builder: (_) {
                                  return AppBarCustom(
                                    title: 'LOBBY',
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
                                    child: ScrollConfiguration(
                                        behavior: NoBehavior(),
                                        child: LayoutBuilder(
                                          builder: ((context, constraint) {
                                            return UI(
                                                uiset
                                                    .pagelist[
                                                        uiset.mypagelistindex]
                                                    .id,
                                                textcontroller,
                                                searchNode,
                                                constraint.maxWidth,
                                                constraint.maxHeight);
                                          }),
                                        ))),
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
