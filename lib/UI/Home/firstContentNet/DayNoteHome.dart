import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
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
import '../../../DB/Event.dart';
import '../../../Dialogs/checkhowdaylog.dart';
import '../../../Provider/EventProvider.dart';
import '../../../Sub/DayEventAdd.dart';
import '../../../Tool/CalendarSource.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/changecalendarview.dart';

class DayNoteHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayNoteHomeState();
}

class _DayNoteHomeState extends State<DayNoteHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List routineday = ['일', '월', '화', '수', '목', '금', '토'];
  final List routinesucceed = [20, 20, 80, 60, 60, 80, 100];
  final List routineplaylistdone = ['doing', 'doing', 'done', 'not yet'];
  final List routineplaylist = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
  ];
  final List personwith = [
    '김영헌',
    '이제민',
    '최우성',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
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
                                          children: const [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                '',
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
                        SizedBox(
                            width: 50,
                            child: InkWell(
                                onTap: () {
                                  settingRoutineHome(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  child: NeumorphicIcon(
                                    Icons.settings,
                                    size: 30,
                                    style: const NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: Colors.black45,
                                        lightSource: LightSource.topLeft),
                                  ),
                                ))),
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
                              const SizedBox(
                                height: 20,
                              ),
                              SearchBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              RoutineBox(),
                              const SizedBox(
                                height: 20,
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

  SearchBox() {
    return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Search()],
      ),
    );
  }

  Search() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
            height: 50,
            child: ContainerDesign(
                child: TextField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintMaxLines: 2,
                      hintText: '톱니바퀴 -> 조건설정 후 검색',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black45),
                      prefixIcon: Icon(Icons.search),
                      isCollapsed: true,
                      prefixIconColor: Colors.black),
                ),
                color: Colors.white))
      ],
    );
  }

  RoutineBox() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('메모',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    Box();
                  });
                },
                child: NeumorphicIcon(
                  Icons.refresh,
                  size: 30,
                  style: const NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 2,
                      surfaceIntensity: 0.5,
                      color: Colors.black45,
                      lightSource: LightSource.topLeft),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Box()
        ],
      ),
    );
  }

  Box() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: Colors.white,
            child: Hive.box('user_setting').get('numorimogi_routine') == null ||
                    Hive.box('user_setting').get('numorimogi_routine') == 0
                ? ListView.builder(
                    // the number of items in the list
                    itemCount: routineday.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 7,
                        child: Column(
                          children: [
                            Text(routineday[index],
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(routinesucceed[index].toString() + '%',
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15))
                          ],
                        ),
                      );
                    })
                : ListView.builder(
                    // the number of items in the list
                    itemCount: routineday.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) / 7,
                        child: Column(
                          children: [
                            Text(routineday[index],
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                child: routinesucceed[index] < 35
                                    ? Text(
                                        personwith[0]
                                            .toString()
                                            .substring(0, 1),
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                    : (routinesucceed[index] < 70
                                        ? Text(
                                            personwith[1]
                                                .toString()
                                                .substring(0, 1),
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))
                                        : Text(
                                            personwith[2]
                                                .toString()
                                                .substring(0, 1),
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))))
                          ],
                        ),
                      );
                    })),
      );
    });
  }
}
