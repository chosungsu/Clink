import 'package:clickbyme/Page/ProfilePage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/route.dart';
import 'package:clickbyme/sheets/pushalarmsetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../../Tool/NoBehavior.dart';

class OptionChangePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OptionChangePageState();
}

class _OptionChangePageState extends State<OptionChangePage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool isChecked_pushalarm = false;
  bool isChecked_adok = false;
  Color colorselection = Colors.white;
  Color coloritems = Colors.white;
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> list_app_setting = <String>[
    '배경색',
    '글자크기',
    '메뉴바 위치',
  ];
  final List<String> list_noti_setting = <String>[
    '앱 푸쉬알림 설정',
    '광고성 정보수신 동의',
  ];

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').get('isChecked_pushalarm') == null
        ? isChecked_pushalarm = false
        : isChecked_pushalarm =
            Hive.box('user_setting').get('isChecked_pushalarm');
    Hive.box('user_setting').get('isChecked_adok') == null
        ? isChecked_adok = false
        : isChecked_adok = Hive.box('user_setting').get('isChecked_adok');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: WillPopScope(
              onWillPop: () async {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const MyHomePage(
                      index: 2,
                    ),
                  ),
                );
                Hive.box('user_setting').put('page_index', 2);
                return false;
              },
              child: Options(),
            )));
  }

  Options() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
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
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60 - 160,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
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
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              OptionChoice(height, context),
                              const SizedBox(
                                height: 50,
                              ),
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

  OptionChoice(double height, BuildContext context) {
    return SizedBox(
      height: 60 * list_app_setting.length.toDouble() +
          40 +
          60 * list_noti_setting.length.toDouble() +
          40 +
          170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('옵션을 원하는대로\n 변경하는 공간입니다.',
                  style: GoogleFonts.jua(
                    fontSize: secondTitleTextsize(),
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          OptView1(),
          const SizedBox(
            height: 20,
          ),
          OptView2(),
        ],
      ),
    );
  }

  OptView1() {
    return SizedBox(
        height: 60 * list_app_setting.length.toDouble() + 40,
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: TextColor(),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '앱 UI 설정',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: TextColor()),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt1_body()
          ],
        ));
  }

  Opt1_body() {
    return SizedBox(
      height: 50 * list_app_setting.length.toDouble(),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list_app_setting.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list_app_setting[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: TextColor()),
                      ),
                      index == 0
                          ? SizedBox(
                              height: 30,
                              width: 183,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 90,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                primary: Hive.box(
                                                                'user_setting')
                                                            .get(
                                                                'which_color_background') ==
                                                        0
                                                    ? Colors.grey.shade400
                                                    : (Hive.box('user_setting').get(
                                                                'which_color_background') ==
                                                            null
                                                        ? Colors.grey.shade400
                                                        : Colors.white),
                                                side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black45,
                                                )),
                                            onPressed: () {
                                              setState(() {
                                                Hive.box('user_setting').put(
                                                    'which_color_background',
                                                    0);
                                              });
                                            },
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: NeumorphicText(
                                                      '낮컬러',
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 3,
                                                        color: Hive.box('user_setting')
                                                                    .get(
                                                                        'which_color_background') ==
                                                                0
                                                            ? Colors.white
                                                            : (Hive.box('user_setting')
                                                                        .get(
                                                                            'which_color_background') ==
                                                                    null
                                                                ? Colors.white
                                                                : Colors
                                                                    .black45),
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      )),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 90,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              primary: Hive.box('user_setting').get(
                                                          'which_color_background') ==
                                                      1
                                                  ? Colors.grey.shade400
                                                  : Colors.white,
                                              side: const BorderSide(
                                                width: 1,
                                                color: Colors.black45,
                                              )),
                                          onPressed: () {
                                            setState(() {
                                              Hive.box('user_setting').put(
                                                  'which_color_background', 1);
                                            });
                                          },
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '밤컬러',
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: Hive.box('user_setting')
                                                                  .get(
                                                                      'which_color_background') ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.black45,
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : (index == 1
                              ? SizedBox(
                                  height: 30,
                                  width: 183,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 90,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                    primary: Hive.box(
                                                                    'user_setting')
                                                                .get(
                                                                    'which_text_size') ==
                                                            0
                                                        ? Colors.grey.shade400
                                                        : (Hive.box('user_setting')
                                                                    .get(
                                                                        'which_text_size') ==
                                                                null
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.white),
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black45,
                                                    )),
                                                onPressed: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_text_size',
                                                            0);
                                                  });
                                                },
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '중간',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_text_size') ==
                                                                    0
                                                                ? Colors.white
                                                                : (Hive.box('user_setting').get(
                                                                            'which_text_size') ==
                                                                        null
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black45),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          )),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 70,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  primary: Hive.box(
                                                                  'user_setting')
                                                              .get(
                                                                  'which_text_size') ==
                                                          1
                                                      ? Colors.grey.shade400
                                                      : Colors.white,
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black45,
                                                  )),
                                              onPressed: () {
                                                setState(() {
                                                  Hive.box('user_setting').put(
                                                      'which_text_size', 1);
                                                });
                                              },
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '큼',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: Hive.box('user_setting')
                                                                      .get(
                                                                          'which_text_size') ==
                                                                  1
                                                              ? Colors.white
                                                              : Colors.black45,
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 183,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                            width: 90,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                    primary: Hive.box(
                                                                    'user_setting')
                                                                .get(
                                                                    'which_menu_pick') ==
                                                            0
                                                        ? Colors.grey.shade400
                                                        : (Hive.box('user_setting')
                                                                    .get(
                                                                        'which_menu_pick') ==
                                                                null
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.white),
                                                    side: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black45,
                                                    )),
                                                onPressed: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_menu_pick',
                                                            0);
                                                  });
                                                },
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '사이드',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_menu_pick') ==
                                                                    0
                                                                ? Colors.white
                                                                : (Hive.box('user_setting').get(
                                                                            'which_menu_pick') ==
                                                                        null
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black45),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          )),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          width: 90,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  primary: Hive.box(
                                                                  'user_setting')
                                                              .get(
                                                                  'which_menu_pick') ==
                                                          1
                                                      ? Colors.grey.shade400
                                                      : Colors.white,
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black45,
                                                  )),
                                              onPressed: () {
                                                setState(() {
                                                  Hive.box('user_setting').put(
                                                      'which_menu_pick', 1);
                                                });
                                              },
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '아래',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: Hive.box('user_setting')
                                                                      .get(
                                                                          'which_menu_pick') ==
                                                                  1
                                                              ? Colors.white
                                                              : Colors.black45,
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView2() {
    return SizedBox(
        height: 60 * list_noti_setting.length.toDouble() + 40,
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: TextColor(),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '알림 설정',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: TextColor()),
                ),
              ],
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            Opt2_body()
          ],
        ));
  }

  Opt2_body() {
    return SizedBox(
      height: 50 * list_noti_setting.length.toDouble(),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list_noti_setting.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list_noti_setting[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: TextColor()),
                      ),
                      index == 0
                          ? Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                  value: isChecked_pushalarm,
                                  onChanged: (bool val) {
                                    setState(() {
                                      selectedDay = DateTime.now();
                                      isChecked_pushalarm = val;
                                      Hive.box('user_setting').put(
                                          'isChecked_pushalarm',
                                          isChecked_pushalarm);
                                      if (isChecked_pushalarm == true) {
                                        pushalarmsetting(context, 0,
                                            isChecked_pushalarm, selectedDay);
                                      }
                                    });
                                  }),
                            )
                          : Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                  value: isChecked_adok,
                                  onChanged: (bool val) {
                                    setState(() {
                                      selectedDay = DateTime.now();
                                      isChecked_adok = val;
                                      Hive.box('user_setting').put(
                                          'isChecked_adok', isChecked_adok);
                                      if (isChecked_adok == true) {
                                        pushalarmsetting(context, 1,
                                            isChecked_pushalarm, selectedDay);
                                      }
                                    });
                                  }),
                            )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
