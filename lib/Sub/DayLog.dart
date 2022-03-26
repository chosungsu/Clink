import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/Dialogs/addTodos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../Tool/NoBehavior.dart';

class DayLog extends StatefulWidget {
  //get onEventTap => null;

  @override
  State<StatefulWidget> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String time_table = '';
  String todo = '';
  final ValueNotifier<int> _daycount = ValueNotifier<int>(0);
  bool isclickedday = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        firestore
            .collection('TODO')
            .doc(Hive.box('user_info').get('id').toString() +
                DateFormat('yyyy-MM-dd')
                    .parse(selectedDay.toString().split(' ')[0])
                    .toString())
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
            tooltip: '추가하기',
            onPressed: () => {
              addTodos(context, textEditingController, selectedDay)
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
                  isclickedday = false;
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
                    } else {
                      time_table = '';
                      todo = '';
                    }
                  });
                  _daycount.value++;
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: NeumorphicButton(
                onPressed: () {
                  print(selectedDay);
                  setState(() {
                    isclickedday = true;
                  });
                },
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    depth: 2,
                    color: Colors.lightBlue,
                    lightSource: LightSource.topLeft),
                child: Center(
                    child: Text(
                  "날짜 선택 후 일정 들여다보기",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))),
          ),
          isclickedday == true
              ? timelineview(context, todo, time_table, selectedDay)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '버튼을 클릭하시면 일정이 이곳에 나타납니다.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
        ],
      );
    });
  }

  timelineview(
    BuildContext context,
    String todo,
    String time_table,
    DateTime selectedDay,
  ) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 220,
        child: todo != ''
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: todo.split(',').length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 120,
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
                                side:
                                    BorderSide(color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Row(
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
                                              todo.split(',')[index],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                        )),
                                    InkWell(
                                      onTap: () async {
                                        String nick =
                                            await Hive.box('user_info')
                                                .get('id');
                                        todo.split(',').length > 1 ?
                                        (index == 0 ? 
                                        await firestore
                                            .collection('TODO')
                                            .doc(nick +
                                                DateFormat('yyyy-MM-dd')
                                                    .parse(selectedDay
                                                        .toString()
                                                        .split(' ')[0])
                                                    .toString())
                                            .update({
                                          'time': time_table.replaceAll(
                                              time_table.split(',')[index] + ',', ''),
                                          'todo': todo.replaceAll(
                                              todo.split(',')[index] + ',', ''),
                                        }) :
                                        await firestore
                                            .collection('TODO')
                                            .doc(nick +
                                                DateFormat('yyyy-MM-dd')
                                                    .parse(selectedDay
                                                        .toString()
                                                        .split(' ')[0])
                                                    .toString())
                                            .update({
                                          'time': time_table.replaceAll(
                                              ',' + time_table.split(',')[index], ''),
                                          'todo': todo.replaceAll(
                                              ',' + todo.split(',')[index], ''),
                                        })) :
                                        await firestore
                                            .collection('TODO')
                                            .doc(nick +
                                                DateFormat('yyyy-MM-dd')
                                                    .parse(selectedDay
                                                        .toString()
                                                        .split(' ')[0])
                                                    .toString())
                                            .update({
                                          'time': time_table.replaceAll(
                                              time_table.split(',')[index], ''),
                                          'todo': todo.replaceAll(
                                              todo.split(',')[index], ''),
                                        });
                                        print(time_table);
                                        print(todo);
                                      },
                                      child: NeumorphicIcon(
                                        Icons.delete,
                                        size: 25,
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.concave,
                                          depth: 5,
                                          color:
                                              Colors.deepPurpleAccent.shade100,
                                        ),
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
                              time_table.split(',')[index],
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Hive.box('user_info').get('id').toString() +
                        '님 \n' +
                        selectedDay.day.toString() +
                        '날의 일정은 없네요',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ));
  }
}
