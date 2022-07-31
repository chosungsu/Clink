import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/SheetGetx/calendarshowsetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/settingCalendarHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../DB/Event.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/calendarthemesetting.dart';

class DayContentHome extends StatefulWidget {
  const DayContentHome({
    Key? key,
    required this.title,
    required this.share,
    required this.origin,
  }) : super(key: key);
  final String title;
  final List share;
  final String origin;
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final controll_cals = Get.put(calendarshowsetting());
  static final controll_cals2 = Get.put(calendarthemesetting());
  int setcal_fromsheet = 0;
  int themecal_fromsheet = controll_cals2.themecalendar;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late Map<DateTime, List<Event>> _events;
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  String hour = '';
  String minute = '';
  String username = Hive.box('user_info').get(
    'id',
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    setcal_fromsheet = controll_cals.showcalendar;
    themecal_fromsheet = controll_cals2.themecalendar;
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    _events = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: BGColor(),
      body: EnterCheckUi(controll_cals, controll_cals2),
    ));
  }

  List<Event> getEventList(DateTime date) {
    return _events[date] ?? [];
  }

  EnterCheckUi(
      calendarshowsetting controll_cals, calendarthemesetting controll_cals2) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(color: BGColor()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: calendarView(
                      height, context, controll_cals, controll_cals2)),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: StatefulBuilder(
                              builder: (_, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ADView(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TimeLineView(),
                                  const SizedBox(
                                    height: 150,
                                  )
                                ],
                              ),
                            );
                          })),
                    ),
                  )),
            ],
          )),
    );
  }

  calendarView(double height, BuildContext context,
      calendarshowsetting controll_cals, calendarthemesetting controll_cals2) {
    return SizedBox(
        //height: isupschedule == 0 ? 170 : (isupschedule == 1 ? 220 : 430),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TableCalendar(
          locale: 'ko_KR',
          focusedDay: _focusedDay,
          pageJumpingEnabled: false,
          shouldFillViewport: false,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          calendarFormat: setcal_fromsheet == 0
              ? CalendarFormat.week
              : (setcal_fromsheet == 1
                  ? CalendarFormat.twoWeeks
                  : CalendarFormat.month),
          eventLoader: getEventList,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,
          headerStyle: HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: true,
              leftChevronPadding: const EdgeInsets.only(left: 10),
              leftChevronMargin: EdgeInsets.zero,
              leftChevronIcon: IconButton(
                  onPressed: () {
                    //Navigator.pop(context);
                    Get.back();
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    child: NeumorphicIcon(
                      Icons.keyboard_arrow_left,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                  )),
              rightChevronVisible: true,
              rightChevronPadding: const EdgeInsets.only(right: 10),
              rightChevronMargin: EdgeInsets.zero,
              rightChevronIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Get.to(
                          () => DayScript(
                                index: 0,
                                date: _selectedDay,
                                position: 'cal',
                                title: widget.title,
                                share: widget.share,
                              ),
                          transition: Transition.downToUp);
                    },
                    icon: NeumorphicIcon(
                      Icons.add,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      settingCalendarHome(
                          context, controll_cals, controll_cals2);
                    },
                    icon: NeumorphicIcon(
                      Icons.settings,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                  ),
                ],
              ),
              titleTextStyle: TextStyle(
                color: TextColor(),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              titleCentered: false,
              formatButtonShowsNext: false),
          calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: const BoxDecoration(
                  color: Colors.orange, shape: BoxShape.circle),
              selectedTextStyle: TextStyle(color: TextColor()),
              defaultTextStyle: TextStyle(color: TextColor()),
              weekendTextStyle: const TextStyle(color: Colors.blue)),
        ),
      ],
    ));
  }

  settingCalendarHome(
    BuildContext context,
    calendarshowsetting controll_cals,
    calendarthemesetting controll_cals2,
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
                  height: 320,
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
                  child: SheetPage(context, setcal_fromsheet, controll_cals,
                      controll_cals2, themecal_fromsheet),
                )),
          );
        }).whenComplete(() {
      setState(() {
        setcal_fromsheet = controll_cals.showcalendar;
        themecal_fromsheet = controll_cals2.themecalendar;
      });
    });
  }

  ADView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  TimeLineView() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('CalendarDataBase')
          //.where('Timestart', isGreaterThanOrEqualTo: '00:00')
          .where('calname', isEqualTo: widget.title)
          .where('OriginalUser', isEqualTo: widget.origin)
          .where('Date',
              isEqualTo: _selectedDay.toString().split('-')[0] +
                  '-' +
                  _selectedDay.toString().split('-')[1] +
                  '-' +
                  _selectedDay.toString().split('-')[2].substring(0, 2) +
                  '일')
          //.orderBy('Timestart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.docs.isEmpty
              ? Center(
                  child: NeumorphicText(
                    '기록된 일정이 없네요;;;',
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: TextColor(),
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: index < snapshot.data!.docs.length - 1 &&
                                              snapshot.data!.docs[index]['Timestart']
                                                      .toString()
                                                      .split(':')[0] ==
                                                  snapshot.data!.docs[index + 1]['Timestart']
                                                      .toString()
                                                      .split(':')[0] ||
                                          index == 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            NeumorphicText(
                                              snapshot.data!
                                                      .docs[index]['Timestart']
                                                      .toString()
                                                      .split(':')[0] +
                                                  ':00',
                                              style: NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                depth: 3,
                                                color: TextColor(),
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2,
                                              height: 15,
                                              endIndent: 20,
                                              color: TextColor(),
                                            ),
                                          ],
                                        )
                                      : (index < snapshot.data!.docs.length - 1 &&
                                                  snapshot.data!.docs[index]['Timestart']
                                                          .toString()
                                                          .split(':')[0] ==
                                                      snapshot.data!.docs[index - 1]['Timestart']
                                                          .toString()
                                                          .split(':')[0] ||
                                              (index == snapshot.data!.docs.length - 1 &&
                                                  snapshot.data!.docs[index]['Timestart']
                                                          .toString()
                                                          .split(':')[0] ==
                                                      snapshot.data!.docs[index - 1]['Timestart'].toString().split(':')[0])
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                NeumorphicText(
                                                  snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['Timestart']
                                                          .toString()
                                                          .split(':')[0] +
                                                      ':00',
                                                  style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: TextColor(),
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                  height: 15,
                                                  endIndent: 20,
                                                  color: TextColor(),
                                                ),
                                              ],
                                            ))),
                              Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      //수정 및 삭제 시트 띄우기
                                      //DelOrEditCalendar(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      decoration: BoxDecoration(
                                          color: themecal_fromsheet == 0
                                              ? (index % 4 == 0
                                                  ? MyTheme.colororigred
                                                  : (index % 4 == 1
                                                      ? MyTheme.colororigorange
                                                      : (index % 4 == 2
                                                          ? MyTheme
                                                              .colororigblue
                                                          : MyTheme
                                                              .colororiggreen)))
                                              : (index % 4 == 0
                                                  ? MyTheme.colorpastelred
                                                  : (index % 4 == 1
                                                      ? MyTheme
                                                          .colorpastelorange
                                                      : (index % 4 == 2
                                                          ? MyTheme
                                                              .colorpastelblue
                                                          : MyTheme
                                                              .colorpastelgreen))),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: TextColor(), width: 1)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              snapshot
                                                  .data!.docs[index]['Daytodo']
                                                  .toString(),
                                              maxLines: 3,
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: snapshot
                                                    .data!
                                                    .docs[index]['Timefinish']
                                                    .isEmpty
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'Timestart']
                                                                .toString()
                                                                .split(
                                                                    ':')[1] ==
                                                            '0'
                                                        ? snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'Timestart']
                                                                .toString() +
                                                            '0' +
                                                            '-' +
                                                            ''
                                                        : snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'Timestart']
                                                                .toString() +
                                                            '-' +
                                                            '',
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Text(
                                                    snapshot.data!.docs[index]['Timestart']
                                                                .toString()
                                                                .split(
                                                                    ':')[1] ==
                                                            '0'
                                                        ? snapshot.data!.docs[index]['Timestart']
                                                                .toString() +
                                                            '0' +
                                                            '-' +
                                                            snapshot.data!.docs[index]['Timefinish']
                                                                .toString()
                                                        : (snapshot.data!.docs[index]['Timefinish'].toString().split(':')[1] == '0'
                                                            ? snapshot.data!.docs[index]['Timestart']
                                                                    .toString() +
                                                                '-' +
                                                                snapshot.data!.docs[index]['Timefinish']
                                                                    .toString() +
                                                                '0'
                                                            : snapshot.data!.docs[index]['Timestart']
                                                                    .toString() +
                                                                '0' +
                                                                '-' +
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        ['Timefinish']
                                                                    .toString()),
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'with',
                                                    softWrap: true,
                                                    style: GoogleFonts.lobster(
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: snapshot
                                                          .data!
                                                          .docs[index]['Shares']
                                                          .length,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 25,
                                                              width: 25,
                                                              child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'Shares']
                                                                          [
                                                                          index2]
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          1),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  });
        } else if (snapshot.hasError) {
          return Center(
            child: NeumorphicText(
              '불러오는 중 오류가 발생하였습니다.\n지속될 경우 문의바랍니다.',
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                depth: 3,
                color: TextColor(),
              ),
              textStyle: NeumorphicTextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(
          child: NeumorphicText(
            '기록된 일정이 없네요;;;',
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              depth: 3,
              color: TextColor(),
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTitleTextsize(),
            ),
          ),
        );
      },
    );
  }
}
