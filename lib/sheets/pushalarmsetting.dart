import 'package:clickbyme/Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

pushalarmsetting(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  TextEditingController controller_hour,
  TextEditingController controller_minute,
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
                            controller_minute))),
              )),
        );
      });
}

SheetPage(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  TextEditingController controller_hour,
  TextEditingController controller_minute,
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
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(context, setalarmhourNode, setalarmminuteNode,
                  controller_hour, controller_minute),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('알람 설정',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize()))
    ],
  ));
}

content(
  BuildContext context,
  FocusNode setalarmhourNode,
  FocusNode setalarmminuteNode,
  TextEditingController controller_hour,
  TextEditingController controller_minute,
) {
  DateTime now = DateTime.now();
  final controll_memo = Get.put(memosetting());
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '매일 알람받기',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: Colors.black),
              ),
            ),
            GetBuilder<memosetting>(
                builder: (_) => Transform.scale(
                      scale: 0.7,
                      child: Switch(
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.black,
                          inactiveTrackColor: Colors.grey.shade400,
                          value: controll_memo.ischeckedpushmemoalarm,
                          onChanged: (bool val) {
                            setState(() {
                              controll_memo.ischeckedpushmemoalarm = val;
                              Hive.box('user_setting').put('alarm_memo',
                                  controll_memo.ischeckedpushmemoalarm);
                              controll_memo.setalarmmemo();
                            });
                          }),
                    ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<memosetting>(
            builder: (_) => controll_memo.ischeckedpushmemoalarm == true
                ? SizedBox(
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
                            Hive.box('user_setting').get('alarm_memo_hour') ==
                                        null ||
                                    Hive.box('user_setting')
                                            .get('alarm_memo_minute') ==
                                        null
                                ? Text(
                                    '설정시간 : 없음',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color: Colors.black),
                                  )
                                : Text(
                                    '설정시간 : ' +
                                        Hive.box('user_setting')
                                            .get('alarm_memo_hour') +
                                        '시 ' +
                                        Hive.box('user_setting')
                                            .get('alarm_memo_minute') +
                                        '분',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color: Colors.black),
                                  ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
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
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                ),
                                onPressed: () {
                                  /*
                                  controller_hour.text.toString(),
                                      controller_minute.text.toString()
                                  */
                                  controll_memo.setalarmmemotimetable(
                                      now.hour.toString(),
                                      now.minute.toString());
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          '변경하기',
                                          style: const NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Colors.white,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                : const SizedBox()),
      ],
    ));
  });
}
