// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:clickbyme/Tool/Getx/category.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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

linkmadeplace(
  BuildContext context,
  int type,
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
                child: place(context, type),
              )),
        );
      }).whenComplete(() {
    final linkspaceset = Get.put(linkspacesetting());
    linkspaceset.indextreetmp.add(List.empty(growable: true));
  });
}

place(BuildContext context, int type) {
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
              titlesecond(context),
              const SizedBox(
                height: 20,
              ),
              contentsecond(context, type),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titlesecond(
  BuildContext context,
) {
  return SizedBox(
      child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: const [
      Text('선택',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    ],
  ));
}

contentsecond(BuildContext context, int type) {
  final linkspaceset = Get.put(linkspacesetting());
  final List listin1 = ['링크', '이미지 및 파일'];
  final List listin3 = ['링크', '이미지 및 파일'];
  final List listin4 = ['링크', '이미지 및 파일'];
  final List<Linkspacepage> listspacepageset = [];
  var id;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        //itemCount: listdata.length,
        itemBuilder: ((context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {},
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
                                Text('보드형 플레이스',
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
              ),
            ],
          );
        }));
  });
}

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
              var changeindex;
              if (s == 'pinchannel') {
                await firestore.collection('PageView').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('spacename') == placestr &&
                        value.docs[i].get('id') == uniquecode &&
                        value.docs[i].get('type') == type) {
                      id = value.docs[i].id;
                      changeindex = value.docs[i].get('index');
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
                  }).whenComplete(() async {
                    updateid.clear();
                    updateindex.clear();
                    await firestore.collection('PageView').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('index') > changeindex) {
                          updateid.add(value.docs[i].id);
                          updateindex.add(value.docs[i].get('index'));
                        }
                      }
                      if (updateid.isEmpty) {
                      } else {
                        for (int j = 0; j < updateid.length; j++) {
                          firestore
                              .collection('PageView')
                              .doc(updateid[j])
                              .update({'index': updateindex[j] - 1});
                        }
                      }
                    });
                    linkspaceset.setcompleted(false);
                  });
                });
              } else {
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('addname') == placestr &&
                        value.docs[i].get('uniquecode') == uniquecode &&
                        value.docs[i].get('index') == index) {
                      id = value.docs[i].id;
                      changeindex = value.docs[i].get('index');
                    }
                  }
                  firestore.collection('Pinchannelin').doc(id).delete();
                }).whenComplete(() async {
                  updateid.clear();
                  updateindex.clear();
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('uniquecode') == uniquecode &&
                          value.docs[i].get('index') > changeindex) {
                        updateid.add(value.docs[i].id);
                        updateindex.add(value.docs[i].get('index'));
                      }
                    }
                    if (updateid.isEmpty) {
                    } else {
                      for (int j = 0; j < updateid.length; j++) {
                        firestore
                            .collection('Pinchannelin')
                            .doc(updateid[j])
                            .update({'index': updateindex[j] - 1});
                      }
                    }
                  }).whenComplete(() async {
                    linkspaceset.setcompleted(false);
                  });
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

linkplaceshowaddaction(
  BuildContext context,
  String mainid,
) {
  Get.bottomSheet(
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: GetBuilder<linkspacesetting>(
                      builder: (_) => SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: addaction(context, mainid)))
                  /*StatefulBuilder(
                      builder: ((context, setState) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: addaction(context, mainid),
                        );
                      }),
                    )*/
                  ),
            ),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    final linkspaceset = Get.put(linkspacesetting());
    linkspaceset.resetsearchfile();
  });
}

addaction(
  BuildContext context,
  String mainid,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
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
              contentaddaction(context, mainid),
              linkspaceset.selectedfile!.isEmpty
                  ? const SizedBox()
                  : bottomaddaction(
                      context, linkspaceset.selectedfile!.length, mainid),
              const SizedBox(
                height: 50,
              ),
            ],
          )));
}

contentaddaction(
  BuildContext context,
  String mainid,
) {
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linkspacepage> listspacepageset = [];
  var id;
  FilePickerResult? res;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return GetBuilder<linkspacesetting>(
        builder: (_) => Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (linkspaceset.selectedfile!.isEmpty) {
                      linkspaceset.resetsearchfile();
                    } else {}
                    res = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        onFileLoading: (status) {
                          if (status == FilePickerStatus.done) {
                            linkspaceset.setcompleted(false);
                          } else {
                            linkspaceset.setcompleted(true);
                          }
                        },
                        lockParentWindow: true);
                    searchfiles(context, mainid, res);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Colors.blue.shade400,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50.withOpacity(.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.folder_open,
                                color: Colors.blue,
                                size: 30,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Select your file',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                linkspaceset.selectedfile!.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    'Selected File',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 15,
                                    ),
                                  )),
                              Text(
                                linkspaceset.selectedfile!.length.toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: linkspaceset.selectedfile!.length,
                              itemBuilder: ((context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: const Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 2,
                                              )
                                            ]),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    linkspaceset.selectedfile![
                                                        index]['name'],
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${(linkspaceset.selectedfile![index]['size'] / 1024).ceil()} KB',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                linkspaceset
                                                    .removesearchfile(index);
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                );
                              })),
                          const SizedBox(
                            height: 20,
                          ),
                          // MaterialButton(
                          //   minWidth: double.infinity,
                          //   height: 45,
                          //   onPressed: () {},
                          //   color: Colors.black,
                          //   child: Text('Upload', style: TextStyle(color: Colors.white),),
                          // )
                        ],
                      )
                    : Container(),
              ],
            ));
  });
}

bottomaddaction(BuildContext context, int numberfileslen, String mainid) {
  return Column(
    children: [
      const SizedBox(
        height: 50,
      ),
      SizedBox(
        height: 60,
        child: OutlineGradientButton(
          child: SizedBox(
              width: 80.w,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(numberfileslen.toString() + '개의 파일 업로드 시작',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                ),
              )),
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          strokeWidth: 2,
          backgroundColor: Colors.blue.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          radius: const Radius.circular(10),
          onTap: () {
            uploadfiles(mainid);
          },
        ),
      ),
    ],
  );
}

linkplaceshowbeforeadd(
  BuildContext context,
  String name,
  String? path,
  String mainid,
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
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              )),
                          child: treeplace(context, name, path, mainid),
                        );
                      }),
                    ))),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {});
}

treeplace(
  BuildContext context,
  String name,
  String? path,
  String mainid,
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
              titlefifth(context),
              const SizedBox(
                height: 20,
              ),
              contentfifth(context, name, path, mainid),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titlefifth(
  BuildContext context,
) {
  return SizedBox(
      child: Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: const [
      Text('업로드',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    ],
  ));
}

contentfifth(
  BuildContext context,
  String name,
  String? path,
  String mainid,
) {
  final linkspaceset = Get.put(linkspacesetting());
  final List<Linkspacepage> listspacepageset = [];
  var id;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            //uploadfiles(path, mainid);
          },
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  name,
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize()),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
      ],
    );
  });
}
