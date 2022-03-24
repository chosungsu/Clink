import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/DB/Radio_cal.dart';
import 'package:clickbyme/Dialogs/addTodos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import '../Tool/NoBehavior.dart';

class DayLog extends StatefulWidget {
  get onEventTap => null;

  @override
  State<StatefulWidget> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  Radio_cal _val = Hive.box('user_setting').get('cal_show_view') == null
      ? Radio_cal.month
      : (Hive.box('user_setting').get('cal_show_view') == 'month'
          ? Radio_cal.month
          : (Hive.box('user_setting').get('cal_show_view') == 'week'
              ? Radio_cal.week
              : Radio_cal.day));
  List<String> todolist = <String>[];
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  DatePickerController _controller = DatePickerController();
  late List<CleanCalendarEvent> selectedEvent;
  final Map<DateTime, List<CleanCalendarEvent>> events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      CleanCalendarEvent('Event A',
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 12, 0),
          description: 'A special event',
          color: Colors.blue),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
        [
      CleanCalendarEvent('Event B',
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 12, 0),
          color: Colors.orange),
      CleanCalendarEvent('Event C',
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 14, 30),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 17, 0),
          color: Colors.pink),
    ],
  };
  @override
  void initState() {
    // TODO: implement initState
    //selectedEvent = events[selectedDay] ?? [];
    super.initState();
  }

  void _handleData(date) {
    /*setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });*/
    print(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          /*IconButton(
              color: Colors.black54,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        title: const Text(
                          "설정",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                        content: StatefulBuilder(
                          builder: (_, StateSetter setState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Radio<Radio_cal>(
                                    value: Radio_cal.month,
                                    groupValue: _val,
                                    onChanged: (Radio_cal? val) {
                                      setState(() {
                                        _val = val!;
                                        Hive.box('user_setting')
                                            .put('cal_show_view', 'month');
                                      });
                                    },
                                  ),
                                  title: const Text(
                                    "월 단위 뷰",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Radio(
                                    value: Radio_cal.week,
                                    groupValue: _val,
                                    onChanged: (Radio_cal? val) {
                                      setState(() {
                                        _val = val!;
                                        Hive.box('user_setting')
                                            .put('cal_show_view', 'week');
                                      });
                                    },
                                  ),
                                  title: const Text(
                                    "주 단위 뷰",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Radio(
                                    value: Radio_cal.day,
                                    groupValue: _val,
                                    onChanged: (Radio_cal? val) {
                                      setState(() {
                                        _val = val!;
                                        Hive.box('user_setting')
                                            .put('cal_show_view', 'day');
                                      });
                                    },
                                  ),
                                  title: const Text(
                                    "일 단위 뷰",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("완료"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => super.widget));
                            },
                          ),
                        ],
                      );
                    });
              },
              tooltip: '세팅하기',
              icon: Icon(Icons.settings)),*/
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () =>
                {addTodos(context, textEditingController, todolist)},
            icon: const Icon(Icons.add_circle),
          ),
        ],
        title: Text('데이로그', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: Container(
            height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: makeBody(context),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
    //DateTime _selectedValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                print(date);
              });
            },
            leftMargin: 20,
            monthColor: Colors.grey,
            dayColor: Colors.black54,
            dayNameColor: Colors.black54,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: Color(0xFF333A47),
            locale: 'ko',
          ),
        ),
        SizedBox(
            child: TimelineTile(
              isFirst: true,
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              endChild: Container(
                constraints: const BoxConstraints(
                  minHeight: 120,
                ),
                child: Card(
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/date.png',
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '오늘의 일정',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              startChild: Container(
                constraints: const BoxConstraints(
                  minWidth: 20,
                ),
                child: Center(
                  child: Text(
                            '09:00',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                          ),
                ),
              ),
            )),
            SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              endChild: Container(
                constraints: const BoxConstraints(
                  minHeight: 120,
                ),
                child: Card(
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/date.png',
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '오늘의 일정',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              startChild: Container(
                constraints: const BoxConstraints(
                  minWidth: 20,
                ),
                child: Center(
                  child: Text(
                            '10:00',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                          ),
                ),
              ),
            )),
      ],
    );
  }
}
