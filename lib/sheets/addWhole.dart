import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
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
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SheetPageAC(
                        context, searchNode, controller, username, date, s),
                  )),
            ),
          ),
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
  bool isresponsible = false;
  MediaQuery.of(context).size.height > 900
      ? isresponsible = true
      : isresponsible = false;
  return SizedBox(
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
              SizedBox(
                height: isresponsible == true ? 40 : 20,
              ),
              title(context, controller, isresponsible),
              SizedBox(
                height: isresponsible == true ? 40 : 20,
              ),
              content(context, searchNode, controller, username, _color, date,
                  s, choicelist, isresponsible),
              SizedBox(
                height: isresponsible == true ? 40 : 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
  TextEditingController controller,
  bool isresponsible,
) {
  return SizedBox(
      height: isresponsible == true ? 80 : 50,
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
  bool isresponsible,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: isresponsible == true ? 60 : 30,
          child: Text('제목',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        SizedBox(
          height: isresponsible == true ? 40 : 20,
        ),
        SizedBox(
          height: isresponsible == true ? 80 : 40,
          child: TextField(
            controller: controller,
            maxLines: 1,
            focusNode: searchNode,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              contentPadding: EdgeInsets.only(left: 10),
              hintText: '제목 입력...',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black45),
            ),
          ),
        ),
        s == 'home'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isresponsible == true ? 40 : 20,
                  ),
                  SizedBox(
                      height: isresponsible == true ? 60 : 30,
                      child: Row(
                        children: [
                          Text('카테고리를 선택하세요',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ],
                      )),
                  SizedBox(
                    height: isresponsible == true ? 40 : 30,
                    child: Text('아래 아이콘 클릭',
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                  ),
                  SizedBox(
                    height: isresponsible == true ? 40 : 20,
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
        SizedBox(
          height: isresponsible == true ? 40 : 20,
        ),
        SizedBox(
          height: isresponsible == true ? 60 : 30,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: _color,
                                        onColorChanged: (Color color) {
                                          setState(() {
                                            _color = color;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
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
        SizedBox(
          height: isresponsible == true ? 60 : 30,
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
                  CreateCalandmemoFailSaveTitle(context);
                } else if (choicelist[0] == 0 &&
                    choicelist[1] == 0 &&
                    s == 'home') {
                  CreateCalandmemoFailSaveCategory(context);
                } else {
                  setState(() {
                    CreateCalandmemoSuccessFlushbar(context);
                    if (s == 'home') {
                      choicelist[0] == 1
                          ? firestore.collection('CalendarSheetHome').add({
                              'calname': controller.text,
                              'madeUser': username,
                              'type': 0,
                              'share': [],
                              'viewsetting': 0,
                              'themesetting': 0,
                              'allowance_share': false,
                              'allowance_change_set': false,
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
                            }).whenComplete(() {
                              CreateCalandmemoSuccessFlushbarSub(context, '일정');
                            })
                          : firestore.collection('MemoDataBase').doc().set({
                              'Collection': null,
                              'memoindex': null,
                              'memolist': null,
                              'homesave': false,
                              'security': false,
                              'pinnumber': '0000',
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
                                  '일',
                              'photoUrl': [],
                              'securewith': 999,
                            }).whenComplete(() {
                              CreateCalandmemoSuccessFlushbarSub(context, '메모');
                            });
                    } else {
                      firestore.collection('CalendarSheetHome').add({
                        'calname': controller.text,
                        'madeUser': username,
                        'type': 0,
                        'share': [],
                        'viewsetting': 0,
                        'themesetting': 0,
                        'allowance_share': false,
                        'allowance_change_set': false,
                        'color':
                            Hive.box('user_setting').get('typecolorcalendar') ??
                                _color.value.toInt(),
                        'date': date.toString().split('-')[0] +
                            '-' +
                            date.toString().split('-')[1] +
                            '-' +
                            date.toString().split('-')[2].substring(0, 2) +
                            '일'
                      }).whenComplete(() {
                        CreateCalandmemoSuccessFlushbarSub(context, '일정');
                      });
                    }
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
