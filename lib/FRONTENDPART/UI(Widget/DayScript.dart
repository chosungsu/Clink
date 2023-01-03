// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/FIREBASE/CalendarVP.dart';
import 'package:clickbyme/Enums/Variables.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/MemoFocusedHolder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../FRONTENDPART/Route/subuiroute.dart';
import '../../../Tool/AndroidIOS.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/ContainerDesign.dart';
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
  List<FocusNode> focusnodelist =
      List<FocusNode>.generate(7, ((index) => FocusNode()));
  late List<TextEditingController> texteditingcontrollerlist;
  final draw = Get.put(navibool());
  final cal_share_person = Get.put(PeopleAdd());
  final controll_cal = Get.put(calendarsetting());
  final controll_memo = Get.put(memosetting());
  final scollection = Get.put(selectcollection());
  //메모변수
  List<TextEditingController> controllers = List.empty(growable: true);
  List<FocusNode> nodes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    texteditingcontrollerlist =
        List<TextEditingController>.generate(5, ((index) {
      if (index == 0 || index == 3 || index == 4 || index == 5) {
        return TextEditingController();
      } else {
        if (widget.position == 'note') {
          return TextEditingController();
        } else {
          return TextEditingController(text: '하루종일 일정');
        }
      }
    }));
    selectedDay = controll_cal.selectedDay;
    controll_memo.imagelist.clear();
    Hive.box('user_setting')
        .put('alarm_cal_hour_${cal_share_person.secondname}', '99');
    Hive.box('user_setting')
        .put('alarm_cal_minute_${cal_share_person.secondname}', '99');
    Hive.box('user_setting').put('typecolorcalendar', null);
    color = controll_memo.color;
    colorfont = controll_memo.colorfont;
    checklisttexts.clear();
    scollection.controllersall.clear();
    scollection.memolistin.clear();
    scollection.memolistcontentin.clear();
    scollection.memoindex = 0;
    Hive.box('user_setting').put('share_cal_person', '');
    cal_share_person.people = [];
    finallist = cal_share_person.people;
    events = {};
    ischeckedtohideminus = controll_memo.ischeckedtohideminus;
    scollection.collection = '';
    selectedValue = Hive.box('user_setting').get('alarming_time') ?? '5분 전';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (int i = 0; i < texteditingcontrollerlist.length; i++) {
      texteditingcontrollerlist[i].dispose();
    }
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
                ? (color == controll_memo.color ? color : controll_memo.color)
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
                                                color,
                                                '',
                                                controll_memo
                                                    .ischeckedtohideminus,
                                                scollection.controllersall,
                                                colorfont,
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
                                            savecalendarsandmemo(
                                                context,
                                                texteditingcontrollerlist,
                                                widget.position,
                                                widget.id);
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
                ? (color == controll_memo.color ? color : controll_memo.color)
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
                                                color,
                                                '',
                                                controll_memo
                                                    .ischeckedtohideminus,
                                                scollection.controllersall,
                                                colorfont,
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
                                            savecalendarsandmemo(
                                                context,
                                                texteditingcontrollerlist,
                                                widget.position,
                                                widget.id);
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
              controller: texteditingcontrollerlist[0],
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
                          controller: texteditingcontrollerlist[0],
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
                                  texteditingcontrollerlist[5],
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
                                                  : colorfont ==
                                                          controll_memo
                                                              .colorfont
                                                      ? colorfont
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
                    pickDates(context, texteditingcontrollerlist[1],
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
                    controller: texteditingcontrollerlist[1],
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
                      pickDates(context, texteditingcontrollerlist[2],
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
                      controller: texteditingcontrollerlist[2],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<calendarsetting>(
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
                                for (int i = 0; i < focusnodelist.length; i++) {
                                  if (i == 3) {
                                  } else {
                                    focusnodelist[i].unfocus();
                                  }
                                }
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  showrepeatdate(
                                      context,
                                      texteditingcontrollerlist[3],
                                      focusnodelist[3]);
                                });
                              },
                              child: Text(
                                'Click',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: controll_memo.color == Colors.black
                                        ? Colors.white
                                        : TextColor()),
                              ),
                            ),
                            subtitle: controll_cal.repeatwhile == 'no'
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
                                    controll_cal.repeatwhile +
                                        '간반복 : ' +
                                        controll_cal.repeatdate.toString() +
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
                      )),
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
              controller: texteditingcontrollerlist[4],
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
                        focusnodelist[5],
                        focusnodelist[6],
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
        return Padding(
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
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
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
                  ),
                ),
              ),
            ));
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
