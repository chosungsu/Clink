import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../Enums/MemoList.dart';
import '../../Enums/Variables.dart';
import '../../LocalNotiPlatform/NotificationApi.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/calendarsetting.dart';
import '../../Tool/Getx/memosetting.dart';

void savecalendarsandmemo(context, texteditingcontrollerlist, position, id) {
  final controllCal = Get.put(calendarsetting());
  final calSharePerson = Get.put(PeopleAdd());
  final controllMemo = Get.put(memosetting());

  uiset.setloading(true);
  var firsttxt = '0' +
      texteditingcontrollerlist[1].text +
      ' - 0' +
      texteditingcontrollerlist[2].text;
  var secondtxt = '0' +
      texteditingcontrollerlist[1].text +
      ' - ' +
      texteditingcontrollerlist[2].text;
  var thirdtxt = texteditingcontrollerlist[1].text +
      ' - 0' +
      texteditingcontrollerlist[2].text;
  var forthtxt = texteditingcontrollerlist[1].text +
      ' - ' +
      texteditingcontrollerlist[2].text;
  if (texteditingcontrollerlist[0].text.isNotEmpty) {
    if (position == 'cal') {
      controllCal.selectedDay != controllCal.selectedDay
          ? differ_date = int.parse(controllCal.selectedDay
              .difference(DateTime.parse(controllCal.selectedDay.toString()))
              .inDays
              .toString())
          : (controllCal.repeatwhile != 'no'
              ? differ_date = controllCal.repeatdate
              : differ_date = 0);
      for (int i = 0; i <= differ_date; i++) {
        if (differ_date == 0) {
        } else {
          controllCal.selectedDay != controllCal.selectedDay
              ? differ_list.add(DateTime(
                  controllCal.selectedDay.year,
                  controllCal.selectedDay.month,
                  controllCal.selectedDay.day + i))
              : (controllCal.repeatwhile == '주'
                  ? differ_list.add(DateTime(
                      controllCal.selectedDay.year,
                      controllCal.selectedDay.month,
                      controllCal.selectedDay.day + 7 * i))
                  : (controllCal.repeatwhile == '월'
                      ? differ_list.add(DateTime(
                          controllCal.selectedDay.year,
                          controllCal.selectedDay.month + i,
                          controllCal.selectedDay.day))
                      : differ_list.add(DateTime(
                          controllCal.selectedDay.year + i,
                          controllCal.selectedDay.month,
                          controllCal.selectedDay.day))));
        }
      }
      firestore.collection('AppNoticeByUsers').add({
        'title': '[' +
            controllCal.calname +
            '] 캘린더의 일정 ${texteditingcontrollerlist[0].text}이(가) 추가되었습니다.',
        'date': DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[0] +
            ' ' +
            DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[1]
                .split(':')[0] +
            ':' +
            DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[1]
                .split(':')[1],
        'username': name,
        'sharename': controllCal.share,
        'read': 'no',
      }).whenComplete(() async {
        if (differ_list.isNotEmpty) {
          if (isChecked_pushalarm) {
            NotificationApi.showNotification(
              title: '알람설정된 일정 : ' + texteditingcontrollerlist[0].text,
              body: texteditingcontrollerlist[1].text.split(':')[0].length == 1
                  ? (texteditingcontrollerlist[2].text.split(':')[0].length == 1
                      ? '예정된 시각 : ' + firsttxt
                      : '예정된 시각 : ' + secondtxt)
                  : (texteditingcontrollerlist[2].text.split(':')[0].length == 1
                      ? '예정된 시각 : ' + thirdtxt
                      : '예정된 시각 : ' + forthtxt),
            );
          }
          uiset.setloading(false);
          Snack.snackbars(
              context: context,
              title: '저장완료함',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
          if (controllCal.repeatwhile != 'no') {
            code = String.fromCharCodes(Iterable.generate(
                5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
          }
          for (int h = 0; h < differ_list.length; h++) {
            await firestore.collection('CalendarDataBase').add({
              'code': code,
              'whenrepeat': controllCal.repeatwhile,
              'whattimecnt': controllCal.repeatdate,
              'Daytodo': texteditingcontrollerlist[0].text,
              'Alarm': isChecked_pushalarm == true
                  ? Hive.box('user_setting').get('alarming_time')
                  : '설정off',
              'Timestart': texteditingcontrollerlist[1].text == '하루종일 일정'
                  ? texteditingcontrollerlist[1].text + '으로 기록'
                  : (texteditingcontrollerlist[1].text.split(':')[0].length == 1
                      ? (texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[1]
                                  .length ==
                              1
                          ? '0' + texteditingcontrollerlist[1].text + '0'
                          : '0' + texteditingcontrollerlist[1].text)
                      : (texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[1]
                                  .length ==
                              1
                          ? texteditingcontrollerlist[1].text + '0'
                          : texteditingcontrollerlist[1].text)),
              'Timefinish': texteditingcontrollerlist[2].text == '하루종일 일정'
                  ? texteditingcontrollerlist[2].text + '으로 기록'
                  : (texteditingcontrollerlist[2].text.split(':')[0].length == 1
                      ? (texteditingcontrollerlist[2]
                                  .text
                                  .split(':')[1]
                                  .length ==
                              1
                          ? '0' + texteditingcontrollerlist[2].text + '0'
                          : '0' + texteditingcontrollerlist[2].text)
                      : (texteditingcontrollerlist[2]
                                  .text
                                  .split(':')[1]
                                  .length ==
                              1
                          ? texteditingcontrollerlist[2].text + '0'
                          : texteditingcontrollerlist[2].text)),
              'Shares': controllCal.share,
              'OriginalUser': usercode,
              'calname': id,
              'summary': texteditingcontrollerlist[4].text,
              'Date': DateFormat('yyyy-MM-dd')
                      .parse(differ_list[h].toString())
                      .toString()
                      .split(' ')[0] +
                  '일',
            }).then((value) {
              firestore
                  .collection('CalendarDataBase')
                  .doc(value.id)
                  .collection('AlarmTable')
                  .doc(calSharePerson.secondname)
                  .set({
                'alarmtype': alarmtypes,
                'alarmhour': controllCal.hour1,
                'alarmminute': controllCal.minute1,
                'alarmmake': isChecked_pushalarm,
                'calcode': value.id
              });
              for (int k = 0; k < controllCal.share.length; k++) {
                if (controllCal.share[k] != calSharePerson.secondname) {
                  firestore
                      .collection('CalendarDataBase')
                      .doc(value.id)
                      .collection('AlarmTable')
                      .doc(controllCal.share[k])
                      .get()
                      .then((value1) {
                    if (value1.exists) {
                    } else {
                      firestore
                          .collection('CalendarDataBase')
                          .doc(value.id)
                          .collection('AlarmTable')
                          .doc(controllCal.share[k])
                          .set({
                        'alarmtype': alarmtypes,
                        'alarmhour': '99',
                        'alarmminute': '99',
                        'alarmmake': false,
                        'calcode': value.id
                      }, SetOptions(merge: true));
                    }
                  });
                }
              }
              if (isChecked_pushalarm) {
                if (alarmtypes[0] == true) {
                  NotificationApi.showScheduledNotification(
                      id: int.parse(differ_list[h]
                                  .toString()
                                  .split(' ')[0]
                                  .toString()
                                  .split('-')[0] +
                              differ_list[h]
                                  .toString()
                                  .split(' ')[0]
                                  .toString()
                                  .split('-')[1]) +
                          int.parse(value.id.hashCode.toString()) +
                          int.parse(
                              calSharePerson.secondname.hashCode.toString()),
                      title: texteditingcontrollerlist[0].text + '일정이 다가옵니다',
                      body: texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[0]
                                  .length ==
                              1
                          ? (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                      payload: id,
                      scheduledate: DateTime.utc(
                        int.parse(differ_list[h]
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(0, 4)),
                        int.parse(differ_list[h]
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(5, 7)),
                        int.parse(differ_list[h]
                                .toString()
                                .split(' ')[0]
                                .toString()
                                .substring(8, 10)) -
                            1,
                        int.parse(controllCal.hour1),
                        int.parse(controllCal.minute1),
                      ));
                } else {
                  NotificationApi.showScheduledNotification(
                      id: int.parse(differ_list[h]
                                  .toString()
                                  .split(' ')[0]
                                  .toString()
                                  .split('-')[0] +
                              differ_list[h]
                                  .toString()
                                  .split(' ')[0]
                                  .toString()
                                  .split('-')[1]) +
                          int.parse(value.id.hashCode.toString()) +
                          int.parse(
                              calSharePerson.secondname.hashCode.toString()),
                      title: texteditingcontrollerlist[0].text + '일정이 다가옵니다',
                      body: texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[0]
                                  .length ==
                              1
                          ? (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                      payload: id,
                      scheduledate: DateTime.utc(
                        int.parse(differ_list[h]
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(0, 4)),
                        int.parse(differ_list[h]
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(5, 7)),
                        int.parse(differ_list[h]
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(8, 10)),
                        int.parse(controllCal.hour1),
                        int.parse(controllCal.minute1),
                      ));
                }
              }
            });
          }
        } else {
          await firestore.collection('CalendarDataBase').add({
            'code': '',
            'whenrepeat': 'no',
            'whattimecnt': 0,
            'Daytodo': texteditingcontrollerlist[0].text,
            'Alarm': isChecked_pushalarm == true
                ? Hive.box('user_setting').get('alarming_time')
                : '설정off',
            'Timestart': texteditingcontrollerlist[1].text == '하루종일 일정'
                ? texteditingcontrollerlist[1].text + '으로 기록'
                : (texteditingcontrollerlist[1].text.split(':')[0].length == 1
                    ? (texteditingcontrollerlist[1].text.split(':')[1].length ==
                            1
                        ? '0' + texteditingcontrollerlist[1].text + '0'
                        : '0' + texteditingcontrollerlist[1].text)
                    : (texteditingcontrollerlist[1].text.split(':')[1].length ==
                            1
                        ? texteditingcontrollerlist[1].text + '0'
                        : texteditingcontrollerlist[1].text)),
            'Timefinish': texteditingcontrollerlist[2].text == '하루종일 일정'
                ? texteditingcontrollerlist[2].text + '으로 기록'
                : (texteditingcontrollerlist[2].text.split(':')[0].length == 1
                    ? (texteditingcontrollerlist[2].text.split(':')[1].length ==
                            1
                        ? '0' + texteditingcontrollerlist[2].text + '0'
                        : '0' + texteditingcontrollerlist[2].text)
                    : (texteditingcontrollerlist[2].text.split(':')[1].length ==
                            1
                        ? texteditingcontrollerlist[2].text + '0'
                        : texteditingcontrollerlist[2].text)),
            'Shares': controllCal.share,
            'OriginalUser': usercode,
            'calname': id,
            'summary': texteditingcontrollerlist[4].text,
            'Date': DateFormat('yyyy-MM-dd')
                    .parse(controllCal.selectedDay.toString())
                    .toString()
                    .split(' ')[0] +
                '일',
          });
          uiset.setloading(false);
          Snack.snackbars(
              context: context,
              title: '저장완료함',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
          firestore
              .collection('CalendarDataBase')
              .where('calname', isEqualTo: id)
              .where('Daytodo', isEqualTo: texteditingcontrollerlist[0].text)
              .get()
              .then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              valueid.add(value.docs[i].id);
              firestore
                  .collection('CalendarDataBase')
                  .doc(valueid[i])
                  .collection('AlarmTable')
                  .doc(calSharePerson.secondname)
                  .set({
                'alarmtype': alarmtypes,
                'alarmhour': controllCal.hour1,
                'alarmminute': controllCal.minute1,
                'alarmmake': isChecked_pushalarm,
                'calcode': valueid[i]
              });
            }

            for (int j = 0; j < valueid.length; j++) {
              for (int k = 0; k < controllCal.share.length; k++) {
                if (controllCal.share[k] != calSharePerson.secondname) {
                  firestore
                      .collection('CalendarDataBase')
                      .doc(valueid[j])
                      .collection('AlarmTable')
                      .doc(controllCal.share[k])
                      .get()
                      .then((value) {
                    if (value.exists) {
                    } else {
                      firestore
                          .collection('CalendarDataBase')
                          .doc(valueid[j])
                          .collection('AlarmTable')
                          .doc(controllCal.share[k])
                          .set({
                        'alarmtype': alarmtypes,
                        'alarmhour': '99',
                        'alarmminute': '99',
                        'alarmmake': false,
                        'calcode': valueid[j]
                      }, SetOptions(merge: true));
                    }
                  });
                }
              }
              if (isChecked_pushalarm == true) {
                if (alarmtypes[0] == true) {
                  NotificationApi.showNotification(
                    title: '알람설정된 일정 : ' + texteditingcontrollerlist[1].text,
                    body: texteditingcontrollerlist[1]
                                .text
                                .split(':')[0]
                                .length ==
                            1
                        ? (texteditingcontrollerlist[2]
                                    .text
                                    .split(':')[0]
                                    .length ==
                                1
                            ? '예정된 시각 : ' + firsttxt
                            : '예정된 시각 : ' + secondtxt)
                        : (texteditingcontrollerlist[2]
                                    .text
                                    .split(':')[0]
                                    .length ==
                                1
                            ? '예정된 시각 : ' + thirdtxt
                            : '예정된 시각 : ' + forthtxt),
                  );
                  NotificationApi.showScheduledNotification(
                      id: int.parse(controllCal.selectedDay
                              .toString()
                              .split(' ')[0]
                              .split('-')[0]) +
                          int.parse(controllCal.selectedDay
                              .toString()
                              .split(' ')[0]
                              .split('-')[1]) +
                          int.parse(valueid[j].hashCode.toString()) +
                          int.parse(
                              calSharePerson.secondname.hashCode.toString()),
                      title: texteditingcontrollerlist[0].text + '일정이 다가옵니다',
                      body: texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[0]
                                  .length ==
                              1
                          ? (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                      payload: id,
                      scheduledate: DateTime.utc(
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(0, 4)),
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(5, 7)),
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(8, 10)),
                        int.parse(controllCal.hour1),
                        int.parse(controllCal.minute1),
                      ));
                } else {
                  NotificationApi.showNotification(
                    title: '알람설정된 일정 : ' + texteditingcontrollerlist[0].text,
                    body: texteditingcontrollerlist[1]
                                .text
                                .split(':')[0]
                                .length ==
                            1
                        ? (texteditingcontrollerlist[2]
                                    .text
                                    .split(':')[0]
                                    .length ==
                                1
                            ? '예정된 시각 : ' + firsttxt
                            : '예정된 시각 : ' + secondtxt)
                        : (texteditingcontrollerlist[2]
                                    .text
                                    .split(':')[0]
                                    .length ==
                                1
                            ? '예정된 시각 : ' + thirdtxt
                            : '예정된 시각 : ' + forthtxt),
                  );
                  NotificationApi.showScheduledNotification(
                      id: int.parse(controllCal.selectedDay
                              .toString()
                              .split(' ')[0]
                              .split('-')[0]) +
                          int.parse(controllCal.selectedDay
                              .toString()
                              .split(' ')[0]
                              .split('-')[1]) +
                          int.parse(valueid[j].hashCode.toString()) +
                          int.parse(
                              calSharePerson.secondname.hashCode.toString()),
                      title: texteditingcontrollerlist[0].text + '일정이 다가옵니다',
                      body: texteditingcontrollerlist[1]
                                  .text
                                  .split(':')[0]
                                  .length ==
                              1
                          ? (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (texteditingcontrollerlist[2]
                                      .text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                      payload: id,
                      scheduledate: DateTime.utc(
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(0, 4)),
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(5, 7)),
                        int.parse(controllCal.selectedDay
                            .toString()
                            .toString()
                            .split(' ')[0]
                            .toString()
                            .substring(8, 10)),
                        int.parse(controllCal.hour1),
                        int.parse(controllCal.minute1),
                      ));
                }
              }
            }
          });
        }
      });
    } else {
      firestore.collection('AppNoticeByUsers').add({
        'title': '메모 ${texteditingcontrollerlist[0].text}이(가) 추가되었습니다.',
        'date': DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[0] +
            ' ' +
            DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[1]
                .split(':')[0] +
            ':' +
            DateFormat('yyyy-MM-dd hh:mm')
                .parse(DateTime.now().toString())
                .toString()
                .split(' ')[1]
                .split(':')[1],
        'username': name,
        'sharename': controllCal.share,
        'read': 'no',
      }).whenComplete(() {
        for (int i = 0; i < scollection.memolistin.length; i++) {
          checklisttexts.add(MemoList(
              memocontent: scollection.memolistcontentin[i],
              contentindex: scollection.memolistin[i]));
        }
        firestore.collection('MemoDataBase').doc().set({
          'memoTitle': texteditingcontrollerlist[0].text,
          'Collection':
              scollection.collection == '' || scollection.collection == null
                  ? null
                  : scollection.collection,
          'memolist': checklisttexts.map((e) => e.memocontent).toList(),
          'memoindex': checklisttexts.map((e) => e.contentindex).toList(),
          'OriginalUser': usercode,
          'alarmok': false,
          'alarmtime': '99:99',
          'color': Hive.box('user_setting').get('coloreachmemo') ??
              color.value.toInt(),
          'colorfont': Hive.box('user_setting').get('coloreachmemofont') ??
              colorfont.value.toInt(),
          'Date': DateFormat('yyyy-MM-dd')
                  .parse(controllCal.selectedDay.toString())
                  .toString()
                  .split(' ')[0] +
              '일',
          'homesave': false,
          'security': false,
          'photoUrl':
              controllMemo.imagelist.isEmpty ? [] : controllMemo.imagelist,
          'voicefile':
              controllMemo.voicelist.isEmpty ? [] : controllMemo.voicelist,
          'drawingfile':
              controllMemo.drawinglist.isEmpty ? [] : controllMemo.drawinglist,
          'pinnumber': '0000',
          'securewith': 999,
          'EditDate': DateFormat('yyyy-MM-dd')
                  .parse(controllCal.selectedDay.toString())
                  .toString()
                  .split(' ')[0] +
              '일',
        }, SetOptions(merge: true)).whenComplete(() {
          uiset.setloading(false);
          Snack.snackbars(
              context: context,
              title: '저장완료함',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        });
      });
    }
  } else {
    uiset.setloading(false);
    Snack.snackbars(
        context: context,
        title: '제목이 비어있어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  }
}
