// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:math';

import 'package:clickbyme/Tool/Getx/category.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/Linkpage.dart';
import '../Enums/Variables.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/BGColor.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/TextSize.dart';
import '../UI/Home/firstContentNet/HomeView.dart';
import '../mongoDB/mongodatabase.dart';

linksetting(
  BuildContext context,
  String name,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: setting(context, name),
              )),
        );
      }).whenComplete(() {});
}

setting(
  BuildContext context,
  String name,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
                name,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

content(
  BuildContext context,
  String name,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String usercode = Hive.box('user_setting').get('usercode');
  final linkspaceset = Get.put(linkspacesetting());
  final peopleadd = Get.put(PeopleAdd());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text('선택',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                  content: Builder(
                    builder: (context) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: SingleChildScrollView(
                              child: BlockPicker(
                            availableColors: [
                              Colors.red,
                              Colors.pink,
                              Colors.deepOrangeAccent,
                              Colors.yellowAccent,
                              Colors.green,
                              Colors.lightGreen,
                              Colors.lightGreenAccent,
                              Colors.greenAccent.shade200,
                              Colors.indigo,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.lightBlueAccent,
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.blueGrey.shade300,
                              Colors.grey,
                              Colors.amber,
                              Colors.brown,
                              Colors.white,
                              Colors.black,
                            ],
                            itemBuilder: ((color, isCurrentColor, changeColor) {
                              return GestureDetector(
                                onTap: () async {
                                  changeColor();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
                                  child: isCurrentColor
                                      ? CircleAvatar(
                                          backgroundColor: color,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: color != Colors.black
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: color,
                                        ),
                                ),
                              );
                            }),
                            onColorChanged: (Color color) async {
                              setState(() {
                                Hive.box('user_setting')
                                    .put('colorlinkpage', color.value.toInt());
                              });
                              linkspaceset.setcolor();
                              StatusBarControl.setColor(linkspaceset.color,
                                  animated: true);
                            },
                            pickerColor: linkspacesetting().color,
                          )));
                    },
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('반영하기'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        var id;
                        await MongoDB.delete(
                            collectionname: 'pinchannel',
                            deletelist: {
                              'username': usercode,
                              'linkname': name,
                            });
                        await MongoDB.add(
                            collectionname: 'pinchannel',
                            addlist: {
                              'username': usercode,
                              'linkname': name,
                              'color': linkspacesetting().color.value.toInt()
                            });
                        await firestore
                            .collection('Pinchannel')
                            .get()
                            .then((value) {
                          for (int i = 0; i < value.docs.length; i++) {
                            if (value.docs[i].get('linkname') == name) {
                              if (value.docs[i].get('username') == usercode) {
                                id = value.docs[i].id;
                              }
                            }
                          }
                          firestore.collection('Pinchannel').doc(id).update({
                            'color': linkspacesetting().color.value.toInt()
                          });
                        });
                      },
                    ),
                  ],
                );
              },
            ).whenComplete(() {
              Get.back();
            });
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.palette,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('배경색 설정',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            Get.to(() => HomeView(where: 'MY', link: name),
                transition: Transition.zoom);
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.view_timeline,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('뷰 순서 변경',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.share,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('공유인원 설정',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    );
  });
}

/*linkmadeplace(
  BuildContext context,
  String name,
  String link,
  String s,
  int index,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: place(context, name, link, s, index),
              )),
        );
      }).whenComplete(() {
    final linkspaceset = Get.put(linkspacesetting());
    linkspaceset.indextreetmp.add(List.empty(growable: true));
  });
}

place(
  BuildContext context,
  String name,
  String link,
  String s,
  int index,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              titlesecond(context, s),
              const SizedBox(
                height: 20,
              ),
              contentsecond(
                context,
                name,
                link,
                s,
                index,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titlesecond(
  BuildContext context,
  String s,
) {
  return SizedBox(
      child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(s == 'add' ? '생성하기' : '무엇으로 변경할까요?',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    ],
  ));
}

contentsecond(
  BuildContext context,
  String name,
  String link,
  String s,
  int index,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String usercode = Hive.box('user_setting').get('usercode');
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linkspacepage> listspacepageset = [];
  var id;
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random rnd = Random();
  String code = '';

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            code = String.fromCharCodes(Iterable.generate(
                5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
            if (s == 'add') {
              await MongoDB.add(collectionname: 'pinchannelin', addlist: {
                'username': usercode,
                'linkname': link,
                'placestr': 'board',
                'index': linkspaceset.indexcnt.length,
                'uniquecode': code
              });
              await firestore.collection('Pinchannelin').add({
                'username': usercode,
                'linkname': link,
                'placestr': 'board',
                'index': linkspaceset.indexcnt.length,
                'uniquecode': code
              });
              linkspaceset.setspacein(Linkspacepage(
                  type: linkspaceset.indexcnt.length,
                  placestr: 'board',
                  uniquecode: code));
            } else {
              await firestore.collection('Pinchannelin').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('username') == usercode &&
                      value.docs[i].get('linkname') == link &&
                      value.docs[i].get('index') == index) {
                    id = value.docs[i].id;
                  }
                }
                firestore
                    .collection('Pinchannelin')
                    .doc(id)
                    .update({'placestr': 'board'});
              });
              linkspaceset.setspacein(Linkspacepage(
                  type: index, placestr: 'board', uniquecode: code));
            }

            Get.back();
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.table_chart,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s == 'add' ? '보드형 플레이스 추가' : '보드형 플레이스',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            code = String.fromCharCodes(Iterable.generate(
                5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
            if (s == 'add') {
              await MongoDB.add(collectionname: 'pinchannelin', addlist: {
                'username': usercode,
                'linkname': link,
                'placestr': 'card',
                'index': linkspaceset.indexcnt.length,
                'uniquecode': code
              });
              await firestore.collection('Pinchannelin').add({
                'username': usercode,
                'linkname': link,
                'placestr': 'card',
                'index': linkspaceset.indexcnt.length,
                'uniquecode': code
              });
              linkspaceset.setspacein(Linkspacepage(
                  type: linkspaceset.indexcnt.length,
                  placestr: 'card',
                  uniquecode: code));
            } else {
              await firestore.collection('Pinchannelin').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('username') == usercode &&
                      value.docs[i].get('linkname') == link &&
                      value.docs[i].get('index') == index) {
                    id = value.docs[i].id;
                  }
                }
                firestore
                    .collection('Pinchannelin')
                    .doc(id)
                    .update({'placestr': 'card'});
              });
              linkspaceset.setspacein(Linkspacepage(
                  type: index, placestr: 'card', uniquecode: code));
            }

            Get.back();
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.view_stream,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s == 'add' ? '링크형 플레이스 추가' : '링크형 플레이스',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        s == 'add'
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      code = String.fromCharCodes(Iterable.generate(5,
                          (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
                      if (s == 'add') {
                        await MongoDB.add(
                            collectionname: 'pinchannelin',
                            addlist: {
                              'username': usercode,
                              'linkname': link,
                              'placestr': 'calendar',
                              'index': linkspaceset.indexcnt.length,
                              'uniquecode': code
                            });
                        await firestore.collection('Pinchannelin').add({
                          'username': usercode,
                          'linkname': link,
                          'placestr': 'calendar',
                          'index': linkspaceset.indexcnt.length,
                          'uniquecode': code
                        });
                        linkspaceset.setspacein(Linkspacepage(
                            type: linkspaceset.indexcnt.length,
                            placestr: 'calendar',
                            uniquecode: code));
                        linkspaceset.indextreetmp
                            .add(List.empty(growable: true));
                        await MongoDB.add(collectionname: 'linknet', addlist: {
                          'username': name,
                          'addname': '',
                          'placestr': 'calendar',
                          'index': linkspaceset
                              .indextreetmp[linkspaceset.indexcnt.length - 1]
                              .length,
                          'uniquecode': code
                        });
                        await firestore.collection('Linknet').add({
                          'username': name,
                          'addname': '',
                          'placestr': 'calendar',
                          'index': linkspaceset
                              .indextreetmp[linkspaceset.indexcnt.length - 1]
                              .length,
                          'uniquecode': code
                        });
                        linkspaceset.setspacetreein(Linkspacetreepage(
                            subindex: linkspaceset
                                .indextreetmp[linkspaceset.indexcnt.length - 1]
                                .length,
                            placestr: 'calendar',
                            uniqueid: code));
                      } else {
                        await firestore
                            .collection('Pinchannelin')
                            .get()
                            .then((value) {
                          for (int i = 0; i < value.docs.length; i++) {
                            if (value.docs[i].get('username') == usercode &&
                                value.docs[i].get('linkname') == link &&
                                value.docs[i].get('index') == index) {
                              id = value.docs[i].id;
                            }
                          }
                          firestore
                              .collection('Pinchannelin')
                              .doc(id)
                              .update({'placestr': 'calendar'});
                        });
                        linkspaceset.setspacein(Linkspacepage(
                            type: index,
                            placestr: 'calendar',
                            uniquecode: code));
                      }

                      Get.back();
                    },
                    child: Row(
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('캘린더형 플레이스 추가',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTitleTextsize())),
                                  ],
                                ),
                              ],
                            )),
                        Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey.shade400)
                      ],
                    ),
                  )
                ],
              )
            : const SizedBox()
      ],
    );
  });
}*/

linkplacechangeoptions(
  BuildContext context,
  int index,
  String placestr,
  String uniquecode,
  int type,
  TextEditingController controller,
  FocusNode searchNode,
  String s,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: changeoptplace(context, index, placestr, uniquecode,
                    type, controller, searchNode, s),
              )),
        );
      }).whenComplete(() {});
}

changeoptplace(
  BuildContext context,
  int index,
  String placestr,
  String uniquecode,
  int type,
  TextEditingController controller,
  FocusNode searchNode,
  String s,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              contentthird(context, index, placestr, uniquecode, type,
                  controller, searchNode, s),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

contentthird(
  BuildContext context,
  int index,
  String placestr,
  String uniquecode,
  int type,
  TextEditingController controller,
  FocusNode searchNode,
  String s,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final linkspaceset = Get.put(linkspacesetting());
  final cg = Get.put(category());
  final List<Linkspacepage> listspacepageset = [];
  var id;
  var updateid = [];
  var updateindex = [];

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            Get.back();
            controller.text = placestr;
            if (s == 'pinchannel') {
              func6(context, controller, searchNode, 'editnametemplate',
                  uniquecode, type, 0);
            } else {
              func6(context, controller, searchNode, 'editnametemplatein',
                  uniquecode, index, 0);
            }
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이름 변경',
                              style: TextStyle(
                                  color: placestr == 'calendar'
                                      ? Colors.grey.shade300
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              const Icon(
                Icons.edit,
                size: 30,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            //linkspaceset.minusspacein(index);
            final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Text('정말 이 링크를 삭제하시겠습니까?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.blueGrey)),
                      ),
                    );
                  },
                ), pressed2)) ??
                false;
            if (reloadpage) {
              Get.back();
              if (s == 'pinchannel') {
                await firestore.collection('PageView').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('spacename') == placestr &&
                        value.docs[i].get('id') == uniquecode &&
                        value.docs[i].get('type') == type) {
                      id = value.docs[i].id;
                    }
                  }
                  firestore.collection('PageView').doc(id).delete();
                }).whenComplete(() async {
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('uniquecode') == id) {
                        updateid.add(value.docs[i].id);
                      }
                    }
                    if (updateid.isEmpty) {
                    } else {
                      for (int j = 0; j < updateid.length; j++) {
                        firestore
                            .collection('Pinchannelin')
                            .doc(updateid[j])
                            .delete();
                      }
                    }
                  }).whenComplete(() {
                    linkspaceset.setcompleted(false);
                  });

                  //updateid.clear();
                });
              } else {
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('addname') == placestr &&
                        value.docs[i].get('uniquecode') == uniquecode &&
                        value.docs[i].get('index') == index) {
                      id = value.docs[i].id;
                    }
                  }
                  firestore.collection('Pinchannelin').doc(id).delete();
                }).whenComplete(() {
                  linkspaceset.setcompleted(false);
                  //updateid.clear();
                });
              }
            }
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('삭제',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              const Icon(
                Icons.delete,
                size: 30,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  });
}

linkplacenamechange(
  BuildContext context,
  String name,
  String code,
  int index,
  String origintext,
  FocusNode node,
  TextEditingController controller,
  String placestr,
) {
  Get.bottomSheet(
          Container(
            margin: const EdgeInsets.only(
                left: 10, right: 10, bottom: kBottomNavigationBarHeight),
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: StatefulBuilder(
                      builder: ((context, setState) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              node.unfocus();
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            child: changenameplace(context, name, code, index,
                                node, controller, origintext),
                          ),
                        );
                      }),
                    ))),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    /*final linkspaceset = Get.put(linkspacesetting());
    linkspaceset.setspecificspacein(
        index,
        Linkspacetreepage(
            subindex: linkspaceset.indextreecnt.length,
            placestr: placestr,
            uniqueid: code));
    linkspaceset.minusspacein(index + 1);*/
    controller.text == '';
  });
}

changenameplace(
  BuildContext context,
  String name,
  String code,
  int index,
  FocusNode node,
  TextEditingController controller,
  String origintext,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              titleforth(
                context,
              ),
              const SizedBox(
                height: 20,
              ),
              contentforth(
                  context, name, code, index, node, controller, origintext),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titleforth(
  BuildContext context,
) {
  return SizedBox(
      child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: const [
      Text('무엇으로 변경할까요?',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    ],
  ));
}

contentforth(
  BuildContext context,
  String name,
  String code,
  int index,
  FocusNode node,
  TextEditingController controller,
  String origintext,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Linkspacepage> listspacepageset = [];
  bool isloading = false;
  var id;
  var updateid = [];
  var updateindex = [];

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ContainerDesign(
          color: Colors.white,
          child: TextField(
            focusNode: node,
            style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10),
              border: InputBorder.none,
              isCollapsed: true,
              hintText: '변경할 제목입력',
              hintStyle:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black45),
            ),
            controller: controller,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: ButtonColor(),
              ),
              onPressed: () async {
                linkspaceset.setcompleted(true);
                if (controller.text.isEmpty) {
                  Snack.show(
                      context: context,
                      title: '알림',
                      content: '변경할 이름이 비어있어요!',
                      snackType: SnackType.warning,
                      behavior: SnackBarBehavior.floating);
                } else {
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    if (value.docs.isNotEmpty) {
                      for (int j = 0; j < value.docs.length; j++) {
                        final messageuniquecode = value.docs[j]['uniquecode'];
                        final messageindex = value.docs[j]['index'];
                        final messageplacestr = value.docs[j]['addname'];
                        if (messageindex == index &&
                            messageuniquecode == code &&
                            messageplacestr == origintext) {
                          firestore
                              .collection('Pinchannelin')
                              .doc(value.docs[j].id)
                              .update({'addname': controller.text});
                        }
                      }
                    } else {
                      firestore.collection('Pinchannelin').add({
                        'addname': '빈 제목',
                        'placestr': origintext,
                        'index': index,
                        'uniquecode': code
                      });
                    }
                  });
                }
                linkspaceset.setcompleted(false);
                Get.back();
              },
              child: Center(
                child: linkspaceset.iscompleted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '변경중...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: contentTextsize(),
                              fontWeight: FontWeight.bold, // bold
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '변경하기',
                              style: const NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: Colors.white,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                              ),
                            ),
                          ),
                        ],
                      ),
              )),
        ),
      ],
    );
  });
}

linkmadetreeplace(
  BuildContext context,
  String name,
  String link,
  String parentnodename,
  int index,
  String uniquecode,
  int type,
) async {
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linkspacepage> listspacepageset = [];
  var id;
  await firestore.collection('Pinchannelin').add({
    'addname': '빈 제목',
    'placestr': parentnodename,
    'index': index,
    'uniquecode': uniquecode
  });
  linkspaceset.setspacetreein(Linkspacetreepage(
      subindex: index, placestr: '빈 제목', uniqueid: uniquecode));
}

treeplace(
  BuildContext context,
  String name,
  String link,
  String s,
  int index,
  String uniquecode,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              titlefifth(context, s),
              const SizedBox(
                height: 20,
              ),
              contentfifth(context, name, link, s, index, uniquecode),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titlefifth(
  BuildContext context,
  String s,
) {
  return SizedBox(
      child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: const [
      Text('생성하기',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    ],
  ));
}

contentfifth(
  BuildContext context,
  String name,
  String link,
  String s,
  int index,
  String uniquecode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String usercode = Hive.box('user_setting').get('usercode');
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linkspacepage> listspacepageset = [];
  var id;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (s == 'board') {
              await MongoDB.add(collectionname: 'linknet', addlist: {
                'username': usercode,
                'addname': '',
                'placestr': 'board',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              await firestore.collection('Linknet').add({
                'username': usercode,
                'addname': '',
                'placestr': 'board',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              linkspaceset.setspacetreein(Linkspacetreepage(
                  subindex: linkspaceset.indextreecnt.length,
                  placestr: 'board',
                  uniqueid: uniquecode));
            } else if (s == 'card') {
              await MongoDB.add(collectionname: 'linknet', addlist: {
                'username': usercode,
                'addname': '',
                'placestr': 'card',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              await firestore.collection('Linknet').add({
                'username': usercode,
                'addname': '',
                'placestr': 'card',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              linkspaceset.setspacetreein(Linkspacetreepage(
                  subindex: linkspaceset.indextreecnt.length,
                  placestr: 'card',
                  uniqueid: uniquecode));
            } else {
              await MongoDB.add(collectionname: 'linknet', addlist: {
                'username': usercode,
                'addname': '',
                'placestr': 'calendar',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              await firestore.collection('Linknet').add({
                'username': usercode,
                'addname': '',
                'placestr': 'calendar',
                'index': linkspaceset.indextreecnt.length,
                'uniquecode': uniquecode
              });
              linkspaceset.setspacetreein(Linkspacetreepage(
                  subindex: linkspaceset.indextreecnt.length,
                  placestr: 'calendar',
                  uniqueid: uniquecode));
            }

            Get.back();
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이 타입 추가하기',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
      ],
    );
  });
}
