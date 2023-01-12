// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/navibool.dart';
import '../Route/mainroute.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

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
        height: Get.height,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: draw.backgroundcolor, width: 1)),
            color: BGColor()),
        child: ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: drawerItems.map((element) {
                return GetBuilder<navibool>(
                    builder: (_) => Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            //Entypo.basecamp
                            //AntDesign.home
                            if (element.containsValue(Entypo.basecamp)) {
                              draw.setclose();
                              Hive.box('user_setting').put('page_index', 0);
                              uiset.setmypagelistindex(Hive.box('user_setting')
                                      .get('currentmypage') ??
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
                            } else if (element.containsValue(Entypo.basecamp)) {
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
                            } else if (element
                                .containsValue(Ionicons.ios_search_outline)) {
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
                            } else if (element.containsValue(
                                Ionicons.notifications_outline)) {
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
                            } else if (element
                                .containsValue(Ionicons.settings_outline)) {
                              draw.setclose();
                              Hive.box('user_setting').put('page_index', 3);
                              uiset.setpageindex(
                                  Hive.box('user_setting').get('page_index'));
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const mainroute(
                                    index: 3,
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
                            ],
                          ),
                        )));
              }).toList(),
            ),
          ),
        ));
  }
}
