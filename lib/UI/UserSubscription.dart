import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../DB/AD_Home.dart';

UserSubscription(BuildContext context) {
  final List<AD_Home> _list_subscript = [
    AD_Home(
      id: '1',
      title: '일정 관리',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '인맥 관리',
      person_num: 4,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '구독 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '포인트 관리',
      person_num: 5,
      date: DateTime.now(),
    )
  ];
  return Column(
    children: [
      Subscript(context, _list_subscript),
    ],
  );
}

ContentSub() {
  return Container(
    child: ListView.builder(
      //controller: mainController,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 35,
      itemBuilder: (context, index) => Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
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
                    '구독 명수 : ' + index.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black45,
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
          )
        ],
      ),
    ),
  );
}

Subscript(context, List<AD_Home> list_subscript) {
  return list_subscript.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              Sticky(context, list_subscript),
            ],
          ),
        );
}

Sticky(context, List<AD_Home> list_subscript) {
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
        itemCount: list_subscript.isEmpty ? 0 : list_subscript.length,
        itemBuilder: (context, index) => Row(
          children: [
            SizedBox(
              width: 100,
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
                      list_subscript[index].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black45,
                      ),
                    ),
                  )),
            ),
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
