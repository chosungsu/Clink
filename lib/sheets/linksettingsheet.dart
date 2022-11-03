import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../Tool/TextSize.dart';
import '../mongoDB/mongodatabase.dart';
import 'movetolinkspace.dart';

linksetting(
  BuildContext context,
  String name,
  TextEditingController controller2,
  FocusNode changenamenode,
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
          margin: const EdgeInsets.all(10),
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
                child: setting(context, name, controller2, changenamenode),
              )),
        );
      }).whenComplete(() {});
}

setting(
  BuildContext context,
  String name,
  TextEditingController controller2,
  FocusNode changenamenode,
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
              content(context, name, controller2, changenamenode),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

content(
  BuildContext context,
  String name,
  TextEditingController controller2,
  FocusNode changenamenode,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String usercode = Hive.box('user_setting').get('usercode');
  final linkspaceset = Get.put(linkspacesetting());

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
                              var id;
                              setState(() {
                                Hive.box('user_setting')
                                    .put('colorlinkpage', color.value.toInt());
                              });
                              linkspaceset.setcolor();
                              StatusBarControl.setColor(linkspaceset.color,
                                  animated: true);
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
                                    'color': color.value.toInt()
                                  });
                              await firestore
                                  .collection('Pinchannel')
                                  .get()
                                  .then((value) {
                                for (int i = 0; i < value.docs.length; i++) {
                                  if (value.docs[i].get('linkname') == name) {
                                    if (value.docs[i].get('username') ==
                                        usercode) {
                                      id = value.docs[i].id;
                                    }
                                  }
                                }
                                firestore
                                    .collection('Pinchannel')
                                    .doc(id)
                                    .update({'color': color.value.toInt()});
                              });
                            },
                            pickerColor: linkspacesetting().color,
                          )));
                    },
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('반영하기'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
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
        )
      ],
    );
  });
}
