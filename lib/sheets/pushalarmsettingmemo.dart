import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/IconBtn.dart';
import '../Tool/Loader.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/Widgets/CreateCalandmemo.dart';

pushalarmsettingmemo(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String controller_hour,
  String controller_minute,
  String doc_title,
  String id,
  FToast fToast,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return GestureDetector(
                          onTap: () {
                            setalarmhourNode.unfocus();
                            setalarmminuteNode.unfocus();
                          },
                          child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: GetBuilder<memosetting>(
                                builder: (_) => Stack(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setalarmhourNode.unfocus();
                                          setalarmminuteNode.unfocus();
                                        },
                                        child: SingleChildScrollView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            child: SheetPage(
                                                context,
                                                setalarmhourNode,
                                                setalarmminuteNode,
                                                controller_hour,
                                                controller_minute,
                                                doc_title,
                                                id,
                                                fToast))),
                                    uisetting().loading == true
                                        ? const Loader_sheets(
                                            wherein: 'memoeach',
                                            height: 400,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              )));
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

SheetPage(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String controller_hour,
  String controller_minute,
  String doc_title,
  String id,
  FToast fToast,
) {
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title(context, doc_title),
              const SizedBox(
                height: 20,
              ),
              content(context, setalarmhourNode, setalarmminuteNode,
                  controller_hour, controller_minute, doc_title, id, fToast),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
  String doc_title,
) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          doc_title != ''
              ? RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                        text: doc_title,
                        style: TextStyle(
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                    TextSpan(
                        text: ' 메모의 알람 설정',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()))
                  ]))
              : RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                        text: '모든 메모',
                        style: TextStyle(
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                    TextSpan(
                        text: ' 의 매일알람 설정',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()))
                  ]))
        ],
      ));
}

content(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String controller_hour,
  String controller_minute,
  String doc_title,
  String id,
  FToast fToast,
) {
  DateTime now = DateTime.now();
  var controll_memo = Get.put(memosetting());
  var uiset = Get.put(uisetting());
  TimeOfDay? pickednow;
  if (doc_title != '') {
    Hive.box('user_setting').put('alarm_memo_hour_$title', controller_hour);
    Hive.box('user_setting').put('alarm_memo_minute_$title', controller_minute);
  } else {
    Hive.box('user_setting').put('alarm_memo_hour', controller_hour);
    Hive.box('user_setting').put('alarm_memo_minute', controller_minute);
    print('second(push) : ' +
        Hive.box('user_setting').get('alarm_memo_hour') +
        ':' +
        Hive.box('user_setting').get('alarm_memo_minute'));
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ContainerDesign(
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: RichText(
                      maxLines: 3,
                      text: TextSpan(
                        text: '알람은 매일 설정하신 시각에 울리게 됩니다',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            color: Colors.orange.shade400),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<memosetting>(
            builder: (_) => SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '시간 설정',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize(),
                                  color: Colors.black),
                            ),
                          ),
                          IconBtn(
                              child: InkWell(
                                  onTap: () async {
                                    pickednow = await showTimePicker(
                                        context: context,
                                        initialEntryMode:
                                            TimePickerEntryMode.inputOnly,
                                        helpText: '시간을 설정해주세요',
                                        cancelText: '닫기',
                                        confirmText: '설정',
                                        initialTime: controller_hour == '99' &&
                                                controller_minute == '99'
                                            ? TimeOfDay.now()
                                            : TimeOfDay(
                                                hour:
                                                    int.parse(controller_hour),
                                                minute: int.parse(
                                                    controller_minute)));
                                    if (pickednow != null) {
                                      controll_memo.settimeminute(
                                          pickednow!.hour,
                                          pickednow!.minute,
                                          doc_title,
                                          id);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(
                                      'Click',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.blue),
                                    ),
                                  )),
                              color: Colors.black)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          doc_title != ''
                              ? controll_memo.hour1.toString() != '99' ||
                                      controll_memo.minute1.toString() != '99'
                                  ? (controll_memo.hour1.toString().length < 2
                                      ? (controll_memo.minute1
                                                  .toString()
                                                  .length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controll_memo.hour1
                                                      .toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controll_memo.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controll_memo.hour1
                                                      .toString() +
                                                  '시 ' +
                                                  controll_memo.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ))
                                      : (controll_memo.minute1
                                                  .toString()
                                                  .length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  controll_memo.hour1
                                                      .toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controll_memo.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  controll_memo.hour1
                                                      .toString() +
                                                  '시 ' +
                                                  controll_memo.minute1
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )))
                                  : Text(
                                      '설정시간 : 없음',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.black),
                                    )
                              : controll_memo.hour2 != '99' ||
                                      controll_memo.minute2 != '99'
                                  ? (controll_memo.hour2.toString().length < 2
                                      ? (controll_memo.minute2
                                                  .toString()
                                                  .length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controll_memo.hour2
                                                      .toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controll_memo.minute2
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  '0' +
                                                  controll_memo.hour2
                                                      .toString() +
                                                  '시 ' +
                                                  controll_memo.minute2
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            ))
                                      : (controll_memo.minute2
                                                  .toString()
                                                  .length <
                                              2
                                          ? Text(
                                              '설정시간 : ' +
                                                  controll_memo.hour2
                                                      .toString() +
                                                  '시 ' +
                                                  '0' +
                                                  controll_memo.minute2
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              '설정시간 : ' +
                                                  controll_memo.hour2
                                                      .toString() +
                                                  '시 ' +
                                                  controll_memo.minute2
                                                      .toString() +
                                                  '분',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize(),
                                                  color: Colors.black),
                                            )))
                                  : Text(
                                      '설정시간 : 없음',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize(),
                                          color: Colors.black),
                                    ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          uiset.setloading(true);
                                          if (doc_title != '') {
                                            if (controll_memo.hour1
                                                        .toString() ==
                                                    '99' ||
                                                controll_memo.minute1
                                                        .toString() ==
                                                    '99') {
                                              uiset.setloading(false);
                                              CreateCalandmemoSuccessFlushbar(
                                                  '시간 설정안됨!', fToast);
                                            } else {
                                              doc_title != ''
                                                  ? Hive.box('user_setting').put(
                                                      'alarm_memo_$doc_title',
                                                      true)
                                                  : Hive.box('user_setting')
                                                      .put('alarm_memo', true);
                                              doc_title != ''
                                                  ? controll_memo.setalarmmemotimetable(
                                                      Hive.box('user_setting')
                                                          .get(
                                                              'alarm_memo_hour_$doc_title')
                                                          .toString(),
                                                      Hive.box('user_setting')
                                                          .get(
                                                              'alarm_memo_minute_$doc_title')
                                                          .toString(),
                                                      doc_title,
                                                      id)
                                                  : controll_memo
                                                      .setalarmmemotimetable(
                                                          controll_memo.hour2,
                                                          controll_memo.minute2,
                                                          '',
                                                          '');
                                              uiset.setloading(false);
                                              CreateCalandmemoSuccessFlushbar(
                                                  '설정 완료!', fToast);
                                              Snack.isopensnacks();
                                            }
                                          } else {
                                            if (controll_memo.hour2
                                                        .toString() ==
                                                    '99' ||
                                                controll_memo.minute2
                                                        .toString() ==
                                                    '99') {
                                              uiset.setloading(false);
                                              CreateCalandmemoSuccessFlushbar(
                                                  '시간 설정안됨!', fToast);
                                            } else {
                                              doc_title != ''
                                                  ? Hive.box('user_setting').put(
                                                      'alarm_memo_$doc_title',
                                                      true)
                                                  : Hive.box('user_setting')
                                                      .put('alarm_memo', true);
                                              doc_title != ''
                                                  ? controll_memo.setalarmmemotimetable(
                                                      Hive.box('user_setting')
                                                          .get(
                                                              'alarm_memo_hour_$doc_title')
                                                          .toString(),
                                                      Hive.box('user_setting')
                                                          .get(
                                                              'alarm_memo_minute_$doc_title')
                                                          .toString(),
                                                      doc_title,
                                                      id)
                                                  : controll_memo
                                                      .setalarmmemotimetable(
                                                          controll_memo.hour2,
                                                          controll_memo.minute2,
                                                          '',
                                                          '');
                                              uiset.setloading(false);
                                              CreateCalandmemoSuccessFlushbar(
                                                  '설정 완료!', fToast);
                                              Snack.isopensnacks();
                                            }
                                          }

                                          /*Get.back();
                                          Snack.show(
                                              context: context,
                                              title: '알림',
                                              content: '알람설정 완료',
                                              snackType: SnackType.info,
                                              behavior:
                                                  SnackBarBehavior.floating);*/
                                        });
                                      },
                                      child: Container(
                                        color: ButtonColor(),
                                        child: Center(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: NeumorphicText(
                                                  '설정하기',
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
                                        ),
                                      ),
                                    )),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                      height: 50,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            uiset.setloading(true);
                                          });
                                          doc_title != ''
                                              ? Hive.box('user_setting').put(
                                                  'alarm_memo_$doc_title',
                                                  false)
                                              : Hive.box('user_setting')
                                                  .put('alarm_memo', false);
                                          controll_memo.setalarmmemo(
                                              doc_title, id);
                                          setState(() {
                                            uiset.setloading(false);
                                            CreateCalandmemoSuccessFlushbar(
                                                '해제 완료!', fToast);
                                            Snack.isopensnacks();
                                          });
                                          /*Get.back();
                                          Snack.show(
                                              context: context,
                                              title: '알림',
                                              content: '알람해제 완료!',
                                              snackType: SnackType.info,
                                              behavior:
                                                  SnackBarBehavior.floating);*/
                                        },
                                        child: Container(
                                          color: Colors.red.shade400,
                                          child: Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '해제하기',
                                                    style:
                                                        const NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: Colors.white,
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
                                          ),
                                        ),
                                      ))),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
      ],
    ));
  });
}
