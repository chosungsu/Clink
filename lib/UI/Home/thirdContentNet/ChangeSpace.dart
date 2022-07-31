import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/Dialogs/howchangespace.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/SpaceAD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/Spacesetting.dart';

class ChangeSpace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeSpaceState();
}

class _ChangeSpaceState extends State<ChangeSpace> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final spaceset = Get.put(Spacesetting());
  List list_space = [];
  String name = Hive.box('user_info').get('id');
  final List<SpaceList> _default_ad = [
    SpaceList(title: '일정공간'),
    SpaceList(title: '메모공간'),
    SpaceList(title: '루틴공간'),
  ];
  List<SpaceList> _user_ad = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: EnterMySpace(),
    ));
  }

  EnterMySpace() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
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
                                //Navigator.pop(context);
                                Get.back();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              child: NeumorphicIcon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: TextColor(),
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
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            surfaceIntensity: 0.5,
                                            depth: 2,
                                            color: TextColor(),
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
                              const SizedBox(
                                height: 20,
                              ),
                              MySpace(height, context),
                              const SizedBox(
                                height: 20,
                              ),
                              ADSpace(height, context),
                              const SizedBox(
                                height: 20,
                              ),
                              ChoiceSpace(height, context),
                              const SizedBox(
                                height: 50,
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
      height: 70 * 3 + 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('나의 현재 스페이스',
                  style: TextStyle(
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize())),
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
    return FutureBuilder(
        future: firestore
            .collection("UserSpaceDataBase")
            .doc(name)
            .get()
            .then((value) {
          _user_ad.clear();
          value.data()!.forEach((key, value) {
            if (value != name) {
              _user_ad.addAll([SpaceList(title: value)]);
            }
          });
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
                height: 70 * _user_ad.length.toDouble(),
                child: ReorderableListView(
                    children: getItems(),
                    onReorder: (oldIndex, newIndex) {
                      onreorder(oldIndex, newIndex);
                    }));
          } else {
            return SizedBox(
                height: 70 * _default_ad.length.toDouble(),
                child: ReorderableListView(
                    children: getItems(),
                    onReorder: (oldIndex, newIndex) {
                      onreorder(oldIndex, newIndex);
                    }));
          }
        });
  }

  List<ListTile> getItems() => _user_ad.isEmpty
      ? _default_ad
          .asMap()
          .map((index, item) =>
              MapEntry(index, buildListTile(item.title, index)))
          .values
          .toList()
      : _user_ad
          .asMap()
          .map((index, item) =>
              MapEntry(index, buildListTile(item.title, index)))
          .values
          .toList();
  ListTile buildListTile(String item, int index) => ListTile(
      key: ValueKey(item + '-' + index.toString()),
      title: Text(item,
          style: TextStyle(
              color: TextColor(),
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize())),
      trailing: index < 3
          ? Icon(
              Icons.menu,
              color: TextColor(),
              size: contentTitleTextsize(),
            )
          : Icon(
              Icons.lock,
              color: TextColor(),
              size: contentTitleTextsize(),
            ));
  onreorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      if (_user_ad.isEmpty) {
        String titling = _default_ad[oldIndex].title;
        _default_ad.removeAt(oldIndex);
        _default_ad.insert(newIndex, SpaceList(title: titling));
        _default_ad
            .asMap()
            .map((index, item) =>
                MapEntry(index, buildListTile(item.title, index)))
            .values
            .toList();
        //data를 즉각적으로 수정하여 firestore에 저장하는 로직
        createData(name, _default_ad, _default_ad.length);
      } else {
        String titling = _user_ad[oldIndex].title;
        _user_ad.removeAt(oldIndex);
        _user_ad.insert(newIndex, SpaceList(title: titling));
        _user_ad
            .asMap()
            .map((index, item) =>
                MapEntry(index, buildListTile(item.title, index)))
            .values
            .toList();
        //data를 즉각적으로 수정하여 firestore에 저장하는 로직
        createData(name, _user_ad, _user_ad.length);
      }
    });
  }

  createData(String name, List<SpaceList> list, int length) {
    for (int i = 0; i < length; i++) {
      firestore
          .collection('UserSpaceDataBase')
          .doc(name)
          .set({
            '$i': list[i].title,
            'name' : name
          }, SetOptions(merge: true));
      list_space.insert(i, list[i].title);
    }
    Hive.box('user_setting').put('space_name', list_space);
    setState(() {
      spaceset.setspace();
    });
  }

  ADSpace(double height, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  ChoiceSpace(double height, BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('더 많은 스페이스를 원하신다면?',
                  style: TextStyle(
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize())),
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
}
