import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:clickbyme/Dialogs/addTodos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../DB/TODO.dart';
import '../Futures/homeasync.dart';
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
  @override
  void initState() {
    super.initState();
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
            onPressed: () =>
                {addTodos(context, textEditingController, selectedDay)},
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
                child: makeBody(context),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
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
          FutureBuilder<List<TODO>>(
            future: homeasync(
                selectedDay), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<TODO>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return timelineview(context, selectedDay, snapshot.data!);
              } else {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: MediaQuery.of(context).size.height - 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height / 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black),
                            )
                          ],
                        ),
                      )),
                );
              }
            },
          ),
        ],
      );
    });
  }

  timelineview(
    BuildContext context,
    DateTime selectedDay,
    List<TODO> list,
  ) {
    List<TODO> tmp_todo_list = [];
    List<String> todo_tmp = [];
    List<String> time_tmp = [];

    return SizedBox(
        height: MediaQuery.of(context).size.height - 220,
        child: list.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list.length,
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
                                              list[index].title,
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
                                        list.length == 1
                                            ? await firestore
                                                .collection("TODO")
                                                .doc(nick +
                                                    DateFormat('yyyy-MM-dd')
                                                        .parse(selectedDay
                                                            .toString()
                                                            .split(' ')[0])
                                                        .toString())
                                                .delete()
                                            : list.removeAt(index);
                                        for (int i = 0; i < list.length; i++) {
                                          tmp_todo_list.add(TODO(
                                              title: list[i].title,
                                              time: list[i].time));
                                          todo_tmp.add(tmp_todo_list[i].title);
                                          time_tmp.add(tmp_todo_list[i].time);
                                        }
                                        print(time_tmp.length);
                                        await firestore
                                            .collection('TODO')
                                            .doc(nick +
                                                DateFormat('yyyy-MM-dd')
                                                    .parse(selectedDay
                                                        .toString()
                                                        .split(' ')[0])
                                                    .toString())
                                            .update({
                                          'time': time_tmp.getRange(
                                              0, time_tmp.length).join(','),
                                          'todo': todo_tmp.getRange(
                                              0, time_tmp.length).join(','),
                                        });
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
                              list[index].time,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
