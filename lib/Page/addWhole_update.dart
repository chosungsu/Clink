import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/memosetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/onequeform.dart';
import '../Tool/NoBehavior.dart';
import '../route.dart';

addWhole_update(
    BuildContext context,
    FocusNode searchNode,
    TextEditingController controller,
    String username,
    DateTime date,
    String s,
    FToast fToast) {
  Get.bottomSheet(
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
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
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          SheetPageAC(context, searchNode, controller, username,
                              date, s, fToast),
                        ],
                      ))),
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
    final cal_share_person = Get.put(PeopleAdd());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String name = Hive.box('user_info').get('id');
    if (s == 'home') {
      Hive.box('user_setting').get('page_index') == 0
          ? Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.fade,
                child: const MyHomePage(
                  index: 0,
                ),
              ),
            )
          : (Hive.box('user_setting').get('page_index') == 1
              ? Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const MyHomePage(
                      index: 1,
                    ),
                  ),
                )
              : Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const MyHomePage(
                      index: 3,
                    ),
                  ),
                ));
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
  FToast fToast,
) {
  List choicelist = List.filled(2, 0, growable: true);

  Color _color = Hive.box('user_setting').get('typecolorcalendar') == null
      ? Colors.yellow
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
                  s, choicelist, isresponsible, fToast),
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
  FToast fToast,
) {
  var controll_memo = Get.put(memosetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());
  String usercode = Hive.box('user_setting').get('usercode');
  int currentPage = 1;
  int initialpage = 0;
  PageController pageController = PageController(initialPage: initialpage);

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: ScrollConfiguration(
      behavior: NoBehavior(),
      child: SingleChildScrollView(
          child: StatefulBuilder(builder: (_, StateSetter setState) {
        return s == 'home'
            ? initialpage == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Text('카테고리를 선택하세요',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListView.builder(
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: ((context, index2) {
                              return index2 == 0
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              choicelist[0] == 0
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.black,
                                                        ),
                                                      ))
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.blue,
                                                        ),
                                                      )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  '캘린더카드',
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: TextColor(),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              choicelist[1] == 0
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.description,
                                                          color: Colors.black,
                                                        ),
                                                      ))
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.blue,
                                                        ),
                                                      )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  '메모카드',
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color: TextColor(),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                            })),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: controll_memo.loading == true
                                  ? Colors.grey.shade100
                                  : Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                print(choicelist);
                                controll_memo.setloading(true);
                                if (choicelist[0] == 0 && choicelist[1] == 0) {
                                  controll_memo.setloading(false);
                                  CreateCalandmemoFailSaveCategory(context);
                                } else {
                                  currentPage = 2;
                                  controll_memo.setloading(false);
                                  initialpage = 1;
                                }
                              });
                            },
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: controll_memo.loading == true
                                        ? NeumorphicText(
                                            '로딩중',
                                            style: const NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Colors.black,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                            ),
                                          )
                                        : NeumorphicText(
                                            '다음단계(1/2)',
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
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        SizedBox(
                          height: 30,
                          child: Text('제목',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ContainerDesign(
                                color: Colors.white,
                                child: TextField(
                                  controller: controller,
                                  focusNode: searchNode,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: '제목 입력...',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black45),
                                  ),
                                ),
                              ),
                            )),
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
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Text('선택',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTitleTextsize())),
                                              content: Builder(
                                                builder: (context) {
                                                  return SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.85,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: ColorPicker(
                                                        pickerColor: _color,
                                                        onColorChanged:
                                                            (Color color) {
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
                                                    Hive.box('user_setting')
                                                        .put(
                                                            'typecolorcalendar',
                                                            _color.value
                                                                .toInt());
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
                        GetBuilder<memosetting>(
                            builder: (_) => SizedBox(
                                height: 60,
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  currentPage = 2;
                                                  controll_memo
                                                      .setloading(false);
                                                  initialpage = 0;
                                                });
                                              },
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '이전',
                                                        style:
                                                            const NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: Colors.black,
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                        flex: 2,
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                primary:
                                                    controll_memo.loading ==
                                                            true
                                                        ? Colors.grey.shade400
                                                        : Colors.blue,
                                              ),
                                              onPressed:
                                                  controll_memo.loading == true
                                                      ? null
                                                      : () {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          controll_memo
                                                              .setloading(true);

                                                          if (controller
                                                              .text.isEmpty) {
                                                            controll_memo
                                                                .setloading(
                                                                    false);
                                                            CreateCalandmemoFailSaveTitle(
                                                                context);
                                                          } else if (choicelist[
                                                                      0] ==
                                                                  0 &&
                                                              choicelist[1] ==
                                                                  0 &&
                                                              s == 'home') {
                                                            controll_memo
                                                                .setloading(
                                                                    false);
                                                            CreateCalandmemoFailSaveCategory(
                                                                context);
                                                          } else {
                                                            setState(() {
                                                              if (s == 'home') {
                                                                choicelist[0] ==
                                                                        1
                                                                    ? firestore
                                                                        .collection(
                                                                            'CalendarSheetHome_update')
                                                                        .add({
                                                                        'calname':
                                                                            controller.text,
                                                                        'madeUser':
                                                                            usercode,
                                                                        'type':
                                                                            0,
                                                                        'share':
                                                                            [],
                                                                        'viewsetting':
                                                                            0,
                                                                        'themesetting':
                                                                            0,
                                                                        'allowance_share':
                                                                            false,
                                                                        'allowance_change_set':
                                                                            false,
                                                                        'color':
                                                                            Hive.box('user_setting').get('typecolorcalendar') ??
                                                                                _color.value.toInt(),
                                                                        'date': date.toString().split('-')[0] +
                                                                            '-' +
                                                                            date.toString().split('-')[
                                                                                1] +
                                                                            '-' +
                                                                            date.toString().split('-')[2].substring(0,
                                                                                2) +
                                                                            '일'
                                                                      }).whenComplete(
                                                                            () {
                                                                        controll_memo
                                                                            .setloading(false);
                                                                        Get.back();
                                                                        Future.delayed(
                                                                            const Duration(seconds: 0),
                                                                            () {
                                                                          CreateCalandmemoMove(
                                                                              context,
                                                                              'cal');
                                                                        });
                                                                      })
                                                                    : firestore
                                                                        .collection(
                                                                            'MemoDataBase')
                                                                        .doc()
                                                                        .set({
                                                                        'Collection':
                                                                            null,
                                                                        'memoindex':
                                                                            null,
                                                                        'memolist':
                                                                            null,
                                                                        'homesave':
                                                                            false,
                                                                        'security':
                                                                            false,
                                                                        'pinnumber':
                                                                            '0000',
                                                                        'EditDate': date.toString().split('-')[0] +
                                                                            '-' +
                                                                            date.toString().split('-')[
                                                                                1] +
                                                                            '-' +
                                                                            date.toString().split('-')[2].substring(0,
                                                                                2) +
                                                                            '일',
                                                                        'memoTitle':
                                                                            controller.text,
                                                                        'OriginalUser':
                                                                            usercode,
                                                                        'alarmok':
                                                                            false,
                                                                        'alarmtime':
                                                                            '99:99',
                                                                        'color':
                                                                            Hive.box('user_setting').get('typecolorcalendar') ??
                                                                                _color.value.toInt(),
                                                                        'colorfont': Colors
                                                                            .black
                                                                            .value
                                                                            .toInt(),
                                                                        'Date': date.toString().split('-')[0] +
                                                                            '-' +
                                                                            date.toString().split('-')[
                                                                                1] +
                                                                            '-' +
                                                                            date.toString().split('-')[2].substring(0,
                                                                                2) +
                                                                            '일',
                                                                        'photoUrl':
                                                                            [],
                                                                        'securewith':
                                                                            999,
                                                                      }).whenComplete(
                                                                            () {
                                                                        controll_memo
                                                                            .setloading(false);
                                                                        Get.back();
                                                                        Future.delayed(
                                                                            const Duration(seconds: 0),
                                                                            () {
                                                                          CreateCalandmemoMove(
                                                                              context,
                                                                              'memo');
                                                                        });
                                                                      });
                                                              } else {
                                                                firestore
                                                                    .collection(
                                                                        'CalendarSheetHome_update')
                                                                    .add({
                                                                  'calname':
                                                                      controller
                                                                          .text,
                                                                  'madeUser':
                                                                      usercode,
                                                                  'type': 0,
                                                                  'share': [],
                                                                  'viewsetting':
                                                                      0,
                                                                  'themesetting':
                                                                      0,
                                                                  'allowance_share':
                                                                      false,
                                                                  'allowance_change_set':
                                                                      false,
                                                                  'color': Hive.box(
                                                                              'user_setting')
                                                                          .get(
                                                                              'typecolorcalendar') ??
                                                                      _color
                                                                          .value
                                                                          .toInt(),
                                                                  'date': date
                                                                              .toString()
                                                                              .split('-')[
                                                                          0] +
                                                                      '-' +
                                                                      date.toString().split(
                                                                              '-')[
                                                                          1] +
                                                                      '-' +
                                                                      date
                                                                          .toString()
                                                                          .split('-')[
                                                                              2]
                                                                          .substring(
                                                                              0,
                                                                              2) +
                                                                      '일'
                                                                }).whenComplete(
                                                                        () {
                                                                  controll_memo
                                                                      .setloading(
                                                                          false);
                                                                  Get.back();
                                                                  Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              0),
                                                                      () {
                                                                    CreateCalandmemoMove(
                                                                        context,
                                                                        'cal');
                                                                  });
                                                                });
                                                              }
                                                            });
                                                          }
                                                        },
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: controll_memo
                                                                  .loading ==
                                                              true
                                                          ? NeumorphicText(
                                                              '로딩중',
                                                              style:
                                                                  const NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .flat,
                                                                depth: 3,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textStyle:
                                                                  NeumorphicTextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                            )
                                                          : NeumorphicText(
                                                              '생성하기',
                                                              style:
                                                                  const NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .flat,
                                                                depth: 3,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textStyle:
                                                                  NeumorphicTextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ))
                                  ],
                                ))),
                      ])
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    SizedBox(
                      height: 30,
                      child: Text('제목',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize())),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ContainerDesign(
                            color: Colors.white,
                            child: TextField(
                              controller: controller,
                              focusNode: searchNode,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: '제목 입력...',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black45),
                              ),
                            ),
                          ),
                        )),
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text('선택',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      contentTitleTextsize())),
                                          content: Builder(
                                            builder: (context) {
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                child: SingleChildScrollView(
                                                  child: ColorPicker(
                                                    pickerColor: _color,
                                                    onColorChanged:
                                                        (Color color) {
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
                    const SizedBox(
                      height: 30,
                    ),
                    GetBuilder<memosetting>(
                        builder: (_) => SizedBox(
                            height: 60,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    primary: controll_memo.loading == true
                                        ? Colors.grey.shade400
                                        : Colors.blue,
                                  ),
                                  onPressed: controll_memo.loading == true
                                      ? null
                                      : () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controll_memo.setloading(true);

                                          if (controller.text.isEmpty) {
                                            controll_memo.setloading(false);
                                            CreateCalandmemoFailSaveTitle(
                                                context);
                                          } else if (choicelist[0] == 0 &&
                                              choicelist[1] == 0 &&
                                              s == 'home') {
                                            controll_memo.setloading(false);
                                            CreateCalandmemoFailSaveCategory(
                                                context);
                                          } else {
                                            setState(() {
                                              firestore
                                                  .collection(
                                                      'CalendarSheetHome_update')
                                                  .add({
                                                'calname': controller.text,
                                                'madeUser': usercode,
                                                'type': 0,
                                                'share': [],
                                                'viewsetting': 0,
                                                'themesetting': 0,
                                                'allowance_share': false,
                                                'allowance_change_set': false,
                                                'color': Hive.box(
                                                            'user_setting')
                                                        .get(
                                                            'typecolorcalendar') ??
                                                    _color.value.toInt(),
                                                'date': date
                                                        .toString()
                                                        .split('-')[0] +
                                                    '-' +
                                                    date
                                                        .toString()
                                                        .split('-')[1] +
                                                    '-' +
                                                    date
                                                        .toString()
                                                        .split('-')[2]
                                                        .substring(0, 2) +
                                                    '일'
                                              }).whenComplete(() {
                                                controll_memo.setloading(false);
                                                Get.back();
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                  CreateCalandmemoSuccessFlushbar(
                                                      '정상적으로 추가됨', fToast);
                                                });
                                              });
                                            });
                                          }
                                        },
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: controll_memo.loading == true
                                              ? NeumorphicText(
                                                  '로딩중',
                                                  style: const NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: Colors.white,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                  ),
                                                )
                                              : NeumorphicText(
                                                  '생성하기',
                                                  style: const NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: Colors.white,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ))),
                  ]);
      })),
    ));
  });
}
