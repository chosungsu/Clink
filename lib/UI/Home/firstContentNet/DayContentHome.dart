import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/addCalendarTodo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:transition/transition.dart';
import 'package:clickbyme/Tool/dateutils.dart';
import '../../../DB/Event.dart';
import '../../../Dialogs/checkhowdaylog.dart';
import '../../../Provider/EventProvider.dart';
import '../../../Sub/DayEventAdd.dart';
import '../../../Tool/CalendarSource.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/changecalendarview.dart';

class DayContentHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int isupschedule = 0;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late Map<DateTime, List<Event>> _events;
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  String hour = '';
  String minute = '';
  final List calendardoinglist = [
    '아침 산책하기',
    '회사 미팅하기',
    '회사 과업 수행하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬과 자바 두언어로 만들기',
  ];
  final List calendarwhattimelist = [
    '6:00 ~ 6:30',
    '9:00 ~ 11:00',
    '9:00 ~ 17:00',
    '19:00 ~ 19:40',
    '20:00 ~ 21:00',
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    _events = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterCheckUi(),
    ));
  }

  List<Event> getEventList(DateTime date) {
    return _events[date] ?? [];
  }

  EnterCheckUi() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  /*height:
                      isupschedule == 0 ? 170 : (isupschedule == 1 ? 220 : 430),*/
                  child: calendarView(height, context)),
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

  calendarView(double height, BuildContext context) {
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
          calendarFormat: isupschedule == 0
              ? CalendarFormat.week
              : (isupschedule == 1
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
                    Navigator.pop(context);
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    child: NeumorphicIcon(
                      Icons.keyboard_arrow_left,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black45,
                          lightSource: LightSource.topLeft),
                    ),
                  )),
              rightChevronVisible: true,
              rightChevronPadding: const EdgeInsets.only(right: 10),
              rightChevronMargin: EdgeInsets.zero,
              rightChevronIcon: IconButton(
                  onPressed: () {
                    //이벤트 작성시트 호출
                    textEditingController1.clear();
                    textEditingController2.clear();
                    textEditingController3.clear();
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: DayScript(
                            index: 0,
                            date: _selectedDay,
                          )),
                    );
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    child: NeumorphicIcon(
                      Icons.add_circle_outlined,
                      size: 30,
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: Colors.black45,
                          lightSource: LightSource.topLeft),
                    ),
                  )),
              titleTextStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleCentered: false,
              formatButtonShowsNext: false),
          calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration:
                  BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              selectedTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.blue)),
        ),
        Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: InkWell(
              onTap: () {
                setState(() {
                  isupschedule == 0
                      ? isupschedule = 1
                      : (isupschedule == 1
                          ? isupschedule = 2
                          : isupschedule = 0);
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade500,
                child: Text(
                  isupschedule == 0 ? '2W' : (isupschedule == 1 ? '1M' : '1W'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  overflow: TextOverflow.fade,
                ),
              ),
            ))
      ],
    ));
  }
  ADView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }
  TimeLineView() {
    return SizedBox(
      height: calendardoinglist.isNotEmpty
          ? 180 * calendardoinglist.length.toDouble()
          : MediaQuery.of(context).size.height * 0.5,
      child: calendardoinglist.isEmpty
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                    '기록된 일정이 없네요;;;',
                    style: NeumorphicStyle(
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
          )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: calendardoinglist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: index < calendarwhattimelist.length - 1 &&
                                          calendarwhattimelist[index]
                                                  .toString()
                                                  .split(':')[0] ==
                                              calendarwhattimelist[index + 1]
                                                  .toString()
                                                  .split(':')[0] ||
                                      index == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NeumorphicText(
                                          calendarwhattimelist[index]
                                                  .toString()
                                                  .split(':')[0] +
                                              ':00',
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Colors.grey.shade400,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 2,
                                          height: 15,
                                          endIndent: 20,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    )
                                  : (index < calendarwhattimelist.length - 1 &&
                                          calendarwhattimelist[index]
                                                  .toString()
                                                  .split(':')[0] !=
                                              calendarwhattimelist[index + 1]
                                                  .toString()
                                                  .split(':')[0] &&
                                          calendarwhattimelist[index]
                                                  .toString()
                                                  .split(':')[0] ==
                                              calendarwhattimelist[index - 1]
                                                  .toString()
                                                  .split(':')[0]
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
                                              calendarwhattimelist[index]
                                                      .toString()
                                                      .split(':')[0] +
                                                  ':00',
                                              style: NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                depth: 3,
                                                color: Colors.grey.shade400,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const Divider(
                                              thickness: 2,
                                              height: 15,
                                              endIndent: 20,
                                              color: Colors.black45,
                                            ),
                                          ],
                                        ))),
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  //수정 및 삭제 시트 띄우기
                                  DelOrEditCalendar(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.black45, width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          calendardoinglist[index].toString(),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          calendarwhattimelist[index]
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black45,
                                                            width: 1)),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
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
              }),
    );
  }
}
