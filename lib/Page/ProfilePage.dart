import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../Sub/NoticePage.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Setting/NoticeApps.dart';
import '../UI/Setting/UserDetails.dart';
import '../UI/Setting/UserSettings.dart';
import 'DrawerScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool login_state = false;
  String name = "null", email = "null", cnt = "null";
  int current_noticepage = 0;
  late Timer _timer_noti;
  final PageController _pcontroll = PageController(
    initialPage: 0,
  );
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer_noti = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (current_noticepage < 4) {
        current_noticepage++;
      } else {
        current_noticepage = 0;
      }
      if (_pcontroll.hasClients) {
        _pcontroll.animateToPage(current_noticepage,
            duration: const Duration(milliseconds: 2000), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer_noti.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                DrawerScreen(),
                ProfileBody(context, _pcontroll),
              ],
            )));
  }

  Widget ProfileBody(BuildContext context, PageController pcontroll) {
    double height =
        MediaQuery.of(context).size.height;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: Duration(milliseconds: 250),
      child: SizedBox(
        height: height,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
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
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          surfaceIntensity: 0.5,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ))),
                      const SizedBox(
                          child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('',
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
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
                        return Column(
                          children: [
                            S_Container1(height),
                            S_Container2(height, pcontroll, context),
                            S_Container3(height),
                            SizedBox(
                              height: 150,
                            ),
                          ],
                        );
                      })),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

S_Container1(double height) {
  return SizedBox(
    height: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('사용자 정보',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 100,
          child: UserDetails(height: height),
        )
      ],
    ),
  );
}

S_Container2(
    double height, PageController pageController, BuildContext context) {
  return SizedBox(
    height: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('앱 공지사항',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: NoticePage(),
                              type: PageTransitionType.leftToRightWithFade));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      child: NeumorphicIcon(
                        Icons.navigate_next,
                        size: 20,
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 2,
                            color: Colors.black45,
                            lightSource: LightSource.topLeft),
                      ),
                    )),
              ],
            )),
        SizedBox(
          height: 100,
          child: NoticeApps(
            height: height,
            pageController: pageController,
          ),
        )
      ],
    ),
  );
}

S_Container3(double height) {
  return SizedBox(
    height: 300,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('부가기능',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 250,
          child: UserSettings(height: height),
        )
      ],
    ),
  );
}
