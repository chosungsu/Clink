// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/FRONTENDPART/UI(Widget/NotiUI.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/AppBarCustom.dart';
import '../../Tool/Getx/navibool.dart';
import '../../Tool/NoBehavior.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class NotiAlarm extends StatefulWidget {
  const NotiAlarm({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm> {
  final draw = Get.put(navibool());
  final uiset = Get.put(uisetting());
  final notilist = Get.put(notishow());

  @override
  void initState() {
    super.initState();
    notilist.allcheck = false;
    notilist.checkboxnoti =
        List.filled(notilist.listad.length, false, growable: true);
    uiset.pagenumber = 3;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<navibool>(
        builder: (_) => Scaffold(
            backgroundColor: draw.backgroundcolor,
            body: SafeArea(
              child: NotiBody(context),
            )));
  }

  Widget NotiBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 60;
    return GetBuilder<navibool>(
        builder: (_) => LayoutBuilder(
              builder: ((context, constraint) {
                return SizedBox(
                  height: height,
                  child: GetBuilder<uisetting>(
                    builder: (controller) {
                      return Container(
                          decoration: BoxDecoration(
                              color: draw.backgroundcolor,
                              border: Border(
                                left: BorderSide(
                                    color: draw.color_textstatus, width: 1),
                              )),
                          child: Column(
                            children: [
                              AppBarCustom(
                                title: 'Notice',
                                lefticon: false,
                                righticon: true,
                                doubleicon: false,
                                lefticonname: Ionicons.add_outline,
                                righticonname: Ionicons.ios_close,
                              ),
                              Container(
                                height: 20,
                              ),
                              SetBoxUI(widget.width),
                              Container(
                                height: 20,
                              ),
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: LayoutBuilder(
                                        builder: ((context, constraint) {
                                          return UI(
                                              widget.width, widget.height);
                                        }),
                                      ))),
                            ],
                          ));
                    },
                  ),
                );
              }),
            ));
  }
}
