import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/Dialogs/checkhowdaylog.dart';
import 'package:clickbyme/Sub/DayDetailPage.dart';
import 'package:clickbyme/Sub/DayEventAdd.dart';
import 'package:clickbyme/Tool/Shimmer_DayLog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../DB/Meeting.dart';
import '../DB/TODO.dart';
import '../Futures/homeasync.dart';
import '../Tool/NoBehavior.dart';
import '../UI/CalendarSource.dart';
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
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            color: Colors.black54,
            tooltip: '사용방법',
            onPressed: () => {checkhowdaylog(context)},
            icon: const Icon(Icons.question_mark),
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            color: Colors.black54,
            tooltip: '뷰 변경',
            onPressed: () => {
              calendarview = Hive.box('user_setting').get('radio_cal') ?? 'day',
              calendarview == 'month' ? 
              changecalendarview(context, 'month'):
              changecalendarview(context, 'day')
            },
            icon: const Icon(Icons.change_circle),
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () =>
                {
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
        title: const Text('데이로그', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: makeBody(context, calendarview),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context, String calendarview) {
    List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          calendarview != 'month' ? 
              SizedBox(
            height: 170,
            child: CalendarTimeline(
              showYears: true,
              initialDate: selectedDay,
              firstDate: DateTime(1900, 1, 1),
              lastDate: DateTime(3000, 12, 31),
              onDateSelected: (date) {
                setState(() {
                  selectedDay = date!;
                });
              },
              leftMargin: 20,
              monthColor: Colors.grey,
              dayColor: Colors.black54,
              dayNameColor: Colors.black54,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: const Color(0xFF333A47),
              locale: 'ko',
            ),
          ) : SizedBox(
            height: 400,
            child: SfCalendar(
              view: CalendarView.month,
              initialSelectedDate: DateTime.now(),
              dataSource: MeetingDataSource(_getDataSource()),
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
              ),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 0,
                endHour: 24,
                nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday]
              ),
            ),
          ),
          
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
    List<TODO> tmp_todo_list = [];
    //List<String> todo_tmp = [];
    //List<String> time_tmp = [];

    return SizedBox(
        height: MediaQuery.of(context).size.height - 250,
        child: list.isNotEmpty
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
                                              padding:
                                                  const EdgeInsets.only(right: 10),
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
              ));
  }
}

