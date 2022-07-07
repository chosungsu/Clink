import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';

addCalendarTodo(
    BuildContext context,
    DateTime selectedDay,
    TextEditingController textEditingController1,
    TextEditingController textEditingController2,
    TextEditingController textEditingController3,
    GlobalKey<FormState> formkey) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 380,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SheetPage(context, selectedDay, textEditingController1,
              textEditingController2, textEditingController3, formkey),
        );
      });
}

SheetPage(
    BuildContext context,
    DateTime selectedDay,
    TextEditingController textEditingController1,
    TextEditingController textEditingController2,
    TextEditingController textEditingController3,
    GlobalKey<FormState> formkey) {
  return SizedBox(
    height: 380,
    child: Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20),
          child: Form(
              key: formkey,
              child: SizedBox(
                height: 380,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSheetTitle(selectedDay),
                      const SizedBox(
                        height: 20,
                      ),
                      buildTitle(textEditingController1),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            buildDateTimePicker(
                                context, selectedDay, textEditingController2, 'prev'),
                            const SizedBox(
                              width: 50,
                            ),
                            buildDateTimePicker(
                                context, selectedDay, textEditingController3, 'after'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Flexible(
                                flex: 2,
                                child: SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          side: const BorderSide(
                                            width: 0.5,
                                            color: Colors.red,
                                          )),
                                      onPressed: () {
                                        //이벤트 작성 취소
                                        Navigator.of(context).pop();
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
                                                '작성취소',
                                                style: const NeumorphicStyle(
                                                  shape: NeumorphicShape.flat,
                                                  depth: 3,
                                                  color: Colors.black45,
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
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      //이벤트 저장
                                      //saveForm();
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
                                              '저장하기',
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
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              )),
        )
      ],
    ),
  );
}

buildSheetTitle(DateTime fromDate) {
  return SizedBox(
    height: 30,
    child: Text(
      fromDate.day.toString() + '일의 일정을 기록해보세요!',
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
    ),
  );
}

buildTitle(TextEditingController titlecontroller) {
  return SizedBox(
    height: 30,
    child: TextFormField(
      style: const TextStyle(fontSize: 20),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: '일정 제목 추가',
      ),
      onFieldSubmitted: (_) {
        //saveForm();
      },
      controller: titlecontroller,
    ),
  );
}

buildDateTimePicker(BuildContext context, DateTime fromDate,
    TextEditingController timecontroller, String s) {
  return SizedBox(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          s == 'prev' ? 
          const SizedBox(
            height: 30,
            child: Text(
            '시작시각',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          )
          )
          :
          const SizedBox(
            height: 30,
            child: Text(
            '종료시각',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          )
          ),
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
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black45),
                            decoration:
                                const InputDecoration(hintText: '시간 : 분'),
                            readOnly: true,
                            controller: timecontroller,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickDates(context, timecontroller, fromDate);
                    },
                    child: const Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
          )
        ],
      ));
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
/*
Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 100,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black45),
                            decoration:
                                const InputDecoration(hintText: '시간 : 분'),
                            readOnly: true,
                            controller: timecontroller,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickDates(context, timecontroller, fromDate);
                    },
                    child: const Icon(Icons.arrow_drop_down),
                  )
                ],
              )
*/
  /*Future saveForm() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: textEditingController1.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }*/