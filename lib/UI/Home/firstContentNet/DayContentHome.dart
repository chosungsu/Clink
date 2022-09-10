import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/settingCalendarHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../DB/Event.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/NoBehavior.dart';
import '../secondContentNet/ClickShowEachCalendar.dart';

class DayContentHome extends StatefulWidget {
  const DayContentHome({
    Key? key,
    required this.title,
    required this.share,
    required this.origin,
    required this.theme,
    required this.view,
    required this.calname,
  }) : super(key: key);
  final String title;
  final List share;
  final String origin;
  final String calname;
  final int theme;
  final int view;
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome>
    with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  var controll_cals = Get.put(calendarsetting());
  int setcal_fromsheet = 0;
  int themecal_fromsheet = 0;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late Map<DateTime, List<Event>> _events;
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  String hour = '';
  String minute = '';
  String username = Hive.box('user_info').get(
    'id',
  );

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  var _rangeStart = null;
  var _rangeEnd = null;
  List<Event> getList(DateTime date) {
    return _events[date] ?? [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setcal_fromsheet = widget.view;
    themecal_fromsheet = widget.theme;
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    _events = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: BGColor(),
      body: EnterCheckUi(
        controll_cals,
      ),
    ));
  }

  EnterCheckUi(calendarsetting controll_cals) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(color: BGColor()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  child: calendarView(
                height,
                context,
                controll_cals,
              )),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: StatefulBuilder(
                              builder: (_, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ADView(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TimeLineView(),
                                  const SizedBox(
                                    height: 50,
                                  )
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

  calendarView(
    double height,
    BuildContext context,
    calendarsetting controll_cals,
  ) {
    List<Widget> list_calendar = [];
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('CalendarDataBase')
            .where('calname', isEqualTo: widget.title)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _events.clear();
            final valuespace = snapshot.data!.docs;
            for (var sp in valuespace) {
              final ev_date = sp.get('Date');
              final ev_todo = sp.get('Daytodo');
              if (_events[DateTime.parse(
                      sp.get('Date').toString().split('일')[0] +
                          ' 00:00:00.000Z')] !=
                  null) {
                _events[DateTime.parse(sp.get('Date').toString().split('일')[0] +
                        ' 00:00:00.000Z')]!
                    .add(Event(title: sp.get('Daytodo')));
              } else {
                _events[DateTime.parse(sp.get('Date').toString().split('일')[0] +
                    ' 00:00:00.000Z')] = [Event(title: sp.get('Daytodo'))];
              }
            }
            list_calendar = <Widget>[
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GetBuilder<calendarsetting>(
                      builder: (_) => TableCalendar(
                        locale: 'ko_KR',
                        focusedDay: _focusedDay,
                        calendarBuilders:
                            CalendarBuilders(dowBuilder: (context, day) {
                          if (day.weekday == DateTime.sunday) {
                            return Container(
                              height: 55,
                              child: Center(
                                child: Text(DateFormat.E('ko_KR').format(day),
                                    style: const TextStyle(color: Colors.red)),
                              ),
                            );
                          } else if (day.weekday == DateTime.saturday) {
                            return Container(
                              height: 55,
                              child: Center(
                                child: Text(DateFormat.E('ko_KR').format(day),
                                    style: const TextStyle(color: Colors.blue)),
                              ),
                            );
                          } else {
                            return Container(
                              height: 55,
                              child: Center(
                                child: Text(DateFormat.E('ko_KR').format(day),
                                    style: TextStyle(color: TextColor())),
                              ),
                            );
                          }
                        }, markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            return Container(
                                width: 50,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: controll_cals.themecalendar == 0
                                        ? (events.length % 4 == 0
                                            ? MyTheme.colororigred
                                            : (events.length % 4 == 1
                                                ? MyTheme.colororigorange
                                                : (events.length % 4 == 2
                                                    ? MyTheme.colororigblue
                                                    : MyTheme.colororiggreen)))
                                        : (events.length % 4 == 0
                                            ? MyTheme.colorpastelred
                                            : (events.length % 4 == 1
                                                ? MyTheme.colorpastelorange
                                                : (events.length % 4 == 2
                                                    ? MyTheme.colorpastelblue
                                                    : MyTheme
                                                        .colorpastelgreen)))),
                                child: Center(
                                  child: Text('+' + events.length.toString(),
                                      style: TextStyle(color: TextColor())),
                                ));
                          }
                          return null;
                        }),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        rangeSelectionMode: _rangeSelectionMode,
                        onRangeSelected: _onRangeSelected,
                        pageJumpingEnabled: false,
                        shouldFillViewport: false,
                        rowHeight: 55,
                        weekendDays: [DateTime.saturday],
                        holidayPredicate: (day) {
                          return day.weekday == DateTime.sunday;
                        },
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        calendarFormat: controll_cals.showcalendar == 0
                            ? CalendarFormat.week
                            : (controll_cals.showcalendar == 1
                                ? CalendarFormat.twoWeeks
                                : CalendarFormat.month),
                        eventLoader: getList,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null;
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        daysOfWeekVisible: true,
                        daysOfWeekHeight: 50,
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMM(locale).format(date),
                            leftChevronVisible: true,
                            leftChevronPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            leftChevronMargin: EdgeInsets.zero,
                            leftChevronIcon: IconBtn(
                                child: IconButton(
                                    onPressed: () {
                                      //Navigator.pop(context);
                                      Get.back();
                                    },
                                    icon: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: NeumorphicIcon(
                                        Icons.keyboard_arrow_left,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    )),
                                color: TextColor()),
                            rightChevronVisible: true,
                            rightChevronPadding:
                                const EdgeInsets.only(right: 10),
                            rightChevronMargin: EdgeInsets.zero,
                            rightChevronIcon: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconBtn(
                                    child: IconButton(
                                      onPressed: () {
                                        Get.to(
                                            () => DayScript(
                                                firstdate:
                                                    _rangeStart ?? _selectedDay,
                                                lastdate:
                                                    _rangeEnd ?? _selectedDay,
                                                position: 'cal',
                                                title: widget.title,
                                                share: widget.share,
                                                orig: widget.origin,
                                                calname: widget.calname),
                                            transition: Transition.downToUp);
                                      },
                                      icon: NeumorphicIcon(
                                        Icons.add,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    ),
                                    color: TextColor()),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconBtn(
                                    child: IconButton(
                                      onPressed: () {
                                        settingCalendarHome(
                                            context,
                                            controll_cals,
                                            widget.theme,
                                            widget.view,
                                            widget.title);
                                      },
                                      icon: NeumorphicIcon(
                                        Icons.settings,
                                        size: 30,
                                        style: NeumorphicStyle(
                                            shape: NeumorphicShape.convex,
                                            depth: 2,
                                            surfaceIntensity: 0.5,
                                            color: TextColor(),
                                            lightSource: LightSource.topLeft),
                                      ),
                                    ),
                                    color: TextColor())
                              ],
                            ),
                            titleTextStyle: TextStyle(
                              color: TextColor(),
                              fontSize: contentTitleTextsize(),
                              fontWeight: FontWeight.bold,
                            ),
                            titleCentered: false,
                            formatButtonShowsNext: false),
                        calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,
                            selectedDecoration: const BoxDecoration(
                                color: Colors.orange, shape: BoxShape.circle),
                            selectedTextStyle: TextStyle(color: TextColor()),
                            defaultTextStyle: TextStyle(color: TextColor()),
                            holidayTextStyle:
                                const TextStyle(color: Colors.red),
                            holidayDecoration: const BoxDecoration(
                                shape: BoxShape.circle, border: Border()),
                            weekendTextStyle:
                                const TextStyle(color: Colors.blue)),
                      ),
                    )
                  ],
                ),
              )
            ];
          }
          return Column(children: list_calendar);
        });
  }

  settingCalendarHome(
    BuildContext context,
    calendarsetting controll_cals,
    int theme,
    int view,
    String title,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SheetPage(context, setcal_fromsheet, controll_cals,
                      themecal_fromsheet, theme, view, title),
                )),
          );
        }).whenComplete(() {});
  }

  ADView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  TimeLineView() {
    List<Widget> list_timelineview = [];
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('CalendarDataBase')
          .where('calname', isEqualTo: widget.title)
          .where('Date',
              isEqualTo: _selectedDay.toString().split('-')[0] +
                  '-' +
                  _selectedDay.toString().split('-')[1] +
                  '-' +
                  _selectedDay.toString().split('-')[2].substring(0, 2) +
                  '일')
          .orderBy('Timestart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          list_timelineview = <Widget>[
            snapshot.data!.docs.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 40,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.4,
                                  minHeight:
                                      MediaQuery.of(context).size.height *
                                          0.25),
                              child: SizedBox.shrink(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: index < snapshot.data!.docs.length - 1 &&
                                                    snapshot.data!.docs[index]['Timestart']
                                                            .toString()
                                                            .split(':')[0] ==
                                                        snapshot
                                                            .data!
                                                            .docs[index + 1]
                                                                ['Timestart']
                                                            .toString()
                                                            .split(':')[0] ||
                                                index == 0
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  NeumorphicText(
                                                    snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Timestart']
                                                            .toString()
                                                            .split(':')[0] +
                                                        ':00',
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: TextColor(),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 2,
                                                    height: 15,
                                                    endIndent: 20,
                                                    color: TextColor(),
                                                  ),
                                                ],
                                              )
                                            : (index < snapshot.data!.docs.length - 1 &&
                                                        snapshot.data!.docs[index]['Timestart']
                                                                .toString()
                                                                .split(
                                                                    ':')[0] ==
                                                            snapshot.data!
                                                                .docs[index - 1]['Timestart']
                                                                .toString()
                                                                .split(':')[0] ||
                                                    (index == snapshot.data!.docs.length - 1 && snapshot.data!.docs[index]['Timestart'].toString().split(':')[0] == snapshot.data!.docs[index - 1]['Timestart'].toString().split(':')[0])
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [],
                                                  )
                                                : Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      NeumorphicText(
                                                        snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'Timestart']
                                                                .toString()
                                                                .split(':')[0] +
                                                            ':00',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: TextColor(),
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2,
                                                        height: 15,
                                                        endIndent: 20,
                                                        color: TextColor(),
                                                      ),
                                                    ],
                                                  ))),
                                    Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () {
                                            //수정 및 삭제 시트 띄우기
                                            Get.to(
                                                () => ClickShowEachCalendar(
                                                    start: snapshot.data!.docs[index]
                                                        ['Timestart'],
                                                    finish:
                                                        snapshot.data!.docs[index]
                                                            ['Timefinish'],
                                                    calinfo: snapshot.data!
                                                        .docs[index]['Daytodo'],
                                                    date: _selectedDay,
                                                    alarm: snapshot.data!
                                                        .docs[index]['Alarm'],
                                                    share: snapshot.data!
                                                        .docs[index]['Shares'],
                                                    calname: widget.calname,
                                                    code: snapshot.data!
                                                        .docs[index]['calname']),
                                                transition: Transition.downToUp);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: themecal_fromsheet == 0
                                                      ? (index % 4 == 0
                                                          ? MyTheme.colororigred
                                                          : (index % 4 == 1
                                                              ? MyTheme
                                                                  .colororigorange
                                                              : (index % 4 == 2
                                                                  ? MyTheme
                                                                      .colororigblue
                                                                  : MyTheme
                                                                      .colororiggreen)))
                                                      : (index % 4 == 0
                                                          ? MyTheme
                                                              .colorpastelred
                                                          : (index % 4 == 1
                                                              ? MyTheme
                                                                  .colorpastelorange
                                                              : (index % 4 == 2
                                                                  ? MyTheme
                                                                      .colorpastelblue
                                                                  : MyTheme
                                                                      .colorpastelgreen))),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: TextColor(),
                                                      width: 1)),
                                              child: SizedBox(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Daytodo']
                                                            .toString(),
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'Timefinish']
                                                                .isEmpty
                                                            ? Text(
                                                                snapshot.data!.docs[index]['Timestart'].toString().split(':')[
                                                                            1] ==
                                                                        '0'
                                                                    ? snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'Timestart']
                                                                            .toString() +
                                                                        '0' +
                                                                        '-' +
                                                                        ''
                                                                    : snapshot
                                                                            .data!
                                                                            .docs[index]['Timestart']
                                                                            .toString() +
                                                                        '-' +
                                                                        '',
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            : (snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'Timefinish']
                                                                        .toString()
                                                                        .split(
                                                                            ':')[1] ==
                                                                    '0'
                                                                ? Text(
                                                                    snapshot.data!.docs[index]['Timestart'].toString().split(':')[1] ==
                                                                            '0'
                                                                        ? snapshot.data!.docs[index]['Timestart'].toString() +
                                                                            '0' +
                                                                            '-' +
                                                                            snapshot.data!.docs[index]['Timefinish']
                                                                                .toString() +
                                                                            '0'
                                                                        : snapshot.data!.docs[index]['Timestart'].toString() +
                                                                            '-' +
                                                                            snapshot.data!.docs[index]['Timefinish'].toString() +
                                                                            '0',
                                                                    style: TextStyle(
                                                                        color:
                                                                            TextColor(),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : Text(
                                                                    snapshot.data!.docs[index]['Timestart'].toString().split(':')[1] ==
                                                                            '0'
                                                                        ? snapshot.data!.docs[index]['Timestart'].toString() +
                                                                            '0' +
                                                                            '-' +
                                                                            snapshot.data!.docs[index]['Timefinish']
                                                                                .toString()
                                                                        : snapshot.data!.docs[index]['Timestart'].toString() +
                                                                            '-' +
                                                                            snapshot.data!.docs[index]['Timefinish'].toString(),
                                                                    style: TextStyle(
                                                                        color:
                                                                            TextColor(),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ))),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'with',
                                                              softWrap: true,
                                                              style: GoogleFonts
                                                                  .lobster(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      itemCount: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                              [
                                                                              'Shares']
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index2) {
                                                                        return Row(
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: Text(snapshot.data!.docs[index]['Shares'][index2].toString().substring(0, 1), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              )),
                                        )),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    })
                : ListTile(
                    title: Center(
                    child: Text(
                      '기록된 일정이 없네요...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor(),
                      ),
                    ),
                  ))
          ];
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          list_timelineview = <Widget>[
            const Center(child: CircularProgressIndicator())
          ];
        } else if (!snapshot.hasData) {
          list_timelineview = <Widget>[
            ListTile(
                title: Center(
              child: Text(
                '기록된 일정이 없네요...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: TextColor(),
                ),
              ),
            ))
          ];
        } else {
          list_timelineview = <Widget>[
            ListTile(
              title: Center(
                  child: Text(
                '데이터를 불러오는데 실패하였습니다.\n 오류가 지속될 경우 문의바랍니다.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: TextColor(),
                ),
              )),
            )
          ];
        }
        return Column(children: list_timelineview);
      },
    );
  }
}
