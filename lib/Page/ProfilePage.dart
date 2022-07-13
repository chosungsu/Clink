import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../Sub/NoticePage.dart';
import '../Tool/NoBehavior.dart';
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
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                DrawerScreen(),
                ProfileBody(context),
              ],
            )));
  }

  Widget ProfileBody(BuildContext context) {
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
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                S_Container1(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                S_Container2(height),
                                const SizedBox(
                                  height: 150,
                                ),
                              ],
                            ));
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
    height: 155,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          child: UserDetails(height: height),
        )
      ],
    ),
  );
}

S_Container2(double height) {
  return SizedBox(
    height: 500,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserSettings(height: height),
      ],
    ),
  );
}
