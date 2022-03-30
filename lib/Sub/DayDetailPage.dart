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
    required this.content,
    required this.date,
    required this.list,
    required this.index,
  }) : super(key: key);
  final String title, daytime, content;
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
  List<String> content_tmp = [];
  //Map<String, dynamic> usermap = {};
  TextEditingController tc1 = TextEditingController();
  TextEditingController tc2 = TextEditingController();
  TextEditingController tc3 = TextEditingController();
  //TextEditingController tc5 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tc1.dispose();
    tc2.dispose();
    tc3.dispose();
    //tc5.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.box('user_setting').put('time', widget.daytime);
    Hive.box('user_setting').put('title', widget.title);
    Hive.box('user_setting').put('content', widget.content);
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
              //widget.list.removeAt(widget.index);

              await firestore
                  .collection('TODO')
                  .doc(nick +
                      DateFormat('yyyy-MM-dd')
                          .parse(widget.date.toString())
                          .toString()
                          .split(' ')[0] +
                      widget.daytime)
                  .update({
                'time': tc2.text.isEmpty ? widget.daytime : tc2.text,
                'todo': tc1.text.isEmpty ? widget.title : tc1.text,
                'content': tc3.text.isEmpty ? widget.content : tc3.text,
              });
              /*for (int i = 0; i < widget.list.length; i++) {
                tmp_todo_list.add(TODO(
                  title: widget.list[i].title,
                  time: widget.list[i].time,
                  content: widget.list[i].content,
                ));
                todo_tmp.add(tmp_todo_list[i].title);
                time_tmp.add(tmp_todo_list[i].time);
                content_tmp.add(tmp_todo_list[i].content);
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
                        'content': tc3.text.isEmpty ? 'none' : tc3.text,
                      });
                    })
                  : await firestore
                      .collection('TODO')
                      .doc(nick +
                          DateFormat('yyyy-MM-dd')
                              .parse(widget.date.toString().split(' ')[0])
                              .toString())
                      .update({
                      'time': time_tmp.getRange(0, time_tmp.length).join(',') +
                          ',' +
                          (tc2.text.isEmpty
                              ? await Hive.box('user_setting').get('time')
                              : tc2.text),
                      'todo': todo_tmp.getRange(0, todo_tmp.length).join(',') +
                          ',' +
                          (tc1.text.isEmpty
                              ? await Hive.box('user_setting').get('title')
                              : tc1.text),
                      'content': content_tmp
                              .getRange(0, content_tmp.length)
                              .join(',') +
                          ',' +
                          (tc3.text.isEmpty ? 'none' : tc3.text),
                    });*/
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
              //print(widget.list[widget.index].title);
              String nick = await Hive.box('user_info').get('id');
              await firestore
                        .collection('TODO')
                        .doc(nick +
                            DateFormat('yyyy-MM-dd')
                                .parse(widget.date.toString())
                                .toString()
                                .split(' ')[0] +
                            widget.daytime)
                        .delete();

              /*widget.list.length == 1
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
                  title: widget.list[i].title,
                  time: widget.list[i].time,
                  content: widget.list[i].content,
                ));
                todo_tmp.add(tmp_todo_list[i].title);
                time_tmp.add(tmp_todo_list[i].time);
                content_tmp.add(tmp_todo_list[i].content);
              }
              await firestore
                  .collection('TODO')
                  .doc(nick +
                      DateFormat('yyyy-MM-dd')
                          .parse(widget.date.toString().split(' ')[0])
                          .toString())
                  .update({
                'time': time_tmp.getRange(0, time_tmp.length).join(','),
                'todo': todo_tmp.getRange(0, todo_tmp.length).join(','),
                'content':
                    content_tmp.getRange(0, content_tmp.length).join(','),
              });*/
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
        title: Text(
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
        elevation: 0,
      ),
      body: Container(
        padding: MediaQuery.of(context).viewInsets,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: makeBody(context, tc1, tc2, tc3, widget.title, widget.daytime,
            widget.content, firestore),
      ),
    );
  }
}

// 바디 만들기
Widget makeBody(
  BuildContext context,
  TextEditingController tc1,
  TextEditingController tc2,
  TextEditingController tc3,
  String title,
  String daytime,
  String content,
  FirebaseFirestore firestore,
) {
  return ScrollConfiguration(
    behavior: NoBehavior(),
    child: SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        }, child: StatefulBuilder(builder: (_, StateSetter setState) {
          return Column(
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
                        '일정 시작시간',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: TextField(
                                    controller: tc3,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText: content == 'none'
                                            ? '이 곳에 내용을 작성해주세요.'
                                            : content,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                  ),
                                ))))),
                  ],
                ),
              ),
            ],
          );
        }))
      ],
    )),
  );
}
