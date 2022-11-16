// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Color colorselection = Colors.white;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();
  final draw = Get.put(navibool());
  final cal_share_person = Get.put(PeopleAdd());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    Hive.box('user_setting').get('which_color_background') == null
        ? colorselection = MyTheme.colorWhite_drawer
        : (Hive.box('user_setting').get('which_color_background') == 0
            ? colorselection = MyTheme.colorWhite_drawer
            : colorselection = MyTheme.colorblack_drawer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: BGColor_shadowcolor(), width: 1)),
            color: BGColor()),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: drawerItems.map((element) {
              selected = drawerItems.indexOf(element) == widget.index;
              return Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: InkWell(
                    onTap: () {
                      if (element.containsValue(Icons.view_stream)) {
                        draw.setclose();
                        Hive.box('user_setting').put('page_index', 0);
                        uiset.setmypagelistindex(0);
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const mainroute(
                              index: 0,
                            ),
                          ),
                        );
                      } else if (element.containsValue(Icons.search)) {
                        //draw.setclose();
                        /*addWhole_update(context, searchNode, controller, name,
                            Date, 'home', fToast);*/
                        draw.setclose();
                        Hive.box('user_setting').put('page_index', 1);
                        uiset.setmypagelistindex(1);
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const mainroute(
                              index: 1,
                            ),
                          ),
                        );
                      } else if (element.containsValue(Icons.settings)) {
                        //draw.setclose();
                        draw.setclose();
                        Hive.box('user_setting').put('page_index', 2);
                        uiset.setmypagelistindex(2);
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
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
                          color: NaviColor(selected),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ));
            }).toList(),
          ),
        ));
  }
}
