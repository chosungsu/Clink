import 'package:clickbyme/Page/NotiAlarm.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/sheets/movetolinkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Route/subuiroute.dart';
import 'AndroidIOS.dart';
import 'Getx/navibool.dart';
import 'Getx/notishow.dart';
import 'IconBtn.dart';
import 'TextSize.dart';

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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var updateid = '';
    var updateusername = [];
    final notilist = Get.put(notishow());
    final draw = Get.put(navibool());
    String name = Hive.box('user_info').get('id');

    func1() => Get.to(() => const NotiAlarm(), transition: Transition.upToDown);
    func2() async {
      final reloadpage = await Get.dialog(OSDialog(
              context,
              '경고',
              Text('알림들을 삭제하시겠습니까?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: Colors.blueGrey)),
              pressed2)) ??
          false;
      if (reloadpage) {
        firestore.collection('AppNoticeByUsers').get().then((value) {
          for (var element in value.docs) {
            if (element.get('sharename').toString().contains(name) == true) {
              updateid = element.id;
              updateusername =
                  element.get('sharename').toString().split(',').toList();
              if (updateusername.length == 1) {
                firestore.collection('AppNoticeByUsers').doc(updateid).delete();
              } else {
                updateusername.removeWhere(
                    (element) => element.toString().contains(name));
                firestore
                    .collection('AppNoticeByUsers')
                    .doc(updateid)
                    .update({'sharename': updateusername});
              }
            } else {
              if (element.get('username').toString() == name) {
                updateid = element.id;
                firestore.collection('AppNoticeByUsers').doc(updateid).delete();
              } else {}
            }
          }
        }).whenComplete(() {
          notilist.isreadnoti();
        });
      }
    }

    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<navibool>(
          builder: (_) => SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 10, top: 5, bottom: 5),
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
                            ? MediaQuery.of(context).size.width - 80
                            : MediaQuery.of(context).size.width - 30,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                                        color: TextColor()),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: mainTitleTextsize(),
                                    ),
                                  ),
                                ),
                                righticon == true
                                    ? IconBtn(
                                        child: IconButton(
                                            onPressed: () => iconname ==
                                                    Icons.notifications_none
                                                ? func1()
                                                : func2(),
                                            icon: Container(
                                              alignment: Alignment.center,
                                              width: 30,
                                              height: 30,
                                              child: NeumorphicIcon(
                                                iconname,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            )),
                                        color: TextColor())
                                    : const SizedBox()
                              ],
                            ))),
                  ],
                ),
              )));
    }));
  }
}
