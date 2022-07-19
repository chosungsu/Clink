import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/firstContentNet/RoutineScript.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Tool/NoBehavior.dart';
import 'package:text_scroll/text_scroll.dart';

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
      backgroundColor: BGColor(),
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor()
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
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                'Routine',
                                                style: GoogleFonts.lobster(
                                                fontSize: 25,
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              )
                                              ),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .bottomToTop,
                                                            child:
                                                                RoutineScript(
                                                              index: 0,
                                                              cardindex: 'null',
                                                            )),
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.add,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color:
                                                                TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      settingRoutineHome(
                                                          context);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.settings,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color:
                                                                TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ))),
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
                              RoutineBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              RoutinePlay(),
                              const SizedBox(
                                height: 50,
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
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('루틴 대시보드',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
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
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 2,
                      surfaceIntensity: 0.5,
                      color: TextColor(),
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
      return Hive.box('user_setting').get('numorimogi_routine') == null ||
              Hive.box('user_setting').get('numorimogi_routine') == 0
          ? SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width - 40,
              child: ContainerDesign(
                  color: BGColor(),
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
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(routinesucceed[index].toString() + '%',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                            ],
                          ),
                        );
                      })),
            )
          : SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width - 40,
              child: ContainerDesign(
                  color: BGColor(),
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
                                      color: TextColor(),
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
                                      color: BGColor(),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  child: routinesucceed[index] < 35
                                      ? Text(
                                          personwith[0]
                                              .toString()
                                              .substring(0, 1),
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))
                                      : (routinesucceed[index] < 70
                                          ? Text(
                                              personwith[1]
                                                  .toString()
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))
                                          : Text(
                                              personwith[2]
                                                  .toString()
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))))
                            ],
                          ),
                        );
                      })),
            );
    });
  }

  RoutinePlay() {
    return SizedBox(
      height: routineplaylist.length * 90 + 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Play',
              style: TextStyle(
                  color: TextColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
          const SizedBox(
            height: 20,
          ),
          Play(),
        ],
      ),
    );
  }

  Play() {
    return SizedBox(
        height: routineplaylist.length * 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ListView.builder(
            // the number of items in the list
            itemCount: routineplaylist.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // display each item of the product list
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ContainerDesign(
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                    height: 30,
                                    child: Center(
                                        child: TextScroll(
                                      routineplaylist[index],
                                      mode: TextScrollMode.bouncing,
                                      velocity: const Velocity(
                                          pixelsPerSecond: Offset(50, 0)),
                                      delayBefore: const Duration(milliseconds: 500),
                                      style: TextStyle(
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.right,
                                      selectable: true,
                                    ))),
                              ),
                              SizedBox(
                                  height: 30,
                                  child: InkWell(
                                      onTap: () {
                                        settingRoutineHome(context);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        height: 30,
                                        child: NeumorphicIcon(
                                          routineplaylistdone[index] ==
                                                  'not yet'
                                              ? Icons.play_circle_outline
                                              : Icons.check_circle_outline,
                                          size: 30,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              surfaceIntensity: 0.5,
                                              color: TextColor(),
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    color: BGColor()
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }));
  }

  RoutineRecommend() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Flexible(
                fit: FlexFit.tight,
                child: Text('루티너',
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
          color: Colors.white,
          child: personwith.isNotEmpty
              ? ListView.builder(
                  // the number of items in the list
                  itemCount: personwith.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  // display each item of the product list
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 40) / 5,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            child: Text(
                                personwith[index].toString().substring(0, 1),
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(personwith[index],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                      ),
                    );
                  })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('아직 추가하신 루티너가 없습니다. 친구추가 버튼으로 추가하세요.',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                )),
    );
  }
}
