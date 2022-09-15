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
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/addmemocollection.dart';
import 'package:numberpicker/numberpicker.dart';

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key,
      required this.firstdate,
      required this.position,
      required this.title,
      required this.share,
      required this.orig,
      required this.lastdate,
      required this.calname})
      : super(key: key);
  final DateTime firstdate;
  final DateTime lastdate;
  final String position;
  final String title;
  final String orig;
  final List share;
  final String calname;
  @override
  State<StatefulWidget> createState() => _DayScriptState();
}

class _DayScriptState extends State<DayScript> {
  //공통변수
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final DateTime _selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
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
  List<MemoList> checklisttexts = [];
  Color _color = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('typecolorcalendar', null);
    Hive.box('user_setting').put('coloreachmemo', Colors.white.value.toInt());
    controll_memo.color = Color(Hive.box('user_setting').get('coloreachmemo'));
    controll_memo.imagelist.clear();
    _color = controll_memo.color;
    checklisttexts.clear();
    controllers.clear();
    scollection.memolistin.clear();
    scollection.memolistcontentin.clear();
    scollection.memoindex = 0;
    cal_share_person.peoplecalendarrestart();
    finallist = cal_share_person.people;
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
    textEditingController4 = TextEditingController();
    textEditingController_add_sheet = TextEditingController();
    _events = {};
    ischeckedtohideminus = controll_memo.ischeckedtohideminus;
    scollection.resetcollection();
    selectedValue = Hive.box('user_setting').get('alarming_time') ?? '5분 전';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
    textEditingController4.dispose();
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
        body: WillPopScope(onWillPop: _onBackPressed, child: UI()),
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
                                          IconBtn(
                                              child: IconButton(
                                                  onPressed: () async {
                                                    final reloadpage =
                                                        await Get.dialog(OSDialog(
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
                                                  },
                                                  icon: Container(
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    child: NeumorphicIcon(
                                                      Icons.keyboard_arrow_left,
                                                      size: 30,
                                                      style:
                                                          const NeumorphicStyle(
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
                                              color: Colors.black),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          '작성하기',
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
                                                              controllers)
                                                          : SizedBox(),
                                                      widget.position == 'note'
                                                          ? const SizedBox(
                                                              width: 10,
                                                            )
                                                          : SizedBox(),
                                                      IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                var firsttxt = '0' +
                                                                    textEditingController2
                                                                        .text +
                                                                    ' - 0' +
                                                                    textEditingController3
                                                                        .text;
                                                                var secondtxt = '0' +
                                                                    textEditingController2
                                                                        .text +
                                                                    ' - ' +
                                                                    textEditingController3
                                                                        .text;
                                                                var thirdtxt =
                                                                    textEditingController2
                                                                            .text +
                                                                        ' - 0' +
                                                                        textEditingController3
                                                                            .text;
                                                                var forthtxt =
                                                                    textEditingController2
                                                                            .text +
                                                                        ' - ' +
                                                                        textEditingController3
                                                                            .text;
                                                                if (textEditingController1
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  if (textEditingController2
                                                                          .text
                                                                          .isNotEmpty ||
                                                                      widget.position ==
                                                                          'note') {
                                                                    //await localnotification.notishow();
                                                                    if (widget
                                                                            .position ==
                                                                        'cal') {
                                                                      CreateCalandmemoSuccessFlushbar(
                                                                          context);
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .add({
                                                                        'title': '[' +
                                                                            widget.calname +
                                                                            '] 캘린더의 일정 ${textEditingController1.text}이(가) 추가되었습니다.',
                                                                        'date': DateFormat('yyyy-MM-dd hh:mm')
                                                                            .parse(widget.firstdate.toString())
                                                                            .toString()
                                                                            .split(' ')[0],
                                                                        'username':
                                                                            widget.share,
                                                                        'read':
                                                                            'no',
                                                                      });
                                                                      widget.lastdate !=
                                                                              widget
                                                                                  .firstdate
                                                                          ? differ_date = int.parse(widget
                                                                              .lastdate
                                                                              .difference(DateTime.parse(widget.firstdate
                                                                                  .toString()))
                                                                              .inDays
                                                                              .toString())
                                                                          : (cal.repeatdate != 1
                                                                              ? differ_date = cal.repeatdate - 1
                                                                              : differ_date = 0);
                                                                      for (int i =
                                                                              0;
                                                                          i <=
                                                                              differ_date;
                                                                          i++) {
                                                                        if (differ_date ==
                                                                            0) {
                                                                        } else {
                                                                          widget.lastdate != widget.firstdate
                                                                              ? differ_list.add(DateTime(widget.firstdate.year, widget.firstdate.month, widget.firstdate.day + i))
                                                                              : differ_list.add(DateTime(widget.firstdate.year, widget.firstdate.month, widget.firstdate.day + 7 * i));
                                                                        }
                                                                      }
                                                                      if (differ_list
                                                                          .isNotEmpty) {
                                                                            Get.back();
                                                                        for (int j =
                                                                                0;
                                                                            j < differ_list.length;
                                                                            j++) {
                                                                          firestore
                                                                              .collection('CalendarDataBase')
                                                                              .add({
                                                                            'Daytodo':
                                                                                textEditingController1.text,
                                                                            'Alarm': isChecked_pushalarm == true
                                                                                ? Hive.box('user_setting').get('alarming_time')
                                                                                : '설정off',
                                                                            'Timestart': textEditingController2.text.split(':')[0].length == 1
                                                                                ? '0' + textEditingController2.text
                                                                                : textEditingController2.text,
                                                                            'Timefinish': textEditingController3.text.split(':')[0].length == 1
                                                                                ? '0' + textEditingController3.text
                                                                                : textEditingController3.text,
                                                                            'Shares':
                                                                                widget.share,
                                                                            'OriginalUser':
                                                                                widget.orig,
                                                                            'calname':
                                                                                widget.title,
                                                                            'Date':
                                                                                DateFormat('yyyy-MM-dd').parse(differ_list[j].toString()).toString().split(' ')[0] + '일',
                                                                          });
                                                                          NotificationApi.showScheduledNotification(
                                                                              id: int.parse(DateFormat('yyyyMMdd').parse(differ_list[j]).toString()) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3))
                                                                                  ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1
                                                                                  : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3))
                                                                                      ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                                                                      : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              title: textEditingController1.text + '일정이 다가옵니다',
                                                                              body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                              scheduledate: DateTime.utc(
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(5, 7)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(8, 10)),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1 : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1])) : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              ));
                                                                        }
                                                                        
                                                                        CreateCalandmemoSuccessFlushbarSub(
                                                                            context,
                                                                            '일정');
                                                                        NotificationApi
                                                                            .showNotification(
                                                                          title:
                                                                              '알람설정된 일정 : ' + textEditingController1.text,
                                                                          body: textEditingController2.text.split(':')[0].length == 1
                                                                              ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt)
                                                                              : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                        );
                                                                      } else {
                                                                        Get.back();
                                                                        firestore
                                                                            .collection('CalendarDataBase')
                                                                            .add({
                                                                          'Daytodo':
                                                                              textEditingController1.text,
                                                                          'Alarm': isChecked_pushalarm == true
                                                                              ? Hive.box('user_setting').get('alarming_time')
                                                                              : '설정off',
                                                                          'Timestart': textEditingController2.text.split(':')[0].length == 1
                                                                              ? '0' + textEditingController2.text
                                                                              : textEditingController2.text,
                                                                          'Timefinish': textEditingController3.text.split(':')[0].length == 1
                                                                              ? '0' + textEditingController3.text
                                                                              : textEditingController3.text,
                                                                          'Shares':
                                                                              widget.share,
                                                                          'OriginalUser':
                                                                              widget.orig,
                                                                          'calname':
                                                                              widget.title,
                                                                          'Date':
                                                                              DateFormat('yyyy-MM-dd').parse(widget.firstdate.toString()).toString().split(' ')[0] + '일',
                                                                        });
                                                                        CreateCalandmemoSuccessFlushbarSub(
                                                                            context,
                                                                            '일정');
                                                                        if (isChecked_pushalarm ==
                                                                            true) {
                                                                          NotificationApi
                                                                              .showNotification(
                                                                            title:
                                                                                '알람설정된 일정 : ' + textEditingController1.text,
                                                                            body: textEditingController2.text.split(':')[0].length == 1
                                                                                ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt)
                                                                                : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                          );
                                                                          NotificationApi.showScheduledNotification(
                                                                              id: int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)) + int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(5, 7)) + int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(8, 10)) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3))
                                                                                  ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1
                                                                                  : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) + int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3))
                                                                                      ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1]))
                                                                                      : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              title: textEditingController1.text + '일정이 다가옵니다',
                                                                              body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                              scheduledate: DateTime.utc(
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(5, 7)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(8, 10)),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1 : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1])) : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              ));
                                                                        } else {}
                                                                      }
                                                                    } else {
                                                                        Get.back();
                                                                      CreateCalandmemoSuccessFlushbar(
                                                                          context);
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .add({
                                                                        'title':
                                                                            '메모 ${textEditingController1.text}가 추가되었습니다.',
                                                                        'date': DateFormat('yyyy-MM-dd hh:mm')
                                                                            .parse(widget.firstdate.toString())
                                                                            .toString()
                                                                            .split(' ')[0],
                                                                        'username':
                                                                            widget.share,
                                                                        'read':
                                                                            'no',
                                                                      });
                                                                      for (int i =
                                                                              0;
                                                                          i < scollection.memolistin.length;
                                                                          i++) {
                                                                        checklisttexts.add(MemoList(
                                                                            memocontent:
                                                                                scollection.memolistcontentin[i],
                                                                            contentindex: scollection.memolistin[i]));
                                                                      }
                                                                      firestore
                                                                          .collection(
                                                                              'MemoDataBase')
                                                                          .doc()
                                                                          .set({
                                                                        'memoTitle':
                                                                            textEditingController1.text,
                                                                        'Collection': scollection.collection == '' ||
                                                                                scollection.collection == null
                                                                            ? null
                                                                            : scollection.collection,
                                                                        'memolist': checklisttexts
                                                                            .map((e) =>
                                                                                e.memocontent)
                                                                            .toList(),
                                                                        'memoindex': checklisttexts
                                                                            .map((e) =>
                                                                                e.contentindex)
                                                                            .toList(),
                                                                        'OriginalUser':
                                                                            username,
                                                                        'alarmok':
                                                                            false,
                                                                        'alarmtime':
                                                                            '99:99',
                                                                        'color':
                                                                            Hive.box('user_setting').get('coloreachmemo') ??
                                                                                _color.value.toInt(),
                                                                        'Date': DateFormat('yyyy-MM-dd').parse(widget.firstdate.toString()).toString().split(' ')[0] +
                                                                            '일',
                                                                        'homesave':
                                                                            false,
                                                                        'security':
                                                                            false,
                                                                        'photoUrl': controll_memo.imagelist.isEmpty
                                                                            ? []
                                                                            : controll_memo.imagelist,
                                                                        'pinnumber':
                                                                            '0000',
                                                                        'securewith':
                                                                            999,
                                                                        'EditDate':
                                                                            DateFormat('yyyy-MM-dd').parse(widget.firstdate.toString()).toString().split(' ')[0] +
                                                                                '일',
                                                                      }, SetOptions(merge: true)).whenComplete(
                                                                              () {
                                                                        CreateCalandmemoSuccessFlushbarSub(
                                                                            context,
                                                                            '메모');
                                                                      });
                                                                    }
                                                                  } else {
                                                                    CreateCalandmemoFailSaveTimeCal(
                                                                        context);
                                                                  }
                                                                } else {
                                                                  CreateCalandmemoFailSaveTitle(
                                                                      context);
                                                                }
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
                                              ? SetAlarmTitle()
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
                                              ? Alarm()
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
        ? TextField(
            minLines: 1,
            maxLines: 3,
            focusNode: searchNode_first_section,
            style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              contentPadding: const EdgeInsets.only(left: 10),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              isCollapsed: true,
              hintText: '일정 제목 추가',
              hintStyle:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black),
            ),
            controller: textEditingController1,
          )
        : (widget.position == 'note'
            ? ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        minLines: 1,
                        maxLines: 1,
                        focusNode: searchNode_first_section,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: contentTextsize(), color: Colors.black),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintText: '제목 입력...',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(),
                              color: Colors.grey.shade400),
                        ),
                        controller: textEditingController1,
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
                                              controll_memo
                                                  .setimageindex(index);
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
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
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
                                        i <
                                            scollection
                                                .memolistcontentin.length;
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
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      'Click',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.blue),
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
                      GetBuilder<selectcollection>(builder: (_) {
                        return scollection.memolistin.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: scollection.memolistin.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      scollection.memolistin[index] == 0
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              child: DetectableTextField(
                                                minLines: null,
                                                maxLines: null,
                                                focusNode: nodes[index],
                                                onTap: () {},
                                                onChanged: (text) {
                                                  scollection.memolistcontentin[
                                                      index] = text;
                                                },
                                                basicStyle: TextStyle(
                                                    fontSize: contentTextsize(),
                                                    color: Colors.black),
                                                controller: controllers[index],
                                                decoration: InputDecoration(
                                                  isCollapsed: true,
                                                  border: InputBorder.none,
                                                  suffixIcon: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      controll_memo
                                                                  .ischeckedtohideminus ==
                                                              true
                                                          ? InkWell(
                                                              onTap: () {},
                                                              child:
                                                                  const SizedBox(
                                                                      width:
                                                                          30),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  scollection
                                                                      .removelistitem(
                                                                          index);
                                                                  controllers
                                                                      .removeAt(
                                                                          index);

                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          scollection
                                                                              .memolistin
                                                                              .length;
                                                                      i++) {
                                                                    controllers[i]
                                                                            .text =
                                                                        scollection
                                                                            .memolistcontentin[i];
                                                                  }
                                                                });
                                                              },
                                                              child: const Icon(
                                                                  Icons
                                                                      .remove_circle_outline,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (index ==
                                                                    0) {
                                                                } else {
                                                                  String
                                                                      content_prev =
                                                                      controllers[index -
                                                                              1]
                                                                          .text;
                                                                  int indexcontent_prev =
                                                                      scollection
                                                                              .memolistin[
                                                                          index -
                                                                              1];
                                                                  scollection
                                                                      .removelistitem(
                                                                          index -
                                                                              1);
                                                                  Hive.box('user_setting').put(
                                                                      'optionmemoinput',
                                                                      indexcontent_prev);
                                                                  Hive.box('user_setting').put(
                                                                      'optionmemocontentinput',
                                                                      content_prev);
                                                                  scollection
                                                                      .addmemolistin(
                                                                          index);
                                                                  scollection
                                                                      .addmemolistcontentin(
                                                                          index);
                                                                  controllers[
                                                                          index -
                                                                              1]
                                                                      .text = scollection
                                                                          .memolistcontentin[
                                                                      index -
                                                                          1];
                                                                  controllers[
                                                                          index]
                                                                      .text = scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                                }
                                                              });
                                                            },
                                                            child: Icon(
                                                                Icons
                                                                    .expand_less,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (index + 1 ==
                                                                    scollection
                                                                        .memoindex) {
                                                                } else {
                                                                  String
                                                                      content =
                                                                      scollection
                                                                              .memolistcontentin[
                                                                          index];
                                                                  int indexcontent =
                                                                      scollection
                                                                              .memolistin[
                                                                          index];
                                                                  scollection
                                                                      .removelistitem(
                                                                          index);
                                                                  Hive.box('user_setting').put(
                                                                      'optionmemoinput',
                                                                      indexcontent);
                                                                  Hive.box('user_setting').put(
                                                                      'optionmemocontentinput',
                                                                      content);
                                                                  scollection
                                                                      .addmemolistin(
                                                                          index +
                                                                              1);
                                                                  scollection
                                                                      .addmemolistcontentin(
                                                                          index +
                                                                              1);
                                                                  controllers[
                                                                          index]
                                                                      .text = scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                                  controllers[
                                                                          index +
                                                                              1]
                                                                      .text = scollection
                                                                          .memolistcontentin[
                                                                      index +
                                                                          1];
                                                                }
                                                              });
                                                            },
                                                            child: Icon(
                                                                Icons
                                                                    .expand_more,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  hintText: '내용 입력',
                                                  hintStyle: TextStyle(
                                                      fontSize:
                                                          contentTextsize(),
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                                textAlign: TextAlign.start,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                detectionRegExp:
                                                    detectionRegExp()!,
                                              ))
                                          : (scollection.memolistin[index] ==
                                                      1 ||
                                                  scollection
                                                          .memolistin[index] ==
                                                      999
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: TextField(
                                                    minLines: 1,
                                                    maxLines: 3,
                                                    onTap: () {},
                                                    onChanged: (text) {
                                                      scollection
                                                              .memolistcontentin[
                                                          index] = text;
                                                    },
                                                    focusNode: nodes[index],
                                                    textAlign: TextAlign.start,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                            contentTextsize(),
                                                        color: Colors.black,
                                                        decorationThickness:
                                                            2.3,
                                                        decoration:
                                                            scollection.memolistin[
                                                                        index] ==
                                                                    999
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null),
                                                    decoration: InputDecoration(
                                                      isCollapsed: true,
                                                      border: InputBorder.none,
                                                      prefixIcon: InkWell(
                                                        onTap: () {
                                                          print('tapped');
                                                          scollection
                                                              .addmemocheckboxlist(
                                                                  index);
                                                        },
                                                        child: const Icon(
                                                            Icons
                                                                .check_box_outline_blank,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      suffixIcon: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          controll_memo
                                                                      .ischeckedtohideminus ==
                                                                  true
                                                              ? InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      scollection
                                                                          .removelistitem(
                                                                              index);
                                                                      controllers
                                                                          .removeAt(
                                                                              index);

                                                                      for (int i =
                                                                              0;
                                                                          i < scollection.memolistin.length;
                                                                          i++) {
                                                                        controllers[i]
                                                                            .text = scollection
                                                                                .memolistcontentin[
                                                                            i];
                                                                      }
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .remove_circle_outline,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (index ==
                                                                        0) {
                                                                    } else {
                                                                      String
                                                                          content_prev =
                                                                          controllers[index - 1]
                                                                              .text;
                                                                      int indexcontent_prev = scollection
                                                                              .memolistin[
                                                                          index -
                                                                              1];
                                                                      scollection.removelistitem(
                                                                          index -
                                                                              1);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemoinput',
                                                                          indexcontent_prev);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemocontentinput',
                                                                          content_prev);
                                                                      scollection
                                                                          .addmemolistin(
                                                                              index);
                                                                      scollection
                                                                          .addmemolistcontentin(
                                                                              index);
                                                                      controllers[index -
                                                                              1]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index -
                                                                              1];
                                                                      controllers[
                                                                              index]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index];
                                                                    }
                                                                  });
                                                                },
                                                                child: Icon(
                                                                    Icons
                                                                        .expand_less,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (index +
                                                                            1 ==
                                                                        scollection
                                                                            .memoindex) {
                                                                    } else {
                                                                      String
                                                                          content =
                                                                          scollection
                                                                              .memolistcontentin[index];
                                                                      int indexcontent =
                                                                          scollection
                                                                              .memolistin[index];
                                                                      scollection
                                                                          .removelistitem(
                                                                              index);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemoinput',
                                                                          indexcontent);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemocontentinput',
                                                                          content);
                                                                      scollection.addmemolistin(
                                                                          index +
                                                                              1);
                                                                      scollection.addmemolistcontentin(
                                                                          index +
                                                                              1);
                                                                      controllers[
                                                                              index]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index];
                                                                      controllers[index +
                                                                              1]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index +
                                                                              1];
                                                                    }
                                                                  });
                                                                },
                                                                child: Icon(
                                                                    Icons
                                                                        .expand_more,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      hintText: '내용 입력',
                                                      hintStyle: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: Colors
                                                              .grey.shade400),
                                                    ),
                                                    controller:
                                                        controllers[index],
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: TextField(
                                                    minLines: 1,
                                                    maxLines: 3,
                                                    focusNode: nodes[index],
                                                    onTap: () {},
                                                    onChanged: (text) {
                                                      scollection
                                                              .memolistcontentin[
                                                          index] = text;
                                                    },
                                                    textAlign: TextAlign.start,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: TextStyle(
                                                        fontSize:
                                                            contentTextsize(),
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      isCollapsed: true,
                                                      border: InputBorder.none,
                                                      prefixIcon: const Icon(
                                                          Icons.star_rate,
                                                          color: Colors.black),
                                                      prefixIconColor:
                                                          Colors.black,
                                                      suffixIcon: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          controll_memo
                                                                      .ischeckedtohideminus ==
                                                                  true
                                                              ? InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      const SizedBox(
                                                                          width:
                                                                              30),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      scollection
                                                                          .removelistitem(
                                                                              index);
                                                                      controllers
                                                                          .removeAt(
                                                                              index);

                                                                      for (int i =
                                                                              0;
                                                                          i < scollection.memolistin.length;
                                                                          i++) {
                                                                        controllers[i]
                                                                            .text = scollection
                                                                                .memolistcontentin[
                                                                            i];
                                                                      }
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .remove_circle_outline,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (index ==
                                                                        0) {
                                                                    } else {
                                                                      String
                                                                          content_prev =
                                                                          controllers[index - 1]
                                                                              .text;
                                                                      int indexcontent_prev = scollection
                                                                              .memolistin[
                                                                          index -
                                                                              1];
                                                                      scollection.removelistitem(
                                                                          index -
                                                                              1);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemoinput',
                                                                          indexcontent_prev);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemocontentinput',
                                                                          content_prev);
                                                                      scollection
                                                                          .addmemolistin(
                                                                              index);
                                                                      scollection
                                                                          .addmemolistcontentin(
                                                                              index);
                                                                      controllers[index -
                                                                              1]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index -
                                                                              1];
                                                                      controllers[
                                                                              index]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index];
                                                                    }
                                                                  });
                                                                },
                                                                child: Icon(
                                                                    Icons
                                                                        .expand_less,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (index +
                                                                            1 ==
                                                                        scollection
                                                                            .memoindex) {
                                                                    } else {
                                                                      String
                                                                          content =
                                                                          scollection
                                                                              .memolistcontentin[index];
                                                                      int indexcontent =
                                                                          scollection
                                                                              .memolistin[index];
                                                                      scollection
                                                                          .removelistitem(
                                                                              index);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemoinput',
                                                                          indexcontent);
                                                                      Hive.box('user_setting').put(
                                                                          'optionmemocontentinput',
                                                                          content);
                                                                      scollection.addmemolistin(
                                                                          index +
                                                                              1);
                                                                      scollection.addmemolistcontentin(
                                                                          index +
                                                                              1);

                                                                      controllers[
                                                                              index]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index];
                                                                      controllers[index +
                                                                              1]
                                                                          .text = scollection
                                                                              .memolistcontentin[
                                                                          index +
                                                                              1];
                                                                    }
                                                                  });
                                                                },
                                                                child: Icon(
                                                                    Icons
                                                                        .expand_more,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      hintText: '내용 입력',
                                                      hintStyle: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: Colors
                                                              .grey.shade400),
                                                    ),
                                                    controller:
                                                        controllers[index],
                                                  ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                    ],
                                  );
                                })
                            : const SizedBox();
                      })
                    ],
                  );
                },
              )
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
                        focusNode: searchNode_first_section,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '제목 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
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
                            color: Colors.black),
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
                        focusNode: searchNode_first_section,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '내용 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: Colors.black),
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
                    )
            ],
          );
        }));
  }

  SetAlarmTitle() {
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
