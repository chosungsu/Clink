import 'dart:io';

import 'package:clickbyme/Tool/Getx/selectcollection.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/TextSize.dart';

MFHolderfirst(List<bool> checkbottoms, List<FocusNode> nodes,
    selectcollection scollection) {
  return StatefulBuilder(builder: ((context, setState) {
    return Row(
      children: [
        FocusedMenuHolder(
            child: NeumorphicIcon(
              Icons.post_add,
              size: 30,
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 2,
                  surfaceIntensity: 0.5,
                  color: checkbottoms[0] == false
                      ? NaviColor(false)
                      : NaviColor(true),
                  lightSource: LightSource.topLeft),
            ),
            onPressed: () {
              for (int i = 0; i < nodes.length; i++) {
                nodes[i].unfocus();
              }
            },
            duration: const Duration(seconds: 0),
            animateMenuItems: true,
            menuOffset: 20,
            menuBoxDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(40.0))),
            bottomOffsetHeight: 10,
            menuWidth: 60,
            openWithTap: true,
            menuItems: [
              FocusedMenuItem(
                  trailingIcon: const Icon(
                    Icons.post_add,
                    size: 30,
                  ),
                  title: Text('',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                  onPressed: () {
                    setState(() {
                      checkbottoms[0] == false
                          ? checkbottoms[0] = true
                          : checkbottoms[0] = false;
                      if (checkbottoms[0] == true) {
                        Hive.box('user_setting').put('optionmemoinput', 0);
                        Hive.box('user_setting')
                            .put('optionmemocontentinput', null);
                        scollection.addmemolistin(scollection.memoindex);
                        scollection
                            .addmemolistcontentin(scollection.memoindex - 1);

                        checkbottoms[0] = false;
                      }
                      for (int i = 0; i < nodes.length; i++) {
                        nodes[i].unfocus();
                      }
                    });
                  }),
              FocusedMenuItem(
                  trailingIcon: const Icon(
                    Icons.check_box_outline_blank,
                    size: 30,
                  ),
                  title: Text('',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                  onPressed: () {
                    setState(() {
                      checkbottoms[1] == false
                          ? checkbottoms[1] = true
                          : checkbottoms[1] = false;
                      if (checkbottoms[1] == true) {
                        Hive.box('user_setting').put('optionmemoinput', 1);
                        Hive.box('user_setting')
                            .put('optionmemocontentinput', null);
                        scollection.addmemolistin(scollection.memoindex);
                        scollection
                            .addmemolistcontentin(scollection.memoindex - 1);
                        checkbottoms[1] = false;
                      }
                      for (int i = 0; i < nodes.length; i++) {
                        nodes[i].unfocus();
                      }
                    });
                  }),
              FocusedMenuItem(
                  trailingIcon: const Icon(
                    Icons.star_rate,
                    size: 30,
                  ),
                  title: Text('',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                  onPressed: () {
                    setState(() {
                      checkbottoms[2] == false
                          ? checkbottoms[2] = true
                          : checkbottoms[2] = false;
                      if (checkbottoms[2] == true) {
                        Hive.box('user_setting').put('optionmemoinput', 2);
                        Hive.box('user_setting')
                            .put('optionmemocontentinput', null);
                        scollection.addmemolistin(scollection.memoindex);
                        scollection
                            .addmemolistcontentin(scollection.memoindex - 1);
                        checkbottoms[2] = false;
                      }
                      for (int i = 0; i < nodes.length; i++) {
                        nodes[i].unfocus();
                      }
                    });
                  })
            ]),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }));
}

MFsecond(
  List<FocusNode> nodes,
  Color _color,
) {
  final controll_memo = Get.put(memosetting());
  return StatefulBuilder(builder: ((context, setState) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: TextColor()),
            shape: BoxShape.circle),
        child: CircleAvatar(
          backgroundColor:
              _color == controll_memo.color ? _color : controll_memo.color,
        ),
      ),
      iconSize: 30,
      alignment: Alignment.center,
      onPressed: () {
        for (int i = 0; i < nodes.length; i++) {
          nodes[i].unfocus();
        }
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('선택'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: _color,
                    onColorChanged: (Color color) {
                      setState(() {
                        Hive.box('user_setting')
                            .put('coloreachmemo', color.value.toInt());
                        controll_memo.setcolor();
                        _color = controll_memo.color;
                      });
                    },
                  ),
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
      },
    );
  }));
}

MFthird(
  List<FocusNode> nodes,
  Color _color,
) {
  List _image = [];
  final imagePicker = ImagePicker();
  final controll_memo = Get.put(memosetting());
  return StatefulBuilder(builder: ((context, setState) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        icon: NeumorphicIcon(
          Icons.camera,
          size: 25,
          style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              depth: 2,
              surfaceIntensity: 0.5,
              color: NaviColor(false),
              lightSource: LightSource.topLeft),
        ),
        iconSize: 30,
        onPressed: () {
          for (int i = 0; i < nodes.length; i++) {
            nodes[i].unfocus();
          }
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('선택'),
                  content: SingleChildScrollView(
                      child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final image = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            controll_memo.setimagelist(image!.path);
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
                          final image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            controll_memo.setimagelist(image!.path);
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
            );
          });
        },
      ),
    );
  }));
}

MFforth(bool ischeckedtohideminus) {
  final controll_memo = Get.put(memosetting());
  return StatefulBuilder(builder: ((context, setState) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          if (ischeckedtohideminus) {
            ischeckedtohideminus = false;
            controll_memo.sethideminus(ischeckedtohideminus);
          } else {
            ischeckedtohideminus = true;
            controll_memo.sethideminus(ischeckedtohideminus);
          }
        });
      },
      icon: const Icon(
        Icons.remove_circle_outline,
        size: 30,
      ),
      label: Text(controll_memo.ischeckedtohideminus == true ? 'on' : 'hide',
          style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize())),
    );
  }));
}
