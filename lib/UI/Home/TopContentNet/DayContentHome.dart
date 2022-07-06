import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:transition/transition.dart';
import 'package:clickbyme/Tool/dateutils.dart';
import '../../../DB/Event.dart';
import '../../../Dialogs/checkhowdaylog.dart';
import '../../../Provider/EventProvider.dart';
import '../../../Sub/DayEventAdd.dart';
import '../../../Tool/CalendarSource.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/changecalendarview.dart';

class DayContentHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late Map<DateTime, List<Event>> _events;
  final _formkey = GlobalKey<FormState>();
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  String hour = '';
  String minute = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    _events = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterCheckUi(),
    ));
  }

  List<Event> getEventList(DateTime date) {
    return _events[date] ?? [];
  }

  EnterCheckUi() {
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
                    const Padding(padding: const EdgeInsets.only(left: 10)),
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
                                style: const NeumorphicStyle(
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
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                const Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ))),
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              calendarView(height, context),
                              AddBtn(),
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

  calendarView(double height, BuildContext context) {
    return SizedBox(
      height: 150,
      child: TableCalendar(
        locale: 'ko_KR',
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        calendarFormat: _calendarFormat,
        eventLoader: getEventList,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.sunday,
        daysOfWeekVisible: true,
        headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            titleTextStyle: TextStyle(
              color: Colors.black45,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleCentered: false,
            formatButtonShowsNext: false),
        calendarStyle: const CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            selectedTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.blue)),
      ),
    );
  }

  AddBtn() {
    return Column(
      children: [
        SizedBox(
          height: 30,
          width: (MediaQuery.of(context).size.width - 40) * 0.5,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade400,
              ),
              onPressed: () {
                //이벤트 작성시트 호출
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SheetPage(),
                        ),
                      );
                    });
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '추가하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }

  SheetPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          child: Form(
              key: _formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: buildSheetTitle(_selectedDay),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      child: buildTitle(textEditingController1),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 80,
                      child: buildDateTimePicker(_selectedDay, textEditingController2),
                    ),
                    
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: (MediaQuery.of(context).size.width - 40) * 0.5,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade400,
                              ),
                              onPressed: () {
                                //이벤트 저장
                                saveForm();
                              },
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: NeumorphicText(
                                        '저장하기',
                                        style: const NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          depth: 3,
                                          color: Colors.white,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ])),
        )
      ],
    );
  }

  buildSheetTitle(DateTime fromDate) {
    return Text(
      fromDate.day.toString() + '일의 일정을 기록해보세요!',
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
    );
  }

  buildTitle(TextEditingController titlecontroller) {
    return TextFormField(
      style: const TextStyle(fontSize: 20),
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

  buildDateTimePicker(DateTime fromDate, TextEditingController timecontroller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '시간설정',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black45),
                      decoration: const InputDecoration(hintText: '시간 : 분'),
                      readOnly: true,
                      controller: timecontroller,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                pickDates(timecontroller);
              },
              child: Icon(Icons.arrow_drop_down),
            )
          ],
        )
      ],
    );
  }

  pickDates(TextEditingController timecontroller) async {
    Future<TimeOfDay?> pick = showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(fromDate));
    pick.then((timeOfDay) {
      setState(() {
        hour = timeOfDay!.hour.toString();
        minute = timeOfDay.minute.toString();
        timecontroller.text = '$hour:$minute';
      });
    });
  }

  Future saveForm() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: textEditingController1.text,
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
