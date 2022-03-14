import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Dialogs/addcalendartodo.dart';
import '../Tool/NoBehavior.dart';

class GoToDoDate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoToDoDateState();
}

class _GoToDoDateState extends State<GoToDoDate> with TickerProviderStateMixin {
  late Map<DateTime, List> _events;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectDay = DateTime.now();
  DateTime focusDay = DateTime.now();
  List _getEvents(DateTime date) {
    return _events[date] ?? [];
  }

  late TextEditingController _eventController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _eventController.dispose();
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
        backgroundColor: Colors.grey.shade100,
        title: Text('일정관리', style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: [
              makeBody(context),
              const SizedBox(
                height: 20,
              ),
              listmakebody(context),
            ],
          )),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.sunday,
            focusedDay: selectDay,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(10000, 12, 31),
            calendarFormat: format,
            eventLoader: (DateTime day) {
              /*if (day.day%2 == 0) {
                return ['hi'];
              } else {
                return [];
              }*/
              return _getEvents(day);
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  final text = DateFormat.E().format(day);
                  return Center(
                    child: Text(text, style: TextStyle(color: Colors.red)),
                  );
                }
              },
            ),
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            onDaySelected: (DateTime _selectDay, DateTime _focusDay) {
              setState(() {
                selectDay = _selectDay;
                focusDay = _focusDay;
              });
            },
            onDayLongPressed: (DateTime date, event) {
              addcalendartodo(context, _eventController, _events, date);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectDay, date);
            },
            calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.shade100,
                    shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Colors.blue.shade100, shape: BoxShape.circle),
                selectedTextStyle: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget listmakebody(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('리스트',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent.shade100)),
              ScrollConfiguration(
                  behavior: NoBehavior(),
                  child: SingleChildScrollView(
                    child: Text('목록',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurpleAccent.shade100)),
                  )),
            ],
          ),
        ));
  }
}
