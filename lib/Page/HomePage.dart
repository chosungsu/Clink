import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/Tool/Shimmer_home.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import '../Futures/homeasync.dart';
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
  initState() {
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
    return Scaffold(
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
                      title: 'HabitMind',
                      index: 0,
                    ),
                  ),
                );
                Hive.box('user_setting').put('page_index', 0);
              })
        ],
      ),
    );
  }

  HomeUi(PageController pController) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
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
                      const SizedBox(
                          child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('StormDot',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: SingleChildScrollView(child:
                        StatefulBuilder(builder: (_, StateSetter setState) {
                      return Column(
                        children: [
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
