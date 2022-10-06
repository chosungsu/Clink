import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Getx/navibool.dart';
import 'IconBtn.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom(
      {Key? key,
      required this.title,
      required this.righticon,
      required this.func})
      : super(key: key);
  final String title;
  final bool righticon;
  final void func;

  @override
  Widget build(BuildContext context) {
    final draw = Get.put(navibool());
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 10),
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
                                  child: Text(title.toString(),
                                      style: GoogleFonts.lobster(
                                        fontSize: 25,
                                        color: TextColor(),
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ))),
                  ],
                ),
              )));
    }));
  }
}
