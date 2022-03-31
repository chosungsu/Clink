import 'package:clickbyme/DB/Event.dart';
import 'package:clickbyme/Provider/EventProvider.dart';
import 'package:clickbyme/Tool/dateutils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Tool/NoBehavior.dart';

class EventViewPage extends StatefulWidget {
  EventViewPage({
    Key? key,
    required this.event,
  }) : super(key: key);
  Event? event;
  @override
  State<StatefulWidget> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
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
            tooltip: '수정하기',
            onPressed: () => {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            color: Colors.black54,
            tooltip: '삭제하기',
            onPressed: () => {},
            icon: const Icon(Icons.delete),
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
                child: makeBody(context),
              ))),
    );
  }

  // 바디 만들기
  Widget makeBody(BuildContext context) {
    return buildDates();
  }

  buildDates() {
    print(widget.event!.from.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDate('From', widget.event!.from.toString().split('.')[0]),
        buildDate('To', widget.event!.to.toString().split('.')[0]),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            widget.event!.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            widget.event!.description,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  buildDate(String title, String date) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              date,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
