import 'package:clickbyme/Dialogs/saveMenu.dart';
import 'package:clickbyme/Futures/quickmenuasync.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import '../Page/DrawerScreen.dart';
import '../Tool/NoBehavior.dart';

class QuickMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickMenuPageState();
}

class _QuickMenuPageState extends State<QuickMenuPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nick = Hive.box('user_info').get('id');
  late List<String> str_menu_list;
  final List<String> _list_ad = [
    '데이로그',
    '챌린지',
    '페이지마크',
    '탐색기록'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    str_menu_list = [];
  }

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
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02, right: 10),
            alignment: Alignment.topLeft,
            color: Colors.deepPurple.shade100,
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
                SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: () {
                        saveMenu(context, str_menu_list);
                      },
                      icon: const Icon(Icons.save_alt),
                      color: Colors.white,
                      iconSize: 30,
                    )),
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
                    child: FutureBuilder<List<String>>(
                      future: quickmenuasync(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.hasData) {
                          return ReorderableListView.builder(
                              itemBuilder: (context, index) {
                                return buildList(index, snapshot.data![index]);
                              },
                              itemCount: snapshot.data!.length,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  str_menu_list.clear();
                                  final index = newIndex > oldIndex
                                      ? newIndex - 1
                                      : newIndex;
                                  final user_quick_menu =
                                      snapshot.data!.removeAt(oldIndex);
                                  snapshot.data!.insert(index, user_quick_menu);
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++) {
                                    str_menu_list.add(snapshot.data![i]);
                                  }
                                  print('1 : ' + str_menu_list.toString());
                                  //firestore 저장
                                  firestore
                                      .collection('QuickMenu')
                                      .doc(nick)
                                      .set({
                                    'name': nick,
                                    'menu': str_menu_list,
                                  });
                                });
                              });
                        } else {
                          return ReorderableListView.builder(
                              itemBuilder: (context, index) {
                                return buildList(index, _list_ad[index]);
                              },
                              itemCount: _list_ad.length,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  str_menu_list.clear();
                                  final index = newIndex > oldIndex
                                      ? newIndex - 1
                                      : newIndex;
                                  final user_quick_menu =
                                      _list_ad.removeAt(oldIndex);
                                  _list_ad.insert(index, user_quick_menu);
                                  for (int i = 0; i < _list_ad.length; i++) {
                                    str_menu_list.add(_list_ad[i]);
                                  }
                                  print('2 : ' + str_menu_list.toString());
                                  //firestore 저장
                                  firestore
                                      .collection('QuickMenu')
                                      .doc(nick)
                                      .set({
                                    'name': nick,
                                    'menu': str_menu_list,
                                  });
                                });
                              });
                        }
                      },
                    ));
              })),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildList(int index, String user_quick_menu) {
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
      title: Text(user_quick_menu,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
