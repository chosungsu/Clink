import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/SheetGetx/calendarshowsetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/addcalendar.dart';
import 'package:clickbyme/sheets/settingCalendarHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../DB/Event.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/calendarthemesetting.dart';

class ChooseCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseCalendarState();
}

class _ChooseCalendarState extends State<ChooseCalendar> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final controll_cals = Get.put(calendarshowsetting());
  static final controll_cals2 = Get.put(calendarthemesetting());
  int setcal_fromsheet = 0;
  int themecal_fromsheet = controll_cals2.themecalendar;
  String username = Hive.box('user_info').get(
    'id',
  );
  TextEditingController controller = TextEditingController();
  final searchNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List list_calendar_home = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    setcal_fromsheet = controll_cals.showcalendar;
    themecal_fromsheet = controll_cals2.themecalendar;
    controller = TextEditingController();
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
      //backgroundColor: BGColor(),
      body: ChoiceC(),
    ));
  }

  ChoiceC() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(color: BGColor()),
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
                                            //Navigator.pop(context);
                                            Get.back();
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
                                              child: Text('',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 25,
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      //리스트 추가하는 창 띄우기
                                                      Hive.box('user_setting')
                                                          .put('typecalendar',
                                                              0);
                                                      addcalendar(
                                                          context,
                                                          searchNode,
                                                          controller,
                                                          username);
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
                                                            color: TextColor(),
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
                      child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: StatefulBuilder(
                              builder: (_, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Clist(),
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

  Clist() {
    return SizedBox(height: 400, child: listy());
  }

  listy() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('CalendarSheetHome')
            .where('madeUser', isEqualTo: username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: NeumorphicText(
                            '기록된 일정이 없네요;;;',
                            style: const NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: Colors.black45,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: NeumorphicText(
                          '일정표 목록',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      height: 300,
                                      width: 200,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => DayContentHome(
                                                title: snapshot.data!
                                                    .docs[index]['calname']),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: ContainerDesign(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                    height: 280,
                                                    child: Column(
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'calname'],
                                                                  maxLines: 5,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTitleTextsize(),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              ],
                                                            )),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            NeumorphicText(
                                                              'Made By ' +
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'madeUser'],
                                                              style:
                                                                  const NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .flat,
                                                                depth: 3,
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                              textStyle:
                                                                  NeumorphicTextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            color: snapshot.data!.docs[index]
                                                        ['color'] !=
                                                    null
                                                ? Color(snapshot
                                                    .data!.docs[index]['color'])
                                                : Colors.blue),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              );
                            }),
                      )
                    ],
                  );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: NeumorphicText(
                      '불러오는 중 오류가 발생하였습니다.\n지속될 경우 문의바랍니다.',
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: Colors.black45,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Center(child: CircularProgressIndicator())],
              ),
            );
          }
          return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: NeumorphicText(
                      '생성된 일정표가 없습니다.\n추가 버튼으로 생성해보세요~',
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: TextColor(),
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ));
        },
      );
    });
  }
}
