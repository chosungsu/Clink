import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/sheets/movetolinkspace.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Getx/navibool.dart';
import 'IconBtn.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    Key? key,
    required this.title,
    required this.righticon,
    required this.iconname,
  }) : super(key: key);
  final String title;
  final bool righticon;
  final IconData iconname;
  @override
  Widget build(BuildContext context) {
    func1() => Get.to(() => const NotiAlarm(), transition: Transition.upToDown);
    func2() => movetolinkspace(context);
    final draw = Get.put(navibool());
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    draw.navi == 0
                        ? draw.drawopen == true
                            ? IconBtn(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        draw.setclose();
                                        Hive.box('user_setting')
                                            .put('page_opened', false);
                                      });
                                    },
                                    icon: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: NeumorphicIcon(
                                        Icons.keyboard_arrow_left,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    )),
                                color: TextColor())
                            : IconBtn(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        draw.setopen();
                                        Hive.box('user_setting')
                                            .put('page_opened', true);
                                      });
                                    },
                                    icon: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: NeumorphicIcon(
                                        Icons.menu,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            surfaceIntensity: 0.5,
                                            depth: 2,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    )),
                                color: TextColor())
                        : const SizedBox(),
                    SizedBox(
                        width: draw.navi == 0
                            ? MediaQuery.of(context).size.width - 70
                            : MediaQuery.of(context).size.width - 20,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: NeumorphicText(
                                    title.toString(),
                                    textAlign: TextAlign.start,
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: Colors.blue.shade200),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                righticon == true
                                    ? InkWell(
                                        onTap: () =>
                                            iconname == Icons.notifications_none
                                                ? func1()
                                                : func2(),
                                        child: Icon(
                                          iconname,
                                          size: 30,
                                          color: TextColor_shadowcolor(),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ))),
                  ],
                ),
              )));
    }));
  }
}
