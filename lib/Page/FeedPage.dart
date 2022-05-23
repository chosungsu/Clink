import 'package:clickbyme/UI/Explore/ChallengeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../DB/Contents.dart';
import '../DB/Home_Rec_title.dart';
import '../DB/TODO.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Explore/FeedView.dart';
import '../UI/Explore/UserView.dart';
import '../UI/Home/UserPicks.dart';
import '../UI/SearchWidget.dart';
import '../UI/UserSubscription.dart';
import 'DrawerScreen.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final PageController _pController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          FeedBody(context, _pController),
        ],
      ),
    ));
  }

  Widget FeedBody(BuildContext context, PageController pController) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
                  height: height * 0.15,
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      'Explore',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black45),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 25,
                                    height: 25,
                                    child: NeumorphicIcon(
                                      Icons.history,
                                      size: 25,
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.85,
                  child: ScrollConfiguration(
                    behavior: NoBehavior(),
                    child: SingleChildScrollView(child:
                        StatefulBuilder(builder: (_, StateSetter setState) {
                      return Column(
                        children: [
                          F_Container1_1(height),
                          F_Container1_2(height),
                          F_Container2(height),
                          SizedBox(
                            height: height * 0.15,
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

F_Container1_1(double height) {
  return SizedBox(
    height: height * 0.25,
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
                      Text('즐겨찾기',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Favorites',
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
                              fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 25,
                  height: 25,
                  child: NeumorphicIcon(
                    Icons.navigate_next,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.black45,
                        lightSource: LightSource.topLeft),
                  ),
                )
              ],
            )),
        SizedBox(
          height: height * 0.2,
          child: UserView(height: height),
        )
      ],
    ),
  );
}

F_Container1_2(double height) {
  return SizedBox(
    height: height * 0.8,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('피드',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Feed',
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
                              fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 25,
                  height: 25,
                  child: NeumorphicIcon(
                    Icons.navigate_next,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.black45,
                        lightSource: LightSource.topLeft),
                  ),
                )
              ],
            )),
        FeedView(height: height),
      ],
    ),
  );
}
F_Container2(double height) {
  return SizedBox(
    height: height * 1.1,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: const [
                      Text('현재 진행중인 챌린지',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Challenges',
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic,
                              fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 25,
                  height: 25,
                  child: NeumorphicIcon(
                    Icons.navigate_next,
                    size: 25,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 2,
                        color: Colors.black45,
                        lightSource: LightSource.topLeft),
                  ),
                )
              ],
            )),
        ChallengeView(height: height),
      ],
    ),
  );
}
