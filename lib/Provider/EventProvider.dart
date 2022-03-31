import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../DB/Event.dart';

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  List<Event> get eventsofDate => _events;
  void setDate(DateTime date) {
    _selectedDate = date;
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }
}
