import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';

import '../Tool/SheetGetx/onequeform.dart';

SheetPageAC(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  DateTime date,
  String s,
) {
  Color _color = Hive.box('user_setting').get('typecolorcalendar') == null
      ? Colors.blue
      : Color(Hive.box('user_setting').get('typecolorcalendar'));
  return SizedBox(
      height: 420,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context, controller),
              const SizedBox(
                height: 20,
              ),
              content(
                  context, searchNode, controller, username, _color, date, s)
            ],
          )));
}

title(
  BuildContext context,
  TextEditingController controller,
) {
  return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text('????????????',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ],
      ));
}

content(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  Color _color,
  DateTime date,
  String s,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int changetype = 0;
  final List types = [
    '??????',
    '??????',
    '??????',
  ];
  final cntget = Get.put(onequeform());
  cntget.setcnt();
  //cntget.setresetcnt();
  int cnt = cntget.cnt;
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text('?????? ??????',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                const SizedBox(
                  width: 20,
                ),
                const Text('????????????',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            maxLines: 2,
            focusNode: searchNode,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintMaxLines: 2,
              hintText: '?????? ????????? ???????????????',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45),
              isCollapsed: true,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 30,
          child: Text('?????? ???????????? ??????',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        const SizedBox(
          height: 20,
        ),
        s == 'home'
            ? SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            changetype--;
                          });
                        },
                        child: changetype == 0
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                              )
                            : Container(
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
                                      color: Colors.black,
                                      lightSource: LightSource.topLeft),
                                ),
                              )),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              primary: Colors.grey.shade400,
                              side: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              )),
                          onPressed: () {},
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    types[changetype],
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
                                )
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            changetype++;
                          });
                        },
                        child: changetype == 2
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                child: NeumorphicIcon(
                                  Icons.keyboard_arrow_right,
                                  size: 30,
                                  style: const NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      surfaceIntensity: 0.5,
                                      color: Colors.black,
                                      lightSource: LightSource.topLeft),
                                ),
                              )),
                  ],
                ),
              )
            : (s == 'cal'
                ? SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  primary: Colors.grey.shade400,
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.black45,
                                  )),
                              onPressed: () {},
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: NeumorphicText(
                                        types[0],
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
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                : (s == 'memo'
                    ? SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Colors.grey.shade400,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {},
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            types[1],
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
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Colors.grey.shade400,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {},
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            types[2],
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
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ))),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 30,
          width: MediaQuery.of(context).size.width - 40,
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: SizedBox(
                  height: 30,
                  child: Text('?????? ?????????',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
              ),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('??????'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: _color,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      _color = color;
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('????????????'),
                                  onPressed: () {
                                    Hive.box('user_setting').put(
                                        'typecolorcalendar',
                                        _color.value.toInt());
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: _color,
                      )))
            ],
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
                primary: Colors.blue,
              ),
              onPressed: () {
                if (controller.text.isEmpty) {
                  Flushbar(
                    backgroundColor: Colors.red.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('??????????????? ?????????????????????.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    icon: const Icon(
                      Icons.info_outline,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    duration: const Duration(seconds: 1),
                    leftBarIndicatorColor: Colors.red.shade100,
                  ).show(context);
                } else {
                  setState(() {
                    Flushbar(
                      backgroundColor: Colors.green.shade400,
                      titleText: Text('Notice',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: contentTitleTextsize(),
                            fontWeight: FontWeight.bold,
                          )),
                      messageText: Text('????????? ??????????????????~',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: contentTextsize(),
                            fontWeight: FontWeight.bold,
                          )),
                      icon: const Icon(
                        Icons.info_outline,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      duration: const Duration(seconds: 1),
                      leftBarIndicatorColor: Colors.green.shade100,
                    ).show(context);
                    types[changetype].toString() == '??????'
                        ? firestore.collection('CalendarSheetHome').add({
                            'calname': controller.text,
                            'madeUser': username,
                            'type': changetype,
                            'share': [],
                            'color': Hive.box('user_setting')
                                .get('typecolorcalendar'),
                            'date': date.toString().split('-')[0] +
                                '-' +
                                date.toString().split('-')[1] +
                                '-' +
                                date.toString().split('-')[2].substring(0, 2) +
                                '???'
                          })
                        : (types[changetype].toString() == '??????'
                            ? firestore.collection('MemoSheetHome').add({
                                'memoname': controller.text,
                                'madeUser': username,
                                'type': changetype,
                                'share': [],
                                'color': Hive.box('user_setting')
                                    .get('typecolorcalendar'),
                                'date': date.toString().split('-')[0] +
                                    '-' +
                                    date.toString().split('-')[1] +
                                    '-' +
                                    date
                                        .toString()
                                        .split('-')[2]
                                        .substring(0, 2) +
                                    '???'
                              })
                            : firestore.collection('RoutineSheetHome').add({
                                'routinename': controller.text,
                                'madeUser': username,
                                'type': changetype,
                                'share': [],
                                'color': Hive.box('user_setting')
                                    .get('typecolorcalendar'),
                                'date': date.toString().split('-')[0] +
                                    '-' +
                                    date.toString().split('-')[1] +
                                    '-' +
                                    date
                                        .toString()
                                        .split('-')[2]
                                        .substring(0, 2) +
                                    '???'
                              }));
                  });

                  Flushbar(
                    backgroundColor: Colors.blue.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('??????????????? ?????????????????????.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    icon: const Icon(
                      Icons.info_outline,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    duration: const Duration(seconds: 2),
                    leftBarIndicatorColor: Colors.blue.shade100,
                  ).show(context).whenComplete(() {
                    if (s == 'home') {
                      setState(() {
                        cntget.minuscnt();
                        cnt = cntget.cnt;
                      });
                    }
                    Get.back();
                  });
                }
              },
              child: s != 'home'
                  ? Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '????????????',
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
                    )
                  : Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '????????????',
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
                          SizedBox(
                            width: 20,
                          ),
                          NeumorphicText(
                            '(???????????? : ' + cnt.toString() + '/5)',
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
                        ],
                      ),
                    )),
        ),
      ],
    );
  });
}
