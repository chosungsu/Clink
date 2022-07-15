import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/Dialogs/howchangespace.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/SpaceAD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Tool/NoBehavior.dart';

class ChangeSpace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeSpaceState();
}

class _ChangeSpaceState extends State<ChangeSpace> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id');
  final List<SpaceList> _list_ad = [];
  final List<SpaceList> _user_ad = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterMySpace(),
    ));
  }

  EnterMySpace() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                        width: 50,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              child: NeumorphicIcon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                style: const NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: Colors.black45,
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                const Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      howchangespace(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: NeumorphicIcon(
                                        Icons.help_outline,
                                        size: 30,
                                        style: const NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            surfaceIntensity: 0.5,
                                            depth: 2,
                                            color: Colors.black45,
                                            lightSource: LightSource.topLeft),
                                      ),
                                    )),
                              ],
                            ))),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MySpace(height, context),
                              const SizedBox(
                                height: 30,
                              ),
                              ChoiceSpace(height, context),
                              const SizedBox(
                                height: 150,
                              ),
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  MySpace(double height, BuildContext context) {
    return SizedBox(
      height: 70 * 5 + 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('나의 현재 스페이스',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          myspace(),
        ],
      ),
    );
  }

  myspace() {
    //유저의 메뉴변경에 따라 자동으로 파이어베이스에 저장되어 불러오는 로직
    return SizedBox(
        height: 70 * 5,
        child: FutureBuilder(
            future: firestore
                .collection("UserSpaceDataBase")
                .doc(name)
                .get()
                .then((value) {
              _list_ad.clear();
              _user_ad.clear();
              for (int i = 0; i < 5; i++) {
                _user_ad.insert(i, SpaceList(title: value['$i']));
              }
            }),
            builder: (context, future) {
              if (future.hasData) {
                return SizedBox(
                    height: 70 * _user_ad.length.toDouble(),
                    child: ReorderableListView(
                        children: getItems(),
                        onReorder: (oldIndex, newIndex) {
                          onreorder(oldIndex, newIndex);
                        }));
              } else if (!future.hasData) {
                return StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('SpaceDataBase').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final valuespace = snapshot.data!.docs;

                      for (var sp in valuespace) {
                        final messageText = sp.get('name');
                        _list_ad.add(SpaceList(title: messageText));
                      }

                      return SizedBox(
                          height: 70 * _list_ad.length.toDouble(),
                          child: ReorderableListView(
                              children: getItems(),
                              onReorder: (oldIndex, newIndex) {
                                onreorder(oldIndex, newIndex);
                              }));
                    }
                    return const SizedBox(
                        height: 70 * 5,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  },
                );
              }
              return const SizedBox(
                  height: 70 * 5,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            }));
  }

  List<ListTile> getItems() => _list_ad.isEmpty
      ? _list_ad
          .asMap()
          .map((index, item) =>
              MapEntry(index, buildListTile_not_buy(item.title, index)))
          .values
          .toList()
      : _user_ad
          .asMap()
          .map((index, item) =>
              MapEntry(index, buildListTile_not_buy(item.title, index)))
          .values
          .toList();
  ListTile buildListTile_not_buy(String item, int index) => ListTile(
      key: ValueKey(item + '-' + index.toString()),
      title: Text(item),
      trailing: index < 3
          ? const Icon(
              Icons.menu,
              color: Colors.black45,
              size: 20,
            )
          : const Icon(
              Icons.lock,
              color: Colors.black45,
              size: 20,
            ));
  onreorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      if (_user_ad.isEmpty) {
        _list_ad
            .asMap()
            .map((index, item) =>
                MapEntry(index, buildListTile_not_buy(item.title, index)))
            .values
            .toList();
        String titling = _list_ad[oldIndex].title;
        _list_ad.removeAt(oldIndex);
        _list_ad.insert(newIndex, SpaceList(title: titling));
        //data를 즉각적으로 수정하여 firestore에 저장하는 로직
        createData(name, _user_ad, _list_ad);
      } else {
        _user_ad
            .asMap()
            .map((index, item) =>
                MapEntry(index, buildListTile_not_buy(item.title, index)))
            .values
            .toList();
        String titling = _user_ad[oldIndex].title;
        _user_ad.removeAt(oldIndex);
        _user_ad.insert(newIndex, SpaceList(title: titling));
        //data를 즉각적으로 수정하여 firestore에 저장하는 로직
        createData(name, _user_ad, _list_ad);
      }
    });
  }

  ChoiceSpace(double height, BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('더 많은 스페이스를 원하신다면?',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SpaceEventAD()
        ],
      ),
    );
  }

  SpaceEventAD() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [SpaceAD()],
    );
  }

  createData(String name, List<SpaceList> list, List<SpaceList> list_ad) {
    if (list.isEmpty) {
      for (int i = 0; i < 5; i++) {
        list.insert(i, SpaceList(title: list_ad[i].title));
        firestore
            .collection('UserSpaceDataBase')
            .doc(name)
            .set({'$i': list[i].title}, SetOptions(merge: true));
      }
    } else {
      for (int i = 0; i < 5; i++) {
        firestore
            .collection('UserSpaceDataBase')
            .doc(name)
            .set({'$i': list[i].title}, SetOptions(merge: true));
      }
    }
  }
}
