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
  int current_noticepage = 0;
  late Timer _timer_noti;
  final PageController _pcontroll = PageController(
    initialPage: 0,
  );
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
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    _timer_noti = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (current_noticepage < 3) {
        current_noticepage++;
      } else {
        current_noticepage = 0;
      }
      if (_pcontroll.hasClients) {
        _pcontroll.animateToPage(current_noticepage,
            duration: const Duration(milliseconds: 2000), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer_noti.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: UI(_pcontroll),
    ));
  }

  UI(PageController pcontroll) {
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
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: Colors.black45,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60 -
                                        160,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: const Text(
                                                '알림',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black45),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
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
                              SizedBox(
                                height: 100,
                                child: NoticeApps(
                                  pageController: pcontroll,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 100,
                                child: RecentAlarms(
                                  pageController: pcontroll,
                                ),
                              ),
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

  NoticeApps({required PageController pageController}) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('공지글',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          NotiBox(pageController)
        ],
      ),
    );
  }

  NotiBox(PageController pageController) {
    return ContainerDesign(
            child: SizedBox(
          height: 30,
          child: PageView.builder(
              scrollDirection: Axis.vertical,
              pageSnapping: false,
              itemCount: _list_ad.length,
              controller: pageController,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        _list_ad[index].title.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'today',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(115, 175, 175, 175),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ));
  }
  RecentAlarms({required PageController pageController}) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('최근',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          NotiBox(pageController)
        ],
      ),
    );
  }
}
