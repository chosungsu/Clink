import 'package:clickbyme/UI/Home/TopContentNet/NewsRoomCard.dart';
import 'package:clickbyme/UI/Home/TopContentNet/TopCard.dart';
import 'package:clickbyme/UI/Home/ThirdContentNet/EventShowCard.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Sub/NoticePage.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/SecondContentNet/ChangeSpace.dart';
import '../UI/Home/SecondContentNet/YourDayfulAd.dart';
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
                                      style: const NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          surfaceIntensity: 0.5,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ))),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      widget.title.toString(),
                                      style: const TextStyle(
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
                                H_Container_1(height, _pController),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_2(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_3(),
                                const SizedBox(
                                  height: 150,
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

  H_Container_1(double height, PageController pController) {
    return SizedBox(
        height: 350,
        width: MediaQuery.of(context).size.width - 40,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: SizedBox(
                  height: 330,
                  child: TopCard(height: height),
                )),
            Positioned(
                top: 0,
                child: SizedBox(
                  height: 230,
                  child: EventShowCard(
                      height: height, pageController: pController),
                ))
          ],
        ));
  }

  H_Container_2(double height) {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text('하루공간',
                    style: TextStyle(
                        color: Colors.black54,
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
                        color: Colors.black54,
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

  H_Container_3() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('스낵 뉴스룸',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          NewsRoomCard()
        ],
      ),
    );
  }
}
