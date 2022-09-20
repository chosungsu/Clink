import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../route.dart';
import '../sheets/addWhole.dart';
import 'HomePage.dart';

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

  @override
  void initState() {
    super.initState();
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
                      if (element.containsValue(Icons.home)) {
                        draw.setclose();
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MyHomePage(
                              index: 1,
                              secondname: cal_share_person.secondname,
                            ),
                          ),
                        );

                        Hive.box('user_setting').put('page_index', 1);
                      } else if (element.containsValue(Icons.add_outlined)) {
                        //draw.setclose();
                        addWhole(context, searchNode, controller, name, Date,
                            'home');
                      } else if (element.containsValue(Icons.group)) {
                        //draw.setclose();
                        draw.setclose();
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MyHomePage(
                                index: 0,
                                secondname: cal_share_person.secondname),
                          ),
                        );
                        Hive.box('user_setting').put('page_index', 0);
                      } else {
                        draw.setclose();
                        Navigator.of(context).pushReplacement(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MyHomePage(
                                index: 3,
                                secondname: cal_share_person.secondname),
                          ),
                        );
                        Hive.box('user_setting').put('page_index', 3);
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
