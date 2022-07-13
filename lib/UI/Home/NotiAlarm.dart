import 'dart:async';

import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/addCalendarTodo.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:transition/transition.dart';
import 'package:clickbyme/Tool/dateutils.dart';
import '../../DB/Event.dart';
import '../../Dialogs/checkhowdaylog.dart';
import '../../Provider/EventProvider.dart';
import '../../Sub/DayEventAdd.dart';
import '../../Tool/CalendarSource.dart';
import '../../Tool/NoBehavior.dart';
import '../../sheets/changecalendarview.dart';

class NotiAlarm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final List notinamelist = [
    '전체',
    '공지글',
    '푸쉬알림',
  ];
  final List<PageList> _list_ad = [
    PageList(
      id: '0',
      title: '새로운 공지사항이 등록되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '1',
      title: '캘린더 카테고리(이)가 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '2',
      title: '일상메모 카테고리(이)가 신설되었습니다.',
      date: DateTime.now(),
    ),
    PageList(
      id: '3',
      title: '갓생루틴 카테고리(이)가 신설되었습니다.',
      date: DateTime.now(),
    ),
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('noti_home_click', 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                child: Column(
                  children: [
                    SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 50,
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                child: NeumorphicIcon(
                                                  Icons.keyboard_arrow_left,
                                                  size: 30,
                                                  style: const NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      surfaceIntensity: 0.5,
                                                      color: Colors.black45,
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                              ))),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60 -
                                              160,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                children: const [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      '알림',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )),
                            ],
                          ),
                        )),
                    NoticeApps(),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              NoticeLists(),
                              const SizedBox(
                                height: 150,
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

  NoticeApps() {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          NotiBox()
        ],
      ),
    );
  }

  NotiBox() {
    return SizedBox(
        height: 30,
        width: MediaQuery.of(context).size.width - 40,
        child: ListView.builder(
            // the number of items in the list
            itemCount: notinamelist.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            // display each item of the product list
            itemBuilder: (context, index) {
              return index == 2
                  ? Row(
                      children: [
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_home_click') ==
                                            null
                                        ? Colors.white
                                        : (Hive.box('user_setting')
                                                    .get('noti_home_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: const BorderSide(
                                      width: 1,
                                      color: Colors.black45,
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_home_click', index);
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          notinamelist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_home_click') ==
                                                    null
                                                ? Colors.black45
                                                : (Hive.box('user_setting').get(
                                                            'noti_home_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 4,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_home_click') ==
                                            null
                                        ? Colors.white
                                        : (Hive.box('user_setting')
                                                    .get('noti_home_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: const BorderSide(
                                      width: 1,
                                      color: Colors.black45,
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_home_click', index);
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          notinamelist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_home_click') ==
                                                    null
                                                ? Colors.black45
                                                : (Hive.box('user_setting').get(
                                                            'noti_home_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    );
            }));
  }

  NoticeLists() {
    return SizedBox(
      height: 120 * _list_ad.length.toDouble(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ListBox()],
      ),
    );
  }

  ListBox() {
    return SizedBox(
      height: _list_ad.isNotEmpty ? 110 * _list_ad.length.toDouble() : (200),
      width: MediaQuery.of(context).size.width - 40,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: _list_ad.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    ContainerDesign(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width - 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    _list_ad[index].title,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ));
          }),
    );
  }
}
