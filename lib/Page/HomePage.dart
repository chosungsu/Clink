import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/Tool/Shimmer_home.dart';
import 'package:clickbyme/UI/Home/UserMain.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Futures/homeasync.dart';
import '../Sub/DayLog.dart';
import '../Sub/WritePost.dart';
import '../Sub/YourTags.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/UserChoice.dart';
import '../route.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDay = DateTime.now();
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final PageController _pController = PageController();

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
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
          RefreshIndicator(
              child: HomeUi(_pController),
              onRefresh: () async {
                Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const MyHomePage(
                      title: 'StormDot',
                      index: 0,
                    ),
                  ),
                );
                Hive.box('user_setting').put('page_index', 0);
              })
        ],
      ),
      floatingActionButton: SpeedDial(
        //animatedIcon: AnimatedIcons.menu_close,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.grey.shade300,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
              child: Image.asset(
                'assets/images/date.png',
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: DayLog(),
                        type: PageTransitionType.leftToRightWithFade));
              },
              label: '일정 작성'),
          SpeedDialChild(
              child: Image.asset(
                'assets/images/challenge.png',
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: WritePost(),
                        type: PageTransitionType.leftToRightWithFade));
              },
              label: '챌린지 작성'),
          SpeedDialChild(
              child: Image.asset(
                'assets/images/playlist.png',
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: YourTags(),
                        type: PageTransitionType.leftToRightWithFade));
              },
              label: '뷰 작성'),
        ],
      ),
    ));
  }

  HomeUi(PageController pController) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
              children: [
                SizedBox(
                  height: height *
                      0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 10)),
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
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: 2,
                                          surfaceIntensity: 0.5,
                                          color: Colors.grey.shade300,
                                          lightSource: LightSource.topLeft),
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
                                          shape: NeumorphicShape.convex,
                                          surfaceIntensity: 0.5,
                                          depth: 2,
                                          color: Colors.grey.shade300,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ))),
                      SizedBox(
                          child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(widget.title.toString(),
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: height *
                      0.85,
                  child: ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: SingleChildScrollView(child:
                        StatefulBuilder(builder: (_, StateSetter setState) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: UserMain(context),
                          ),
                          FutureBuilder<List<TODO>>(
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
                          ),
                        ],
                      );
                    })),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
