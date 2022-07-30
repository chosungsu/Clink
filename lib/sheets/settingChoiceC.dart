import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Tool/TextSize.dart';

SheetPageC(BuildContext context, TextEditingController controller,
    FocusNode searchNode, doc, doc_type, doc_color) {
  return SizedBox(
      height: 280,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  width: MediaQuery.of(context).size.width - 70,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                      Container(
                          width: (MediaQuery.of(context).size.width - 70) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 70) * 0.4,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, searchNode, controller, doc, doc_type, doc_color)
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

content(BuildContext context, FocusNode searchNode,
    TextEditingController controller, doc, doc_type, doc_color) {
  String username = Hive.box('user_info').get(
    'id',
  );
  Color _color = doc_color == null
      ? Colors.blue
      : Color(doc_color);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List updateid = [];
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Text('제목 수정하기',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize())),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                focusNode: searchNode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: '카드 제목을 입력하세요',
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
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                      height: 30,
                      child: Text('일정표 카드 배경색',
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
                                  title: const Text('선택'),
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
                                      child: const Text('반영하기'),
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
              height: 10,
            ),
            SizedBox(
                height: 30,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            firestore
                                .collection('CalendarSheetHome')
                                .doc(doc)
                                .delete();
                            Navigator.pop(context);
                          });
                        },
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '삭제',
                                  style: const NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: Colors.red,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              firestore
                                  .collection('CalendarSheetHome')
                                  .doc(doc)
                                  .update({
                                'calname': controller.text,
                                'madeUser': username,
                                'type': doc_type,
                                'color': doc_color,
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '변경',
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
                    )
                  ],
                )),
          ],
        ));
  });
}
