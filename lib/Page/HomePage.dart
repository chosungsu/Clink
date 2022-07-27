import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/SheetGetx/Spacesetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/FormContentNet/FormCard.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
import 'package:clickbyme/UI/Home/firstContentNet/TopCard.dart';
import 'package:clickbyme/UI/Home/secondContentNet/EventShowCard.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/ChangeSpace.dart';
import 'package:clickbyme/route.dart';
import 'package:clickbyme/sheets/addgroupmember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/firstContentNet/RoutineHome.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key, required this.colorbackground, required this.coloritems})
      : super(key: key);
  final Color colorbackground;
  final Color coloritems;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  int navi = 0;
  int currentPage = 0;
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final spaceset = Get.put(Spacesetting());
  List showspacelist = [];
  String name = Hive.box('user_info').get('id');
  List<SpaceList> _user_ad = [];
  final List<SpaceList> _default_ad = [
    SpaceList(title: '날씨공간'),
    SpaceList(title: '일정공간'),
    SpaceList(title: '루틴공간'),
    SpaceList(title: '메모공간'),
    SpaceList(title: '운동공간'),
  ];

  late final PageController _pController;
  //프로 버전 구매시 사용하게될 코드
  bool isbought = false;

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    spaceset.setspace();
    showspacelist = spaceset.space;
    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
    navi = NaviWhere();
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: navi == 0
                ? (isdraweropen == true
                    ? Stack(
                        children: [
                          Container(
                            width: 50,
                            child: DrawerScreen(),
                          ),
                          HomeUi(_pController),
                        ],
                      )
                    : Stack(
                        children: [
                          HomeUi(_pController),
                        ],
                      ))
                : Stack(
                    children: [
                      HomeUi(_pController),
                    ],
                  )));
  }

  HomeUi(PageController pController) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        height: height,
        child: Container(
            color: BGColor(),
            //decoration: BoxDecoration(color: colorselection),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            navi == 0
                                ? SizedBox(
                                    width: 50,
                                    child: isdraweropen
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                xoffset = 0;
                                                yoffset = 0;
                                                scalefactor = 1;
                                                isdraweropen = false;
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            ))
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                xoffset = 50;
                                                yoffset = 0;
                                                scalefactor = 1;
                                                isdraweropen = true;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 30,
                                              height: 30,
                                              child: NeumorphicIcon(
                                                Icons.menu,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    surfaceIntensity: 0.5,
                                                    depth: 2,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            )))
                                : const SizedBox(),
                            SizedBox(
                                width: navi == 0
                                    ? MediaQuery.of(context).size.width - 60
                                    : MediaQuery.of(context).size.width - 10,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text('Habit Tracker',
                                              style: GoogleFonts.lobster(
                                                fontSize: 25,
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              /*Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    child: NotiAlarm()),
                                              );*/
                                              Get.to(NotiAlarm());
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 30,
                                              height: 30,
                                              child: NeumorphicIcon(
                                                Icons.notifications_none,
                                                size: 30,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    surfaceIntensity: 0.5,
                                                    depth: 2,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            )),
                                      ],
                                    ))),
                          ],
                        ),
                      ),
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
                              children: [
                                /*FutureBuilder<List<TODO>>(
                            future: homeasync(
                                selectedDay), // a previously-obtained Future<String> or null
                            builder: (BuildContext context,
                                AsyncSnapshot<List<TODO>> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return UserChoice(
                                    context, snapshot.data!, pController);
                              } else {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          border: const NeumorphicBorder.none(),
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(5)),
                                          depth: 5,
                                          color: Colors.white,
                                        ),
                                        child: Shimmer_home(context))
                                  ],
                                );
                              }
                            },
                          ),*/
                                const SizedBox(
                                  height: 20,
                                ),
                                /*H_Container_0(height),
                                const SizedBox(
                                  height: 20,
                                ),*/
                                H_Container_1(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_2(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_3(height, _pController),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_5(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_4(height),
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
      ),
    );
  }

  /*H_Container_0(double height) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormCard(height: height),
        ],
      ),
    );
  }*/

  H_Container_1(double height) {
    //프로버전 구매시 보이지 않게 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  H_Container_2(double height) {
    return SizedBox(
      height: 130,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text('카테고리',
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
          ),
          const SizedBox(
            height: 20,
          ),
          TopCard(height: height),
        ],
      ),
    );
  }

  H_Container_3(double height, PageController pController) {
    //프로버전 구매시 보이지 않게 함
    return SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventShowCard(
            height: height,
            pageController: pController,
            pageindex: 0,
            buy: isbought
          ),
        ],
      ),
    );
  }

  H_Container_4(double height) {
    //프로버전 구매시 사용할 코드
    //isbought == false일 경우와 isbought == true일 경우 사이즈박스 크기를 제한 풀기...
    return SizedBox(
      height: isbought == false ? 80 * 3 + 50 : 130 * 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('스페이스',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
                GestureDetector(
                  onTap: () {
                    //타일변경으로 넘어가기
                    /*Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: ChangeSpace()),
                  );*/
                    Get.to(
                            () => ChangeSpace(),
                        transition: Transition.fadeIn
                    );
                  },
                  child: Text('변경',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: isbought == true ? 80 * 5 : 80 * 3,
            child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: isbought == true ? showspacelist.length : 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                showspacelist[index] == '날씨공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (showspacelist[index] == '운동공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (showspacelist[index] == '메모공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : (showspacelist[index] == '루틴공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ))));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    ContainerDesign(
                                      color: BGColor(),
                                      child: Column(
                                        children: [
                                          Stack(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width - 40,
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(showspacelist[index],
                                                          style: TextStyle(
                                                              color: TextColor(),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18)),
                                                    ],
                                                  )),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: showspacelist[index] == '날씨공간'
                                                        ? NeumorphicIcon(
                                                      Icons.sunny,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (showspacelist[index] == '운동공간'
                                                        ? NeumorphicIcon(
                                                      Icons.directions_run,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (showspacelist[index] == '메모공간' ?
                                                    NeumorphicIcon(
                                                      Icons.note,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : (showspacelist[index] == '루틴공간' ?
                                                    NeumorphicIcon(
                                                      Icons.add_task,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : NeumorphicIcon(
                                                      Icons.today,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ))))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ));
                        })
            /*FutureBuilder(
                future: firestore
                    .collection("UserSpaceDataBase")
                    .doc(name)
                    .get()
                    .then((value) {
                  _user_ad.clear();
                  value.data()!.forEach((key, value) {
                    _user_ad.addAll([SpaceList(title: value)]);
                  });
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData || _user_ad.isNotEmpty) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: isbought == true ? _user_ad.length : 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                _user_ad[index].title == '날씨공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (_user_ad[index].title == '운동공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (_user_ad[index].title == '메모공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : (_user_ad[index].title == '루틴공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ))));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    ContainerDesign(
                                      color: BGColor(),
                                      child: Column(
                                        children: [
                                          Stack(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width - 40,
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(_user_ad[index].title,
                                                          style: TextStyle(
                                                              color: TextColor(),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18)),
                                                    ],
                                                  )),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: _user_ad[index].title == '날씨공간'
                                                        ? NeumorphicIcon(
                                                      Icons.sunny,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (_user_ad[index].title == '운동공간'
                                                        ? NeumorphicIcon(
                                                      Icons.directions_run,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (_user_ad[index].title == '메모공간' ?
                                                    NeumorphicIcon(
                                                      Icons.note,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : (_user_ad[index].title == '루틴공간' ?
                                                    NeumorphicIcon(
                                                      Icons.add_task,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : NeumorphicIcon(
                                                      Icons.today,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ))))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ));
                        });
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: isbought == true ? _default_ad.length : 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                _default_ad[index].title == '날씨공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (_default_ad[index].title == '운동공간'
                                    ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: DayContentHome()),
                                )
                                    : (_default_ad[index].title == '메모공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : (_default_ad[index].title == '루틴공간' ?
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ) : Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: RoutineHome()),
                                ))));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    ContainerDesign(
                                      color: BGColor(),
                                      child: Column(
                                        children: [
                                          Stack(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width - 40,
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(_default_ad[index].title,
                                                          style: TextStyle(
                                                              color: TextColor(),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18)),
                                                    ],
                                                  )),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: _default_ad[index].title == '날씨공간'
                                                        ? NeumorphicIcon(
                                                      Icons.sunny,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (_default_ad[index].title == '운동공간'
                                                        ? NeumorphicIcon(
                                                      Icons.directions_run,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    )
                                                        : (_default_ad[index].title == '메모공간' ?
                                                    NeumorphicIcon(
                                                      Icons.note,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : (_default_ad[index].title == '루틴공간' ?
                                                    NeumorphicIcon(
                                                      Icons.add_task,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ) : NeumorphicIcon(
                                                      Icons.today,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape:
                                                          NeumorphicShape.convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                          LightSource.topLeft),
                                                    ))))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ));
                        });
                  }
                }),*/
          )
        ],
      ),
    );
  }

  H_Container_5(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }
}
