import 'package:clickbyme/DB/Event.dart';
import 'package:clickbyme/Provider/EventProvider.dart';
import 'package:clickbyme/Tool/dateutils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Tool/NoBehavior.dart';

class DayEventAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayEventAddState();
}

class _DayEventAddState extends State<DayEventAdd> {
  final _formkey = GlobalKey<FormState>();
  final titlecontroller = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            color: Colors.black54,
            tooltip: '추가하기',
            onPressed: () => {saveForm()},
            icon: const Icon(Icons.check),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ScrollConfiguration(
          behavior: NoBehavior(),
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: makeBody(context, titlecontroller, fromDate, toDate),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context, TextEditingController titlecontroller,
      DateTime fromDate, DateTime toDate) {
    return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: StatefulBuilder(builder: (_, StateSetter setState) {
          return Form(
            key: _formkey,
              child: Column(children: [
            buildTitle(titlecontroller),
            const SizedBox(
              height: 20,
            ),
            buildDateTimePicker(fromDate, 'from'),
            buildDateTimePicker(toDate, 'to'),
          ]));
        }));
  }

  buildTitle(TextEditingController titlecontroller) {
    return TextFormField(
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
          border: UnderlineInputBorder(), hintText: '일정 제목 추가'),
      onFieldSubmitted: (_) {
        saveForm();
      },
      validator: (title) =>
        title != null && title.isEmpty ? '제목은 필수 입력란입니다.' : null,
      controller: titlecontroller,
    );
  }

  buildDateTimePicker(DateTime fromDate, String s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        s == 'from'
            ? const Text(
                'From',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              )
            : const Text(
                'To',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: buildDropdownField(
                    text: dateutils.toDate(fromDate),
                    onClicked: () {
                      s == 'from'
                          ? pickDates(pickDate: true, s: s)
                          : pickDates(pickDate: true, s: s);
                    })),
            Expanded(
                flex: 1,
                child: buildDropdownField(
                    text: dateutils.toTime(fromDate),
                    onClicked: () {
                      s == 'from'
                          ? pickDates(pickDate: false, s: s)
                          : pickDates(pickDate: false, s: s);
                    })),
          ],
        )
      ],
    );
  }

  buildDropdownField({required String text, required onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  pickDates({required bool pickDate, required String s}) async {
    final date = await pick(fromDate, s,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      s == 'from' ? fromDate = date : toDate = date;
    });
  }

  Future<DateTime?> pick(DateTime fromDate, String s,
      {required bool pickDate, DateTime? firstDate}) async {
    if (s == 'from') {
      if (pickDate) {
        final date = await showDatePicker(
          context: context,
          initialDate: fromDate,
          firstDate: firstDate ?? DateTime(1900, 1),
          lastDate: DateTime(3000),
        );
        if (date == null) {
          return null;
        }
        final time = Duration(hours: fromDate.hour, minutes: fromDate.minute);
        return date.add(time);
      } else {
        final tod = await showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(fromDate));
        if (tod == null) {
          return null;
        }
        final date = DateTime(fromDate.year, fromDate.month, fromDate.day);
        final time = Duration(hours: tod.hour, minutes: tod.minute);
        return date.add(time);
      }
    } else {
      if (pickDate) {
        final date = await showDatePicker(
          context: context,
          initialDate: fromDate,
          firstDate: firstDate ?? DateTime(1900, 1),
          lastDate: DateTime(3000),
        );
        if (date == null) {
          return null;
        }
        final time = Duration(hours: fromDate.hour, minutes: fromDate.minute);
        return date.add(time);
      } else {
        final tod = await showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(fromDate));
        if (tod == null) {
          return null;
        }
        final date = DateTime(fromDate.year, fromDate.month, fromDate.day);
        final time = Duration(hours: tod.hour, minutes: tod.minute);
        return date.add(time);
      }
    }
  }

  Future saveForm() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: titlecontroller.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
