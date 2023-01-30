// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names, camel_case_types
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Enums/Variables.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/Getx/navibool.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    textcontroller = TextEditingController();
    super.initState();
    listpinlink.clear();
    uiset.showtopbutton = false;
    uiset.searchpagemove = '';
    uiset.mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
    scrollController = ScrollController();
    draw.navi = Hive.box('user_setting').get('which_menu_pick') ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    textcontroller.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                    child: DrawerScreen(index: 0),
                                  ),
                                )
                              : const Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(index: 0),
                                  ),
                                ),
                          GroupBody(context),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      )
                    : Stack(
                        children: [
                          GroupBody(context),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      ))));
  }

  Widget GroupBody(BuildContext context) {
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
                        : null;
                  },
                  child: SizedBox(
                    height: height,
                    child: GetBuilder<uisetting>(
                      builder: (controller) {
                        return Container(
                            color: draw.backgroundcolor,
                            child: Column(
                              children: [
                                AppBarCustom(
                                  title: 'LOBBY',
                                  lefticon: false,
                                  righticon: true,
                                  doubleicon: false,
                                  lefticonname: Ionicons.add_outline,
                                  righticonname: Ionicons.add_outline,
                                  textcontroller: textcontroller,
                                  searchnode: searchNode,
                                ),
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
