// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Enums/Variables.dart';
import '../Route/mainroute.dart';
import '../Route/subuiroute.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/SpaceinUI.dart';

class Spacein extends StatefulWidget {
  const Spacein({Key? key, required this.id, required this.type})
      : super(key: key);
  final String id;
  final int type;

  @override
  State<StatefulWidget> createState() => _SpaceinState();
}

class _SpaceinState extends State<Spacein> with TickerProviderStateMixin {
  var scrollController;

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 6);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            bottomNavigationBar: ADSHOW(),
            backgroundColor: draw.backgroundcolor,
            floatingActionButton: widget.type == 1
                ? null
                : Speeddialspace(context, widget.id, widget.type),
            body: SafeArea(
              child: WillPopScope(
                onWillPop: _onWillPop,
                child: UI(),
              ),
            )));
  }

  Widget UI() {
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
                              title: '',
                              righticon: false,
                              iconname: Icons.notifications_none,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ScrollConfiguration(
                              behavior: NoBehavior(),
                              child: SpaceinUI(widget.id)),
                        ],
                      )),
                ),
              ),
            )));
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      if (isDialOpen.value == true) {
        isDialOpen.value = false;
      } else {
        StatusBarControl.setColor(draw.backgroundcolor, animated: true);
        draw.setnavi();
        Hive.box('user_setting').put('page_index', 0);
        Get.to(
            () => const mainroute(
                  index: 0,
                ),
            transition: Transition.upToDown);
      }

      //Get.back();
    });
    return false;
  }
}
