import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Analytics/EntercheckView.dart';
import 'package:clickbyme/UI/Analytics/ReportView.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/secondContentNet/EventShowCard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Tool/NoBehavior.dart';
import 'DrawerScreen.dart';

class AnalyticPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage>
    with TickerProviderStateMixin {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  int navi = 0;
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  final PageController _pController = PageController();
  bool isbought = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navi = NaviWhere();
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
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
                          AnalyticBody(context, _pController),
                        ],
                      )
                    : Stack(
                        children: [
                          AnalyticBody(context, _pController),
                        ],
                      ))
                : Stack(
                    children: [
                      AnalyticBody(context, _pController),
                    ],
                  )));
  }

  Widget AnalyticBody(BuildContext context, PageController pController) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        height: height,
        child: Container(
            color: BGColor(),
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
                                width: MediaQuery.of(context).size.width - 60,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text('Explore',
                                              style: GoogleFonts.lobster(
                                                fontSize: 25,
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  A_Container1(height, _pController),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  A_Container2(height),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  A_Container3(height),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  A_Container4(height),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  A_Container5(height),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ));
                        })),
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  A_Container1(double height, PageController pController) {
    return SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventShowCard(
            height: height,
            pageController: pController,
            pageindex: 1,
            buy: isbought,
          ),
        ],
      ),
    );
  }

  A_Container2(double height) {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text('액티비티',
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ),
          const SizedBox(
            height: 20,
          ),
          ReportView(),
        ],
      ),
    );
  }

  A_Container3(double height) {
    return SizedBox(
      height: 180,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('출석현황',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
              GestureDetector(
                onTap: () {
                  //타일변경으로 넘어가기
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: EnterCheckPage()),
                  );
                },
                child: Text('Go',
                    style: TextStyle(
                        color: TextColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          EntercheckView(),
        ],
      ),
    );
  }

  A_Container4(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  A_Container5(double height) {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text('루틴활동',
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
          ),
          const SizedBox(
            height: 20,
          ),
          ReportView(),
        ],
      ),
    );
  }
}
