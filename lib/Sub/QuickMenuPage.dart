import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

import '../DB/AD_Home.dart';
import '../Page/DrawerScreen.dart';
import '../Tool/NoBehavior.dart';

class QuickMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickMenuPageState();
}

class _QuickMenuPageState extends State<QuickMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            DrawerScreen(),
            makeBody(context),
          ],
        ));
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
    final List<AD_Home> _list_ad = [
      AD_Home(
        id: '1',
        title: '데이로그',
        person_num: 3,
        date: DateTime.now(),
      ),
      AD_Home(
        id: '2',
        title: '챌린지',
        person_num: 5,
        date: DateTime.now(),
      ),
      AD_Home(
        id: '3',
        title: '페이지마크',
        person_num: 5,
        date: DateTime.now(),
      ),
      AD_Home(
        id: '4',
        title: '개인키 보관',
        person_num: 4,
        date: DateTime.now(),
      ),
    ];
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01, right: 10),
            alignment: Alignment.topLeft,
            color: Colors.deepPurple.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.keyboard_arrow_left),
                              color: Colors.white,
                              iconSize: 30,
                            )),
                        SizedBox(
                            child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('퀵메뉴 설정',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    )),
                InkWell(
                  onTap: () {
                    //hive 저장
                    Hive.box('user_setting').put('quick_menu', _list_ad);
                  },
                  child: NeumorphicIcon(
                    Icons.save_alt,
                    size: 20,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.white,
                        lightSource: LightSource.topLeft),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  left: BorderSide(
                      width: 1.0,
                      color: const Color.fromARGB(255, 255, 214, 214)),
                  right: const BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  bottom: const BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                )),
            child: ScrollConfiguration(
              behavior: NoBehavior(),
              child: SingleChildScrollView(
                  child: StatefulBuilder(builder: (_, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9 - 20,
                  child: ReorderableListView.builder(
                      itemBuilder: (context, index) {
                        final user_quick_menu =
                            Hive.box('user_setting').get('quick_menu') != null
                                ? Hive.box('user_setting')
                                    .get('quick_menu')[index]
                                : _list_ad[index];
                        return buildList(index, user_quick_menu);
                      },
                      itemCount: _list_ad.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          final index =
                              newIndex > oldIndex ? newIndex - 1 : newIndex;
                          final user_quick_menu = _list_ad.removeAt(oldIndex);
                          _list_ad.insert(index, user_quick_menu);
                        });
                      }),
                );
              })),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildList(int index, AD_Home user_quick_menu) {
    return ListTile(
      key: ValueKey(user_quick_menu),
      leading: NeumorphicIcon(
        Icons.drag_handle,
        size: 20,
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: 2,
            color: Colors.deepPurple.shade200,
            lightSource: LightSource.topLeft),
      ),
      title: Text(user_quick_menu.title,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
