import 'dart:async';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/SheetGetx/navibool.dart';
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
  final draw = Get.put(navibool());
  int navi = 0;
  var _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navi = NaviWhere();
    _controller = TextEditingController();
    isdraweropen = draw.drawopen;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: navi == 0
          ? (draw.drawopen == true
              ? Stack(
                  children: [
                    Container(
                      width: 50,
                      child: DrawerScreen(),
                    ),
                    ProfileBody(context),
                  ],
                )
              : Stack(
                  children: [
                    ProfileBody(context),
                  ],
                ))
          : Stack(
              children: [
                ProfileBody(context),
              ],
            ),
    ));
  }

  Widget ProfileBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
        transform: Matrix4.translationValues(xoffset, yoffset, 0)
          ..scale(scalefactor),
        duration: const Duration(milliseconds: 250),
        child: GetBuilder<navibool>(
          builder: (_) => GestureDetector(
            onTap: () {
              setState(() {
                xoffset = 0;
                yoffset = 0;
                scalefactor = 1;
                isdraweropen = false;
                draw.setclose();
                Hive.box('user_setting').put('page_opened', false);
              });
            },
            child: SizedBox(
              height: height,
              child: Container(
                  color: BGColor(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            navi == 0
                                ? SizedBox(
                                    width: 50,
                                    child: draw.drawopen == true
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                xoffset = 0;
                                                yoffset = 0;
                                                scalefactor = 1;
                                                isdraweropen = false;
                                                draw.setclose();
                                                Hive.box('user_setting')
                                                    .put('page_opened', false);
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
                                                draw.setopen();
                                                Hive.box('user_setting')
                                                    .put('page_opened', true);
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
                                child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('',
                                  style: TextStyle(
                                      color: TextColor(),
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
                            child: SingleChildScrollView(child: StatefulBuilder(
                                builder: (_, StateSetter setState) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      S_Container1(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      S_Container2(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      S_Container3(height),
                                      const SizedBox(
                                        height: 50,
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
          ),
        ));
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

  S_Container2() {
    //프로버전 구매시 보이지 않게 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  S_Container3(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserSettings(height: height, controller: _controller),
        ],
      ),
    );
  }
}
