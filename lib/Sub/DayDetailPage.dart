import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class DayDetailPage extends StatefulWidget {
  const DayDetailPage({
    Key? key,
    required this.title,
    required this.daytime,
    required this.date,
    required this.list,
    required this.index,
  }) : super(key: key);
  final String title, daytime;
  final List<TODO> list;
  final DateTime date;
  final int index;
  @override
  State<StatefulWidget> createState() => _DayDetailPageState();
}

class _DayDetailPageState extends State<DayDetailPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<TODO> tmp_todo_list = [];
  List<String> todo_tmp = [];
  List<String> time_tmp = [];
  TextEditingController tc1 = TextEditingController();
  TextEditingController tc2 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tc1.dispose();
    tc2.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.box('user_setting').put('time', widget.daytime);
    Hive.box('user_setting').put('title', widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            visualDensity: VisualDensity(horizontal: -3, vertical: -3),
            onPressed: () async {
              Navigator.of(context).pop();
              String nick = await Hive.box('user_info').get('id');
              String str_snaps = '';
              String str_todo = '';
              widget.list.removeAt(widget.index);
              for (int i = 0; i < widget.list.length; i++) {
                tmp_todo_list.add(TODO(
                    title: widget.list[i].title, time: widget.list[i].time));
                todo_tmp.add(tmp_todo_list[i].title);
                time_tmp.add(tmp_todo_list[i].time);
              }
              widget.list.isEmpty
                  ? await firestore
                      .collection("TODO")
                      .doc(nick +
                          DateFormat('yyyy-MM-dd')
                              .parse(widget.date.toString().split(' ')[0])
                              .toString())
                      .delete()
                      .whenComplete(() async {
                      await firestore
                          .collection('TODO')
                          .doc(nick +
                              DateFormat('yyyy-MM-dd')
                                  .parse(widget.date.toString().split(' ')[0])
                                  .toString())
                          .set({
                        'name': nick,
                        'date': DateFormat('yyyy-MM-dd')
                            .parse(widget.date.toString())
                            .toString()
                            .split(' ')[0],
                        'time': tc2.text.isEmpty
                            ? await Hive.box('user_setting').get('time')
                            : tc2.text,
                        'todo': tc1.text.isEmpty
                            ? await Hive.box('user_setting').get('title')
                            : tc1.text,
                      });
                    })
                  : await firestore
                      .collection('TODO')
                      .doc(nick +
                          DateFormat('yyyy-MM-dd')
                              .parse(widget.date.toString().split(' ')[0])
                              .toString())
                      .get()
                      .then((DocumentSnapshot ds) async {
                      if (ds.data() != null) {
                        await firestore
                            .collection('TODO')
                            .doc(nick +
                                DateFormat('yyyy-MM-dd')
                                    .parse(widget.date.toString().split(' ')[0])
                                    .toString())
                            .update({
                          'time': time_tmp
                                  .getRange(0, time_tmp.length)
                                  .join(',') +
                              ',' +
                              (tc2.text.isEmpty
                                  ? await Hive.box('user_setting').get('time')
                                  : tc2.text),
                          'todo': todo_tmp
                                  .getRange(0, time_tmp.length)
                                  .join(',') +
                              ',' +
                              (tc1.text.isEmpty
                                  ? await Hive.box('user_setting').get('title')
                                  : tc1.text),
                        });
                      }
                    });
            },
            icon: Icon(
              Icons.save_alt,
              color: Colors.black54,
              size: 20,
            ),
            iconSize: 18,
          ),
          IconButton(
            visualDensity: VisualDensity(horizontal: -3, vertical: -3),
            onPressed: () async {
              Navigator.pop(context);
              print(widget.list[widget.index].title);
              String nick = await Hive.box('user_info').get('id');
              widget.list.length == 1
                  ? await firestore
                      .collection("TODO")
                      .doc(nick +
                          DateFormat('yyyy-MM-dd')
                              .parse(widget.date.toString().split(' ')[0])
                              .toString())
                      .delete()
                  : widget.list.removeAt(widget.index);
              for (int i = 0; i < widget.list.length; i++) {
                tmp_todo_list.add(TODO(
                    title: widget.list[i].title, time: widget.list[i].time));
                todo_tmp.add(tmp_todo_list[i].title);
                time_tmp.add(tmp_todo_list[i].time);
              }
              await firestore
                  .collection('TODO')
                  .doc(nick +
                      DateFormat('yyyy-MM-dd')
                          .parse(widget.date.toString().split(' ')[0])
                          .toString())
                  .update({
                'time': time_tmp.getRange(0, time_tmp.length).join(','),
                'todo': todo_tmp.getRange(0, time_tmp.length).join(','),
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.black54,
              size: 20,
            ),
            iconSize: 18,
          ),
        ],
        backgroundColor: Colors.white,
        title: SizedBox(
          width: 150,
          child: Expanded(
              child: Container(
            color: Colors.white,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blueGrey,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
            ),
          )),
        ),
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: makeBody(context, tc1, tc2, widget.title, widget.daytime),
      ),
    );
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, TextEditingController tc1,
    TextEditingController tc2, String title, String daytime) {
  return Container(
    height: MediaQuery.of(context).size.height,
    child: ScrollConfiguration(
      behavior: NoBehavior(),
      child: SingleChildScrollView(
          child: GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Column(
          children: [
            //first : 일정의 제목을 보여줄것
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: Text(
                      '일정 제목',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: TextField(
                      controller: tc1,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: title,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //second : 일정의 날짜와 시간을 보여줄 것
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: Text(
                      '일정 시간 및 날짜',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: TextField(
                      controller: tc2,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: daytime,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //third : 일정의 세부사항 보여줄것
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: Text(
                      '일정 세부내용',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ScrollConfiguration(
                              behavior: NoBehavior(),
                              child: const SingleChildScrollView(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      hintText: '이 곳에 내용을 작성해주세요.',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ))))),
                ],
              ),
            ),
            //forth : 일정을 공유하는 사람을 클립형태로 보여줄것
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: Text(
                      '공유하시는 피플',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: TextField(
                      controller: tc2,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: daytime,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    ),
  );
}
