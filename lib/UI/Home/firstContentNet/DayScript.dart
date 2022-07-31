import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/SheetGetx/PeopleAdd.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../DB/ChipList.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/addgroupmember.dart';
import '../../../sheets/showGroupmember.dart';

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key,
      required this.index,
      required this.date,
      required this.position,
      required this.title,
      required this.share})
      : super(key: key);
  final int index;
  final DateTime date;
  final String position;
  final String title;
  final List share;
  @override
  State<StatefulWidget> createState() => _DayScriptState();
}

class _DayScriptState extends State<DayScript> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  DateTime _selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isclickedshowmore = false;
  String username = Hive.box('user_info').get(
    'id',
  );
  List<ChipList> list_sp = [];
  static final cal_share_person = Get.put(PeopleAdd());
  List finallist = cal_share_person.people;
  final searchNode = FocusNode();
  late TextEditingController controllername;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  final List memostar = [1, 2, 1, 1, 3];
  final List memotitle = ['memo1', 'memo2', 'memo3', 'memo4', 'memo5'];
  final List memocontent = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기 fighting!!!',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    cal_share_person.peoplecalendarrestart();
    finallist = cal_share_person.people;
    controllername = TextEditingController();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllername.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: GestureDetector(
        onTap: () {
          searchNode.unfocus();
        },
        child: UI(list_sp),
      ),
    ));
  }

  UI(List<ChipList> list_sp) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            //Navigator.pop(context);
                                            Get.back();
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.keyboard_arrow_left,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60 -
                                        160,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                widget.index == 0
                                                    ? '작성하기'
                                                    : (widget.index == 1
                                                        ? '수정하기'
                                                        : '삭제하기'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        secondTitleTextsize(),
                                                    color: TextColor()),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            child: InkWell(
                                onTap: () {
                                  if (textEditingController1.text.isNotEmpty) {
                                    if (textEditingController2
                                            .text.isNotEmpty ||
                                        textEditingController3
                                            .text.isNotEmpty) {
                                      widget.position == 'cal'
                                          ? firestore
                                              .collection('CalendarDataBase')
                                              .add({
                                              'Daytodo':
                                                  textEditingController1.text,
                                              'Timestart':
                                                  textEditingController2.text,
                                              'Timefinish':
                                                  textEditingController3.text,
                                              'Shares': widget.share,
                                              'OriginalUser': username,
                                              'calname': widget.title,
                                              'Date': widget.date
                                                      .toString()
                                                      .split('-')[0] +
                                                  '-' +
                                                  widget.date
                                                      .toString()
                                                      .split('-')[1] +
                                                  '-' +
                                                  widget.date
                                                      .toString()
                                                      .split('-')[2]
                                                      .substring(0, 2) +
                                                  '일',
                                            })
                                          : (widget.position == 'note'
                                              ? firestore
                                                  .collection(
                                                      'CalendarDataBase')
                                                  .add({
                                                  'Daytodo':
                                                      textEditingController1
                                                          .text,
                                                  'Timestart':
                                                      textEditingController2
                                                          .text,
                                                  'Timefinish':
                                                      textEditingController3
                                                          .text,
                                                  'Shares': finallist,
                                                  'OriginalUser': username,
                                                })
                                              : firestore
                                                  .collection(
                                                      'CalendarDataBase')
                                                  .add({
                                                  'Daytodo':
                                                      textEditingController1
                                                          .text,
                                                  'Timestart':
                                                      textEditingController2
                                                          .text,
                                                  'Timefinish':
                                                      textEditingController3
                                                          .text,
                                                  'Shares': finallist,
                                                  'OriginalUser': username,
                                                }));
                                    } else {
                                      Flushbar(
                                        backgroundColor: Colors.red.shade400,
                                        titleText: Text('Notice',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: contentTitleTextsize(),
                                              fontWeight: FontWeight.bold,
                                            )),
                                        messageText: widget.position == 'cal'
                                            ? Text('시작시각은 필수 입력사항입니다!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: contentTextsize(),
                                                  fontWeight: FontWeight.bold,
                                                ))
                                            : Text('메모내용은 필수 입력사항입니다!',
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
                                        leftBarIndicatorColor:
                                            Colors.red.shade100,
                                      ).show(context);
                                    }
                                  } else {
                                    Flushbar(
                                      backgroundColor: Colors.red.shade400,
                                      titleText: Text('Notice',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: contentTitleTextsize(),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      messageText: Text('제목은 필수 입력사항입니다!',
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
                                      leftBarIndicatorColor:
                                          Colors.red.shade100,
                                    ).show(context);
                                  }
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Flushbar(
                                      backgroundColor: Colors.blue.shade400,
                                      titleText: Text('Notice',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: contentTitleTextsize(),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      messageText: widget.position == 'cal'
                                          ? Text('일정이 정상적으로 추가되었습니다.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: contentTextsize(),
                                                fontWeight: FontWeight.bold,
                                              ))
                                          : Text('메모가 정상적으로 추가되었습니다.',
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
                                      leftBarIndicatorColor:
                                          Colors.blue.shade100,
                                    ).show(context);
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  child: NeumorphicIcon(
                                    Icons.done_all,
                                    size: 30,
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: TextColor(),
                                        lightSource: LightSource.topLeft),
                                  ),
                                ))),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSheetTitle(widget.date),
                              const SizedBox(
                                height: 20,
                              ),
                              Title(),
                              const SizedBox(
                                height: 20,
                              ),
                              widget.position == 'cal'
                                  ? SizedBox(
                                      height: 120,
                                      child: Row(
                                        children: [
                                          Content(
                                              context,
                                              textEditingController2,
                                              'prev',
                                              widget.date),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Content(
                                              context,
                                              textEditingController3,
                                              'after',
                                              widget.date),
                                        ],
                                      ),
                                    )
                                  : (widget.position == 'note'
                                      ? Content(context, textEditingController2,
                                          'prev', widget.date)
                                      : Content(context, textEditingController2,
                                          'prev', widget.date)),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  buildSheetTitle(DateTime fromDate) {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: Text(
              '일정제목',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: TextColor()),
            ),
          )
        : (widget.position == 'note'
            ? SizedBox(
                height: 30,
                child: Text(
                  '메모제목',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
              )
            : SizedBox(
                height: 30,
                child: Text(
                  '루틴제목',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
              ));
  }

  Title() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: searchNode,
              readOnly: widget.index == 2 ? true : false,
              style: TextStyle(fontSize: 20, color: TextColor()),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '일정 제목 추가',
                hintStyle:
                    TextStyle(fontSize: contentTextsize(), color: TextColor()),
              ),
              controller: textEditingController1,
            ),
          )
        : (widget.position == 'note'
            ? SizedBox(
                height: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        focusNode: searchNode,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '제목 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        controller: textEditingController1,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        '메모내용',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100,
                      child: TextField(
                        minLines: 1,
                        maxLines: 10,
                        focusNode: searchNode,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '내용 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        controller: textEditingController2,
                      ),
                    )
                  ],
                ))
            : SizedBox(
                height: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        focusNode: searchNode,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '제목 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        controller: textEditingController1,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        '메모내용',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100,
                      child: TextField(
                        minLines: 1,
                        maxLines: 3,
                        focusNode: searchNode,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '내용 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        controller: textEditingController2,
                      ),
                    )
                  ],
                ),
              ));
  }

  Content(
    BuildContext context,
    TextEditingController textEditingController,
    String s,
    DateTime fromDate,
  ) {
    return widget.position == 'cal'
        ? SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                s == 'prev'
                    ? SizedBox(
                        height: 30,
                        child: Text(
                          '시작시각',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: TextColor()),
                        ))
                    : SizedBox(
                        height: 30,
                        child: Text(
                          '종료시각',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: TextColor()),
                        )),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: BGColor(),
                                  border:
                                      Border.all(color: TextColor(), width: 2)),
                              child: s == 'prev'
                                  ? TextField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      readOnly:true,
                                      style: TextStyle(
                                          fontSize: 20, color: TextColor()),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        hintText: '시간 : 분',
                                        hintStyle: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: TextColor()),
                                      ),
                                      controller: textEditingController,
                                    )
                                  : TextField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      readOnly:true,
                                      style: TextStyle(
                                          fontSize: 20, color: TextColor()),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        hintText: '시간 : 분',
                                        hintStyle: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: TextColor()),
                                      ),
                                      controller: textEditingController,
                                    ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.index == 2) {
                          } else {
                            pickDates(context, textEditingController, fromDate);
                          }
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: TextColor(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
        : (widget.position == 'note'
            ? SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        '중요도 선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                      .get('stars') ==
                                                  1 ||
                                              Hive.box('user_setting')
                                                      .get('stars') ==
                                                  null
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 1);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+1',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                              .get('stars') ==
                                                          1 ||
                                                      Hive.box('user_setting')
                                                              .get('stars') ==
                                                          null
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              2
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 2);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+2',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      2
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              3
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 3);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+3',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      3
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        '중요도 선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                      .get('stars') ==
                                                  1 ||
                                              Hive.box('user_setting')
                                                      .get('stars') ==
                                                  null
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 1);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+1',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                              .get('stars') ==
                                                          1 ||
                                                      Hive.box('user_setting')
                                                              .get('stars') ==
                                                          null
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              2
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 2);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+2',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      2
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              3
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 3);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: NeumorphicText(
                                            '+3',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      3
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }

  showGroupmember(
    FocusNode searchNode,
    TextEditingController controller,
  ) {
    Get.bottomSheet(
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 440,
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
                  child: SheetPageG(context, searchNode, controller),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
        .whenComplete(() {
      setState(() {
        controller.clear();
        cal_share_person.peoplecalendar();
        finallist = cal_share_person.people;
      });
    });
  }
}

pickDates(BuildContext context, TextEditingController timecontroller,
    DateTime fromDate) async {
  String hour = '';
  String minute = '';
  Future<TimeOfDay?> pick = showTimePicker(
      context: context, initialTime: TimeOfDay.fromDateTime(fromDate));
  pick.then((timeOfDay) {
    hour = timeOfDay!.hour.toString();
    minute = timeOfDay.minute.toString();
    timecontroller.text = '$hour:$minute';
  });
}
