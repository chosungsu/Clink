// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/UI(Widget/NotiUI.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/Loader.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/NoBehavior.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'DrawerScreen.dart';

class NotiAlarm extends StatefulWidget {
  const NotiAlarm({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //notilist.noticontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: draw.backgroundcolor,
            body: SafeArea(child: NotiBody(context))));
  }

  Widget NotiBody(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => LayoutBuilder(
              builder: ((context, constraint) {
                return UI(
                  constraint.maxWidth,
                  constraint.maxHeight,
                );
              }),
            ));
  }
}
