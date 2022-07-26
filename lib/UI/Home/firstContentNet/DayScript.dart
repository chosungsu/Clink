import 'package:clickbyme/Tool/BGColor.dart';
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

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key,
      required this.index,
      required this.date,
      required this.position})
      : super(key: key);
  final int index;
  final DateTime date;
  final String position;
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

  final searchNode = FocusNode();
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

    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                                  settingRoutineHome(context);
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
                                height: 20,
                              ),
                              AddSharing(list_sp),
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
            child: TextFormField(
              key: const ValueKey('cal' + 'title'),
              focusNode: searchNode,
              readOnly: widget.index == 2 ? true : false,
              style: TextStyle(fontSize: contentTextsize(), color: TextColor()),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TextColor())),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TextColor())),
                hintText: '일정 제목 추가',
                hintStyle:
                    TextStyle(fontSize: contentTextsize(), color: TextColor()),
              ),
              onFieldSubmitted: (_) {
                //saveForm();
              },
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
                      child: TextFormField(
                        key: const ValueKey('note' + 'title'),
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: contentTextsize()),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          hintText: widget.index == 0
                              ? '제목 입력'
                              : memotitle[widget.index],
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        onFieldSubmitted: (_) {
                          //saveForm();
                        },
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
                      child: TextFormField(
                        key: const ValueKey('note' + 'content'),
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: contentTextsize()),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          hintText: widget.index == 0
                              ? '내용 입력'
                              : memocontent[widget.index],
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        onFieldSubmitted: (_) {
                          //saveForm();
                        },
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
                      child: TextFormField(
                        key: const ValueKey('routine' + 'title'),
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: contentTextsize()),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          hintText: widget.index == 0
                              ? '제목 입력'
                              : memotitle[widget.index],
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        onFieldSubmitted: (_) {
                          //saveForm();
                        },
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
                      child: TextFormField(
                        key: const ValueKey('routine' + 'content'),
                        readOnly: widget.index == 2 ? true : false,
                        style: TextStyle(fontSize: contentTextsize()),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: TextColor())),
                          hintText: widget.index == 0
                              ? '내용 입력'
                              : memocontent[widget.index],
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                        onFieldSubmitted: (_) {
                          //saveForm();
                        },
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
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '시간 : 분',
                                  hintStyle: TextStyle(
                                      fontSize: contentTextsize(),
                                      color: TextColor()),
                                ),
                                readOnly: true,
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

  AddSharing(List<ChipList> list_sp) {
    bool isselected = false;
    return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              '공유',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: TextColor()),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: firestore
                  .collection('PeopleList')
                  .doc(username)
                  .get()
                  .then((value) {
                value.data()!.forEach((key, value) {
                  list_sp.add(ChipList(checked: isselected, title: value));
                });
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData || list_sp.isNotEmpty) {
                  return SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: list_sp.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            list_sp[index].checked == true
                                                ? list_sp.insert(
                                                    index,
                                                    ChipList(
                                                        checked: false,
                                                        title: list_sp[index]
                                                            .title))
                                                : list_sp.insert(
                                                    index,
                                                    ChipList(
                                                        checked: true,
                                                        title: list_sp[index]
                                                            .title));
                                            list_sp.removeAt(index + 1);
                                          });
                                        },
                                        child: ContainerDesign(
                                            color: BGColor(),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.orange
                                                                  .shade500,
                                                          child: list_sp[index]
                                                                      .checked ==
                                                                  false
                                                              ? Text(
                                                                  list_sp[index]
                                                                      .title
                                                                      .toString()
                                                                      .substring(
                                                                          0, 1),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18))
                                                              : Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                ))),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    list_sp[index]
                                                        .title
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          }));
                }
                return SizedBox(
                    height: 80,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Center(
                      child: Text(
                        '친구 리스트를 불러오는 중입니다...',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ));
              }),
        ],
      ),
    );
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
