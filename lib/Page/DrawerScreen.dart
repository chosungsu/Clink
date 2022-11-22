// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Enums/Variables.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Route/mainroute.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool selected = false;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  late DateTime Date = DateTime.now();
  final draw = Get.put(navibool());
  final cal_share_person = Get.put(PeopleAdd());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: draw.backgroundcolor, width: 1)),
            color: BGColor()),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: drawerItems.map((element) {
              return GetBuilder<navibool>(
                  builder: (_) => Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: InkWell(
                        onTap: () {
                          if (element.containsValue(Icons.view_stream)) {
                            draw.setclose();
                            Hive.box('user_setting').put('page_index', 0);
                            uiset.setmypagelistindex(
                                Hive.box('user_setting').get('currentmypage') ??
                                    0);
                            uiset.setpageindex(
                                Hive.box('user_setting').get('page_index'));
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const mainroute(
                                  index: 0,
                                ),
                              ),
                            );
                          } else if (element.containsValue(Icons.search)) {
                            draw.setclose();
                            Hive.box('user_setting').put('page_index', 1);
                            uiset.setpageindex(
                                Hive.box('user_setting').get('page_index'));
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const mainroute(
                                  index: 1,
                                ),
                              ),
                            );
                          } else if (element.containsValue(Icons.settings)) {
                            draw.setclose();
                            Hive.box('user_setting').put('page_index', 2);
                            uiset.setpageindex(
                                Hive.box('user_setting').get('page_index'));
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const mainroute(
                                  index: 2,
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              element['icon'],
                              color:
                                  drawerItems.indexOf(element) == widget.index
                                      ? Colors.purple.shade300
                                      : draw.color_textstatus,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )));
            }).toList(),
          ),
        ));
  }
}
