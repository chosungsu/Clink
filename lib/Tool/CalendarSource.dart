import 'package:clickbyme/DB/Event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return getEvent(index).to;
  }

  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }

  @override
  bool isAllDay(int index) {
    return getEvent(index).isAllDay;
  }
}
