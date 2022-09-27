import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/calendarsetting.dart';
import 'package:clickbyme/Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/IconBtn.dart';

pushalarmsettingcal(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String hour,
  String minute,
  String doc_title,
  String id,
  int isChecked_pushalarmwhat,
  DateTime date,
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
                            hour,
                            minute,
                            doc_title,
                            id,
                            isChecked_pushalarmwhat,
                            date))),
              )),
        );
      });
}

SheetPage(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  String hour,
  String minute,
  String doc_title,
  String id,
  int isChecked_pushalarmwhat,
  DateTime date,
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
              content(context, setalarmhourNode, setalarmminuteNode, hour,
                  minute, doc_title, id, isChecked_pushalarmwhat, date),
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
                        text: ' 일정의 알람 설정',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize()))
                  ]))
              : RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                        text: '알람 설정',
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
  String hour,
  String minute,
  String doc_title,
  String id,
  int isChecked_pushalarmwhat,
  DateTime date,
) {
  DateTime now = DateTime.now();
  final controll_cal = Get.put(calendarsetting());
  TimeOfDay? pickednow;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  final cal_share_person = Get.put(PeopleAdd());

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
                        text: '알람은 설정하신 시각에 울리게 됩니다',
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
        GetBuilder<calendarsetting>(
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
                                        initialTime:
                                            controll_cal.hour1 == '99' &&
                                                    controll_cal.minute1 == '99'
                                                ? TimeOfDay.now()
                                                : TimeOfDay(
                                                    hour: int.parse(
                                                        controll_cal.hour1),
                                                    minute: int.parse(
                                                        controll_cal.minute1)));
                                    if (pickednow != null) {
                                      if (doc_title != '') {
                                        controll_cal.settimeminute(
                                            pickednow!.hour,
                                            pickednow!.minute,
                                            doc_title,
                                            id);
                                      } else {
                                        controll_cal.settimeminute(
                                            pickednow!.hour,
                                            pickednow!.minute,
                                            '',
                                            '');
                                      }
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
                              ? (controll_cal.hour1 != '99' ||
                                      controll_cal.minute1 != '99'
                                  ? Text(
                                      '설정시간 : ' +
                                          controll_cal.hour1 +
                                          '시 ' +
                                          controll_cal.minute1 +
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
                              : (controll_cal.hour1 != '99' ||
                                      controll_cal.minute1 != '99'
                                  ? Text(
                                      '설정시간 : ' +
                                          controll_cal.hour1 +
                                          '시 ' +
                                          controll_cal.minute1 +
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
                                    )),
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
                                          Get.back();
                                          Snack.show(
                                              context: context,
                                              title: '알림',
                                              content: '알람설정 완료',
                                              snackType: SnackType.info,
                                              behavior:
                                                  SnackBarBehavior.floating);
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
                                          controll_cal.setalarmcal(
                                              doc_title, id);
                                          Get.back();
                                          Snack.show(
                                              context: context,
                                              title: '알림',
                                              content: '알람해제 완료!',
                                              snackType: SnackType.info,
                                              behavior:
                                                  SnackBarBehavior.floating);
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
