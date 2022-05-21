import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/Dialogs/checkhowdaylog.dart';
import 'package:clickbyme/Provider/EventProvider.dart';
import 'package:clickbyme/Sub/DayEventAdd.dart';
import 'package:clickbyme/Sub/EventViewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../DB/TODO.dart';
import '../Futures/homeasync.dart';
import '../Page/DrawerScreen.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/CalendarSource.dart';
import '../Tool/ShimmerDesign/Shimmer_DayLog.dart';
import '../sheets/changecalendarview.dart';

class DayLog extends StatefulWidget {
  //get onEventTap => null;

  @override
  State<StatefulWidget> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
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
    setState(() {
      calendarview = Hive.box('user_setting').get('radio_cal') ?? 'day';
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            DrawerScreen(),
            makeBody(context, calendarview),
          ],
        ));
  }

  // 바디 만들기
  Widget makeBody(BuildContext context, String calendarview) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02, right: 10),
            alignment: Alignment.topLeft,
            color: Colors.deepPurple.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.keyboard_arrow_left),
                              color: Colors.white,
                              iconSize: 30,
                            )),
                        const SizedBox(
                            child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('데이로그',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    )),
                SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        IconButton(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          color: Colors.white,
                          tooltip: '사용방법',
                          onPressed: () => {checkhowdaylog(context)},
                          icon: const Icon(Icons.question_mark),
                        ),
                        IconButton(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          color: Colors.white,
                          tooltip: '뷰 변경',
                          onPressed: () => {
                            calendarview =
                                Hive.box('user_setting').get('radio_cal') ??
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
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          color: Colors.white,
                          tooltip: '추가하기',
                          onPressed: () => {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: DayEventAdd(),
                                    type:
                                        PageTransitionType.leftToRightWithFade))
                            //addTodos(context, textEditingController, selectedDay)
                          },
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  left: BorderSide(
                      width: 1.0,
                      color: const Color.fromARGB(255, 255, 214, 214)),
                  right: const BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  bottom: const BorderSide(
                      width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                )),
            child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.9 - 20,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: calendarView(),
                    ))),
          ),
        ),
      ],
    );
  }

  calendarView() {
    final _getDataSource = Provider.of<EventProvider>(context).events;
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          calendarview == 'day'
              ? SizedBox(
                  height: 400,
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
                            final provider = Provider.of<EventProvider>(context,
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
                  )
                )
              : (calendarview == 'week'
                  ? SizedBox(
                      height: 400,
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
                  : SizedBox(
                      height: 400,
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
                                      MonthAppointmentDisplayMode.indicator),
                              timeSlotViewSettings: const TimeSlotViewSettings(
                                  startHour: 0,
                                  endHour: 24,
                                  nonWorkingDays: <int>[
                                    DateTime.saturday,
                                    DateTime.sunday
                                  ]),
                            ),
                          ))),
                      )),
          FutureBuilder<List<TODO>>(
            future: homeasync(
                selectedDay), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<TODO>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return timelineview(context, selectedDay, snapshot.data!);
              } else {
                return Shimmer_DayLog(context);
              }
            },
          ),
        ],
      );
    });
  }

  timelineview(
    BuildContext context,
    DateTime selectedDay,
    List<TODO> list,
  ) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final selectEvents = provider.eventsofDate;
    List<TODO> tmp_todo_list = [];
    //List<String> todo_tmp = [];
    //List<String> time_tmp = [];

    return SizedBox(
        height: MediaQuery.of(context).size.height - 250,
        child: selectEvents.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Hive.box('user_info').get('id').toString() +
                        '님 \n' +
                        selectedDay.day.toString() +
                        '일의 일정은 없네요',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )
            : SfCalendar(
                view: CalendarView.timelineDay,
                dataSource: MeetingDataSource(provider.events),
                initialDisplayDate: provider.selectedDate,
                appointmentBuilder: appointBuild,
                headerHeight: 0,
                selectionDecoration:
                    const BoxDecoration(color: Colors.transparent),
                onTap: (details) {
                  if (details.appointments == null) return;
                  final event = details.appointments!.first;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventViewPage(event: event),
                  ));
                },
              )
        /*list.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 120,
                      child: TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.2,
                        isFirst: index == 0 ? true : false,
                        isLast: index == list.length - 1 ? true : false,
                        endChild: Container(
                            constraints: const BoxConstraints(
                              minHeight: 120,
                            ),
                            child: InkWell(
                              onTap: () {
                                //새창을 띄워 상세정보를 보여준다.
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: DayDetailPage(
                                          title: list[index].title,
                                          daytime: list[index].time,
                                          content: list[index].content,
                                          date: selectedDay,
                                          list: list,
                                          index: index,
                                        ),
                                        type: PageTransitionType
                                            .leftToRightWithFade));
                              },
                              child: Card(
                                  elevation: 10,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/date.png',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      list[index].title,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black45,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  )),
                            )),
                        startChild: Container(
                          constraints: const BoxConstraints(
                            minWidth: 20,
                          ),
                          color:
                              (int.parse(list[index].time.split(':')[0]) >= 12
                                  ? Colors.deepPurple.shade400
                                  : Colors.yellow.shade400),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              int.parse(list[index].time.split(':')[0]) >= 12
                                  ? const Icon(Icons.dark_mode)
                                  : const Icon(Icons.sunny),
                              Text(
                                list[index].time +
                                    '\n' +
                                    (int.parse(list[index]
                                                .time
                                                .split(':')[0]) >=
                                            12
                                        ? 'PM'
                                        : 'AM'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                        ),
                      ));
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Hive.box('user_info').get('id').toString() +
                        '님 \n' +
                        selectedDay.day.toString() +
                        '날의 일정은 없네요',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )*/
        );
  }

  Widget appointBuild(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
