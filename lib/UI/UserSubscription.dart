import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Day.dart';
import 'package:clickbyme/DB/Recommend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../DB/AD_Home.dart';

UserSubscription(BuildContext context) {
  final List<Day> _list_day = [
    Day(
      day: '일',
    ),
    Day(
      day: '월',
    ),
    Day(
      day: '화',
    ),
    Day(
      day: '수',
    ),
    Day(
      day: '목',
    ),
    Day(
      day: '금',
    ),
    Day(
      day: '토',
    ),
  ];
  return Column(
    children: [
      Subscript(context, _list_day),
    ],
  );
}

ContentSub() {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List<Recommend> _list_recommend = [
    Recommend(sub: '오늘의 추천'),
    Recommend(sub: '오늘의 일정'),
    Recommend(sub: '새로 생긴 챌린지'),
    Recommend(sub: '인기 많은 데이로그'),
    Recommend(sub: '읽지 않은 스크립스'),
  ];
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return Container(
    child: ListView.builder(
      //controller: mainController,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _list_recommend.length,
      itemBuilder: (context, index) => Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: NeumorphicText(
                      _list_recommend[index].sub,
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: _list_background_color[index],
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      //controller: mainController,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _list_content.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Card(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            _list_content[index].title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            _list_content[index]
                                                    .date
                                                    .year
                                                    .toString() +
                                                '-' +
                                                _list_content[index]
                                                    .date
                                                    .month
                                                    .toString() +
                                                '-' +
                                                _list_content[index]
                                                    .date
                                                    .day
                                                    .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        )
                                      ]),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
          )
        ],
      ),
    ),
  );
}

Subscript(context, List<Day> list_day) {
  return list_day.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              Sticky(context, list_day),
            ],
          ),
        );
}

Sticky(context, List<Day> list_day) {
  return StickyHeader(
    header: Container(
      color: Colors.grey.shade100,
      alignment: Alignment.topLeft,
      height: MediaQuery.of(context).size.height / 15,
      child: ListView.builder(
        //controller: mainController,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        scrollDirection: Axis.horizontal,
        itemCount: list_day.isEmpty ? 0 : list_day.length,
        itemBuilder: (context, index) => Row(
          children: [
            SizedBox(
                width: 100,
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                    } else if (index == 1) {
                    } else if (index == 2) {
                    } else if (index == 3) {
                    } else if (index == 4) {
                    } else if (index == 5) {
                    } else {}
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.orangeAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          list_day[index].day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black45,
                          ),
                        ),
                      )),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 15),
            )
          ],
        ),
      ),
    ),
    content: ContentSub(),
  );
}
