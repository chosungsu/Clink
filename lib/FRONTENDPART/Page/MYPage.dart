/**
 * // ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/ResponsiveUI.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../Enums/Variables.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/Loader.dart';
import '../../Tool/NoBehavior.dart';
import '../../Tool/AppBarCustom.dart';
import '../UI(Widget/PageUI.dart';
import 'DrawerScreen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

GlobalKey LSFlex = GlobalKey();

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
  var _controller = TextEditingController();
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    listpinlink.clear();
    uiset.showtopbutton = false;
    uiset.searchpagemove = '';
    Hive.box('user_setting').put('page_index', 0);
    uiset.mypagelistindex = Hive.box('user_setting').get('currentmypage') ?? 0;
    scrollController = ScrollController();
    draw.navi = Hive.box('user_setting').get('which_menu_pick') ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                              ? Positioned(
                                  left: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(
                                      index: Hive.box('user_setting')
                                          .get('page_index'),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: 80,
                                    child: DrawerScreen(
                                      index: Hive.box('user_setting')
                                          .get('page_index'),
                                    ),
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
              child: GetBuilder<navibool>(
                builder: (_) => GestureDetector(
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
                    child: Container(
                        color: draw.backgroundcolor,
                        child: Column(
                          children: [
                            GetBuilder<uisetting>(
                              builder: (_) => AppBarCustom(
                                title: '',
                                lefticon: false,
                                lefticonname: Icons.add,
                                righticon: true,
                                doubleicon: false,
                                righticonname: Ionicons.add_outline,
                                textEditingController: _controller,
                                focusNode: searchNode,
                                myindex: uiset.mypagelistindex,
                              ),
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
                                        return SingleChildScrollView(
                                            physics: const ScrollPhysics(),
                                            child: UI(
                                                uiset
                                                    .pagelist[
                                                        uiset.mypagelistindex]
                                                    .id,
                                                _controller,
                                                constraint.maxWidth,
                                                constraint.maxHeight));
                                      }),
                                    ))),
                          ],
                        )),
                  ),
                ),
              )));
    }));
  }
}

 */