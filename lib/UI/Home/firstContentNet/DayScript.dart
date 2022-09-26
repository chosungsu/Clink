import 'dart:io';
import 'package:clickbyme/LocalNotiPlatform/NotificationApi.dart';
import 'package:clickbyme/UI/Home/Widgets/ImageSlider.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:clickbyme/UI/Home/Widgets/MemoFocusedHolder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../DB/Event.dart';
import '../../../DB/MemoList.dart';
import '../../../Dialogs/destroyBackKey.dart';
import '../../../Tool/AndroidIOS.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/Loader.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/addmemocollection.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../sheets/pushalarmsettingcal.dart';
import '../../Sign/UserCheck.dart';

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key,
      required this.firstdate,
      required this.position,
      required this.title,
      required this.share,
      required this.orig,
      required this.lastdate,
      required this.calname,
      required this.isfromwhere})
      : super(key: key);
  final DateTime firstdate;
  final DateTime lastdate;
  final String position;
  final String title;
  final String orig;
  final List share;
  final String calname;
  final String isfromwhere;
  @override
  State<StatefulWidget> createState() => _DayScriptState();
}

class _DayScriptState extends State<DayScript> {
  //공통변수
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool loading = false;
  final DateTime _selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  late FToast fToast;
  bool isresponsible = false;
  bool iskeyboardup = false;
  final imagePicker = ImagePicker();
  final searchNode_first_section = FocusNode();
  final searchNode_second_section = FocusNode();
  final searchNode_third_section = FocusNode();
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  late TextEditingController textEditingController5;
  //캘린더변수
  late Map<DateTime, List<Event>> _events;
  static final cal_share_person = Get.put(PeopleAdd());
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
  final List<bool> _ischecked_alarmslist = [false, false];
  //메모변수
  int _currentValue = 1;
  final scollection = Get.put(selectcollection());
  final searchNode_add_section = FocusNode();
  late TextEditingController textEditingController_add_sheet;
  List<TextEditingController> controllers = List.empty(growable: true);
  List savepicturelist = [];
  List<FocusNode> nodes = [];
  List<bool> checkbottoms = [
    false,
    false,
    false,
  ];
  bool ischeckedtohideminus = false;
  bool reloadpage = false;
  List<MemoList> checklisttexts = [];
  Color _color = Colors.white;
  Color _colorfont = Colors.black;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
    controll_memo.imagelist.clear();
    _color = controll_memo.color;
    _colorfont = controll_memo.colorfont;
    checklisttexts.clear();
    controllers.clear();
    scollection.memolistin.clear();
    scollection.memolistcontentin.clear();
    scollection.memoindex = 0;
    Hive.box('user_setting').put('share_cal_person', '');
    cal_share_person.people = [];
    finallist = cal_share_person.people;
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
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
      controll_memo.setloading(true);
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
      if (textEditingController2.text.isNotEmpty || widget.position == 'note') {
        //await localnotification.notishow();
        if (widget.position == 'cal') {
          firestore.collection('AppNoticeByUsers').add({
            'title': '[' +
                widget.calname +
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
            'username': username,
            'sharename': widget.share,
            'read': 'no',
          }).whenComplete(() async {
            widget.lastdate != widget.firstdate
                ? differ_date = int.parse(widget.lastdate
                    .difference(DateTime.parse(widget.firstdate.toString()))
                    .inDays
                    .toString())
                : (cal.repeatdate != 1
                    ? differ_date = cal.repeatdate - 1
                    : differ_date = 0);
            for (int i = 0; i <= differ_date; i++) {
              if (differ_date == 0) {
              } else {
                widget.lastdate != widget.firstdate
                    ? differ_list.add(DateTime(widget.firstdate.year,
                        widget.firstdate.month, widget.firstdate.day + i))
                    : differ_list.add(DateTime(widget.firstdate.year,
                        widget.firstdate.month, widget.firstdate.day + 7 * i));
              }
            }
            if (differ_list.isNotEmpty) {
              //calendarsetting().setalarmtype(widget.id, alarmtypes);
              for (int j = 0; j < differ_list.length; j++) {
                await firestore.collection('CalendarDataBase').add({
                  'Daytodo': textEditingController1.text,
                  'Alarm': isChecked_pushalarm == true
                      ? Hive.box('user_setting').get('alarming_time')
                      : '설정off',
                  'Timestart':
                      textEditingController2.text.split(':')[0].length == 1
                          ? '0' + textEditingController2.text
                          : textEditingController2.text,
                  'Timefinish':
                      textEditingController3.text.split(':')[0].length == 1
                          ? '0' + textEditingController3.text
                          : textEditingController3.text,
                  'Shares': widget.share,
                  'OriginalUser': widget.orig,
                  'calname': widget.title,
                  'summary': textEditingController5.text,
                  'Date': DateFormat('yyyy-MM-dd')
                          .parse(differ_list[j].toString())
                          .toString()
                          .split(' ')[0] +
                      '일',
                });
                firestore
                    .collection('CalendarDataBase')
                    .where('calname', isEqualTo: widget.title)
                    .where('Daytodo', isEqualTo: textEditingController1.text)
                    .get()
                    .then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    valueid.add(value.docs[i].id);
                  }
                  firestore
                      .collection('CalendarDataBase')
                      .doc(valueid[0])
                      .collection('AlarmTable')
                      .doc(cal_share_person.secondname)
                      .set({
                    'alarmtype': _ischecked_alarmslist,
                    'alarmhour': Hive.box('user_setting')
                        .get('alarm_cal_hour_${cal_share_person.secondname}'),
                    'alarmminute': Hive.box('user_setting')
                        .get('alarm_cal_minute_${cal_share_person.secondname}'),
                    'alarmmake': isChecked_pushalarm,
                    'calcode': valueid[0]
                  });
                  for (int j = 0; j < valueid.length; j++) {
                    for (int k = 0; k < widget.share.length; k++) {
                      firestore
                          .collection('CalendarDataBase')
                          .doc(valueid[j])
                          .collection('AlarmTable')
                          .doc(widget.share[k])
                          .get()
                          .then((value) {
                        if (value.exists) {
                        } else {
                          firestore
                              .collection('CalendarDataBase')
                              .doc(valueid[j])
                              .collection('AlarmTable')
                              .doc(widget.share[k])
                              .set({
                            'alarmtype': _ischecked_alarmslist,
                            'alarmhour': '99',
                            'alarmminute': '99',
                            'alarmmake': false,
                            'calcode': valueid[j]
                          }, SetOptions(merge: true));
                        }
                      });
                    }
                  }
                });
                NotificationApi.showScheduledNotification(
                    id: int.parse(DateFormat('yyyyMMdd').parse(differ_list[j]).toString()) + int.parse(textEditingController2.text.split(':')[1]) <
                            int.parse(selectedValue.substring(
                                0, selectedValue.length - 3))
                        ? int.parse(textEditingController2.text.split(':')[0].length == 1
                                ? '0' +
                                    textEditingController2.text.split(':')[0]
                                : textEditingController2.text.split(':')[0]) -
                            1
                        : int.parse(textEditingController2.text.split(':')[0].length == 1
                                        ? '0' +
                                            textEditingController2.text
                                                .split(':')[0]
                                        : textEditingController2.text.split(':')[0]) +
                                    int.parse(textEditingController2.text.split(':')[1]) <
                                int.parse(selectedValue.substring(0, selectedValue.length - 3))
                            ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                            : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                    title: textEditingController1.text + '일정이 다가옵니다',
                    body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                    scheduledate: DateTime.utc(
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(0, 4)),
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(5, 7)),
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(8, 10)),
                      int.parse(textEditingController2.text.split(':')[1]) <
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3))
                          ? int.parse(textEditingController2.text
                                          .split(':')[0]
                                          .length ==
                                      1
                                  ? '0' +
                                      textEditingController2.text.split(':')[0]
                                  : textEditingController2.text.split(':')[0]) -
                              1
                          : int.parse(textEditingController2.text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '0' + textEditingController2.text.split(':')[0]
                              : textEditingController2.text.split(':')[0]),
                      int.parse(textEditingController2.text.split(':')[1]) <
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3))
                          ? 60 -
                              (int.parse(selectedValue.substring(
                                      0, selectedValue.length - 3)) -
                                  int.parse(textEditingController2.text
                                      .split(':')[1]))
                          : int.parse(
                                  textEditingController2.text.split(':')[1]) -
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3)),
                    ));
              }

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
            } else {
              await firestore.collection('CalendarDataBase').add({
                'Daytodo': textEditingController1.text,
                'Alarm': isChecked_pushalarm == true
                    ? Hive.box('user_setting').get('alarming_time')
                    : '설정off',
                'Timestart':
                    textEditingController2.text.split(':')[0].length == 1
                        ? '0' + textEditingController2.text
                        : textEditingController2.text,
                'Timefinish':
                    textEditingController3.text.split(':')[0].length == 1
                        ? '0' + textEditingController3.text
                        : textEditingController3.text,
                'Shares': widget.share,
                'OriginalUser': widget.orig,
                'calname': widget.title,
                'summary': textEditingController5.text,
                'Date': DateFormat('yyyy-MM-dd')
                        .parse(widget.firstdate.toString())
                        .toString()
                        .split(' ')[0] +
                    '일',
              });
              firestore
                  .collection('CalendarDataBase')
                  .where('calname', isEqualTo: widget.title)
                  .where('Daytodo', isEqualTo: textEditingController1.text)
                  .get()
                  .then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  valueid.add(value.docs[i].id);
                }
                firestore
                    .collection('CalendarDataBase')
                    .doc(valueid[0])
                    .collection('AlarmTable')
                    .doc(cal_share_person.secondname)
                    .set({
                  'alarmtype': _ischecked_alarmslist,
                  'alarmhour': Hive.box('user_setting')
                      .get('alarm_cal_hour_${cal_share_person.secondname}'),
                  'alarmminute': Hive.box('user_setting')
                      .get('alarm_cal_minute_${cal_share_person.secondname}'),
                  'alarmmake': isChecked_pushalarm,
                  'calcode': valueid[0]
                });
                for (int j = 0; j < valueid.length; j++) {
                  for (int k = 0; k < widget.share.length; k++) {
                    firestore
                        .collection('CalendarDataBase')
                        .doc(valueid[j])
                        .collection('AlarmTable')
                        .doc(widget.share[k])
                        .get()
                        .then((value) {
                      if (value.exists) {
                      } else {
                        firestore
                            .collection('CalendarDataBase')
                            .doc(valueid[j])
                            .collection('AlarmTable')
                            .doc(widget.share[k])
                            .set({
                          'alarmtype': _ischecked_alarmslist,
                          'alarmhour': '99',
                          'alarmminute': '99',
                          'alarmmake': false,
                          'calcode': valueid[j]
                        }, SetOptions(merge: true));
                      }
                    });
                  }
                }
              });

              if (isChecked_pushalarm == true) {
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
                NotificationApi.showScheduledNotification(
                    id: int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)) +
                                int.parse(widget.firstdate
                                    .toString()
                                    .toString()
                                    .split(' ')[0]
                                    .toString()
                                    .substring(5, 7)) +
                                int.parse(widget.firstdate
                                    .toString()
                                    .toString()
                                    .split(' ')[0]
                                    .toString()
                                    .substring(8, 10)) +
                                int.parse(
                                    textEditingController2.text.split(':')[1]) <
                            int.parse(selectedValue.substring(
                                0, selectedValue.length - 3))
                        ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) -
                            1
                        : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) + int.parse(textEditingController2.text.split(':')[1]) <
                                int.parse(selectedValue.substring(0, selectedValue.length - 3))
                            ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                            : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                    title: textEditingController1.text + '일정이 다가옵니다',
                    body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                    scheduledate: DateTime.utc(
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(0, 4)),
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(5, 7)),
                      int.parse(widget.firstdate
                          .toString()
                          .toString()
                          .split(' ')[0]
                          .toString()
                          .substring(8, 10)),
                      int.parse(textEditingController2.text.split(':')[1]) <
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3))
                          ? int.parse(textEditingController2.text
                                          .split(':')[0]
                                          .length ==
                                      1
                                  ? '0' +
                                      textEditingController2.text.split(':')[0]
                                  : textEditingController2.text.split(':')[0]) -
                              1
                          : int.parse(textEditingController2.text
                                      .split(':')[0]
                                      .length ==
                                  1
                              ? '0' + textEditingController2.text.split(':')[0]
                              : textEditingController2.text.split(':')[0]),
                      int.parse(textEditingController2.text.split(':')[1]) <
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3))
                          ? 60 -
                              (int.parse(selectedValue.substring(
                                      0, selectedValue.length - 3)) -
                                  int.parse(textEditingController2.text
                                      .split(':')[1]))
                          : int.parse(
                                  textEditingController2.text.split(':')[1]) -
                              int.parse(selectedValue.substring(
                                  0, selectedValue.length - 3)),
                    ));
              } else {}
            }
            setState(() {
              controll_memo.setloading(false);
            });
            CreateCalandmemoSuccessFlushbar('저장완료', fToast);
            Future.delayed(const Duration(seconds: 1), () {
              Get.back();
            });
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
            'username': username,
            'sharename': widget.share,
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
              'OriginalUser': username,
              'alarmok': false,
              'alarmtime': '99:99',
              'color': Hive.box('user_setting').get('coloreachmemo') ??
                  _color.value.toInt(),
              'colorfont': Hive.box('user_setting').get('coloreachmemofont') ??
                  _colorfont.value.toInt(),
              'Date': DateFormat('yyyy-MM-dd')
                      .parse(widget.firstdate.toString())
                      .toString()
                      .split(' ')[0] +
                  '일',
              'homesave': false,
              'security': false,
              'photoUrl': controll_memo.imagelist.isEmpty
                  ? []
                  : controll_memo.imagelist,
              'pinnumber': '0000',
              'securewith': 999,
              'EditDate': DateFormat('yyyy-MM-dd')
                      .parse(widget.firstdate.toString())
                      .toString()
                      .split(' ')[0] +
                  '일',
            }, SetOptions(merge: true)).whenComplete(() {
              setState(() {
                controll_memo.setloading(false);
              });
              CreateCalandmemoSuccessFlushbar('저장완료', fToast);
              Future.delayed(const Duration(seconds: 1), () {
                Get.back();
              });
            });
          });
        }
      } else {
        setState(() {
          controll_memo.setloading(false);
        });
        CreateCalandmemoFailSaveTimeCal(context);
      }
    } else {
      setState(() {
        controll_memo.setloading(false);
      });
      CreateCalandmemoFailSaveTitle(context);
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
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].dispose();
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
      Get.back();
    }
    return reloadpage;
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsible = true
        : isresponsible = false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: BGColor(),
        resizeToAvoidBottomInset: true,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Stack(
              children: [
                UI(),
                controll_memo.loading == true ? const Loader() : Container()
              ],
            )),
      ),
    );
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<memosetting>(
          builder: (_) => SizedBox(
                height: height,
                child: Container(
                    decoration: BoxDecoration(
                      color: widget.position == 'note'
                          ? (_color == controll_memo.color
                              ? _color
                              : controll_memo.color)
                          : Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Row(
                                        children: [
                                          GetPlatform.isMobile == false
                                              ? IconBtn(
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        reloadpage = await Get.dialog(OSDialog(
                                                                context,
                                                                '경고',
                                                                Text(
                                                                    '뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            contentTextsize(),
                                                                        color: Colors
                                                                            .blueGrey)),
                                                                pressed2)) ??
                                                            false;
                                                        if (reloadpage) {
                                                          Get.back();
                                                        }
                                                      },
                                                      icon: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                        height: 30,
                                                        child: NeumorphicIcon(
                                                          Icons
                                                              .keyboard_arrow_left,
                                                          size: 30,
                                                          style: const NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              surfaceIntensity:
                                                                  0.5,
                                                              color:
                                                                  Colors.black,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      )),
                                                  color: Colors.black)
                                              : const SizedBox(),
                                          SizedBox(
                                              width:
                                                  GetPlatform.isMobile == false
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          20,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          widget.position ==
                                                                  'cal'
                                                              ? '새 일정 작성'
                                                              : '새 메모 작성',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  secondTitleTextsize(),
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      widget.position == 'note'
                                                          ? MFHolder(
                                                              checkbottoms,
                                                              nodes,
                                                              scollection,
                                                              _color,
                                                              '',
                                                              controll_memo
                                                                  .ischeckedtohideminus,
                                                              controllers,
                                                              _colorfont,
                                                            )
                                                          : const SizedBox(),
                                                      widget.position == 'note'
                                                          ? const SizedBox(
                                                              width: 10,
                                                            )
                                                          : const SizedBox(),
                                                      IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                autosavelogic();
                                                              },
                                                              icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: 30,
                                                                  style: const NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: Colors.black),
                                                    ],
                                                  ))),
                                        ],
                                      )),
                                ],
                              ),
                            )),
                        Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(child:
                                    StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                  return GestureDetector(
                                    onTap: () {
                                      searchNode_first_section.unfocus();
                                      searchNode_second_section.unfocus();
                                      searchNode_third_section.unfocus();
                                      searchNode_add_section.unfocus();
                                      for (int i = 0;
                                          i < scollection.memoindex;
                                          i++) {
                                        if (nodes.isNotEmpty) {
                                          nodes[i].unfocus();
                                        }
                                        scollection.memolistcontentin[i] =
                                            controllers[i].text;
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
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
                                          buildSheetTitle(widget.firstdate),
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
                                    ),
                                  );
                                })),
                              ),
                            )),
                      ],
                    )),
              ));
    }));
  }

  buildSheetTitle(DateTime fromDate) {
    return widget.position == 'cal'
        ? Text(
            '일정제목',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: Colors.black),
          )
        : Text(
            '메모제목',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: Colors.black),
          );
  }

  WholeContent() {
    iskeyboardup = MediaQuery.of(context).viewInsets.bottom != 0;
    return widget.position == 'cal'
        ? ContainerDesign(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: searchNode_first_section,
              style:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black),
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
            color: Colors.white)
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
                          focusNode: searchNode_first_section,
                          style: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
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
                  Text(
                    '첨부사진',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<memosetting>(
                    builder: (_) => SizedBox(
                        height: 100,
                        child: controll_memo.imagelist.isEmpty
                            ? Center(
                                child: RichText(
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '상단바의 ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400),
                                  ),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '아이콘을 클릭하여 추가하세요',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400),
                                  ),
                                ]),
                              ))
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: controll_memo.imagelist.length,
                                itemBuilder: ((context, index) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controll_memo.setimageindex(index);
                                          Get.to(
                                              () => ImageSliderPage(
                                                  index: index, doc: ''),
                                              transition:
                                                  Transition.rightToLeft);
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox(
                                                height: 90,
                                                width: 90,
                                                child: Image.network(
                                                    controll_memo
                                                        .imagelist[index],
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                }))),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  );
                                }))),
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
                              color: Colors.black),
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
                                      controllers[i].text;
                                }
                                addmemocollector(
                                    context,
                                    username,
                                    textEditingController_add_sheet,
                                    searchNode_add_section,
                                    'inside',
                                    scollection,
                                    isresponsible);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Click',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              )),
                          color: Colors.black)
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
                          color: Colors.black),
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
                      const WidgetSpan(
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.black,
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
                                              color: _colorfont,
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
                                                                      .colorfont,
                                                                ),
                                                                controller:
                                                                    controllers[
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
                                                                                  controllers.removeAt(index);

                                                                                  for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                    controllers[i].text = scollection.memolistcontentin[i];
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
                                                                          color: controll_memo
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
                                                                              ? const Icon(Icons.check_box, color: Colors.black)
                                                                              : const Icon(Icons.check_box_outline_blank, color: Colors.black),
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
                                                                                        controllers.removeAt(index);

                                                                                        for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                          controllers[i].text = scollection.memolistcontentin[i];
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
                                                                          controllers[
                                                                              index],
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
                                                                            color: controll_memo
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
                                                                          prefixIcon: const Icon(
                                                                              Icons.star_rate,
                                                                              color: Colors.black),
                                                                          prefixIconColor:
                                                                              Colors.black,
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
                                                                                          controllers.removeAt(index);

                                                                                          for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                            controllers[i].text = scollection.memolistcontentin[i];
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
                                                                            controllers[index]),
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
                                    controllers[i].text =
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
                          : const SizedBox())
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
            color: Colors.black),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.lastdate != widget.firstdate
                  ? SizedBox(
                      child: ContainerDesign(
                        color: Colors.white,
                        child: ListTile(
                          leading: NeumorphicIcon(
                            Icons.today,
                            size: 30,
                            style: const NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                surfaceIntensity: 0.5,
                                color: Colors.black,
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
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      child: ContainerDesign(
                        color: Colors.white,
                        child: ListTile(
                          leading: NeumorphicIcon(
                            Icons.today,
                            size: 30,
                            style: const NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                surfaceIntensity: 0.5,
                                color: Colors.black,
                                lightSource: LightSource.topLeft),
                          ),
                          title: Text(
                            widget.firstdate.toString().split(' ')[0],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize(),
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: ContainerDesign(
                  color: Colors.white,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '시작시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: Colors.black),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(), color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController2,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(
                            context, textEditingController2, widget.firstdate);
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: ContainerDesign(
                  color: Colors.white,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '종료시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: Colors.black),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(), color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController3,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(
                            context, textEditingController3, widget.firstdate);
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              widget.lastdate == widget.firstdate
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              widget.lastdate == widget.firstdate
                  ? GetBuilder<calendarsetting>(
                      builder: (_) => SizedBox(
                            child: ContainerDesign(
                              color: Colors.white,
                              child: ListTile(
                                leading: NeumorphicIcon(
                                  Icons.sync,
                                  size: 30,
                                  style: const NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      surfaceIntensity: 0.5,
                                      color: Colors.black,
                                      lightSource: LightSource.topLeft),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              '원하시는 반복횟수',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      contentTitleTextsize(),
                                                  color: Colors.black),
                                            ),
                                            content: StatefulBuilder(
                                              builder: ((context, setState) {
                                                return NumberPicker(
                                                    minValue: 1,
                                                    maxValue: 48,
                                                    value: cal.repeatdate,
                                                    onChanged: ((value) {
                                                      setState(() {
                                                        cal.repeatdate = value;
                                                      });
                                                      cal.setrepeatdate(
                                                          cal.repeatdate);
                                                    }));
                                              }),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                      color:
                                                          Colors.blue.shade400),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: NeumorphicIcon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                    style: const NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: Colors.black,
                                        lightSource: LightSource.topLeft),
                                  ),
                                ),
                                subtitle: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: contentTextsize(),
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                  ),
                                  controller: cal.repeatdate == 1
                                      ? (textEditingController4
                                        ..text = cal.repeatdate.toString() +
                                            '주 반복생성(기본값)')
                                      : (textEditingController4
                                        ..text = cal.repeatdate.toString() +
                                            '주 반복생성'),
                                ),
                                title: Text(
                                  '반복작성설정',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                      color: Colors.black),
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
              color: Colors.black),
        ),
        const SizedBox(
          height: 20,
        ),
        ContainerDesign(
            child: TextField(
              minLines: 5,
              maxLines: null,
              focusNode: searchNode_second_section,
              style:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black),
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
            color: Colors.white)
      ],
    ));
  }

  /*SetAlarmTitle() {
    return widget.position == 'cal'
        ? SizedBox(
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
                      color: Colors.black),
                ),
              ),
              Transform.scale(
                scale: 1,
                child: Switch(
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey.shade400,
                    value: isChecked_pushalarm,
                    onChanged: (bool val) {
                      setState(() {
                        isChecked_pushalarm = val;
                        if (isChecked_pushalarm) {
                          Hive.box('user_setting')
                              .put('alarming_time', selectedValue);
                        }
                      });
                    }),
              )
            ],
          ))
        : const SizedBox();
  }

  List<DropdownMenuItem<String>> get dropdownItems_alarm {
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
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContainerDesign(
                color: Colors.white,
                child: ListTile(
                  leading: NeumorphicIcon(
                    Icons.alarm,
                    size: 30,
                    style: const NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        surfaceIntensity: 0.5,
                        color: Colors.black,
                        lightSource: LightSource.topLeft),
                  ),
                  title: Text(
                    '알람',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: Colors.black),
                  ),
                  trailing: isChecked_pushalarm == true
                      ? DropdownButton(
                          value: selectedValue,
                          dropdownColor: Colors.white,
                          items: dropdownItems_alarm,
                          icon: NeumorphicIcon(
                            Icons.arrow_drop_down,
                            size: 20,
                            style: const NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                surfaceIntensity: 0.5,
                                color: Colors.black,
                                lightSource: LightSource.topLeft),
                          ),
                          style: TextStyle(
                              color: Colors.black, fontSize: contentTextsize()),
                          onChanged: isChecked_pushalarm == true
                              ? (String? value) {
                                  setState(() {
                                    selectedValue = value!;
                                    Hive.box('user_setting')
                                        .put('alarming_time', selectedValue);
                                  });
                                }
                              : null,
                        )
                      : Text(
                          '설정off상태입니다.',
                          style: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
                        ),
                ),
              ),
            ],
          ))
        : const SizedBox();
  }*/
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
                color: Colors.black),
          ),
        ),
        Transform.scale(
          scale: 1,
          child: Switch(
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.black,
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
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text(
              '하루전 알람',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.black),
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
            activeColor: Colors.white,
            checkColor: Colors.blue,
            selected: alarmtypes[0],
          ),
          CheckboxListTile(
            title: Text(
              '당일 알람',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: Colors.black),
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
            activeColor: Colors.white,
            checkColor: Colors.blue,
            selected: alarmtypes[1],
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
                  color: Colors.black),
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
              icon: const Icon(Icons.alarm_add),
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
                          DateTime.now());
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
                          color: Colors.black),
                    ),
                    trailing: Hive.box('user_setting').get(
                                    'alarm_cal_hour_${cal_share_person.secondname}') !=
                                '99' ||
                            Hive.box('user_setting').get(
                                    'alarm_cal_minute_${cal_share_person.secondname}') !=
                                '99'
                        ? SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Hive.box('user_setting').get(
                                          'alarm_cal_hour_${cal_share_person.secondname}') +
                                      '시 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.grey.shade400),
                                ),
                                Text(
                                  Hive.box('user_setting').get(
                                          'alarm_cal_minute_${cal_share_person.secondname}') +
                                      '분',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.grey.shade400),
                                ),
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

addmemocollector(
    BuildContext context,
    String username,
    TextEditingController textEditingController_add_sheet,
    FocusNode searchNode_add_section,
    String s,
    selectcollection scollection,
    bool isresponsive) {
  Get.bottomSheet(
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: GestureDetector(
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
                    ))),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
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
      timecontroller.text = '$hour:$minute';
    }
  });
}
