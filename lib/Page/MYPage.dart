// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../DB/PageList.dart';
import '../Enums/Variables.dart';
import '../Route/subuiroute.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Loader.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/PageUI.dart';
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
  var _controller = TextEditingController();

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
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
    scrollController.dispose();
    //notilist.noticontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: draw.backgroundcolor,
            floatingActionButton: Speeddialmemo(
                context,
                usercode,
                _controller,
                searchNode,
                scrollController,
                isDialOpen,
                uiset.pagelist.isEmpty ? '빈 스페이스' : uiset.pagelist[0].title),
            body: SafeArea(
              child: draw.navi == 0
                  ? (draw.drawopen == true
                      ? Stack(
                          children: [
                            SizedBox(
                              width: 80,
                              child: DrawerScreen(
                                index:
                                    Hive.box('user_setting').get('page_index'),
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
                        ))
                  : Stack(
                      children: [
                        GroupBody(context),
                        uiset.loading == true
                            ? const Loader(
                                wherein: 'route',
                              )
                            : Container()
                      ],
                    ),
            )));
  }

  Widget GroupBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
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
                              title: 'MY',
                              righticon: true,
                              iconname: Icons.notifications_none,
                              textEditingController: _controller,
                              focusNode: searchNode,
                              myindex: uiset.mypagelistindex,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ScrollConfiguration(
                              behavior: NoBehavior(),
                              child: PageUI1(
                                  uiset.pagelist[uiset.mypagelistindex].id
                                      .toString(),
                                  _controller)),
                        ],
                      )),
                ),
              ),
            )));
  }
}
