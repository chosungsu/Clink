import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/onequeform.dart';
import '../route.dart';

addWhole(
    BuildContext context,
    FocusNode searchNode,
    TextEditingController controller,
    String username,
    DateTime date,
    String s) {
  Get.bottomSheet(
          Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  //height: s == 'home' ? 440 : 340,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: GestureDetector(
                      onTap: () {
                        searchNode.unfocus();
                      },
                      child: SheetPageAC(
                          context, searchNode, controller, username, date, s)),
                ),
              )),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    final draw = Get.put(navibool());
    draw.setclose();
    controller.clear();
    final cntget = Get.put(onequeform());
    cntget.setcnt();
    if (s == 'home') {
      Hive.box('user_setting').get('page_index') == 0
          ? Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const MyHomePage(
                  index: 0,
                ),
              ),
            )
          : Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const MyHomePage(
                  index: 2,
                ),
              ),
            );
    }
  });
}

SheetPageAC(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  DateTime date,
  String s,
) {
  List choicelist = List.filled(2, 0, growable: true);
  Color _color = Hive.box('user_setting').get('typecolorcalendar') == null
      ? Colors.blue
      : Color(Hive.box('user_setting').get('typecolorcalendar'));
  return SizedBox(
      //height: s == 'home' ? 420 : 320,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              title(context, controller),
              const SizedBox(
                height: 20,
              ),
              content(context, searchNode, controller, username, _color, date,
                  s, choicelist),
              const SizedBox(
                height: 20,
              ),
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
          Text('추가하기',
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
  List choicelist,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  /*int changetype = 0;
  final List types = [
    '캘린더',
    '메모',
  ];*/

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text('제목',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                const SizedBox(
                  width: 20,
                ),
                const Text('필수항목',
                    style: TextStyle(
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
              hintText: '제목 입력...',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45),
              isCollapsed: true,
            ),
          ),
        ),
        s == 'home'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Text('카테고리를 선택하세요',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text('필수항목',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 40,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        childAspectRatio: 2 / 1,
                        children: List.generate(2, (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              index == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (choicelist[0] == 1) {
                                            choicelist.clear();
                                            choicelist.add(0);
                                            choicelist.add(0);
                                          } else {
                                            choicelist.clear();
                                            choicelist.add(1);
                                            choicelist.add(0);
                                          }
                                        });
                                      },
                                      child: choicelist[0] == 0
                                          ? SizedBox(
                                              height: 55,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 25,
                                                      height: 25,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.calendar_month,
                                                          size: 25,
                                                          style: const NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              color:
                                                                  Colors.black,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text('캘린더',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 55,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 25,
                                                      height: 25,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.check,
                                                          size: 25,
                                                          style: NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              color: Colors.blue
                                                                  .shade300,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text('캘린더',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (choicelist[1] == 1) {
                                            choicelist.clear();
                                            choicelist.add(0);
                                            choicelist.add(0);
                                          } else {
                                            choicelist.clear();
                                            choicelist.add(0);
                                            choicelist.add(1);
                                          }
                                        });
                                      },
                                      child: choicelist[1] == 0
                                          ? SizedBox(
                                              height: 55,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 25,
                                                      height: 25,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.description,
                                                          size: 25,
                                                          style: const NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              color:
                                                                  Colors.black,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text('일상메모',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 55,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      width: 25,
                                                      height: 25,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.check,
                                                          size: 25,
                                                          style: NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              color: Colors.blue
                                                                  .shade300,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: Center(
                                                      child: Text('일상메모',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    )
                            ],
                          );
                        }),
                      ))
                ],
              )
            : const SizedBox(
                height: 0,
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
                  child: Text('카드 배경색',
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
                          builder: (context) {
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
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.red.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('카드제목은 필수사항입니다.',
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
                } else if (choicelist[0] == 0 &&
                    choicelist[1] == 0 &&
                    s == 'home') {
                  Flushbar(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.red.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('카테고리는 필수 선택사항입니다.',
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
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.green.shade400,
                      titleText: Text('Notice',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: contentTitleTextsize(),
                            fontWeight: FontWeight.bold,
                          )),
                      messageText: Text('잠시만 기다려주세요~',
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
                    if (s == 'home') {
                      choicelist[0] == 1
                          ? firestore.collection('CalendarSheetHome').add({
                              'calname': controller.text,
                              'madeUser': username,
                              'type': 0,
                              'share': [],
                              'viewsetting': 0,
                              'themesetting': 0,
                              'color': Hive.box('user_setting')
                                      .get('typecolorcalendar') ??
                                  _color.value.toInt(),
                              'date': date.toString().split('-')[0] +
                                  '-' +
                                  date.toString().split('-')[1] +
                                  '-' +
                                  date
                                      .toString()
                                      .split('-')[2]
                                      .substring(0, 2) +
                                  '일'
                            })
                          : firestore.collection('MemoDataBase').doc().set({
                              'Collection': null,
                              'memoindex': null,
                              'memolist': null,
                              'homesave': false,
                              'EditDate': date.toString().split('-')[0] +
                                  '-' +
                                  date.toString().split('-')[1] +
                                  '-' +
                                  date
                                      .toString()
                                      .split('-')[2]
                                      .substring(0, 2) +
                                  '일',
                              'memoTitle': controller.text,
                              'OriginalUser': username,
                              'color': Hive.box('user_setting')
                                      .get('typecolorcalendar') ??
                                  _color.value.toInt(),
                              'Date': date.toString().split('-')[0] +
                                  '-' +
                                  date.toString().split('-')[1] +
                                  '-' +
                                  date
                                      .toString()
                                      .split('-')[2]
                                      .substring(0, 2) +
                                  '일'
                            });
                    } else {
                      firestore.collection('CalendarSheetHome').add({
                        'calname': controller.text,
                        'madeUser': username,
                        'type': 0,
                        'share': [],
                        'viewsetting': 0,
                        'themesetting': 0,
                        'color':
                            Hive.box('user_setting').get('typecolorcalendar') ??
                                _color.value.toInt(),
                        'date': date.toString().split('-')[0] +
                            '-' +
                            date.toString().split('-')[1] +
                            '-' +
                            date.toString().split('-')[2].substring(0, 2) +
                            '일'
                      });
                    }
                  });

                  Flushbar(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.blue.shade400,
                    titleText: Text('Notice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentTitleTextsize(),
                          fontWeight: FontWeight.bold,
                        )),
                    messageText: Text('정상적으로 추가되었습니다.',
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
                    //전면광고띄우기
                    Get.back();
                  });
                }
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '생성하기',
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
