import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/SheetGetx/navibool.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../route.dart';
import 'HomePage.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int page_index = Hive.box('user_setting').get('page_index') ?? 0;
  late bool selected;
  Color colorselection = Colors.white;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  late DateTime Date = DateTime.now();
  final draw = Get.put(navibool());

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
      width: 50,
      decoration: BoxDecoration(color: BGColor()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: drawerItems.map((element) {
          selected = drawerItems.indexOf(element) == page_index;
          return Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: InkWell(
                onTap: () {
                  setState(() {
                    draw.setclose();
                    if (element.containsValue(Icons.home)) {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const MyHomePage(
                            index: 0,
                          ),
                        ),
                      );

                      Hive.box('user_setting').put('page_index', 0);
                    } else if (element.containsValue(Icons.add_outlined)) {
                      addcalendar(
                          context, searchNode, controller, name, Date, 'home');
                      Hive.box('user_setting').put('page_index',
                          Hive.box('user_setting').get('page_index'));
                    } else {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const MyHomePage(
                            index: 2,
                          ),
                        ),
                      );
                      Hive.box('user_setting').put('page_index', 2);
                    }
                  });
                },
                child: Column(
                  children: [
                    selected
                        ? Icon(
                            element['icon'],
                            color: NaviColor(selected),
                          )
                        : Icon(
                            element['icon'],
                            color: NaviColor(selected),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    selected
                        ? Text(element['title'],
                            style: TextStyle(
                                color: NaviColor(selected),
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize()))
                        : Text(element['title'],
                            style: TextStyle(
                                color: NaviColor(selected),
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }
}
