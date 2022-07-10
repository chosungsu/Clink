import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/addCalendarTodo.dart';
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

class RoutineHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RoutineHomeState();
}

class _RoutineHomeState extends State<RoutineHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool isclickedshowmore = false;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List routineday = ['일', '월', '화', '수', '목', '금', '토'];
  final List routinesucceed = [
    '3/3',
    '3/3',
    '3/3',
    '3/3',
    '3/3',
    '3/3',
    '3/3',
  ];
  final List routineplaylistdone = ['doing', 'doing', 'done', 'not yet'];
  final List routineplaylist = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
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
                    padding: EdgeInsets.only(left: 10, right: 10),
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
                                            style: NeumorphicStyle(
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
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                '',
                                                style: const TextStyle(
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
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  child: NeumorphicIcon(
                                    Icons.settings,
                                    size: 30,
                                    style: NeumorphicStyle(
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
                              RoutineBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              RoutinePlay(),
                              const SizedBox(
                                height: 20,
                              ),
                              RoutineRecommend(),
                              SizedBox(
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

  RoutineBox() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('루틴 대시보드',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
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
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: ListView.builder(
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
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(routinesucceed[index],
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              );
            }),
      ),
    );
  }

  RoutinePlay() {
    return SizedBox(
      height: isclickedshowmore == false
          ? 3 * 60 + 120
          : routineplaylist.length * 60 + 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('Play',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              GestureDetector(
                onTap: () {
                  
                },
                child: const Text('추가',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Play(),
          const SizedBox(
            height: 20,
          ),
          isclickedshowmore == true
              ? const SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade400,
                          ),
                          onPressed: () {
                            //구독관리페이지 호출
                            setState(() {
                              isclickedshowmore = true;
                            });
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: NeumorphicText(
                                    '더보기',
                                    style: const NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Colors.white,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Play() {
    return SizedBox(
      height: isclickedshowmore == false ? 3 * 60 : routineplaylist.length * 60,
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: ListView.builder(
            // the number of items in the list
            itemCount: routineplaylist.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // display each item of the product list
            itemBuilder: (context, index) {
              return SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              routineplaylist[index],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(routineplaylistdone[index],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      ),
                    ],
                  ));
            }),
      ),
    );
  }

  RoutineRecommend() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                '다른 루티너분들 루틴형성표를 구경하실래요?',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Recommend()
        ],
      ),
    );
  }

  Recommend() {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width - 40,
      child: ContainerDesign(
        child: ListView.builder(
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
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(routinesucceed[index],
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
