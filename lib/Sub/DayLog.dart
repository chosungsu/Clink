import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/DB/Radio_cal.dart';
import 'package:clickbyme/Dialogs/addTodos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../Tool/NoBehavior.dart';

class DayLog extends StatefulWidget {
  //get onEventTap => null;

  @override
  State<StatefulWidget> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  final Radio_cal _val = Hive.box('user_setting').get('cal_show_view') == null
      ? Radio_cal.month
      : (Hive.box('user_setting').get('cal_show_view') == 'month'
          ? Radio_cal.month
          : (Hive.box('user_setting').get('cal_show_view') == 'week'
              ? Radio_cal.week
              : Radio_cal.day));
  List<String> todolist = <String>[];
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String time_table = '';
  String todo = '';
  @override
  void initState() {
    // TODO: implement initState
    //selectedEvent = events[selectedDay] ?? [];
    super.initState();
    setState(() {
      firestore
          .collection('TODO')
          .doc(Hive.box('user_info').get('id').toString() +
              selectedDay.toString())
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.data() != null) {
          time_table = (ds.data() as Map)['time'];
          todo = (ds.data() as Map)['todo'];
        } else {
          time_table = '';
          todo = '';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        firestore
            .collection('TODO')
            .doc(Hive.box('user_info').get('id').toString() +
                selectedDay.toString())
            .get()
            .then((DocumentSnapshot ds) {
          if (ds.data() != null) {
            time_table = (ds.data() as Map)['time'];
            todo = (ds.data() as Map)['todo'];
          } else {
            time_table = '';
            todo = '';
          }
        });
      });
    });
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
            onPressed: () => {
              addTodos(context, textEditingController, todolist, selectedDay)
            },
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
                child: makeBody(context, todo, time_table),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context, String todo_, String time_table_) {
    //DateTime _selectedValue;
    return StatefulBuilder(builder: (_, StateSetter setState) {
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
                  firestore
                      .collection('TODO')
                      .doc(Hive.box('user_info').get('id').toString() +
                          selectedDay.toString())
                      .get()
                      .then((DocumentSnapshot ds) {
                    if (ds.data() != null) {
                      time_table = (ds.data() as Map)['time'];
                      todo = (ds.data() as Map)['todo'];
                      print(time_table);
                      print(todo);
                      time_table_ = time_table;
                      todo_ = todo;
                    } else {
                      time_table = '';
                      todo = '';
                      print(time_table);
                      print(todo);
                      time_table_ = time_table;
                      todo_ = todo;
                    }
                  });
                  print(selectedDay);
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
          timelineview(context, todo_, time_table_)
        ],
      );
    });
  }

  timelineview(
    BuildContext context,
    String todo,
    String time_table,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 220,
      child: todo != ''
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: todo.toString().split(',').length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
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
                                todo.toString().split(',')[index],
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
                        time_table.toString().split(',')[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ));
              })
          : Center(
              child: Text(
                Hive.box('user_info').get('id').toString() + '님 \n오늘의 일정은 없네요',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black45,
                ),
              ),
            ),
    );
  }
}
