import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../DB/TODO.dart';
import '../../Dialogs/checkhowdaylog.dart';
import '../../Futures/homeasync.dart';
import '../../Provider/EventProvider.dart';
import '../../Sub/DayEventAdd.dart';
import '../../Tool/CalendarSource.dart';
import '../../Tool/NoBehavior.dart';
import '../../sheets/changecalendarview.dart';

class DayContentHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String calendarview = 'day';

  @override
  void initState() {
    super.initState();
    setState(() {
      calendarview = Hive.box('user_setting').get('radio_cal') ?? 'day';
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      calendarview = Hive.box('user_setting').get('radio_cal') ?? 'day';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterCheckUi(calendarview),
    ));
  }

  EnterCheckUi(String s) {
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
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                        width: 50,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
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
                                    color: Colors.black45,
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60 - 160,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ))),
                    SizedBox(
                        width: 160,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              IconButton(
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                color: Colors.white,
                                tooltip: '사용방법',
                                onPressed: () => {checkhowdaylog(context)},
                                icon: const Icon(
                                  Icons.question_mark,
                                  color: Colors.black45,
                                ),
                              ),
                              IconButton(
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                color: Colors.black45,
                                tooltip: '뷰 변경',
                                onPressed: () => {
                                  calendarview = Hive.box('user_setting')
                                          .get('radio_cal') ??
                                      'day',
                                  calendarview == 'month'
                                      ? changecalendarview(context, 'month')
                                      : (calendarview == 'week'
                                          ? changecalendarview(context, 'week')
                                          : changecalendarview(context, 'day'))
                                },
                                icon: const Icon(Icons.change_circle),
                              ),
                              IconButton(
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                color: Colors.black45,
                                tooltip: '추가하기',
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DayEventAdd(),
                                          type: PageTransitionType
                                              .leftToRightWithFade))
                                  //addTodos(context, textEditingController, selectedDay)
                                },
                                icon: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              calendarView(height, context, s),
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

  calendarView(double height, BuildContext context, String calendarview) {
    final _getDataSource = Provider.of<EventProvider>(context).events;
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          calendarview == 'day'
              ? SizedBox(
                  height: height * 0.6,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            border: NeumorphicBorder.none(),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(20)),
                            depth: -2,
                            color: Colors.grey.shade200
                            //color: Colors.grey.shade200,
                            ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: SfCalendar(
                            view: CalendarView.day,
                            initialSelectedDate: DateTime.now(),
                            dataSource: MeetingDataSource(_getDataSource),
                            onTap: (details) {
                              final provider = Provider.of<EventProvider>(
                                  context,
                                  listen: false);
                              provider.setDate(details.date!);
                              setState(() {
                                selectedDay = details.date!;
                              });
                            },
                            monthViewSettings: const MonthViewSettings(
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.indicator),
                            timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 0,
                                endHour: 24,
                                nonWorkingDays: <int>[
                                  DateTime.saturday,
                                  DateTime.sunday
                                ]),
                          ),
                        )),
                  ))
              : (calendarview == 'week'
                  ? SizedBox(
                      height: height * 0.6,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                border: NeumorphicBorder.none(),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20)),
                                depth: -2,
                                color: Colors.grey.shade200
                                //color: Colors.grey.shade200,
                                ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: SfCalendar(
                                view: CalendarView.week,
                                initialSelectedDate: DateTime.now(),
                                dataSource: MeetingDataSource(_getDataSource),
                                onTap: (details) {
                                  final provider = Provider.of<EventProvider>(
                                      context,
                                      listen: false);
                                  provider.setDate(details.date!);
                                  setState(() {
                                    selectedDay = details.date!;
                                  });
                                },
                                monthViewSettings: const MonthViewSettings(
                                    appointmentDisplayMode:
                                        MonthAppointmentDisplayMode.indicator),
                                timeSlotViewSettings:
                                    const TimeSlotViewSettings(
                                        startHour: 0,
                                        endHour: 24,
                                        nonWorkingDays: <int>[
                                      DateTime.saturday,
                                      DateTime.sunday
                                    ]),
                              ),
                            )),
                      ))
                  : SizedBox(
                      height: height * 0.6,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  border: NeumorphicBorder.none(),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(20)),
                                  depth: -2,
                                  color: Colors.grey.shade200
                                  //color: Colors.grey.shade200,
                                  ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: SfCalendar(
                                  view: CalendarView.month,
                                  initialSelectedDate: DateTime.now(),
                                  dataSource: MeetingDataSource(_getDataSource),
                                  onTap: (details) {
                                    final provider = Provider.of<EventProvider>(
                                        context,
                                        listen: false);
                                    provider.setDate(details.date!);
                                    setState(() {
                                      selectedDay = details.date!;
                                    });
                                  },
                                  monthViewSettings: const MonthViewSettings(
                                      appointmentDisplayMode:
                                          MonthAppointmentDisplayMode
                                              .indicator),
                                  timeSlotViewSettings:
                                      const TimeSlotViewSettings(
                                          startHour: 0,
                                          endHour: 24,
                                          nonWorkingDays: <int>[
                                        DateTime.saturday,
                                        DateTime.sunday
                                      ]),
                                ),
                              ))),
                    )),
        ],
      );
    });
  }
}

/*CalendarView(double height) {
  return SizedBox(
    height: height * 0.6,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        EnterCheckEvents(height: height),
      ],
    ),
  );
}
*/