import 'package:clickbyme/Enums/Drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../route.dart';
class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 70, top: 70, left: 30),
      color: Colors.deepPurple.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: drawerItems.map((element) {
          return Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: InkWell(
                onTap: () {
                  if (element.containsValue(Icons.home)) {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'HabitMind',
                          index: 0,
                        ),
                      ),
                    );
                  } else if (element.containsValue(Icons.widgets)) {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'HabitMind',
                          index: 1,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const MyHomePage(
                          title: 'HabitMind',
                          index: 2,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(element['icon'], color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    element['title'],
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }
}
