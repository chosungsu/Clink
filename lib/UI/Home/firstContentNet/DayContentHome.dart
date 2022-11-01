import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/Route/initScreenLoading.dart';
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
import '../../../Tool/Getx/PeopleAdd.dart';
import '../../../Tool/Getx/calendarsetting.dart';
import '../../../Tool/NoBehavior.dart';
import '../Widgets/CalendarView.dart';
import '../secondContentNet/ClickShowEachCalendar.dart';

class DayContentHome extends StatefulWidget {
  const DayContentHome({
    Key? key,
    required this.id,
    /*required this.share,
    required this.origin,
    required this.theme,
    required this.view,
    required this.calname,*/
  }) : super(key: key);
  final String id;
  /*final List share;
  final String origin;
  final String calname;
  final int theme;
  final int view;*/
  @override
  State<StatefulWidget> createState() => _DayContentHomeState();
}

class _DayContentHomeState extends State<DayContentHome>
    with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final cal_share_person = Get.put(PeopleAdd());
  var controll_cals = Get.put(calendarsetting());
  //int setcal_fromsheet = 0;
  //int themecal_fromsheet = 0;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late Map<DateTime, List<Event>> events;
  late DateTime fromDate = DateTime.now();
  late DateTime toDate = DateTime.now();
  String hour = '';
  String minute = '';
  String username = Hive.box('user_info').get(
    'id',
  );
  String usercode = Hive.box('user_setting').get('usercode');
  String madeUser = '';
  int theme = 0;
  int view = 0;
  String calname = '';
  List share = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  var _rangeStart = null;
  var _rangeEnd = null;
  var updateidalarm = '';
  List<bool> alarmtypes = [];
  bool isChecked_pushalarm = false;
  List<Event> getList(DateTime date) {
    return events[date] ?? [];
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
    /*setcal_fromsheet = widget.view;
    themecal_fromsheet = widget.theme;
    if (setcal_fromsheet == 0) {
      controll_cals.showcalendar = 0;
    } else if (setcal_fromsheet == 1) {
      controll_cals.showcalendar = 1;
    } else {
      controll_cals.showcalendar = 2;
    }
    if (themecal_fromsheet == 0) {
      controll_cals.themecalendar = 0;
    } else {
      controll_cals.themecalendar = 1;
    }*/
    fromDate = DateTime.now();
    toDate = DateTime.now().add(const Duration(hours: 2));
    events = {};
    controll_cals.selectedDay = _selectedDay;
    controll_cals.focusedDay = _focusedDay;
    /*firestore
        .collection('CalendarSheetHome_update')
        .doc(widget.id)
        .get()
        .then((value) {
      if (value.exists) {
        madeUser = value.data()!['madeUser'];
        theme = value.data()!['themesetting'];
        view = value.data()!['viewsetting'];
        share = value.data()!['share'];
        calname = value.data()!['calname'];
        controll_cals.showcalendar = view;
        controll_cals.themecalendar = theme;
      }
    });
    print(view);*/
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
            backgroundColor: BGColor(),
            body: FutureBuilder(
              future: firestore
                  .collection('CalendarSheetHome_update')
                  .doc(widget.id)
                  .get()
                  .then((value) {
                if (value.exists) {
                  madeUser = value.data()!['madeUser'];
                  theme = value.data()!['themesetting'];
                  view = value.data()!['viewsetting'];
                  share = value.data()!['share'];
                  calname = value.data()!['calname'];
                  controll_cals.showcalendar = view;
                  controll_cals.themecalendar = theme;
                }
              }),
              builder: ((context, snapshot) {
                return EnterCheckUi(controll_cals, events);
              }),
            )));
  }

  EnterCheckUi(
      calendarsetting controll_cals, Map<DateTime, List<Event>> events) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(color: BGColor()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('CalendarDataBase')
                      .where('calname', isEqualTo: widget.id)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        events.clear();
                        final valuespace = snapshot.data!.docs;
                        for (var sp in valuespace) {
                          final ev_date = sp.get('Date');
                          final ev_todo = sp.get('Daytodo');
                          if (events[DateTime.parse(
                                  sp.get('Date').toString().split('일')[0] +
                                      ' 00:00:00.000Z')] !=
                              null) {
                            events[DateTime.parse(
                                    sp.get('Date').toString().split('일')[0] +
                                        ' 00:00:00.000Z')]!
                                .add(Event(title: sp.get('Daytodo')));
                          } else {
                            events[DateTime.parse(
                                sp.get('Date').toString().split('일')[0] +
                                    ' 00:00:00.000Z')] = [
                              Event(title: sp.get('Daytodo'))
                            ];
                          }
                        }
                      }
                    }
                    return SizedBox(
                        child: calendarView(
                            context,
                            controll_cals,
                            events,
                            _focusedDay,
                            _selectedDay,
                            widget.id,
                            /*widget.share,
                            widget.calname,*/
                            share,
                            calname,
                            usercode,
                            /*widget.theme,
                            widget.view,*/
                            theme,
                            view,
                            'oncontent'));
                  })),
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

  ADView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  TimeLineView() {
    List<Widget> list_timelineview = [];
    return GetBuilder<calendarsetting>(
        builder: (_) => StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('CalendarDataBase')
                  .where('calname', isEqualTo: widget.id)
                  //.where('calname', isEqualTo: widget.title)
                  .where('Date',
                      isEqualTo: controll_cals.selectedDay
                              .toString()
                              .split('-')[0] +
                          '-' +
                          controll_cals.selectedDay.toString().split('-')[1] +
                          '-' +
                          controll_cals.selectedDay
                              .toString()
                              .split('-')[2]
                              .substring(0, 2) +
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
                              //수정 및 삭제 시트 띄우기
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ContainerDesign(
                                      child: SizedBox(
                                        height: 80,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'Timestart']
                                                                    .toString() ==
                                                                '하루종일 일정으로 기록' &&
                                                            snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'Timefinish']
                                                                    .toString() ==
                                                                '하루종일 일정으로 기록'
                                                        ? Text(
                                                            '하루종일',
                                                            maxLines: 2,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          )
                                                        : Column(
                                                            children: [
                                                              snapshot.data!.docs[index]
                                                                              [
                                                                              'Timestart'] ==
                                                                          '' ||
                                                                      snapshot.data!.docs[index]
                                                                              [
                                                                              'Timestart'] ==
                                                                          '하루종일 일정으로 기록'
                                                                  ? Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        maxLines:
                                                                            2,
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              TextColor(),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        snapshot.data!.docs[index]['Timestart'].toString().split(':')[1].length ==
                                                                                1
                                                                            ? snapshot.data!.docs[index]['Timestart'].toString().split(':')[0] +
                                                                                ':0' +
                                                                                snapshot.data!.docs[index]['Timestart'].toString().split(':')[1]
                                                                            : snapshot.data!.docs[index]['Timestart'],
                                                                        maxLines:
                                                                            2,
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              TextColor(),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                    ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  '~',
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color:
                                                                        TextColor(),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                ),
                                                              ),
                                                              snapshot.data!.docs[index]
                                                                              [
                                                                              'Timefinish'] ==
                                                                          '' ||
                                                                      snapshot.data!.docs[index]
                                                                              [
                                                                              'Timefinish'] ==
                                                                          '하루종일 일정으로 기록'
                                                                  ? Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        maxLines:
                                                                            2,
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              TextColor(),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        snapshot.data!.docs[index]['Timefinish'].toString().split(':')[1].length ==
                                                                                1
                                                                            ? snapshot.data!.docs[index]['Timefinish'].toString().split(':')[0] +
                                                                                ':0' +
                                                                                snapshot.data!.docs[index]['Timefinish'].toString().split(':')[1]
                                                                            : snapshot.data!.docs[index]['Timefinish'],
                                                                        maxLines:
                                                                            2,
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              TextColor(),
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                    ),
                                                            ],
                                                          )
                                                  ],
                                                )),
                                            VerticalDivider(
                                              width: 10,
                                              thickness: 1,
                                              indent: 15,
                                              endIndent: 15,
                                              color: TextColor(),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await firestore
                                                        .collectionGroup(
                                                            'AlarmTable')
                                                        .get()
                                                        .then((value) {
                                                      if (value
                                                          .docs.isNotEmpty) {
                                                        for (int i = 0;
                                                            i <
                                                                value.docs
                                                                    .length;
                                                            i++) {
                                                          if (value
                                                                  .docs[i].id ==
                                                              cal_share_person
                                                                  .secondname) {
                                                            if (value.docs[i]
                                                                        .data()[
                                                                    'calcode'] ==
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id) {
                                                              updateidalarm =
                                                                  value.docs[i]
                                                                      .id;
                                                              alarmtypes
                                                                  .clear();
                                                              for (int j = 0;
                                                                  j <
                                                                      value
                                                                          .docs[
                                                                              i]
                                                                          .data()[
                                                                              'alarmtype']
                                                                          .length;
                                                                  j++) {
                                                                alarmtypes.add(value
                                                                        .docs[i]
                                                                        .data()[
                                                                    'alarmtype'][j]);
                                                              }
                                                              print(alarmtypes);
                                                              hour = value
                                                                  .docs[i]
                                                                  .data()[
                                                                      'alarmhour']
                                                                  .toString();
                                                              minute = value
                                                                  .docs[i]
                                                                  .data()[
                                                                      'alarmminute']
                                                                  .toString();
                                                              isChecked_pushalarm =
                                                                  value.docs[i]
                                                                          .data()[
                                                                      'alarmmake'];
                                                              /*calendarsetting().settimeminute(
                                    int.parse(value.docs[i]
                                        .data()['alarmhour']
                                        .toString()),
                                    int.parse(value.docs[i]
                                        .data()['alarmminute']
                                        .toString()),
                                    snapshot.data!.docs[index]['Daytodo'],
                                    snapshot.data!.docs[index].id);*/
                                                            }
                                                          }
                                                        }
                                                      }
                                                    });
                                                    Get.to(
                                                        () =>
                                                            ClickShowEachCalendar(
                                                                groupcode: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ['code'],
                                                                start: snapshot.data!.docs[index][
                                                                    'Timestart'],
                                                                finish: snapshot
                                                                        .data!
                                                                        .docs[index][
                                                                    'Timefinish'],
                                                                calinfo: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ['Daytodo'],
                                                                date: controll_cals
                                                                    .selectedDay,
                                                                share: snapshot
                                                                    .data!
                                                                    .docs[index]['Shares'],
                                                                //calname: widget.calname,
                                                                calname: calname,
                                                                code: snapshot.data!.docs[index]['calname'],
                                                                summary: snapshot.data!.docs[index]['summary'],
                                                                isfromwhere: 'dayhome',
                                                                id: snapshot.data!.docs[index].id,
                                                                alarmtypes: alarmtypes,
                                                                alarmmake: isChecked_pushalarm,
                                                                alarmhour: hour,
                                                                alarmminute: minute),
                                                        transition: Transition.downToUp);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            right: 10),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['Daytodo']
                                                                .toString(),
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['summary']
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color:
                                                                    TextColor_shadowcolor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 18),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      color: controll_cals.themecalendar == 0
                                          ? (index % 4 == 0
                                              ? MyTheme.colororigred
                                              : (index % 4 == 1
                                                  ? MyTheme.colororigorange
                                                  : (index % 4 == 2
                                                      ? MyTheme.colororigblue
                                                      : MyTheme
                                                          .colororiggreen)))
                                          : (index % 4 == 0
                                              ? MyTheme.colorpastelred
                                              : (index % 4 == 1
                                                  ? MyTheme.colorpastelorange
                                                  : (index % 4 == 2
                                                      ? MyTheme.colorpastelblue
                                                      : MyTheme
                                                          .colorpastelgreen)))),
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
            ));
  }
}
