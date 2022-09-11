import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../Tool/BGColor.dart';
import '../Tool/IconBtn.dart';

pushalarmsetting(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String controller_hour,
  String controller_minute,
  String doc_title,
  String id,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
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
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
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
                child: GestureDetector(
                    onTap: () {
                      setalarmhourNode.unfocus();
                      setalarmminuteNode.unfocus();
                    },
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SheetPage(
                            context,
                            setalarmhourNode,
                            setalarmminuteNode,
                            controller_hour,
                            controller_minute,
                            doc_title,
                            id))),
              )),
        );
      });
}

SheetPage(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String controller_hour,
  String controller_minute,
  String doc_title,
  String id,
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
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
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
                  controller_hour, controller_minute, doc_title, id),
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
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      doc_title != ''
          ? RichText(
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
) {
  DateTime now = DateTime.now();
  final controll_memo = Get.put(memosetting());
  TimeOfDay? pickednow;
  if (doc_title != '') {
    Hive.box('user_setting').put('alarm_memo_hour_$title', controller_hour);
    Hive.box('user_setting').put('alarm_memo_minute_$title', controller_minute);
  } else {
    Hive.box('user_setting').put('alarm_memo_hour', controller_hour);
    Hive.box('user_setting').put('alarm_memo_minute', controller_minute);
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
                                    controll_memo.settimeminute(pickednow!.hour,
                                        pickednow!.minute, doc_title, id);
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
                              ? controller_hour == '99' &&
                                      controller_minute == '99'
                                  ? (controller_hour !=
                                              controll_memo.hour1.toString() ||
                                          controller_minute !=
                                              controll_memo.minute1.toString()
                                      ? Text(
                                          '설정시간 : ' +
                                              controll_memo.hour1.toString() +
                                              '시 ' +
                                              controll_memo.minute1.toString() +
                                              '분',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        )
                                      : Text(
                                          '설정시간 : 없음',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        ))
                                  : (controller_hour !=
                                              controll_memo.hour1.toString() ||
                                          controller_minute !=
                                              controll_memo.minute1.toString()
                                      ? (controll_memo.hour1 == 99 ||
                                              controll_memo.minute1 == 99
                                          ? Text(
                                              '설정시간 : ' +
                                                  controller_hour +
                                                  '시 ' +
                                                  controller_minute +
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
                                            ))
                                      : Text(
                                          '설정시간 : ' +
                                              controller_hour +
                                              '시 ' +
                                              controller_minute +
                                              '분',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        ))
                              : (controller_hour !=
                                          controll_memo.hour2.toString() ||
                                      controller_minute !=
                                          controll_memo.minute2.toString()
                                  ? (controll_memo.hour2 != '99' ||
                                          controll_memo.minute2 != '99'
                                      ? Text(
                                          '설정시간 : ' +
                                              controll_memo.hour2.toString() +
                                              '시 ' +
                                              controll_memo.minute2.toString() +
                                              '분',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        )
                                      : Text(
                                          '설정시간 : 없음',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        ))
                                  : (controll_memo.hour2 != '99' ||
                                          controll_memo.minute2 != '99'
                                      ? Text(
                                          '설정시간 : ' +
                                              controll_memo.hour2.toString() +
                                              '시 ' +
                                              controll_memo.minute2.toString() +
                                              '분',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        )
                                      : Text(
                                          '설정시간 : 없음',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize(),
                                              color: Colors.black),
                                        ))),
                          /*Flexible(
                                fit: FlexFit.tight,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: TimePickerSpinner(
                                        is24HourMode: true,
                                        normalTextStyle: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: Colors.black),
                                        highlightedTextStyle: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: Colors.blue),
                                        spacing: 10,
                                        itemHeight: 60,
                                        isForce2Digits: true,
                                        onTimeChange: (time) {
                                          setState(() {
                                            now = time;
                                          });
                                        },
                                      ),
                                    )
                                    /*Container(
                                      height: 50,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 1,
                                        focusNode: setalarmhourNode,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 5),
                                          isCollapsed: true,
                                          hintText: '00',
                                          hintStyle: TextStyle(
                                              fontSize: contentTextsize(),
                                              color: Colors.grey.shade400),
                                        ),
                                        controller: controller_hour,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 1,
                                        focusNode: setalarmminuteNode,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 5),
                                          isCollapsed: true,
                                          hintText: '00',
                                          hintStyle: TextStyle(
                                              fontSize: contentTextsize(),
                                              color: Colors.grey.shade400),
                                        ),
                                        controller: controller_minute,
                                      ),
                                    )*/
                                  ],
                                )),*/
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
                                        Hive.box('user_setting')
                                            .put('alarm_memo_$doc_title', true);
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
                                        Navigator.pop(context);
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
                              doc_title != ''
                                  ? Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          height: 50,
                                          child: InkWell(
                                            onTap: () {
                                              Hive.box('user_setting').put(
                                                  'alarm_memo_$doc_title',
                                                  false);
                                              controll_memo.setalarmmemo(
                                                  doc_title, id);
                                              Navigator.pop(context);
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
                                                          shape: NeumorphicShape
                                                              .flat,
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
                                          )))
                                  : const SizedBox(),
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
