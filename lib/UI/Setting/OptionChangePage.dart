import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/route.dart';
import 'package:clickbyme/sheets/userinfo_draggable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Tool/NoBehavior.dart';
import '../../Tool/IconBtn.dart';

class OptionChangePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OptionChangePageState();
}

class _OptionChangePageState extends State<OptionChangePage>
    with WidgetsBindingObserver {
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
  final List<String> list_user_setting = <String>[
    '개인정보 수집 및 이용 동의',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeDependencies();
    if (state == AppLifecycleState.inactive) {
      SystemNavigator.pop();
    }
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                        color: TextColor()),
                                  ),
                                ),
                                IconBtn(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .leftToRight,
                                                child: const MyHomePage(
                                                  index: 2,
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                        icon: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.close,
                                            size: 30,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: TextColor(),
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        )),
                                    color: TextColor())
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
                            mainAxisSize: MainAxisSize.min,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('옵션 설정',
                  style: TextStyle(
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
          OptView3(),
        ],
      ),
    );
  }

  OptView1() {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: BGColor_shadowcolor(),
                        foregroundColor: BGColor_shadowcolor(),
                        child: Icon(
                          Icons.tune,
                          color: TextColor(),
                        ),
                      )),
                  const SizedBox(
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
          ),
          color: BGColor_shadowcolor(),
        ));
  }

  Opt1_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list_app_setting.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
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
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (Hive.box('user_setting').get(
                                                            'which_color_background') ==
                                                        1 ||
                                                    Hive.box('user_setting').get(
                                                            'which_color_background') ==
                                                        null) {
                                                  Hive.box('user_setting').put(
                                                      'which_color_background',
                                                      0);
                                                } else {
                                                  Hive.box('user_setting').put(
                                                      'which_color_background',
                                                      1);
                                                }
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Hive.box('user_setting').get(
                                                          'which_color_background') ==
                                                      0
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: NeumorphicIcon(
                                                        Icons.check,
                                                        size: 25,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            color: Colors
                                                                .blue.shade300,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ))),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (Hive.box('user_setting').get(
                                                        'which_color_background') ==
                                                    0) {
                                                  Hive.box('user_setting').put(
                                                      'which_color_background',
                                                      1);
                                                } else {
                                                  Hive.box('user_setting').put(
                                                      'which_color_background',
                                                      0);
                                                }
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Hive.box('user_setting').get(
                                                          'which_color_background') ==
                                                      1
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: NeumorphicIcon(
                                                        Icons.check,
                                                        size: 25,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            color: Colors
                                                                .blue.shade300,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ))),
                                ],
                              ),
                            )
                          : (index == 1
                              ? SizedBox(
                                  height: 30,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (Hive.box('user_setting')
                                                                .get(
                                                                    'which_text_size') ==
                                                            1 ||
                                                        Hive.box('user_setting')
                                                                .get(
                                                                    'which_text_size') ==
                                                            null) {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_text_size',
                                                              0);
                                                    } else {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_text_size',
                                                              1);
                                                    }
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_text_size') ==
                                                                    0
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons.format_size,
                                                      size: 15,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (Hive.box('user_setting')
                                                            .get(
                                                                'which_text_size') ==
                                                        0) {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_text_size',
                                                              1);
                                                    } else {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_text_size',
                                                              0);
                                                    }
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_text_size') ==
                                                                    1
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons.text_fields,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (Hive.box('user_setting')
                                                                .get(
                                                                    'which_menu_pick') ==
                                                            1 ||
                                                        Hive.box('user_setting')
                                                                .get(
                                                                    'which_menu_pick') ==
                                                            null) {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_menu_pick',
                                                              0);
                                                    } else {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_menu_pick',
                                                              1);
                                                    }
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_menu_pick') ==
                                                                    0
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons
                                                          .align_horizontal_left,
                                                      size: 15,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (Hive.box('user_setting')
                                                            .get(
                                                                'which_menu_pick') ==
                                                        0) {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_menu_pick',
                                                              1);
                                                    } else {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'which_menu_pick',
                                                              0);
                                                    }
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_menu_pick') ==
                                                                    1
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons
                                                          .align_vertical_bottom,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                )
                          /*SizedBox(
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
                                )*/
                          )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView3() {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: BGColor_shadowcolor(),
                        foregroundColor: BGColor_shadowcolor(),
                        child: Icon(
                          Icons.portrait,
                          color: TextColor(),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '약관 및 정책',
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
              Opt3_body()
            ],
          ),
          color: BGColor_shadowcolor(),
        ));
  }

  Opt3_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list_user_setting.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    userinfo_draggable(context);
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list_user_setting[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
