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
import '../../../Dialogs/checkbackincandm.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/addmemocollection.dart';

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
  final imagePicker = ImagePicker();
  final searchNode_first_section = FocusNode();
  final searchNode_second_section = FocusNode();
  final searchNode_third_section = FocusNode();
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  //캘린더변수
  late Map<DateTime, List<Event>> _events;
  static final cal_share_person = Get.put(PeopleAdd());
  final controll_memo = Get.put(memosetting());
  List finallist = cal_share_person.people;
  String selectedValue = '선택없음';
  bool isChecked_pushalarm = false;
  int differ_date = 0;
  List differ_list = [];
  //메모변수
  final scollection = Get.put(selectcollection());
  final searchNode_add_section = FocusNode();
  late TextEditingController textEditingController_add_sheet;
  List<TextEditingController> controllers = [];
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
    Hive.box('user_setting').put('coloreachmemo', BGColor().value.toInt());
    controll_memo.setcolor();
    controll_memo.resetimagelist();
    _color = controll_memo.color;
    checklisttexts.clear();
    controllers.clear();
    scollection.resetmemolist();
    cal_share_person.peoplecalendarrestart();
    finallist = cal_share_person.people;
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
    textEditingController_add_sheet = TextEditingController();
    _events = {};

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
    textEditingController_add_sheet.dispose();
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].dispose();
    }
  }

  Future<bool> _onBackPressed() async {
    final reloadpage = await Get.dialog(checkbackincandm(context)) ?? false;
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
        child: GestureDetector(
          onTap: () {
            searchNode_first_section.unfocus();
            searchNode_second_section.unfocus();
            searchNode_third_section.unfocus();
            searchNode_add_section.unfocus();
            for (int i = 0; i < scollection.memoindex; i++) {
              if (nodes.isNotEmpty) {
                nodes[i].unfocus();
              }
              scollection.memolistcontentin[i] = controllers[i].text;
            }
          },
          child: UI(),
        ),
      ),
      bottomNavigationBar: widget.position == 'note'
          ? Container(
              padding: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                  color: BGColor_shadowcolor(),
                  border: Border(
                      top: BorderSide(
                          color: TextColor_shadowcolor(), width: 2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: ((context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              index == 0
                                  ? MFHolderfirst(
                                      checkbottoms, nodes, scollection)
                                  : (index == 1
                                      ? MFthird(nodes, _color, '')
                                      : MFsecond(
                                          nodes,
                                          _color,
                                        )),
                            ],
                          );
                        })),
                  ),
                  MFforth(ischeckedtohideminus)
                ],
              ))
          : const SizedBox(
              height: 0,
            ),
    ));
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
                          : BGColor(),
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
                                                        await Get.dialog(
                                                                checkbackincandm(
                                                                    context)) ??
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
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          surfaceIntensity: 0.5,
                                                          color: TextColor(),
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  )),
                                              color: TextColor()),
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
                                                                  TextColor()),
                                                        ),
                                                      ),
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
                                                                        'date': DateFormat('yyyy-MM-dd')
                                                                            .parse(widget.firstdate.toString())
                                                                            .toString()
                                                                            .split(' ')[0],
                                                                        'username':
                                                                            widget.share
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
                                                                          : differ_date =
                                                                              0;
                                                                      for (int i =
                                                                              0;
                                                                          i <=
                                                                              differ_date;
                                                                          i++) {
                                                                        if (differ_date ==
                                                                            0) {
                                                                        } else {
                                                                          differ_list.add(DateTime(
                                                                              widget.firstdate.year,
                                                                              widget.firstdate.month,
                                                                              widget.firstdate.day + i));
                                                                        }
                                                                      }
                                                                      if (differ_list
                                                                          .isNotEmpty) {
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
                                                                        }
                                                                        CreateCalandmemoSuccessFlushbarSub(
                                                                            context,
                                                                            '일정');
                                                                        if (isChecked_pushalarm ==
                                                                            true) {
                                                                          NotificationApi.showScheduledNotification(
                                                                              title: '알람설정된 일정 : ' + textEditingController1.text,
                                                                              body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                              scheduledate: DateTime.utc(
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(5, 7)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(8, 10)),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1 : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1])) : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              ));
                                                                        } else {
                                                                          NotificationApi
                                                                              .showNotification(
                                                                            title:
                                                                                '알람설정된 일정 : ' + textEditingController1.text,
                                                                            body: textEditingController2.text.split(':')[0].length == 1
                                                                                ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt)
                                                                                : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                          );
                                                                        }
                                                                      } else {
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
                                                                          NotificationApi.showScheduledNotification(
                                                                              title: '알람설정된 일정 : ' + textEditingController1.text,
                                                                              body: textEditingController2.text.split(':')[0].length == 1 ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt) : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                              scheduledate: DateTime.utc(
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(0, 4)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(5, 7)),
                                                                                int.parse(widget.firstdate.toString().toString().split(' ')[0].toString().substring(8, 10)),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]) - 1 : int.parse(textEditingController2.text.split(':')[0].length == 1 ? '0' + textEditingController2.text.split(':')[0] : textEditingController2.text.split(':')[0]),
                                                                                int.parse(textEditingController2.text.split(':')[1]) < int.parse(selectedValue.substring(0, selectedValue.length - 3)) ? 60 - (int.parse(selectedValue.substring(0, selectedValue.length - 3)) - int.parse(textEditingController2.text.split(':')[1])) : int.parse(textEditingController2.text.split(':')[1]) - int.parse(selectedValue.substring(0, selectedValue.length - 3)),
                                                                              ));
                                                                        } else {
                                                                          NotificationApi
                                                                              .showNotification(
                                                                            title:
                                                                                '알람설정된 일정 : ' + textEditingController1.text,
                                                                            body: textEditingController2.text.split(':')[0].length == 1
                                                                                ? (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + firsttxt : '예정된 시각 : ' + secondtxt)
                                                                                : (textEditingController3.text.split(':')[0].length == 1 ? '예정된 시각 : ' + thirdtxt : '예정된 시각 : ' + forthtxt),
                                                                          );
                                                                        }
                                                                      }
                                                                    } else {
                                                                      CreateCalandmemoSuccessFlushbar(
                                                                          context);
                                                                      firestore
                                                                          .collection(
                                                                              'AppNoticeByUsers')
                                                                          .add({
                                                                        'title':
                                                                            '메모 ${textEditingController1.text}가 추가되었습니다.',
                                                                        'date': DateFormat('yyyy-MM-dd')
                                                                            .parse(widget.firstdate.toString())
                                                                            .toString()
                                                                            .split(' ')[0],
                                                                        'username':
                                                                            widget.share
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
                                                                      for (int j =
                                                                              0;
                                                                          j < controll_memo.imagelist.length;
                                                                          j++) {
                                                                        savepicturelist
                                                                            .add(controll_memo.imagelist[j]);
                                                                      }
                                                                      firestore
                                                                          .collection(
                                                                              'MemoDataBase')
                                                                          .doc()
                                                                          .set({
                                                                        'memoTitle':
                                                                            textEditingController1.text,
                                                                        'saveimage':
                                                                            savepicturelist,
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
                                                                        'color':
                                                                            Hive.box('user_setting').get('typecolorcalendar') ??
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
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color:
                                                                          TextColor(),
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: TextColor()),
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
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Column(
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
        ? SizedBox(
            height: 30,
            child: Row(
              children: [
                Text(
                  '일정제목',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text('필수항목',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ))
        : (widget.position == 'note'
            ? SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      '메모제목',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: TextColor()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('필수항목',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ))
            : SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      '루틴제목',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
                          color: TextColor()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('필수항목',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                )));
  }

  WholeContent() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: searchNode_first_section,
              style: TextStyle(fontSize: contentTextsize(), color: TextColor()),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '일정 제목 추가',
                hintStyle:
                    TextStyle(fontSize: contentTextsize(), color: TextColor()),
              ),
              controller: textEditingController1,
            ),
          )
        : (widget.position == 'note'
            ? ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
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
                          style: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: '제목 입력',
                            hintStyle: TextStyle(
                                fontSize: contentTextsize(),
                                color: TextColor()),
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
                          '첨부사진',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: TextColor()),
                        ),
                      ),
                      GetBuilder<memosetting>(
                        builder: (_) => SizedBox(
                            height: 100,
                            child: controll_memo.imagelist.isEmpty
                                ? Center(
                                    child: Text(
                                      '하단바의 사진아이콘을 클릭하여 추가하세요',
                                      style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: TextColor()),
                                    ),
                                  )
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
                          height: 30,
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  '컬렉션 선택',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                      color: TextColor()),
                                ),
                              ),
                              InkWell(
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
                                child: NeumorphicIcon(
                                  Icons.add,
                                  size: 30,
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      surfaceIntensity: 0.5,
                                      color: TextColor(),
                                      lightSource: LightSource.topLeft),
                                ),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 30,
                        child: Text(
                          '+아이콘으로 MY컬렉션을 추가 및 지정해주세요',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue),
                        ),
                      ),
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
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
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
                              color: TextColor()),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 30,
                        child: Text(
                          '하단 아이콘으로 메모내용 작성하시면 됩니다.',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue),
                        ),
                      ),
                      GetBuilder<selectcollection>(
                          builder: (_) => scollection.memolistin.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: scollection.memolistin.length,
                                  itemBuilder: (context, index) {
                                    nodes.add(FocusNode());
                                    controllers.add(TextEditingController());
                                    controllers[index].text =
                                        scollection.memolistcontentin[index];
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
                                                  controller: controllers[index]
                                                    ..selection = TextSelection
                                                        .fromPosition(TextPosition(
                                                            offset: controllers[
                                                                    index]
                                                                .text
                                                                .length)),
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
                                                                    controllers[
                                                                            index]
                                                                        .text = '';
                                                                    scollection
                                                                        .removelistitem(
                                                                            index);
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
                                                                  if (index ==
                                                                      0) {
                                                                    scollection
                                                                        .addmemolistin(
                                                                            index);
                                                                    scollection
                                                                        .addmemolistcontentin(
                                                                            index);
                                                                  } else {
                                                                    scollection
                                                                        .addmemolistin(
                                                                            index -
                                                                                1);
                                                                    scollection
                                                                        .addmemolistcontentin(
                                                                            index -
                                                                                1);
                                                                  }
                                                                });
                                                              },
                                                              child: Icon(
                                                                  Icons
                                                                      .expand_less,
                                                                  color:
                                                                      TextColor_shadowcolor()),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
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
                                                                  if (index +
                                                                          1 ==
                                                                      scollection
                                                                          .memoindex) {
                                                                    scollection
                                                                        .addmemolistin(
                                                                            index);
                                                                    scollection
                                                                        .addmemolistcontentin(
                                                                            index);
                                                                  } else {
                                                                    scollection
                                                                        .addmemolistin(
                                                                            index +
                                                                                1);
                                                                    scollection
                                                                        .addmemolistcontentin(
                                                                            index +
                                                                                1);
                                                                  }
                                                                });
                                                              },
                                                              child: Icon(
                                                                  Icons
                                                                      .expand_more,
                                                                  color:
                                                                      TextColor_shadowcolor()),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    hintText: '내용 입력',
                                                    hintStyle: TextStyle(
                                                        fontSize:
                                                            contentTextsize(),
                                                        color: TextColor()),
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  detectionRegExp:
                                                      detectionRegExp()!,
                                                  onDetectionTyped: (text) {
                                                    print(text);
                                                  },
                                                  onDetectionFinished: () {
                                                    print('finished');
                                                  },
                                                ))
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
                                                            50,
                                                    child: TextField(
                                                      minLines: 1,
                                                      maxLines: 1,
                                                      focusNode: nodes[index],
                                                      textAlign:
                                                          TextAlign.start,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: TextColor(),
                                                          decorationThickness:
                                                              2.3,
                                                          decoration: scollection
                                                                          .memolistin[
                                                                      index] ==
                                                                  999
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null),
                                                      decoration:
                                                          InputDecoration(
                                                        isCollapsed: true,
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: InkWell(
                                                          onTap: () {
                                                            print('tapped');
                                                            scollection
                                                                .addmemocheckboxlist(
                                                                    index);
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              color:
                                                                  TextColor()),
                                                        ),
                                                        suffixIcon: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            controll_memo
                                                                        .ischeckedtohideminus ==
                                                                    true
                                                                ? InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        const SizedBox(
                                                                      width: 30,
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        controllers[index].text =
                                                                            '';
                                                                        scollection
                                                                            .removelistitem(index);
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
                                                                    setState(
                                                                        () {
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
                                                                      if (index ==
                                                                          0) {
                                                                        scollection
                                                                            .addmemolistin(index);
                                                                        scollection
                                                                            .addmemolistcontentin(index);
                                                                      } else {
                                                                        scollection.addmemolistin(
                                                                            index -
                                                                                1);
                                                                        scollection.addmemolistcontentin(
                                                                            index -
                                                                                1);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .expand_less,
                                                                      color:
                                                                          TextColor_shadowcolor()),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
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
                                                                      if (index +
                                                                              1 ==
                                                                          scollection
                                                                              .memoindex) {
                                                                        scollection
                                                                            .addmemolistin(index);
                                                                        scollection
                                                                            .addmemolistcontentin(index);
                                                                      } else {
                                                                        scollection.addmemolistin(
                                                                            index +
                                                                                1);
                                                                        scollection.addmemolistcontentin(
                                                                            index +
                                                                                1);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .expand_more,
                                                                      color:
                                                                          TextColor_shadowcolor()),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        hintText: '내용 입력',
                                                        hintStyle: TextStyle(
                                                            fontSize:
                                                                contentTextsize(),
                                                            color: TextColor()),
                                                      ),
                                                      controller: controllers[
                                                          index]
                                                        ..selection = TextSelection
                                                            .fromPosition(TextPosition(
                                                                offset: controllers[
                                                                        index]
                                                                    .text
                                                                    .length)),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    child: TextField(
                                                      minLines: 1,
                                                      maxLines: 1,
                                                      focusNode: nodes[index],
                                                      textAlign:
                                                          TextAlign.start,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: TextColor()),
                                                      decoration:
                                                          InputDecoration(
                                                        isCollapsed: true,
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: Icon(
                                                            Icons.star_rate,
                                                            color: TextColor()),
                                                        prefixIconColor:
                                                            TextColor(),
                                                        suffixIcon: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            controll_memo
                                                                        .ischeckedtohideminus ==
                                                                    true
                                                                ? InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child: const SizedBox(
                                                                        width:
                                                                            30),
                                                                  )
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        controllers[index].text =
                                                                            '';
                                                                        scollection
                                                                            .removelistitem(index);
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
                                                                    setState(
                                                                        () {
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
                                                                      if (index ==
                                                                          0) {
                                                                        scollection
                                                                            .addmemolistin(index);
                                                                        scollection
                                                                            .addmemolistcontentin(index);
                                                                      } else {
                                                                        scollection.addmemolistin(
                                                                            index -
                                                                                1);
                                                                        scollection.addmemolistcontentin(
                                                                            index -
                                                                                1);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .expand_less,
                                                                      color:
                                                                          TextColor_shadowcolor()),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
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
                                                                      if (index +
                                                                              1 ==
                                                                          scollection
                                                                              .memoindex) {
                                                                        scollection
                                                                            .addmemolistin(index);
                                                                        scollection
                                                                            .addmemolistcontentin(index);
                                                                      } else {
                                                                        scollection.addmemolistin(
                                                                            index +
                                                                                1);
                                                                        scollection.addmemolistcontentin(
                                                                            index +
                                                                                1);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                      Icons
                                                                          .expand_more,
                                                                      color:
                                                                          TextColor_shadowcolor()),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        hintText: '내용 입력',
                                                        hintStyle: TextStyle(
                                                            fontSize:
                                                                contentTextsize(),
                                                            color: TextColor()),
                                                      ),
                                                      controller: controllers[
                                                          index]
                                                        ..selection = TextSelection
                                                            .fromPosition(TextPosition(
                                                                offset: controllers[
                                                                        index]
                                                                    .text
                                                                    .length)),
                                                    ),
                                                  )),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                      ],
                                    );
                                  })
                              : const SizedBox())
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
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '제목 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
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
                            color: TextColor()),
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
                        style: TextStyle(fontSize: 20, color: TextColor()),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '내용 입력',
                          hintStyle: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
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
            color: TextColor()),
      ),
    );
  }

  Time() {
    return widget.position == 'cal'
        ? SizedBox(
            height: widget.lastdate != widget.firstdate ? 320 : 300,
            child: Column(
              children: [
                widget.lastdate != widget.firstdate
                    ? SizedBox(
                        height: 100,
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
                                  color: TextColor(),
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
                                  color: TextColor()),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 80,
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
                                  color: TextColor(),
                                  lightSource: LightSource.topLeft),
                            ),
                            title: Text(
                              widget.firstdate.toString().split(' ')[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                  color: TextColor()),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.schedule,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '시작시간',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        controller: textEditingController2,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          pickDates(context, textEditingController2,
                              widget.firstdate);
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: TextColor(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.schedule,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '종료시간',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      subtitle: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: contentTextsize(), color: TextColor()),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        controller: textEditingController3,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          pickDates(context, textEditingController3,
                              widget.firstdate);
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: TextColor(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
        : (widget.position == 'note'
            ? SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        '중요도 선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                      .get('stars') ==
                                                  1 ||
                                              Hive.box('user_setting')
                                                      .get('stars') ==
                                                  null
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 1);
                                    });
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
                                            '+1',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                              .get('stars') ==
                                                          1 ||
                                                      Hive.box('user_setting')
                                                              .get('stars') ==
                                                          null
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              2
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 2);
                                    });
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
                                            '+2',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      2
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              3
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 3);
                                    });
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
                                            '+3',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      3
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
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
                  ],
                ),
              )
            : SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        '중요도 선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                      .get('stars') ==
                                                  1 ||
                                              Hive.box('user_setting')
                                                      .get('stars') ==
                                                  null
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 1);
                                    });
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
                                            '+1',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                              .get('stars') ==
                                                          1 ||
                                                      Hive.box('user_setting')
                                                              .get('stars') ==
                                                          null
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              2
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 2);
                                    });
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
                                            '+2',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      2
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      primary: Hive.box('user_setting')
                                                  .get('stars') ==
                                              3
                                          ? Colors.grey.shade400
                                          : Colors.white,
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black45,
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      Hive.box('user_setting').put('stars', 3);
                                    });
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
                                            '+3',
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              depth: 3,
                                              color: Hive.box('user_setting')
                                                          .get('stars') ==
                                                      3
                                                  ? Colors.white
                                                  : Colors.black45,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
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
                  ],
                ),
              ));
  }

  SetAlarmTitle() {
    return widget.position == 'cal'
        ? SizedBox(
            height: 30,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '알람설정',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                      activeColor: Colors.blue,
                      inactiveThumbColor: TextColor(),
                      inactiveTrackColor: Colors.grey.shade100,
                      value: isChecked_pushalarm,
                      onChanged: (bool val) {
                        setState(() {
                          isChecked_pushalarm = val;
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
            height: 200,
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: ContainerDesign(
                    color: BGColor(),
                    child: ListTile(
                      leading: NeumorphicIcon(
                        Icons.alarm,
                        size: 30,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            surfaceIntensity: 0.5,
                            color: TextColor(),
                            lightSource: LightSource.topLeft),
                      ),
                      title: Text(
                        '알람',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                      trailing: isChecked_pushalarm == true
                          ? DropdownButton(
                              value: selectedValue,
                              dropdownColor: BGColor(),
                              items: dropdownItems_alarm,
                              icon: NeumorphicIcon(
                                Icons.arrow_drop_down,
                                size: 20,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                              style: TextStyle(
                                  color: TextColor(),
                                  fontSize: contentTextsize()),
                              onChanged: isChecked_pushalarm == true
                                  ? (String? value) {
                                      setState(() {
                                        selectedValue = value!;
                                        Hive.box('user_setting').put(
                                            'alarming_time', selectedValue);
                                      });
                                    }
                                  : null,
                            )
                          : Text(
                              '설정off상태입니다.',
                              style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: TextColor()),
                            ),
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
