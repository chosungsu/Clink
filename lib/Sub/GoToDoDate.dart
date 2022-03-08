import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Dialogs/addcalendartodo.dart';


class GoToDoDate extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _GoToDoDateState();
}

class _GoToDoDateState extends State<GoToDoDate> with TickerProviderStateMixin{
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
        title: Text(
            '일정관리',
            style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: makeBody(context),
      ),
    );
  }
  // 바디 만들기
  Widget makeBody(BuildContext context) {

    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.sunday,
      focusedDay: selectDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(10000, 12, 31),
      calendarFormat: format,
      eventLoader: _getEvents,
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
              shape: BoxShape.circle
          ),
          selectedDecoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle
          ),
          selectedTextStyle: TextStyle(
              color: Colors.white
          )
      ),
    );
  }
}