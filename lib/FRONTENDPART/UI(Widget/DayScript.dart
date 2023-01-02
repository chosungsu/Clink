// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:clickbyme/Enums/Variables.dart';
import 'package:clickbyme/LocalNotiPlatform/NotificationApi.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/MemoFocusedHolder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../Enums/Event.dart';
import '../../../Enums/MemoList.dart';
import '../../../FRONTENDPART/Route/subuiroute.dart';
import '../../../Tool/AndroidIOS.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/navibool.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/Getx/uisetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/Loader.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/lunarToSolar.dart';
import '../../../sheets/addcalendarrepeat.dart';
import '../../../sheets/addmemocollection.dart';
import '../../../sheets/pushalarmsettingcal.dart';
import 'CalendarView.dart';

class DayScript extends StatefulWidget {
  const DayScript(
      {Key? key,
      required this.position,
      required this.id,
      required this.isfromwhere})
      : super(key: key);
  final String position;
  final String id;
  final String isfromwhere;
  @override
  State<StatefulWidget> createState() => _DayScriptState();
}

class _DayScriptState extends State<DayScript> {
  //공통변수
  bool isresponsible = false;
  final imagePicker = ImagePicker();
  List<FocusNode> focusnodelist =
      List<FocusNode>.generate(5, ((index) => FocusNode()));
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  late TextEditingController textEditingController5;
  final draw = Get.put(navibool());
  //캘린더변수
  late Map<DateTime, List<Event>> _events;
  static final cal_share_person = Get.put(PeopleAdd());
  final controll_cal = Get.put(calendarsetting());
  final controll_memo = Get.put(memosetting());
  final cal = Get.put(calendarsetting());
  List finallist = cal_share_person.people;
  String selectedValue = '선택없음';
  bool isChecked_pushalarm = false;
  int differ_date = 0;
  List differ_list = [];
  List<bool> alarmtypes = [false, false];
  var isChecked_pushalarmwhat = 0;
  String hour = '';
  String minute = '';
  final setalarmhourNode = FocusNode();
  final setalarmminuteNode = FocusNode();
  List valueid = [];
  //메모변수
  int _currentValue = 1;
  final scollection = Get.put(selectcollection());
  late TextEditingController textEditingController_add_sheet;
  List<TextEditingController> controllers = List.empty(growable: true);
  List savepicturelist = [];
  List<FocusNode> nodes = [];
  List<bool> checkbottoms = [
    false,
    false,
    false,
  ];
  List<bool> checkdayyang = [
    true,
    false,
  ];
  bool ischeckedtohideminus = false;
  List<MemoList> checklisttexts = [];
  Color _color = Colors.white;
  Color _colorfont = Colors.black;
  List<int> lunar = [];
  List<int> solar = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    selectedDay = controll_cal.selectedDay;
    controll_cal.hour1 = '99';
    controll_cal.minute1 = '99';
    cal.repeatwhile = 'no';
    cal.repeatdate = 0;
    controll_memo.imagelist.clear();
    Hive.box('user_setting')
        .put('alarm_cal_hour_${cal_share_person.secondname}', '99');
    Hive.box('user_setting')
        .put('alarm_cal_minute_${cal_share_person.secondname}', '99');
    Hive.box('user_setting').put('typecolorcalendar', null);
    Hive.box('user_setting').put('coloreachmemo', Colors.white.value.toInt());
    controll_memo.color = Color(Hive.box('user_setting').get('coloreachmemo'));
    Hive.box('user_setting')
        .put('coloreachmemofont', Colors.black.value.toInt());
    controll_memo.colorfont =
        Color(Hive.box('user_setting').get('coloreachmemofont'));
    _color = controll_memo.color;
    _colorfont = controll_memo.colorfont;
    checklisttexts.clear();
    scollection.controllersall.clear();
    scollection.memolistin.clear();
    scollection.memolistcontentin.clear();
    scollection.memoindex = 0;
    Hive.box('user_setting').put('share_cal_person', '');
    cal_share_person.people = [];
    finallist = cal_share_person.people;
    textEditingController1 = TextEditingController();
    if (widget.position == 'note') {
      textEditingController2 = TextEditingController();
      textEditingController3 = TextEditingController();
    } else {
      textEditingController2 = TextEditingController(text: '하루종일 일정');
      textEditingController3 = TextEditingController(text: '하루종일 일정');
    }
    textEditingController4 = TextEditingController();
    textEditingController5 = TextEditingController();
    textEditingController_add_sheet = TextEditingController();
    _events = {};
    ischeckedtohideminus = controll_memo.ischeckedtohideminus;
    scollection.collection = '';
    selectedValue = Hive.box('user_setting').get('alarming_time') ?? '5분 전';
  }

  void autosavelogic() {
    setState(() {
      uisetting().setloading(true);
    });
    var firsttxt = '0' +
        textEditingController2.text +
        ' - 0' +
        textEditingController3.text;
    var secondtxt =
        '0' + textEditingController2.text + ' - ' + textEditingController3.text;
    var thirdtxt =
        textEditingController2.text + ' - 0' + textEditingController3.text;
    var forthtxt =
        textEditingController2.text + ' - ' + textEditingController3.text;
    if (textEditingController1.text.isNotEmpty) {
      if (widget.position == 'cal') {
        controll_cal.selectedDay != controll_cal.selectedDay
            ? differ_date = int.parse(controll_cal.selectedDay
                .difference(DateTime.parse(controll_cal.selectedDay.toString()))
                .inDays
                .toString())
            : (cal.repeatwhile != 'no'
                ? differ_date = cal.repeatdate
                : differ_date = 0);
        if (differ_date == 0) {
        } else {
          for (int i = 0; i <= differ_date; i++) {
            if (differ_date == 0) {
            } else {
              controll_cal.selectedDay != controll_cal.selectedDay
                  ? differ_list.add(DateTime(
                      controll_cal.selectedDay.year,
                      controll_cal.selectedDay.month,
                      controll_cal.selectedDay.day + i))
                  : (cal.repeatwhile == '주'
                      ? differ_list.add(DateTime(
                          controll_cal.selectedDay.year,
                          controll_cal.selectedDay.month,
                          controll_cal.selectedDay.day + 7 * i))
                      : (cal.repeatwhile == '월'
                          ? differ_list.add(DateTime(
                              controll_cal.selectedDay.year,
                              controll_cal.selectedDay.month + i,
                              controll_cal.selectedDay.day))
                          : differ_list.add(DateTime(
                              controll_cal.selectedDay.year + i,
                              controll_cal.selectedDay.month,
                              controll_cal.selectedDay.day))));
            }
          }
        }
        firestore.collection('AppNoticeByUsers').add({
          'title': '[' +
              controll_cal.calname +
              '] 캘린더의 일정 ${textEditingController1.text}이(가) 추가되었습니다.',
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
          'sharename': controll_cal.share,
          'read': 'no',
        }).whenComplete(() async {
          if (differ_list.isNotEmpty) {
            if (isChecked_pushalarm) {
              NotificationApi.showNotification(
                title: '알람설정된 일정 : ' + textEditingController1.text,
                body: textEditingController2.text.split(':')[0].length == 1
                    ? (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + firsttxt
                        : '예정된 시각 : ' + secondtxt)
                    : (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + thirdtxt
                        : '예정된 시각 : ' + forthtxt),
              );
            }
            setState(() {
              uisetting().setloading(false);
            });
            Snack.snackbars(
                context: context,
                title: '저장완료함',
                backgroundcolor: Colors.green,
                bordercolor: draw.backgroundcolor);
            Future.delayed(const Duration(seconds: 1), () {
              Get.back();
            });
            if (cal.repeatwhile != 'no') {
              code = String.fromCharCodes(Iterable.generate(
                  5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
            }
            for (int h = 0; h < differ_list.length; h++) {
              await firestore.collection('CalendarDataBase').add({
                'code': code,
                'whenrepeat': cal.repeatwhile,
                'whattimecnt': cal.repeatdate,
                'Daytodo': textEditingController1.text,
                'Alarm': isChecked_pushalarm == true
                    ? Hive.box('user_setting').get('alarming_time')
                    : '설정off',
                'Timestart': textEditingController2.text == '하루종일 일정'
                    ? textEditingController2.text + '으로 기록'
                    : (textEditingController2.text.split(':')[0].length == 1
                        ? (textEditingController2.text.split(':')[1].length == 1
                            ? '0' + textEditingController2.text + '0'
                            : '0' + textEditingController2.text)
                        : (textEditingController2.text.split(':')[1].length == 1
                            ? textEditingController2.text + '0'
                            : textEditingController2.text)),
                'Timefinish': textEditingController3.text == '하루종일 일정'
                    ? textEditingController3.text + '으로 기록'
                    : (textEditingController3.text.split(':')[0].length == 1
                        ? (textEditingController3.text.split(':')[1].length == 1
                            ? '0' + textEditingController3.text + '0'
                            : '0' + textEditingController3.text)
                        : (textEditingController3.text.split(':')[1].length == 1
                            ? textEditingController3.text + '0'
                            : textEditingController3.text)),
                'Shares': controll_cal.share,
                'OriginalUser': usercode,
                'calname': widget.id,
                'summary': textEditingController5.text,
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
                    .doc(cal_share_person.secondname)
                    .set({
                  'alarmtype': alarmtypes,
                  'alarmhour': controll_cal.hour1,
                  'alarmminute': controll_cal.minute1,
                  'alarmmake': isChecked_pushalarm,
                  'calcode': value.id
                });
                for (int k = 0; k < controll_cal.share.length; k++) {
                  if (controll_cal.share[k] != cal_share_person.secondname) {
                    firestore
                        .collection('CalendarDataBase')
                        .doc(value.id)
                        .collection('AlarmTable')
                        .doc(controll_cal.share[k])
                        .get()
                        .then((value1) {
                      if (value1.exists) {
                      } else {
                        firestore
                            .collection('CalendarDataBase')
                            .doc(value.id)
                            .collection('AlarmTable')
                            .doc(controll_cal.share[k])
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
                            int.parse(cal_share_person.secondname.hashCode
                                .toString()),
                        title: textEditingController1.text + '일정이 다가옵니다',
                        body:
                            textEditingController2.text.split(':')[0].length ==
                                    1
                                ? (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + firsttxt
                                    : '예정된 시각 : ' + secondtxt)
                                : (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + thirdtxt
                                    : '예정된 시각 : ' + forthtxt),
                        payload: widget.id,
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
                          int.parse(controll_cal.hour1),
                          int.parse(controll_cal.minute1),
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
                            int.parse(cal_share_person.secondname.hashCode
                                .toString()),
                        title: textEditingController1.text + '일정이 다가옵니다',
                        body:
                            textEditingController2.text.split(':')[0].length ==
                                    1
                                ? (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + firsttxt
                                    : '예정된 시각 : ' + secondtxt)
                                : (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + thirdtxt
                                    : '예정된 시각 : ' + forthtxt),
                        payload: widget.id,
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
                          int.parse(controll_cal.hour1),
                          int.parse(controll_cal.minute1),
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
              'Daytodo': textEditingController1.text,
              'Alarm': isChecked_pushalarm == true
                  ? Hive.box('user_setting').get('alarming_time')
                  : '설정off',
              'Timestart': textEditingController2.text == '하루종일 일정'
                  ? textEditingController2.text + '으로 기록'
                  : (textEditingController2.text.split(':')[0].length == 1
                      ? (textEditingController2.text.split(':')[1].length == 1
                          ? '0' + textEditingController2.text + '0'
                          : '0' + textEditingController2.text)
                      : (textEditingController2.text.split(':')[1].length == 1
                          ? textEditingController2.text + '0'
                          : textEditingController2.text)),
              'Timefinish': textEditingController3.text == '하루종일 일정'
                  ? textEditingController3.text + '으로 기록'
                  : (textEditingController3.text.split(':')[0].length == 1
                      ? (textEditingController3.text.split(':')[1].length == 1
                          ? '0' + textEditingController3.text + '0'
                          : '0' + textEditingController3.text)
                      : (textEditingController3.text.split(':')[1].length == 1
                          ? textEditingController3.text + '0'
                          : textEditingController3.text)),
              'Shares': controll_cal.share,
              'OriginalUser': usercode,
              'calname': widget.id,
              'summary': textEditingController5.text,
              'Date': DateFormat('yyyy-MM-dd')
                      .parse(controll_cal.selectedDay.toString())
                      .toString()
                      .split(' ')[0] +
                  '일',
            });
            setState(() {
              uisetting().setloading(false);
            });
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
                .where('calname', isEqualTo: widget.id)
                .where('Daytodo', isEqualTo: textEditingController1.text)
                .get()
                .then((value) {
              for (int i = 0; i < value.docs.length; i++) {
                valueid.add(value.docs[i].id);
                firestore
                    .collection('CalendarDataBase')
                    .doc(valueid[i])
                    .collection('AlarmTable')
                    .doc(cal_share_person.secondname)
                    .set({
                  'alarmtype': alarmtypes,
                  'alarmhour': controll_cal.hour1,
                  'alarmminute': controll_cal.minute1,
                  'alarmmake': isChecked_pushalarm,
                  'calcode': valueid[i]
                });
              }

              for (int j = 0; j < valueid.length; j++) {
                for (int k = 0; k < controll_cal.share.length; k++) {
                  if (controll_cal.share[k] != cal_share_person.secondname) {
                    firestore
                        .collection('CalendarDataBase')
                        .doc(valueid[j])
                        .collection('AlarmTable')
                        .doc(controll_cal.share[k])
                        .get()
                        .then((value) {
                      if (value.exists) {
                      } else {
                        firestore
                            .collection('CalendarDataBase')
                            .doc(valueid[j])
                            .collection('AlarmTable')
                            .doc(controll_cal.share[k])
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
                      title: '알람설정된 일정 : ' + textEditingController1.text,
                      body: textEditingController2.text.split(':')[0].length ==
                              1
                          ? (textEditingController3.text.split(':')[0].length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (textEditingController3.text.split(':')[0].length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                    );
                    NotificationApi.showScheduledNotification(
                        id: int.parse(controll_cal.selectedDay
                                .toString()
                                .split(' ')[0]
                                .split('-')[0]) +
                            int.parse(controll_cal.selectedDay
                                .toString()
                                .split(' ')[0]
                                .split('-')[1]) +
                            int.parse(valueid[j].hashCode.toString()) +
                            int.parse(cal_share_person.secondname.hashCode
                                .toString()),
                        title: textEditingController1.text + '일정이 다가옵니다',
                        body:
                            textEditingController2.text.split(':')[0].length ==
                                    1
                                ? (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + firsttxt
                                    : '예정된 시각 : ' + secondtxt)
                                : (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + thirdtxt
                                    : '예정된 시각 : ' + forthtxt),
                        payload: widget.id,
                        scheduledate: DateTime.utc(
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(0, 4)),
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(5, 7)),
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(8, 10)),
                          int.parse(controll_cal.hour1),
                          int.parse(controll_cal.minute1),
                        ));
                  } else {
                    NotificationApi.showNotification(
                      title: '알람설정된 일정 : ' + textEditingController1.text,
                      body: textEditingController2.text.split(':')[0].length ==
                              1
                          ? (textEditingController3.text.split(':')[0].length ==
                                  1
                              ? '예정된 시각 : ' + firsttxt
                              : '예정된 시각 : ' + secondtxt)
                          : (textEditingController3.text.split(':')[0].length ==
                                  1
                              ? '예정된 시각 : ' + thirdtxt
                              : '예정된 시각 : ' + forthtxt),
                    );
                    NotificationApi.showScheduledNotification(
                        id: int.parse(controll_cal.selectedDay
                                .toString()
                                .split(' ')[0]
                                .split('-')[0]) +
                            int.parse(controll_cal.selectedDay
                                .toString()
                                .split(' ')[0]
                                .split('-')[1]) +
                            int.parse(valueid[j].hashCode.toString()) +
                            int.parse(cal_share_person.secondname.hashCode
                                .toString()),
                        title: textEditingController1.text + '일정이 다가옵니다',
                        body:
                            textEditingController2.text.split(':')[0].length ==
                                    1
                                ? (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + firsttxt
                                    : '예정된 시각 : ' + secondtxt)
                                : (textEditingController3.text
                                            .split(':')[0]
                                            .length ==
                                        1
                                    ? '예정된 시각 : ' + thirdtxt
                                    : '예정된 시각 : ' + forthtxt),
                        payload: widget.id,
                        scheduledate: DateTime.utc(
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(0, 4)),
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(5, 7)),
                          int.parse(controll_cal.selectedDay
                              .toString()
                              .toString()
                              .split(' ')[0]
                              .toString()
                              .substring(8, 10)),
                          int.parse(controll_cal.hour1),
                          int.parse(controll_cal.minute1),
                        ));
                  }
                }
              }
            });
          }
        });
      } else {
        firestore.collection('AppNoticeByUsers').add({
          'title': '메모 ${textEditingController1.text}이(가) 추가되었습니다.',
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
          'sharename': controll_cal.share,
          'read': 'no',
        }).whenComplete(() {
          for (int i = 0; i < scollection.memolistin.length; i++) {
            checklisttexts.add(MemoList(
                memocontent: scollection.memolistcontentin[i],
                contentindex: scollection.memolistin[i]));
          }
          firestore.collection('MemoDataBase').doc().set({
            'memoTitle': textEditingController1.text,
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
                _color.value.toInt(),
            'colorfont': Hive.box('user_setting').get('coloreachmemofont') ??
                _colorfont.value.toInt(),
            'Date': DateFormat('yyyy-MM-dd')
                    .parse(controll_cal.selectedDay.toString())
                    .toString()
                    .split(' ')[0] +
                '일',
            'homesave': false,
            'security': false,
            'photoUrl':
                controll_memo.imagelist.isEmpty ? [] : controll_memo.imagelist,
            'voicefile':
                controll_memo.voicelist.isEmpty ? [] : controll_memo.voicelist,
            'drawingfile': controll_memo.drawinglist.isEmpty
                ? []
                : controll_memo.drawinglist,
            'pinnumber': '0000',
            'securewith': 999,
            'EditDate': DateFormat('yyyy-MM-dd')
                    .parse(controll_cal.selectedDay.toString())
                    .toString()
                    .split(' ')[0] +
                '일',
          }, SetOptions(merge: true)).whenComplete(() {
            setState(() {
              uisetting().setloading(false);
            });
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
      setState(() {
        uisetting().setloading(false);
      });
      Snack.snackbars(
          context: context,
          title: '제목이 비어있어요!',
          backgroundcolor: Colors.red,
          bordercolor: draw.backgroundcolor);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
    textEditingController4.dispose();
    textEditingController5.dispose();
    textEditingController_add_sheet.dispose();
    for (int i = 0; i < scollection.controllersall.length; i++) {
      scollection.controllersall[i].dispose();
    }
  }

  Future<bool> _onBackPressed() async {
    final reloadpage = await Get.dialog(OSDialog(
            context,
            '경고',
            Text('뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: Colors.blueGrey)),
            pressed2)) ??
        false;
    if (reloadpage) {
      controll_cal.setclickday(selectedDay, selectedDay);
      Get.back();
    }
    return reloadpage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: BGColor(),
          resizeToAvoidBottomInset: true,
          body: GetBuilder<memosetting>(
            builder: (_) => WillPopScope(
                onWillPop: _onBackPressed,
                child: Stack(
                  children: [
                    UI(),
                    uisetting().loading == true
                        ? (widget.position == 'note'
                            ? const Loader(
                                wherein: 'note',
                              )
                            : const Loader(
                                wherein: 'cal',
                              ))
                        : Container()
                  ],
                )),
          )),
    );
  }

  UI() {
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<memosetting>(
          builder: (_) => LayoutBuilder(
                builder: ((context, constraint) {
                  return Responsivelayout(
                      constraint.maxWidth,
                      LSView(constraint.maxHeight),
                      PRView(constraint.maxHeight));
                }),
              ));
    }));
  }

  LSView(maxHeight) {
    return SizedBox(
      height: maxHeight,
      child: Container(
          decoration: BoxDecoration(
            color: widget.position == 'note'
                ? (_color == controll_memo.color ? _color : controll_memo.color)
                : BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ContainerDesign(
                            child: GestureDetector(
                              onTap: () async {
                                final reloadpage = await Get.dialog(OSDialog(
                                        context,
                                        '경고',
                                        Text(
                                            '뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: Colors.blueGrey)),
                                        pressed2)) ??
                                    false;
                                if (reloadpage) {
                                  controll_cal.setclickday(
                                      selectedDay, selectedDay);
                                  Get.back();
                                }
                              },
                              child: Icon(
                                Feather.chevron_left,
                                size: 30,
                                color: TextColor(),
                              ),
                            ),
                            color: draw.backgroundcolor),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        widget.position == 'cal'
                                            ? '새 일정 작성'
                                            : '새 메모 작성',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: secondTitleTextsize(),
                                          color: widget.position == 'note'
                                              ? (controll_memo.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : Colors.black)
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    widget.position == 'note'
                                        ? GetBuilder<memosetting>(
                                            builder: (_) => MFHolder(
                                                checkbottoms,
                                                nodes,
                                                scollection,
                                                _color,
                                                '',
                                                controll_memo
                                                    .ischeckedtohideminus,
                                                scollection.controllersall,
                                                _colorfont,
                                                controll_memo.imagelist))
                                        : const SizedBox(),
                                    widget.position == 'note'
                                        ? const SizedBox(
                                            width: 10,
                                          )
                                        : const SizedBox(),
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () async {
                                            autosavelogic();
                                          },
                                          child: Icon(
                                            Ionicons.checkmark_done,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                  ],
                                ))),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      for (int i = 0; i < focusnodelist.length; i++) {
                        if (i == 3) {
                        } else {
                          focusnodelist[i].unfocus();
                        }
                      }
                      for (int i = 0; i < scollection.memoindex; i++) {
                        if (nodes.isNotEmpty) {
                          nodes[i].unfocus();
                        }
                        scollection.memolistcontentin[i] =
                            scollection.controllersall[i].text;
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: SingleChildScrollView(
                                        physics: const ScrollPhysics(),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              buildSheetTitle(
                                                  controll_cal.selectedDay),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              WholeContent(),
                                              widget.position == 'cal'
                                                  ? const SizedBox(
                                                      height: 30,
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                              widget.position == 'cal'
                                                  ? SetTimeTitle()
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                              widget.position == 'cal'
                                                  ? const SizedBox(
                                                      height: 20,
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                              widget.position == 'cal'
                                                  ? Time()
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                              widget.position == 'cal'
                                                  ? const SizedBox(
                                                      height: 30,
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    ),
                                              const SizedBox(
                                                height: 50,
                                              )
                                            ],
                                          ),
                                        )))),
                            Flexible(
                                flex: 1,
                                child: ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: SingleChildScrollView(
                                      physics: const ScrollPhysics(),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            widget.position == 'cal'
                                                ? SetCalSummary()
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            widget.position == 'cal'
                                                ? const SizedBox(
                                                    height: 30,
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            widget.position == 'cal'
                                                ? buildAlarmTitleupdateversion()
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            widget.position == 'cal'
                                                ? const SizedBox(
                                                    height: 20,
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            widget.position == 'cal'
                                                ? Alarmupdateversion()
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            const SizedBox(
                                              height: 50,
                                            )
                                          ],
                                        ),
                                      ),
                                    ))),
                          ],
                        )),
                  )),
            ],
          )),
    );
  }

  PRView(maxHeight) {
    return SizedBox(
      height: maxHeight,
      child: Container(
          decoration: BoxDecoration(
            color: widget.position == 'note'
                ? (_color == controll_memo.color ? _color : controll_memo.color)
                : BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ContainerDesign(
                            child: GestureDetector(
                              onTap: () async {
                                final reloadpage = await Get.dialog(OSDialog(
                                        context,
                                        '경고',
                                        Text(
                                            '뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: Colors.blueGrey)),
                                        pressed2)) ??
                                    false;
                                if (reloadpage) {
                                  controll_cal.setclickday(
                                      selectedDay, selectedDay);
                                  Get.back();
                                }
                              },
                              child: Icon(
                                Feather.chevron_left,
                                size: 30,
                                color: TextColor(),
                              ),
                            ),
                            color: draw.backgroundcolor),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        widget.position == 'cal'
                                            ? '새 일정 작성'
                                            : '새 메모 작성',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: secondTitleTextsize(),
                                          color: widget.position == 'note'
                                              ? (controll_memo.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : Colors.black)
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    widget.position == 'note'
                                        ? GetBuilder<memosetting>(
                                            builder: (_) => MFHolder(
                                                checkbottoms,
                                                nodes,
                                                scollection,
                                                _color,
                                                '',
                                                controll_memo
                                                    .ischeckedtohideminus,
                                                scollection.controllersall,
                                                _colorfont,
                                                controll_memo.imagelist))
                                        : const SizedBox(),
                                    widget.position == 'note'
                                        ? const SizedBox(
                                            width: 10,
                                          )
                                        : const SizedBox(),
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () async {
                                            autosavelogic();
                                          },
                                          child: Icon(
                                            Ionicons.checkmark_done,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor)
                                  ],
                                ))),
                      ],
                    ),
                  )),
              Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () {
                      for (int i = 0; i < focusnodelist.length; i++) {
                        if (i == 3) {
                        } else {
                          focusnodelist[i].unfocus();
                        }
                      }
                      for (int i = 0; i < scollection.memoindex; i++) {
                        if (nodes.isNotEmpty) {
                          nodes[i].unfocus();
                        }
                        scollection.memolistcontentin[i] =
                            scollection.controllersall[i].text;
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ScrollConfiguration(
                            behavior: NoBehavior(),
                            child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      buildSheetTitle(controll_cal.selectedDay),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      WholeContent(),
                                      widget.position == 'cal'
                                          ? const SizedBox(
                                              height: 30,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? SetTimeTitle()
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? const SizedBox(
                                              height: 20,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? Time()
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? const SizedBox(
                                              height: 30,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? SetCalSummary()
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? const SizedBox(
                                              height: 30,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? buildAlarmTitleupdateversion()
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? const SizedBox(
                                              height: 20,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      widget.position == 'cal'
                                          ? Alarmupdateversion()
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      const SizedBox(
                                        height: 50,
                                      )
                                    ],
                                  ),
                                )))),
                  )),
            ],
          )),
    );
  }

  buildSheetTitle(DateTime fromDate) {
    return widget.position == 'cal'
        ? Text(
            '일정제목',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize(),
              color: widget.position == 'note'
                  ? (controll_memo.color == Colors.black
                      ? Colors.white
                      : Colors.black)
                  : TextColor(),
            ),
          )
        : Text(
            '메모제목',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize(),
              color: widget.position == 'note'
                  ? (controll_memo.color == Colors.black
                      ? Colors.white
                      : Colors.black)
                  : TextColor(),
            ),
          );
  }

  WholeContent() {
    return widget.position == 'cal'
        ? ContainerDesign(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: focusnodelist[0],
              style: TextStyle(fontSize: contentTextsize(), color: TextColor()),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '일정 제목 추가',
                hintStyle: TextStyle(
                    fontSize: contentTextsize(), color: Colors.grey.shade400),
              ),
              controller: textEditingController1,
            ),
            color: BGColor())
        : ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<memosetting>(
                    builder: (_) => ContainerDesign(
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          focusNode: focusnodelist[0],
                          style: TextStyle(
                              fontSize: contentTextsize(),
                              color: controll_memo.color == Colors.black
                                  ? Colors.white
                                  : controll_memo.colorfont),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            isCollapsed: true,
                            hintText: '메모 제목 추가',
                            hintStyle: TextStyle(
                                fontSize: contentTextsize(),
                                color: Colors.grey.shade400),
                          ),
                          controller: textEditingController1,
                        ),
                        color: controll_memo.color),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          '컬렉션 선택',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: widget.position == 'note'
                                ? (controll_memo.color == Colors.black
                                    ? Colors.white
                                    : Colors.black)
                                : Colors.black,
                          ),
                        ),
                      ),
                      IconBtn(
                        child: InkWell(
                            onTap: () {
                              for (int i = 0;
                                  i < scollection.memolistcontentin.length;
                                  i++) {
                                nodes[i].unfocus();
                                scollection.memolistcontentin[i] =
                                    scollection.controllersall[i].text;
                              }
                              addhashtagcollector(
                                  context,
                                  name,
                                  textEditingController_add_sheet,
                                  focusnodelist[4],
                                  'inside',
                                  scollection,
                                  isresponsible);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Click',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: widget.position == 'note'
                                      ? (controll_memo.color == Colors.black
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.black,
                                ),
                              ),
                            )),
                        color: widget.position == 'note'
                            ? (controll_memo.color == Colors.black
                                ? Colors.white
                                : Colors.black)
                            : Colors.black,
                      )
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<selectcollection>(
                    builder: (_) => SizedBox(
                        height: 30,
                        child: Text(
                          scollection.collection == '' ||
                                  scollection.collection == null
                              ? '지정된 컬렉션이 없습니다.'
                              : '지정한 컬렉션 이름 : ' + scollection.collection,
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        )),
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
                        color: widget.position == 'note'
                            ? (controll_memo.color == Colors.black
                                ? Colors.white
                                : Colors.black)
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '상단바의 ',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade400),
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.more_vert,
                          color: widget.position == 'note'
                              ? (controll_memo.color == Colors.black
                                  ? Colors.white
                                  : Colors.black)
                              : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '아이콘을 클릭하여 추가하세요',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade400),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<selectcollection>(
                      builder: (_) => scollection.memolistin.isNotEmpty
                          ? ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: scollection.memolistin.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  key: ValueKey(index),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          ReorderableDragStartListener(
                                            index: index,
                                            child: Icon(
                                              Icons.drag_indicator_outlined,
                                              color: controll_memo.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : _colorfont ==
                                                          controll_memo
                                                              .colorfont
                                                      ? _colorfont
                                                      : controll_memo.colorfont,
                                            ),
                                          ),
                                          scollection.memolistin[index] == 0
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      70,
                                                  child: GetBuilder<
                                                          memosetting>(
                                                      builder: (_) =>
                                                          ContainerDesign(
                                                              color:
                                                                  controll_memo
                                                                      .color,
                                                              child: TextField(
                                                                onChanged:
                                                                    (text) {
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index] = text;
                                                                },
                                                                minLines: null,
                                                                maxLines: null,
                                                                focusNode:
                                                                    nodes[
                                                                        index],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      contentTextsize(),
                                                                  color: controll_memo
                                                                              .color ==
                                                                          Colors
                                                                              .black
                                                                      ? Colors
                                                                          .white
                                                                      : controll_memo
                                                                          .colorfont,
                                                                ),
                                                                controller:
                                                                    scollection
                                                                            .controllersall[
                                                                        index],
                                                                decoration:
                                                                    InputDecoration(
                                                                  isCollapsed:
                                                                      true,
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  suffixIconConstraints:
                                                                      const BoxConstraints(
                                                                          maxWidth:
                                                                              30),
                                                                  suffixIcon:
                                                                      Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      controll_memo.ischeckedtohideminus ==
                                                                              true
                                                                          ? InkWell(
                                                                              onTap: () {},
                                                                              child: const SizedBox(width: 30),
                                                                            )
                                                                          : InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  scollection.removelistitem(index);
                                                                                  scollection.controllersall.removeAt(index);

                                                                                  for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                    scollection.controllersall[i].text = scollection.memolistcontentin[i];
                                                                                  }
                                                                                });
                                                                              },
                                                                              child: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                  hintText:
                                                                      '내용 입력',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          contentTextsize(),
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                              ))),
                                                )
                                              : (scollection.memolistin[index] ==
                                                          1 ||
                                                      scollection.memolistin[
                                                              index] ==
                                                          999
                                                  ? SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                      child:
                                                          GetBuilder<
                                                                  memosetting>(
                                                              builder: (_) =>
                                                                  ContainerDesign(
                                                                    color: controll_memo
                                                                        .color,
                                                                    child:
                                                                        TextField(
                                                                      minLines:
                                                                          1,
                                                                      maxLines:
                                                                          3,
                                                                      onChanged:
                                                                          (text) {
                                                                        scollection.memolistcontentin[index] =
                                                                            text;
                                                                      },
                                                                      focusNode:
                                                                          nodes[
                                                                              index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      textAlignVertical:
                                                                          TextAlignVertical
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              contentTextsize(),
                                                                          color: controll_memo.color == Colors.black
                                                                              ? Colors
                                                                                  .white
                                                                              : controll_memo
                                                                                  .colorfont,
                                                                          decorationThickness:
                                                                              2.3,
                                                                          decoration: scollection.memolistin[index] == 999
                                                                              ? TextDecoration.lineThrough
                                                                              : null),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isCollapsed:
                                                                            true,
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            const EdgeInsets.only(left: 10),
                                                                        border:
                                                                            InputBorder.none,
                                                                        prefixIcon:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              scollection.memolistin[index] == 999 ? scollection.memolistin[index] = 1 : scollection.memolistin[index] = 999;
                                                                            });
                                                                          },
                                                                          child: scollection.memolistin[index] == 999
                                                                              ? Icon(
                                                                                  Icons.check_box,
                                                                                  color: widget.position == 'note' ? (controll_memo.color == Colors.black ? Colors.white : Colors.black) : Colors.black,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.check_box_outline_blank,
                                                                                  color: widget.position == 'note' ? (controll_memo.color == Colors.black ? Colors.white : Colors.black) : Colors.black,
                                                                                ),
                                                                        ),
                                                                        suffixIconConstraints:
                                                                            const BoxConstraints(maxWidth: 30),
                                                                        suffixIcon:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            controll_memo.ischeckedtohideminus == true
                                                                                ? InkWell(
                                                                                    onTap: () {},
                                                                                    child: const SizedBox(
                                                                                      width: 30,
                                                                                    ),
                                                                                  )
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        scollection.removelistitem(index);
                                                                                        scollection.controllersall.removeAt(index);

                                                                                        for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                          scollection.controllersall[i].text = scollection.memolistcontentin[i];
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                        hintText:
                                                                            '내용 입력',
                                                                        hintStyle: TextStyle(
                                                                            fontSize:
                                                                                contentTextsize(),
                                                                            color:
                                                                                Colors.grey.shade400),
                                                                      ),
                                                                      controller:
                                                                          scollection
                                                                              .controllersall[index],
                                                                    ),
                                                                  )))
                                                  : SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                      child: GetBuilder<
                                                              memosetting>(
                                                          builder: (_) =>
                                                              ContainerDesign(
                                                                color:
                                                                    controll_memo
                                                                        .color,
                                                                child:
                                                                    TextField(
                                                                        onChanged:
                                                                            (text) {
                                                                          scollection.memolistcontentin[index] =
                                                                              text;
                                                                        },
                                                                        minLines:
                                                                            1,
                                                                        maxLines:
                                                                            3,
                                                                        focusNode:
                                                                            nodes[
                                                                                index],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        textAlignVertical:
                                                                            TextAlignVertical
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                contentTextsize(),
                                                                            color: controll_memo.color == Colors.black
                                                                                ? Colors
                                                                                    .white
                                                                                : controll_memo
                                                                                    .colorfont),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          isCollapsed:
                                                                              true,
                                                                          isDense:
                                                                              true,
                                                                          contentPadding:
                                                                              const EdgeInsets.only(left: 10),
                                                                          border:
                                                                              InputBorder.none,
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.star_rate,
                                                                            color: widget.position == 'note'
                                                                                ? (controll_memo.color == Colors.black ? Colors.white : Colors.black)
                                                                                : Colors.black,
                                                                          ),
                                                                          prefixIconColor: widget.position == 'note'
                                                                              ? (controll_memo.color == Colors.black ? Colors.white : Colors.black)
                                                                              : Colors.black,
                                                                          suffixIconConstraints:
                                                                              const BoxConstraints(maxWidth: 30),
                                                                          suffixIcon:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              controll_memo.ischeckedtohideminus == true
                                                                                  ? InkWell(
                                                                                      onTap: () {},
                                                                                      child: const SizedBox(width: 30),
                                                                                    )
                                                                                  : InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          scollection.removelistitem(index);
                                                                                          scollection.controllersall.removeAt(index);

                                                                                          for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                            scollection.controllersall[i].text = scollection.memolistcontentin[i];
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      child: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                          hintText:
                                                                              '내용 입력',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: contentTextsize(),
                                                                              color: Colors.grey.shade400),
                                                                        ),
                                                                        controller:
                                                                            scollection.controllersall[index]),
                                                              )))),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  String content_prev =
                                      scollection.memolistcontentin[oldIndex];
                                  int indexcontent_prev =
                                      scollection.memolistin[oldIndex];
                                  scollection.removelistitem(oldIndex);
                                  Hive.box('user_setting').put(
                                      'optionmemoinput', indexcontent_prev);
                                  Hive.box('user_setting').put(
                                      'optionmemocontentinput', content_prev);
                                  scollection.addmemolistin(newIndex);
                                  scollection.addmemolistcontentin(newIndex);
                                  for (int i = 0;
                                      i < scollection.memolistcontentin.length;
                                      i++) {
                                    scollection.controllersall[i].text =
                                        scollection.memolistcontentin[i];
                                  }
                                });
                              },
                              /*proxyDecorator: (Widget child, int index,
                            Animation<double> animation) {
                          return Material(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: TextColor_shadowcolor(),
                                      width: 1)),
                              child: child,
                            ),
                          );
                        },*/
                            )
                          : const SizedBox()),
                ],
              );
            },
          );
  }

  SetTimeTitle() {
    return SizedBox(
      height: 30,
      child: Text(
        '일정세부사항',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: widget.position == 'note'
              ? (controll_memo.color == Colors.black
                  ? Colors.white
                  : Colors.black)
              : TextColor(),
        ),
      ),
    );
  }

  Time() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          for (int i = 0; i < focusnodelist.length; i++) {
                            if (i == 3) {
                            } else {
                              focusnodelist[i].unfocus();
                            }
                          }
                          Future.delayed(const Duration(milliseconds: 300), () {
                            calendarView(context, widget.id, 'oncreate');
                          });
                        },
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
                                    color: widget.position == 'note'
                                        ? (controll_memo.color == Colors.black
                                            ? Colors.white
                                            : Colors.black)
                                        : TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                              title: GetBuilder<calendarsetting>(
                                builder: (_) => Text(
                                  controll_cal.selectedDay
                                      .toString()
                                      .split(' ')[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize(),
                                    color: widget.position == 'note'
                                        ? (controll_memo.color == Colors.black
                                            ? Colors.white
                                            : Colors.black)
                                        : TextColor(),
                                  ),
                                ),
                              )),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ContainerDesign(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (checkdayyang[1] == true) {
                                      checkdayyang[1] = false;
                                      checkdayyang[0] = true;
                                      solar = CalendarConverter.lunarToSolar(
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[0]),
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[1]),
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[2]),
                                          0,
                                          Timezone.Korean);
                                      controll_cal.selectedDay =
                                          DateFormat('yyyy-MM-dd').parse(
                                              solar[2].toString() +
                                                  '-' +
                                                  solar[1].toString() +
                                                  '-' +
                                                  solar[0].toString());
                                      controll_cal.focusedDay =
                                          controll_cal.selectedDay;
                                    } else {
                                      checkdayyang[0] = false;
                                      checkdayyang[1] = true;
                                      lunar = CalendarConverter.solarToLunar(
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[0]),
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[1]),
                                          int.parse(controll_cal.selectedDay
                                              .toString()
                                              .split(' ')[0]
                                              .split('-')[2]),
                                          Timezone.Korean);
                                      controll_cal.selectedDay =
                                          DateFormat('yyyy-MM-dd').parse(
                                              lunar[2].toString() +
                                                  '-' +
                                                  lunar[1].toString() +
                                                  '-' +
                                                  lunar[0].toString());
                                      controll_cal.focusedDay =
                                          controll_cal.selectedDay;
                                    }
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '양력',
                                      style: TextStyle(
                                          fontWeight: checkdayyang[0] == true
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: checkdayyang[0] == true
                                              ? contentTitleTextsize()
                                              : 16,
                                          color: widget.position == 'note'
                                              ? (controll_memo.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : Colors.black)
                                              : TextColor()),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '음력',
                                      style: TextStyle(
                                          fontWeight: checkdayyang[1] == true
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: checkdayyang[1] == true
                                              ? contentTitleTextsize()
                                              : 16,
                                          color: widget.position == 'note'
                                              ? (controll_memo.color ==
                                                      Colors.black
                                                  ? Colors.white
                                                  : Colors.black)
                                              : TextColor()),
                                    ),
                                  ],
                                ),
                              ),
                              color: BGColor())
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ContainerDesign(
                color: BGColor(),
                child: ListTile(
                  onTap: () {
                    pickDates(context, textEditingController2,
                        controll_cal.selectedDay);
                  },
                  leading: NeumorphicIcon(
                    Icons.schedule,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        surfaceIntensity: 0.5,
                        color: widget.position == 'note'
                            ? (controll_memo.color == Colors.black
                                ? Colors.white
                                : Colors.black)
                            : TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                  title: Text(
                    '일정시작시간',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: widget.position == 'note'
                            ? (controll_memo.color == Colors.black
                                ? Colors.white
                                : Colors.black)
                            : TextColor()),
                  ),
                  subtitle: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: widget.position == 'note'
                            ? (controll_memo.color == Colors.black
                                ? Colors.white
                                : Colors.black)
                            : TextColor()),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    controller: textEditingController2,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: ContainerDesign(
                  color: BGColor(),
                  child: ListTile(
                    onTap: () {
                      pickDates(context, textEditingController3,
                          controll_cal.selectedDay);
                    },
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: widget.position == 'note'
                              ? (controll_memo.color == Colors.black
                                  ? Colors.white
                                  : Colors.black)
                              : TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '일정종료시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: widget.position == 'note'
                              ? (controll_memo.color == Colors.black
                                  ? Colors.white
                                  : Colors.black)
                              : TextColor()),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: widget.position == 'note'
                              ? (controll_memo.color == Colors.black
                                  ? Colors.white
                                  : Colors.black)
                              : TextColor()),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController3,
                    ),
                  ),
                ),
              ),
              controll_cal.selectedDay == controll_cal.focusedDay
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              controll_cal.selectedDay == controll_cal.focusedDay
                  ? GetBuilder<calendarsetting>(
                      builder: (_) => SizedBox(
                            child: ContainerDesign(
                              color: BGColor(),
                              child: ListTile(
                                leading: NeumorphicIcon(
                                  Icons.sync,
                                  size: 30,
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      surfaceIntensity: 0.5,
                                      color: widget.position == 'note'
                                          ? (controll_memo.color == Colors.black
                                              ? Colors.white
                                              : Colors.black)
                                          : TextColor(),
                                      lightSource: LightSource.topLeft),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    for (int i = 0;
                                        i < focusnodelist.length;
                                        i++) {
                                      if (i == 3) {
                                      } else {
                                        focusnodelist[i].unfocus();
                                      }
                                    }
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      showrepeatdate(
                                          context,
                                          textEditingController4,
                                          focusnodelist[3]);
                                    });
                                  },
                                  child: Text(
                                    'Click',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color:
                                            controll_memo.color == Colors.black
                                                ? Colors.white
                                                : TextColor()),
                                  ),
                                ),
                                subtitle: cal.repeatwhile == 'no'
                                    ? Text(
                                        '설정값 없음',
                                        style: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: widget.position == 'note'
                                                ? (controll_memo.color ==
                                                        Colors.black
                                                    ? Colors.white
                                                    : Colors.black)
                                                : TextColor()),
                                      )
                                    : Text(
                                        cal.repeatwhile +
                                            '간반복 : ' +
                                            cal.repeatdate.toString() +
                                            '회 설정',
                                        style: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: widget.position == 'note'
                                                ? (controll_memo.color ==
                                                        Colors.black
                                                    ? Colors.white
                                                    : Colors.black)
                                                : TextColor()),
                                      ),
                                title: Text(
                                  '반복작성설정',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                      color: widget.position == 'note'
                                          ? (controll_memo.color == Colors.black
                                              ? Colors.white
                                              : Colors.black)
                                          : TextColor()),
                                ),
                              ),
                            ),
                          ))
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          );
        }));
  }

  SetCalSummary() {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '세부설명 작성',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize(),
              color: widget.position == 'note'
                  ? (controll_memo.color == Colors.black
                      ? Colors.white
                      : Colors.black)
                  : TextColor()),
        ),
        const SizedBox(
          height: 20,
        ),
        ContainerDesign(
            child: TextField(
              minLines: 5,
              maxLines: null,
              focusNode: focusnodelist[1],
              style: TextStyle(
                  fontSize: contentTextsize(),
                  color: widget.position == 'note'
                      ? (controll_memo.color == Colors.black
                          ? Colors.white
                          : Colors.black)
                      : TextColor()),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '일정에 대한 세부사항 작성',
                hintStyle: TextStyle(
                    fontSize: contentTextsize(), color: Colors.grey.shade400),
              ),
              controller: textEditingController5,
            ),
            color: BGColor())
      ],
    ));
  }

  buildAlarmTitleupdateversion() {
    return SizedBox(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            '알람설정',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: widget.position == 'note'
                    ? (controll_memo.color == Colors.black
                        ? Colors.white
                        : Colors.black)
                    : TextColor()),
          ),
        ),
        Transform.scale(
          scale: 1,
          child: Switch(
              activeColor: Colors.blue,
              inactiveThumbColor: widget.position == 'note'
                  ? (controll_memo.color == Colors.black
                      ? Colors.white
                      : Colors.black)
                  : TextColor(),
              inactiveTrackColor: Colors.grey.shade100,
              value: isChecked_pushalarm,
              onChanged: (bool val) {
                setState(() {
                  isChecked_pushalarm = val;
                });
              }),
        )
      ],
    ));
  }

  Alarmupdateversion() {
    return SizedBox(
        child: ContainerDesign(
      color: BGColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
              data: ThemeData(
                  disabledColor: TextColor(),
                  unselectedWidgetColor: TextColor()),
              child: CheckboxListTile(
                title: Text(
                  '하루전 알람',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: widget.position == 'note'
                          ? (controll_memo.color == Colors.black
                              ? Colors.white
                              : Colors.black)
                          : TextColor()),
                ),
                subtitle: Text(
                  '이 기능은 하루전날만 알람이 울립니다.',
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey.shade400,
                      overflow: TextOverflow.ellipsis),
                ),
                enabled: !isChecked_pushalarm == true ? false : true,
                value: alarmtypes[0],
                onChanged: (bool? value) {
                  setState(() {
                    if (alarmtypes[1] == true) {
                      alarmtypes[1] = false;
                      alarmtypes[0] = value!;
                    } else {
                      alarmtypes[0] = value!;
                    }
                    isChecked_pushalarmwhat = 0;
                  });
                },
                activeColor: BGColor(),
                checkColor: Colors.blue,
                selected: alarmtypes[0],
              )),
          Theme(
            data: ThemeData(
                disabledColor: TextColor(), unselectedWidgetColor: TextColor()),
            child: CheckboxListTile(
              title: Text(
                '당일 알람',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: widget.position == 'note'
                        ? (controll_memo.color == Colors.black
                            ? Colors.white
                            : Colors.black)
                        : TextColor()),
              ),
              subtitle: Text(
                '이 기능은 당일만 알람이 울립니다.',
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    overflow: TextOverflow.ellipsis),
              ),
              enabled: !isChecked_pushalarm == true ? false : true,
              value: alarmtypes[1],
              onChanged: (bool? value) {
                setState(() {
                  if (alarmtypes[0] == true) {
                    alarmtypes[0] = false;
                    alarmtypes[1] = value!;
                  } else {
                    alarmtypes[1] = value!;
                  }
                  isChecked_pushalarmwhat = 1;
                });
              },
              activeColor: BGColor(),
              checkColor: Colors.blue,
              selected: alarmtypes[1],
            ),
          ),
          const Divider(
            height: 30,
            color: Colors.grey,
            thickness: 1,
            indent: 15.0,
            endIndent: 15.0,
          ),
          ListTile(
            title: Text(
              '시간 설정',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: widget.position == 'note'
                      ? (controll_memo.color == Colors.black
                          ? Colors.white
                          : Colors.black)
                      : TextColor()),
            ),
            subtitle: Text(
              '우측 알람 아이콘 클릭',
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  overflow: TextOverflow.ellipsis),
            ),
            enabled: !isChecked_pushalarm == true ? false : true,
            trailing: IconButton(
              icon: Icon(
                Icons.alarm_add,
                color: TextColor(),
              ),
              onPressed: !isChecked_pushalarm == true
                  ? null
                  : () async {
                      /*await firestore
                    .collection('CalendarDataBase')
                    .doc(widget.id)
                    .get()
                    .then(
                  (value) {
                    if (value.exists) {
                      setState(() {
                        hour = value.data()!['alarmhour'].toString();
                        minute = value.data()!['alarmminute'].toString();
                      });
                    }
                  },
                );*/
                      hour = '99';
                      minute = '99';
                      pushalarmsettingcal(
                        context,
                        setalarmhourNode,
                        setalarmminuteNode,
                        hour,
                        minute,
                        '',
                        '',
                        isChecked_pushalarmwhat,
                        DateTime.now(),
                      );
                    },
            ),
          ),
          GetBuilder<calendarsetting>(
              builder: (_) => ListTile(
                    title: Text(
                      '설정된 시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: widget.position == 'note'
                              ? (controll_memo.color == Colors.black
                                  ? Colors.white
                                  : Colors.black)
                              : TextColor()),
                    ),
                    trailing: controll_cal.hour1 != '99' ||
                            controll_cal.minute1 != '99'
                        ? SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (controll_cal.hour1.toString().length < 2
                                    ? (controll_cal.minute1.toString().length <
                                            2
                                        ? Text(
                                            '0' +
                                                controll_cal.hour1.toString() +
                                                '시 ' +
                                                '0' +
                                                controll_cal.minute1
                                                    .toString() +
                                                '분',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: TextColor()),
                                          )
                                        : Text(
                                            '0' +
                                                controll_cal.hour1.toString() +
                                                '시 ' +
                                                controll_cal.minute1
                                                    .toString() +
                                                '분',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: TextColor()),
                                          ))
                                    : (controll_cal.minute1.toString().length <
                                            2
                                        ? Text(
                                            controll_cal.hour1.toString() +
                                                '시 ' +
                                                '0' +
                                                controll_cal.minute1
                                                    .toString() +
                                                '분',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: TextColor()),
                                          )
                                        : Text(
                                            controll_cal.hour1.toString() +
                                                '시 ' +
                                                controll_cal.minute1
                                                    .toString() +
                                                '분',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize(),
                                                color: TextColor()),
                                          )))
                                /*Text(
                                  controll_cal.hour1 + '시 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.grey.shade400),
                                ),
                                Text(
                                  controll_cal.minute1 + '분',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.grey.shade400),
                                ),*/
                              ],
                            ),
                          )
                        : Text(
                            '설정 안됨',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.grey.shade400),
                          ),
                  ))
        ],
      ),
    ));
  }
}

addhashtagcollector(
    BuildContext context,
    String username,
    TextEditingController textEditingController_add_sheet,
    FocusNode searchNode_add_section,
    String s,
    selectcollection scollection,
    bool isresponsive) {
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
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
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
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return GestureDetector(
                          onTap: () {
                            searchNode_add_section.unfocus();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SheetPagememoCollection(
                                  context,
                                  username,
                                  textEditingController_add_sheet,
                                  searchNode_add_section,
                                  s,
                                  scollection,
                                  isresponsive),
                            ],
                          ));
                    }),
                  ))),
        );
      }).whenComplete(() {
    textEditingController_add_sheet.clear();
  });
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
      if (minute.length == 1) {
        minute = '0' + minute;
      }
      timecontroller.text = '$hour:$minute';
    } else {
      timecontroller.text = '하루종일 일정';
    }
  });
}
