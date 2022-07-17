import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/FormContentNet/FormCard.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
import 'package:clickbyme/UI/Home/firstContentNet/TopCard.dart';
import 'package:clickbyme/UI/Home/secondContentNet/EventShowCard.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/ChangeSpace.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/YourDayfulAd.dart';
import 'package:clickbyme/sheets/addgroupmember.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/NoBehavior.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  int currentPage = 0;
  late final PageController _pController;
  //프로 버전 구매시 사용하게될 코드
  bool isbought = false;
  final List<SpaceList> _list_ad = [
    SpaceList(
      title: '날씨조각',
    ),
    SpaceList(
      title: '운동조각',
    ),
    SpaceList(
      title: '일정조각',
    ),
    SpaceList(
      title: '메모조각',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          DrawerScreen(),
          HomeUi(_pController),
        ],
      ),
    ));
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
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
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
                            SizedBox(
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
                                            style: const NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: Colors.black45,
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
                                            style: const NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                surfaceIntensity: 0.5,
                                                depth: 2,
                                                color: Colors.black45,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                            SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            'Habit Tracker',
                                            style: MyTheme.kAppTitle,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    child: NotiAlarm()),
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 30,
                                              height: 30,
                                              child: NeumorphicIcon(
                                                Icons.notifications_none,
                                                size: 30,
                                                style: const NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    surfaceIntensity: 0.5,
                                                    depth: 2,
                                                    color: Colors.black45,
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
                                H_Container_0(height),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                H_Container_4(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_5(height),
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

  H_Container_0(double height) {
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
  }
  H_Container_1(double height) {
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
          const Flexible(
            fit: FlexFit.tight,
            child: Text('카테고리',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
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
    return SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventShowCard(height: height, pageController: pController, pageindex: 0,),
        ],
      ),
    );
  }

  H_Container_4(double height) {
    //프로버전 구매시 사용할 코드
    //isbought == false일 경우와 isbought == true일 경우 사이즈박스 크기를 제한 풀기...
    return SizedBox(
      height:
          isbought == false ? 110 * 3 : 110 * _list_ad.length.toDouble(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('스페이스',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              GestureDetector(
                onTap: () {
                  //타일변경으로 넘어가기
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: ChangeSpace()),
                  );
                },
                child: const Text('변경',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          YourDayfulAd(height: height)
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
