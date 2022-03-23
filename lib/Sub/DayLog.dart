import 'package:clickbyme/Dialogs/changesetcal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../Tool/NoBehavior.dart';

class DayLog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  List<String> todolist = <String>[];
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
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
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
  }

  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
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
          IconButton(
              color: Colors.black54,
              onPressed: () {
                changesetcal(context);
              },
              tooltip: '세팅하기',
              icon: Icon(Icons.settings)),
          IconButton(
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () => {
              textEditingController.text = "",
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 250,
                        width: 320,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Add Todo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: textEditingController,
                              style: const TextStyle(color: Colors.white),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Add your new todo item',
                                  hintStyle: TextStyle(color: Colors.white60)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 320,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    todolist.add(textEditingController.text);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Add Todo"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
        title: Text('데이로그', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SizedBox(
          child: CalendarView(),
        ),
      ),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
    //DateTime _selectedValue;
    return TimelineTile();
  }

  Widget CalendarView() {
    return Calendar(
      startOnMonday: false,
      selectedColor: Colors.blue,
      todayColor: Colors.red,
      eventColor: Colors.green,
      eventDoneColor: Colors.amber,
      bottomBarColor: Colors.deepOrange,
      onRangeSelected: (range) {
        print('selected Day ${range.from},${range.to}');
      },
      onDateSelected: (date) {
        return _handleData(date);
      },
      events: events,
      isExpanded: true,
      dayOfWeekStyle: TextStyle(
        fontSize: 15,
        color: Colors.black12,
        fontWeight: FontWeight.w100,
      ),
      bottomBarTextStyle: TextStyle(
        color: Colors.white,
      ),
      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
      hideBottomBar: false,
      hideArrows: false,
      weekDays: [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ],
    );
  }
}
