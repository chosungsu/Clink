// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/BACKENDPART/Getx/PeopleAdd.dart';
import 'package:clickbyme/BACKENDPART/Getx/calendarsetting.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/sheets/pushalarmsettingcal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../BACKENDPART/Enums/Variables.dart';
import '../../../FRONTENDPART/Route/subuiroute.dart';
import '../../../FRONTENDPART/UI/DayScript.dart';
import '../../../BACKENDPART/LocalNotiPlatform/NotificationApi.dart';
import '../../../Tool/AndroidIOS.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../BACKENDPART/Getx/navibool.dart';
import '../../../Tool/Loader.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Widgets/CreateCalandmemo.dart';

class ClickShowEachCalendar extends StatefulWidget {
  const ClickShowEachCalendar({
    Key? key,
    required this.groupcode,
    required this.start,
    required this.finish,
    required this.calinfo,
    required this.date,
    required this.share,
    required this.calname,
    required this.code,
    required this.summary,
    required this.isfromwhere,
    required this.id,
    required this.alarmtypes,
    required this.alarmmake,
    required this.alarmhour,
    required this.alarmminute,
  }) : super(key: key);
  final String groupcode;
  final String start;
  final String finish;
  final String calinfo;
  final DateTime date;
  final List share;
  final String calname;
  final String code;
  final String summary;
  final String isfromwhere;
  final String id;
  final List<bool> alarmtypes;
  final bool alarmmake;
  final String alarmhour;
  final String alarmminute;
  @override
  State<StatefulWidget> createState() => _ClickShowEachCalendarState();
}

class _ClickShowEachCalendarState extends State<ClickShowEachCalendar>
    with WidgetsBindingObserver {
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  final searchNode = FocusNode();
  final searchsecondNode = FocusNode();
  List updateid = [];
  List deleteid = [];
  bool isresponsive = false;
  bool isChecked_pushalarm = false;
  String changevalue = Hive.box('user_setting').get('alarming_time') ?? "10분 전";
  bool loading = false;
  late List<bool> alarmtypes = [];
  final setalarmhourNode = FocusNode();
  final setalarmminuteNode = FocusNode();
  String hour = '';
  String minute = '';
  var isChecked_pushalarmwhat = null;
  final draw = Get.put(navibool());
  final peopleadd = Get.put(PeopleAdd());
  final controll_cal = Get.put(calendarsetting());
  String updateidalarm = '';
  String deleterepeatwhile = '';
  int deleterepeatdate = 0;
  List differ_list = [];
  String deleteidsingle = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    print(widget.date);
    alarmtypes.clear();
    WidgetsBinding.instance.addObserver(this);
    textEditingController1 = TextEditingController(text: widget.calinfo);
    if (widget.start == '' || widget.start == '하루종일 일정으로 기록') {
      textEditingController2 = TextEditingController(text: '하루종일 일정');
    } else {
      textEditingController2 = TextEditingController(text: widget.start);
    }
    if (widget.finish == '' || widget.finish == '하루종일 일정으로 기록') {
      textEditingController3 = TextEditingController(text: '하루종일 일정');
    } else {
      textEditingController3 = TextEditingController(text: widget.finish);
    }
    textEditingController4 = TextEditingController(text: widget.summary);
    for (int i = 0; i < widget.alarmtypes.length; i++) {
      alarmtypes.add(widget.alarmtypes[i]);
    }
    isChecked_pushalarm = widget.alarmmake;
    controll_cal.hour1 = widget.alarmhour;
    controll_cal.minute1 = widget.alarmminute;
    deleteid = [];
    isChecked_pushalarmwhat =
        widget.alarmtypes.indexWhere((element) => element == true);
  }

  void deletelogic() async {
    //삭제
    deleteid.clear();
    final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
          builder: (context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: SingleChildScrollView(
                child: Text('정말 이 일정을 삭제하시겠습니까?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize(),
                        color: Colors.blueGrey)),
              ),
            );
          },
        ), GetBackWithTrue)) ??
        false;
    if (reloadpage) {
      setState(() {
        loading = true;
      });
      firestore.collection('AppNoticeByUsers').add({
        'title': '[' +
            widget.calname +
            '] 캘린더의 일정 중 ${textEditingController1.text}이(가) 삭제되었습니다.',
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
        'username': appnickname,
        'sharename': widget.share,
        'read': 'no',
      }).whenComplete(() {
        firestore
            .collection('CalendarDataBase')
            .where('calname', isEqualTo: widget.code)
            .where('Daytodo', isEqualTo: widget.calinfo)
            .where('code', isEqualTo: widget.groupcode)
            .where('OriginalUser', isEqualTo: peopleadd.usrcode)
            /*.where('Date',
                isEqualTo: widget.date.toString().split('-')[0] +
                    '-' +
                    widget.date.toString().split('-')[1] +
                    '-' +
                    widget.date.toString().split('-')[2].substring(0, 2) +
                    '일')*/
            .where('Timestart', isEqualTo: widget.start)
            .get()
            .then((value) async {
          for (var element in value.docs) {
            deleteid.add(element.id);
            deleterepeatwhile = element.data()['whenrepeat'];
            deleterepeatdate = element.data()['whattimecnt'];
            differ_list.add(element.data()['Date']);
          }
          await firestore
              .collection('CalendarDataBase')
              .where('calname', isEqualTo: widget.code)
              .where('Daytodo', isEqualTo: widget.calinfo)
              .where('Date',
                  isEqualTo: widget.date.toString().split('-')[0] +
                      '-' +
                      widget.date.toString().split('-')[1] +
                      '-' +
                      widget.date.toString().split('-')[2].substring(0, 2) +
                      '일')
              .where('Timestart', isEqualTo: widget.start)
              .get()
              .then((value) {
            deleteidsingle = value.docs[0].id;
          });
        }).whenComplete(() async {
          if (deleterepeatwhile == 'no') {
            Future.delayed(const Duration(seconds: 0), () async {
              setState(() {
                loading = false;
              });
              Snack.snackbars(
                  context: context,
                  title: '일정삭제 완료!',
                  backgroundcolor: Colors.red,
                  bordercolor: draw.backgroundcolor);
              widget.isfromwhere == 'home' ? GoToMain() : Get.back();
              firestore
                  .collection('CalendarDataBase')
                  .doc(deleteidsingle)
                  .delete();
              NotificationApi.cancelNotification(
                  id: int.parse(widget.date.toString().split('-')[0]) +
                      int.parse(widget.date.toString().split('-')[1]) +
                      int.parse(widget.id.hashCode.toString()) +
                      int.parse(appnickname.hashCode.toString()));
            });
          } else {
            if (differ_list.length == 1) {
              Future.delayed(const Duration(seconds: 0), () async {
                setState(() {
                  loading = false;
                });
                Snack.snackbars(
                    context: context,
                    title: '일정삭제 완료!',
                    backgroundcolor: Colors.red,
                    bordercolor: draw.backgroundcolor);
                widget.isfromwhere == 'home' ? GoToMain() : Get.back();
                firestore
                    .collection('CalendarDataBase')
                    .doc(deleteidsingle)
                    .delete();
                NotificationApi.cancelNotification(
                    id: int.parse(widget.date.toString().split('-')[0]) +
                        int.parse(widget.date.toString().split('-')[1]) +
                        int.parse(widget.id.hashCode.toString()) +
                        int.parse(appnickname.hashCode.toString()));
              });
            } else {
              final reloadpage =
                  await Get.dialog(OSDialogsecond(context, '알림', Builder(
                        builder: (context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: SingleChildScrollView(
                              child: Text(
                                  '이 일정은 ' +
                                      deleterepeatwhile +
                                      '간 반복 설정되어 ' +
                                      (differ_list.length - 1).toString() +
                                      '개의 동일일정이 있습니다. 무엇을 도와드릴까요?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.blueGrey)),
                            ),
                          );
                        },
                      ), GetBackWithTrue)) ??
                      false;
              if (reloadpage) {
                Future.delayed(const Duration(seconds: 0), () async {
                  setState(() {
                    loading = false;
                  });
                  Snack.snackbars(
                      context: context,
                      title: '일정삭제 완료!',
                      backgroundcolor: Colors.red,
                      bordercolor: draw.backgroundcolor);
                  widget.isfromwhere == 'home' ? GoToMain() : Get.back();
                  for (int i = 0; i <= deleterepeatdate; i++) {
                    firestore
                        .collection('CalendarDataBase')
                        .doc(deleteid[i])
                        .delete();
                    NotificationApi.cancelNotification(
                        id: int.parse(differ_list[i].toString().split('-')[0]) +
                            int.parse(differ_list[i].toString().split('-')[1]) +
                            int.parse(widget.id.hashCode.toString()) +
                            int.parse(appnickname.hashCode.toString()));
                  }
                });
              } else {
                Future.delayed(const Duration(seconds: 0), () async {
                  setState(() {
                    loading = false;
                  });
                  Snack.snackbars(
                      context: context,
                      title: '일정삭제 완료!',
                      backgroundcolor: Colors.red,
                      bordercolor: draw.backgroundcolor);
                  widget.isfromwhere == 'home' ? GoToMain() : Get.back();
                  firestore
                      .collection('CalendarDataBase')
                      .doc(deleteidsingle)
                      .delete();
                  NotificationApi.cancelNotification(
                      id: int.parse(widget.date.toString().split('-')[0]) +
                          int.parse(widget.date.toString().split('-')[1]) +
                          int.parse(widget.id.hashCode.toString()) +
                          int.parse(appnickname.hashCode.toString()));
                });
              }
            }
          }
        });
      });
    }
  }

  void savelogic() {
    //수정
    setState(() {
      loading = true;
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
    firestore.collection('AppNoticeByUsers').add({
      'title': '[' +
          widget.calname +
          '] 캘린더의 일정 중 ${textEditingController1.text}이(가) 변경되었습니다.',
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
      'username': appnickname,
      'sharename': widget.share,
      'read': 'no',
    }).whenComplete(() {
      firestore
          .collection('CalendarDataBase')
          .where('calname', isEqualTo: widget.code)
          .where('Daytodo', isEqualTo: widget.calinfo)
          .where('Date',
              isEqualTo: widget.date.toString().split('-')[0] +
                  '-' +
                  widget.date.toString().split('-')[1] +
                  '-' +
                  widget.date.toString().split('-')[2].substring(0, 2) +
                  '일')
          .where('Timestart', isEqualTo: widget.start)
          .get()
          .then((value) {
        updateid.clear();
        for (var element in value.docs) {
          updateid.add(element.id);
        }
        for (int i = 0; i < updateid.length; i++) {
          firestore.collection('CalendarDataBase').doc(updateid[i]).update({
            'Daytodo': textEditingController1.text.isEmpty
                ? widget.calinfo
                : textEditingController1.text,
            'Alarm': isChecked_pushalarm,
            'summary': textEditingController4.text,
            'Timestart': textEditingController2.text.isEmpty
                ? widget.start
                : (textEditingController2.text == '하루종일 일정'
                    ? textEditingController2.text + '으로 기록'
                    : (textEditingController2.text.split(':')[0].length == 1
                        ? (textEditingController2.text.split(':')[1].length == 1
                            ? '0' + textEditingController2.text + '0'
                            : '0' + textEditingController2.text)
                        : (textEditingController2.text.split(':')[1].length == 1
                            ? textEditingController2.text + '0'
                            : textEditingController2.text))),
            'Timefinish': textEditingController3.text.isEmpty
                ? widget.finish
                : (textEditingController3.text == '하루종일 일정'
                    ? textEditingController3.text + '으로 기록'
                    : (textEditingController3.text.split(':')[0].length == 1
                        ? (textEditingController3.text.split(':')[1].length == 1
                            ? '0' + textEditingController3.text + '0'
                            : '0' + textEditingController3.text)
                        : (textEditingController3.text.split(':')[1].length == 1
                            ? textEditingController3.text + '0'
                            : textEditingController3.text))),
          });
        }
        firestore
            .collection('CalendarDataBase')
            .doc(widget.id)
            .collection('AlarmTable')
            .doc(appnickname)
            .get()
            .then((value) {
          if (value.exists) {
            firestore
                .collection('CalendarDataBase')
                .doc(widget.id)
                .collection('AlarmTable')
                .doc(appnickname)
                .update({
              'alarmhour': controll_cal.hour1,
              'alarmminute': controll_cal.minute1,
              'alarmmake': isChecked_pushalarm,
              'alarmtype': alarmtypes,
            });
          } else {
            firestore
                .collection('CalendarDataBase')
                .doc(widget.id)
                .collection('AlarmTable')
                .doc(appnickname)
                .set({
              'alarmhour': controll_cal.hour1,
              'alarmminute': controll_cal.minute1,
              'alarmmake': isChecked_pushalarm,
              'alarmtype': alarmtypes,
            }, SetOptions(merge: true));
          }
        });
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
        Snack.snackbars(
            context: context,
            title: '저장완료',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
        Future.delayed(const Duration(seconds: 1), () {
          if (widget.isfromwhere == 'home') {
            GoToMain();
          } else {
            Get.back();
          }
        });
        if (isChecked_pushalarm) {
          if (alarmtypes[0] == true) {
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
            NotificationApi.cancelNotification(
                id: int.parse(widget.date.toString().split('-')[0]) +
                    int.parse(widget.date.toString().split('-')[1]) +
                    int.parse(widget.id.hashCode.toString()) +
                    int.parse(appnickname.hashCode.toString()));
            NotificationApi.showScheduledNotification(
                id: int.parse(widget.date.toString().split('-')[0]) +
                    int.parse(widget.date.toString().split('-')[1]) +
                    int.parse(widget.id.hashCode.toString()) +
                    int.parse(appnickname.hashCode.toString()),
                title: textEditingController1.text + '일정이 다가옵니다',
                body: textEditingController2.text.split(':')[0].length == 1
                    ? (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + firsttxt
                        : '예정된 시각 : ' + secondtxt)
                    : (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + thirdtxt
                        : '예정된 시각 : ' + forthtxt),
                payload: widget.code,
                scheduledate: DateTime.utc(
                  int.parse(widget.date.toString().split('-')[0]),
                  int.parse(widget.date.toString().split('-')[1]),
                  int.parse(widget.date
                          .toString()
                          .split('-')[2]
                          .toString()
                          .split(' ')[0]) -
                      1,
                  int.parse(controll_cal.hour1),
                  int.parse(controll_cal.minute1),
                ));
          } else {
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
            NotificationApi.cancelNotification(
                id: int.parse(widget.date.toString().split('-')[0]) +
                    int.parse(widget.date.toString().split('-')[1]) +
                    int.parse(widget.id.hashCode.toString()) +
                    int.parse(appnickname.hashCode.toString()));
            NotificationApi.showScheduledNotification(
                id: int.parse(widget.date.toString().split('-')[0]) +
                    int.parse(widget.date.toString().split('-')[1]) +
                    int.parse(widget.id.hashCode.toString()) +
                    int.parse(appnickname.hashCode.toString()),
                title: textEditingController1.text + '일정이 다가옵니다',
                body: textEditingController2.text.split(':')[0].length == 1
                    ? (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + firsttxt
                        : '예정된 시각 : ' + secondtxt)
                    : (textEditingController3.text.split(':')[0].length == 1
                        ? '예정된 시각 : ' + thirdtxt
                        : '예정된 시각 : ' + forthtxt),
                payload: widget.code,
                scheduledate: DateTime.utc(
                  int.parse(widget.date.toString().split('-')[0]),
                  int.parse(widget.date.toString().split('-')[1]),
                  int.parse(widget.date
                      .toString()
                      .split('-')[2]
                      .toString()
                      .split(' ')[0]),
                  int.parse(controll_cal.hour1),
                  int.parse(controll_cal.minute1),
                ));
          }
        } else {
          NotificationApi.cancelNotification(
              id: int.parse(widget.date.toString().split('-')[0]) +
                  int.parse(widget.date.toString().split('-')[1]) +
                  int.parse(widget.id.hashCode.toString()) +
                  int.parse(appnickname.hashCode.toString()));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
  }

  Future<bool> _onWillPop() async {
    savelogic();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
    return Scaffold(
        backgroundColor: draw.backgroundcolor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: Stack(
              children: [
                UI(),
                loading == true
                    ? const Loader(
                        wherein: 'caleach',
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: draw.backgroundcolor,
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
                        GetPlatform.isMobile == false
                            ? ContainerDesign(
                                child: GestureDetector(
                                  onTap: () => savelogic(),
                                  child: Icon(
                                    Feather.chevron_left,
                                    size: 30,
                                    color: draw.color_textstatus,
                                  ),
                                ),
                                color: draw.backgroundcolor)
                            : const SizedBox(),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    const Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () async {
                                            savelogic();
                                          },
                                          child: Icon(
                                            Ionicons.checkmark_done,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ContainerDesign(
                                        child: GestureDetector(
                                          onTap: () async {
                                            deletelogic();
                                          },
                                          child: Icon(
                                            AntDesign.delete,
                                            size: 30,
                                            color: draw.color_textstatus,
                                          ),
                                        ),
                                        color: draw.backgroundcolor),
                                  ],
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
                        return GestureDetector(
                            onTap: () {
                              searchNode.unfocus();
                              searchsecondNode.unfocus();
                            },
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    buildSheetTitle(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Title(),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    buildContentTitle(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Content(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SetCalSummary(),
                                    /*const SizedBox(
                                      height: 20,
                                    ),
                                    buildAlarmTitle(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Alarm(),*/
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    buildAlarmTitleupdateversion(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Alarmupdateversion(),
                                    const SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              ),
                            ));
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  buildSheetTitle() {
    return Text(
      '일정제목',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: draw.color_textstatus),
    );
  }

  Title() {
    return SizedBox(
        child: ContainerDesign(
      color: draw.backgroundcolor,
      child: TextField(
        readOnly: false,
        minLines: 1,
        maxLines: 3,
        focusNode: searchNode,
        style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          border: InputBorder.none,
          isCollapsed: true,
        ),
        controller: textEditingController1,
      ),
    ));
  }

  buildContentTitle() {
    return Text(
      '일정세부사항',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: contentTitleTextsize(),
          color: draw.color_textstatus),
    );
  }

  Content() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: ContainerDesign(
                  color: draw.backgroundcolor,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: draw.color_textstatus,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '일정시작시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: draw.color_textstatus),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController2,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(context, textEditingController2, widget.date);
                      },
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: draw.color_textstatus,
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
                  color: draw.backgroundcolor,
                  child: ListTile(
                    leading: NeumorphicIcon(
                      Icons.schedule,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: draw.color_textstatus,
                          lightSource: LightSource.topLeft),
                    ),
                    title: Text(
                      '일정종료시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: draw.color_textstatus),
                    ),
                    subtitle: TextFormField(
                      readOnly: true,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      controller: textEditingController3,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        pickDates(context, textEditingController3, widget.date);
                      },
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: draw.color_textstatus,
                      ),
                    ),
                  ),
                ),
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
              color: draw.color_textstatus),
        ),
        const SizedBox(
          height: 20,
        ),
        ContainerDesign(
            child: TextField(
              minLines: 5,
              maxLines: null,
              focusNode: searchsecondNode,
              style: TextStyle(
                  fontSize: contentTextsize(), color: draw.color_textstatus),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '일정에 대한 세부사항 작성',
                hintStyle: TextStyle(
                    fontSize: contentTextsize(), color: draw.color_textstatus),
              ),
              controller: textEditingController4,
            ),
            color: draw.backgroundcolor)
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
                color: draw.color_textstatus),
          ),
        ),
        Transform.scale(
          scale: 1,
          child: Switch(
              activeColor: Colors.blue,
              inactiveThumbColor: draw.color_textstatus,
              inactiveTrackColor: draw.color_textstatus,
              value: isChecked_pushalarm,
              onChanged: (bool val) {
                setState(() {
                  isChecked_pushalarm = val;
                  if (isChecked_pushalarm == false) {
                    NotificationApi.cancelNotification(
                        id: int.parse(widget.date.toString().split('-')[0]) +
                            int.parse(widget.date.toString().split('-')[1]) +
                            int.parse(widget.id.hashCode.toString()) +
                            int.parse(appnickname.hashCode.toString()));
                  }
                });
              }),
        )
      ],
    ));
  }

  Alarmupdateversion() {
    return SizedBox(
        child: ContainerDesign(
      color: draw.backgroundcolor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text(
              '하루전 알람',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  color: draw.color_textstatus),
            ),
            subtitle: Text(
              '이 기능은 하루전날만 알람이 울립니다.',
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: draw.color_textstatus,
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
                calendarsetting().setalarmtype(widget.id, alarmtypes);
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
                  color: draw.color_textstatus),
            ),
            subtitle: Text(
              '이 기능은 당일만 알람이 울립니다.',
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: draw.color_textstatus,
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
                calendarsetting().setalarmtype(widget.id, alarmtypes);
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
          GetBuilder<calendarsetting>(
              builder: (_) => ListTile(
                    title: Text(
                      '시간 설정',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
                    ),
                    subtitle: Text(
                      '우측 알람 아이콘 클릭',
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: draw.color_textstatus,
                          overflow: TextOverflow.ellipsis),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.alarm_add),
                      onPressed: () {
                        hour = controll_cal.hour1;
                        minute = controll_cal.minute1;
                        pushalarmsettingcal(
                          context,
                          setalarmhourNode,
                          setalarmminuteNode,
                          hour,
                          minute,
                          widget.calinfo,
                          widget.id,
                          isChecked_pushalarmwhat,
                          widget.date,
                        );
                      },
                    ),
                  )),
          GetBuilder<calendarsetting>(
              builder: (_) => ListTile(
                    title: Text(
                      '설정된 시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: draw.color_textstatus),
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
                                                color: draw.color_textstatus),
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
                                                color: draw.color_textstatus),
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
                                                color: draw.color_textstatus),
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
                                                color: draw.color_textstatus),
                                          )))
                              ],
                            ),
                          )
                        : Text(
                            '설정 안됨',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: draw.color_textstatus),
                          ),
                  ))
        ],
      ),
    ));
  }
}
