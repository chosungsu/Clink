import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/SheetGetx/PeopleAdd.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../DB/Event.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/NoBehavior.dart';

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key,
      required this.firstdate,
      required this.position,
      required this.title,
      required this.share,
      required this.orig,
      required this.lastdate})
      : super(key: key);
  final DateTime firstdate;
  final DateTime lastdate;
  final String position;
  final String title;
  final String orig;
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
  late Map<DateTime, List<Event>> _events;
  static final cal_share_person = Get.put(PeopleAdd());
  List finallist = cal_share_person.people;
  final searchNode = FocusNode();
  late TextEditingController controllername;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  String selectedValue = '선택없음';
  bool isChecked_pushalarm = false;
  int differ_date = 0;
  List differ_list = [];

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
    _events = {};
    widget.lastdate != widget.firstdate
        ? differ_date = int.parse(widget.lastdate
            .difference(DateTime.parse(widget.firstdate.toString()))
            .inDays
            .toString())
        : differ_date = 0;
    for (int i = 0; i <= differ_date; i++) {
      differ_list.add(DateTime(widget.firstdate.year, widget.firstdate.month,
          widget.firstdate.day + i));
    }
    selectedValue = Hive.box('user_setting').get('alarming_time') ?? '5분 전';
    Hive.box('user_setting').get('isChecked_alarming') == null
        ? isChecked_pushalarm = false
        : isChecked_pushalarm =
            Hive.box('user_setting').get('isChecked_alarming');
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
        child: UI(),
      ),
    ));
  }

  UI() {
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
                                                '작성하기',
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
                                      if (widget.position == 'cal') {
                                        Flushbar(
                                          backgroundColor:
                                              Colors.green.shade400,
                                          titleText: Text('Uploading...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    contentTitleTextsize(),
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
                                          leftBarIndicatorColor:
                                              Colors.green.shade100,
                                        ).show(context);
                                        if (differ_list.isNotEmpty) {
                                          for (int j = 0;
                                              j < differ_list.length;
                                              j++) {
                                            firestore
                                                .collection('CalendarDataBase')
                                                .add({
                                              'Daytodo':
                                                  textEditingController1.text,
                                              'Timestart':
                                                  textEditingController2.text
                                                              .split(':')[0]
                                                              .length ==
                                                          1
                                                      ? '0' +
                                                          textEditingController2
                                                              .text
                                                      : textEditingController2
                                                          .text,
                                              'Timefinish':
                                                  textEditingController3.text,
                                              'Shares': widget.share,
                                              'OriginalUser': widget.orig,
                                              'calname': widget.title,
                                              'Date': DateFormat('yyyy-MM-dd')
                                                      .parse(differ_list[j]
                                                          .toString())
                                                      .toString()
                                                      .split(' ')[0] +
                                                  '일',
                                            });
                                          }
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.blue.shade400,
                                              titleText: Text('Notice',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        contentTitleTextsize(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              messageText: widget.position ==
                                                      'cal'
                                                  ? Text('일정이 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))
                                                  : Text('메모가 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 25.0,
                                                color: Colors.white,
                                              ),
                                              duration:
                                                  const Duration(seconds: 1),
                                              leftBarIndicatorColor:
                                                  Colors.blue.shade100,
                                            )
                                                .show(context)
                                                .whenComplete(() => Get.back());
                                          });
                                        } else {
                                          for (int j = 0;
                                              j < differ_list.length;
                                              j++) {
                                            firestore
                                                .collection('CalendarDataBase')
                                                .add({
                                              'Daytodo':
                                                  textEditingController1.text,
                                              'Timestart':
                                                  textEditingController2.text
                                                              .split(':')[0]
                                                              .length ==
                                                          1
                                                      ? '0' +
                                                          textEditingController2
                                                              .text
                                                      : textEditingController2
                                                          .text,
                                              'Timefinish':
                                                  textEditingController3.text,
                                              'Shares': widget.share,
                                              'OriginalUser': widget.orig,
                                              'calname': widget.title,
                                              'Date': DateFormat('yyyy-MM-dd')
                                                      .parse(widget.firstdate
                                                          .toString())
                                                      .toString()
                                                      .split(' ')[0] +
                                                  '일',
                                            });
                                          }
                                          Future.delayed(
                                              const Duration(seconds: 0), () {
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.blue.shade400,
                                              titleText: Text('Notice',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        contentTitleTextsize(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              messageText: widget.position ==
                                                      'cal'
                                                  ? Text('일정이 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))
                                                  : Text('메모가 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 25.0,
                                                color: Colors.white,
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              leftBarIndicatorColor:
                                                  Colors.blue.shade100,
                                            )
                                                .show(context)
                                                .whenComplete(() => Get.back());
                                          });
                                        }
                                      } else if (widget.position == 'note') {
                                        Flushbar(
                                          backgroundColor:
                                              Colors.green.shade400,
                                          titleText: Text('Uploading...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    contentTitleTextsize(),
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
                                          leftBarIndicatorColor:
                                              Colors.green.shade100,
                                        ).show(context);
                                        firestore
                                            .collection('CalendarDataBase')
                                            .add({
                                          'Daytodo':
                                              textEditingController1.text,
                                          'Timestart':
                                              textEditingController2.text,
                                          'Timefinish':
                                              textEditingController3.text,
                                          'Shares': finallist,
                                          'OriginalUser': username,
                                        }).whenComplete(() {
                                          Future.delayed(
                                              const Duration(seconds: 0), () {
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.blue.shade400,
                                              titleText: Text('Notice',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        contentTitleTextsize(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              messageText: widget.position ==
                                                      'cal'
                                                  ? Text('일정이 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))
                                                  : Text('메모가 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 25.0,
                                                color: Colors.white,
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              leftBarIndicatorColor:
                                                  Colors.blue.shade100,
                                            )
                                                .show(context)
                                                .whenComplete(() => Get.back());
                                          });
                                        });
                                      } else {
                                        Flushbar(
                                          backgroundColor:
                                              Colors.green.shade400,
                                          titleText: Text('Uploading...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    contentTitleTextsize(),
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
                                          leftBarIndicatorColor:
                                              Colors.green.shade100,
                                        ).show(context);
                                        firestore
                                            .collection('CalendarDataBase')
                                            .add({
                                          'Daytodo':
                                              textEditingController1.text,
                                          'Timestart':
                                              textEditingController2.text,
                                          'Timefinish':
                                              textEditingController3.text,
                                          'Shares': finallist,
                                          'OriginalUser': username,
                                        }).whenComplete(() {
                                          Future.delayed(
                                              const Duration(seconds: 0), () {
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.blue.shade400,
                                              titleText: Text('Notice',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        contentTitleTextsize(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              messageText: widget.position ==
                                                      'cal'
                                                  ? Text('일정이 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ))
                                                  : Text('메모가 정상적으로 추가되었습니다.',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            contentTextsize(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 25.0,
                                                color: Colors.white,
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              leftBarIndicatorColor:
                                                  Colors.blue.shade100,
                                            )
                                                .show(context)
                                                .whenComplete(() => Get.back());
                                          });
                                        });
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
                              const SizedBox(
                                height: 20,
                              ),
                              buildSheetTitle(widget.firstdate),
                              const SizedBox(
                                height: 20,
                              ),
                              Title(),
                              const SizedBox(
                                height: 30,
                              ),
                              SetTimeTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              widget.position == 'cal'
                                  ? Time()
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              const SizedBox(
                                height: 30,
                              ),
                              SetAlarmTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              Alarm(),
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
            child: Row(
              children: [
                Text(
                  '일정제목',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text('필수항목',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ))
        : (widget.position == 'note'
            ? SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      '메모제목',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: TextColor()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('필수항목',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ))
            : SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      '루틴제목',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: TextColor()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('필수항목',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                )));
  }

  Title() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: searchNode,
              style: TextStyle(fontSize: contentTextsize(), color: TextColor()),
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
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
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
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
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

  SetTimeTitle() {
    return SizedBox(
      height: 30,
      child: Text(
        '일정세부사항',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: contentTitleTextsize(),
            color: TextColor()),
      ),
    );
  }

  Time() {
    return widget.position == 'cal'
        ? SizedBox(
            height: widget.lastdate != widget.firstdate ? 320 : 300,
            child: Column(
              children: [
                widget.lastdate != widget.firstdate
                    ? SizedBox(
                        height: 100,
                        child: ContainerDesign(
                          color: BGColor(),
                          child: ListTile(
                            leading: NeumorphicIcon(
                              Icons.today,
                              size: 30,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  surfaceIntensity: 0.5,
                                  color: TextColor(),
                                  lightSource: LightSource.topLeft),
                            ),
                            title: Text(
                              widget.firstdate.toString().split(' ')[0] +
                                  '부터 ' +
                                  widget.lastdate.toString().split(' ')[0] +
                                  '까지',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                  color: TextColor()),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 80,
                        child: ContainerDesign(
                          color: BGColor(),
                          child: ListTile(
                            leading: NeumorphicIcon(
                              Icons.today,
                              size: 30,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  surfaceIntensity: 0.5,
                                  color: TextColor(),
                                  lightSource: LightSource.topLeft),
                            ),
                            title: Text(
                              widget.firstdate.toString().split(' ')[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                  color: TextColor()),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.schedule,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '시작시간',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        controller: textEditingController2,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          pickDates(context, textEditingController2,
                              widget.firstdate);
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: TextColor(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.schedule,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '종료시간',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        controller: textEditingController3,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          pickDates(context, textEditingController3,
                              widget.firstdate);
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: TextColor(),
                        ),
                      ),
                    ),
                  ),
                ),
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

  SetAlarmTitle() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '알람설정',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                      activeColor: Colors.blue,
                      inactiveThumbColor: TextColor(),
                      inactiveTrackColor: Colors.grey.shade100,
                      value: isChecked_pushalarm,
                      onChanged: (bool val) {
                        setState(() {
                          isChecked_pushalarm = val;
                          Hive.box('user_setting')
                              .put('isChecked_alarming', isChecked_pushalarm);
                        });
                      }),
                )
              ],
            ))
        : const SizedBox();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("1분 전"), value: "1분 전"),
      const DropdownMenuItem(child: Text("5분 전"), value: "5분 전"),
      const DropdownMenuItem(child: Text("10분 전"), value: "10분 전"),
      const DropdownMenuItem(child: Text("30분 전"), value: "30분 전"),
    ];
    return menuItems;
  }

  Alarm() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 200,
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.alarm,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '알람',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      trailing: isChecked_pushalarm == true
                          ? DropdownButton(
                              value: selectedValue,
                              dropdownColor: BGColor(),
                              items: dropdownItems,
                              icon: NeumorphicIcon(
                                Icons.arrow_drop_down,
                                size: 20,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                              style: TextStyle(
                                  color: TextColor(),
                                  fontSize: contentTextsize()),
                              onChanged: isChecked_pushalarm == true
                                  ? (String? value) {
                                      setState(() {
                                        selectedValue = value!;
                                        Hive.box('user_setting').put(
                                            'alarming_time', selectedValue);
                                      });
                                    }
                                  : null,
                            )
                          : Text(
                              '설정off상태입니다.',
                              style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
                            ),
                    ),
                  ),
                ),
              ],
            ))
        : const SizedBox();
  }
}

pickDates(BuildContext context, TextEditingController timecontroller,
    DateTime fromDate) async {
  String hour = '';
  String minute = '';
  Future<TimeOfDay?> pick = showTimePicker(
      context: context, initialTime: TimeOfDay.fromDateTime(fromDate));
  pick.then((timeOfDay) {
    if (timeOfDay != null) {
      hour = timeOfDay.hour.toString();
      minute = timeOfDay.minute.toString();
      timecontroller.text = '$hour:$minute';
    }
  });
}
