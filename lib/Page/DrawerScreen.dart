import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../route.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int page_index = Hive.box('user_setting').get('page_index');
  late bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: drawerItems.map((element) {
          selected = drawerItems.indexOf(element) == page_index;
          return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: InkWell(
                onTap: () {
                  if (element.containsValue(Icons.home)) {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'BOnd',
                          index: 0,
                        ),
                      ),
                    );
                    Hive.box('user_setting').put('page_index', 0);
                  } else if (element.containsValue(Icons.explore_outlined)) {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'BOnd',
                          index: 1,
                        ),
                      ),
                    );
                    Hive.box('user_setting').put('page_index', 1);
                  } else if (element.containsValue(Icons.bar_chart)) {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'BOnd',
                          index: 2,
                        ),
                      ),
                    );
                    Hive.box('user_setting').put('page_index', 2);
                  } else {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'BOnd',
                          index: 3,
                        ),
                      ),
                    );
                    Hive.box('user_setting').put('page_index', 3);
                  }
                },
                child: Column(
                  children: [
                    selected
                        ? Icon(element['icon'], color: Colors.deepPurple.shade300)
                        : Icon(element['icon'], color: Colors.blueGrey.shade100),
                    const SizedBox(
                      height: 20,
                    ),
                    selected
                        ? Text(element['title'],
                            style: TextStyle(
                                color: Colors.deepPurple.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))
                        : Text(element['title'],
                            style: TextStyle(
                                color: Colors.blueGrey.shade100,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }
}
