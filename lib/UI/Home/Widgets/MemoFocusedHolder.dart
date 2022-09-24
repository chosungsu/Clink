import 'dart:io';

import 'package:clickbyme/Tool/Getx/selectcollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/showmemocontent.dart';

MFHolder(
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  Color _color,
  String doc,
  bool ischeckedtohideminus,
  List<TextEditingController> controllers,
  Color _colorfont,
) {
  final controll_memo = Get.put(memosetting());
  List _image = [];
  final imagePicker = ImagePicker();
  bool isresponsible = false;
  return StatefulBuilder(builder: ((context, setState) {
    return FocusedMenuHolder(
        child: IconBtn(
            child: Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: NeumorphicIcon(
                Icons.more_vert,
                size: 30,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: Colors.black,
                    lightSource: LightSource.topLeft),
              ),
            ),
            color: Colors.black),
        onPressed: () {},
        duration: const Duration(seconds: 0),
        animateMenuItems: true,
        menuOffset: 20,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        bottomOffsetHeight: 10,
        menuWidth: MediaQuery.of(context).size.width / 2,
        openWithTap: true,
        menuItems: [
          FocusedMenuItem(
              title: Text('메모작성',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  showmemocontent(
                      context, checkbottoms, nodes, scollection, controllers);
                });
              }),
          FocusedMenuItem(
              title: Text('첨부사진추가',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    nodes[i].unfocus();
                  }
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('선택',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize())),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Builder(
                              builder: (context) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final image =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.camera);
                                          setState(() {
                                            controll_memo.setloading(true);
                                            _uploadFile(
                                              context,
                                              File(image!.path),
                                              doc,
                                            );
                                            controll_memo.setloading(false);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text('사진 촬영',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                          leading: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.blue.shade400,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final image =
                                              await imagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {
                                            controll_memo.setloading(true);
                                            _uploadFile(context,
                                                File(image!.path), doc);
                                            controll_memo.setloading(false);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text('갤러리 선택',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                          leading: Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.blue.shade400,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                );
                              },
                            ));
                      },
                    );
                  });
                });
              }),
          FocusedMenuItem(
              title: Text('바탕색상변경',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    nodes[i].unfocus();
                  }
                  setState(() {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: _color,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          Hive.box('user_setting').put(
                                              'coloreachmemo',
                                              color.value.toInt());
                                          controll_memo.setcolor();
                                          _color = controll_memo.color;
                                        });
                                      },
                                    ),
                                  ));
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
                  });
                });
              }),
          FocusedMenuItem(
              title: Text('글자색변경',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    nodes[i].unfocus();
                  }
                  setState(() {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: _colorfont,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          Hive.box('user_setting').put(
                                              'coloreachmemofont',
                                              color.value.toInt());
                                          controll_memo.setcolorfont();
                                          _colorfont = controll_memo.colorfont;
                                        });
                                      },
                                    ),
                                  ));
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
                  });
                });
              }),
          FocusedMenuItem(
              backgroundColor: Colors.red.shade200,
              title: RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red.shade400,
                    ),
                  ),
                  TextSpan(
                    text: controll_memo.ischeckedtohideminus == true
                        ? '아이콘 띄우기'
                        : '아이콘 지우기',
                    style: TextStyle(
                        fontSize: contentTextsize(), color: Colors.black),
                  ),
                ]),
              ),
              onPressed: () {
                setState(() {
                  controll_memo.sethideminus(!ischeckedtohideminus);
                });
              })
        ]);
  }));
}

Future _uploadFile(BuildContext context, File _image, String doc) async {
  final controll_memo = Get.put(memosetting());
  await Permission.photos.request();
  var pstatus = await Permission.photos.status;
  if (pstatus.isGranted) {
    DateTime now = DateTime.now();
    var datestamp = DateFormat("yyyyMMdd'T'HHmmss");
    String currentdate = datestamp.format(now);
    // 스토리지에 업로드할 파일 경로
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child(doc).child('$currentdate.jpg');

    // 파일 업로드
    final uploadTask = firebaseStorageRef.putFile(
        _image, SettableMetadata(contentType: 'image/png'));

    // 완료까지 기다림
    await uploadTask.whenComplete(() {});

    // 업로드 완료 후 url
    final downloadUrl = await firebaseStorageRef.getDownloadURL();
    controll_memo.setimagelist(downloadUrl);

    // 문서 작성
    if (doc != '') {
      await FirebaseFirestore.instance
          .collection('MemoDataBase')
          .doc(doc)
          .update({
        'photoUrl': controll_memo.imagelist,
      });
    } else {}
  }
}
