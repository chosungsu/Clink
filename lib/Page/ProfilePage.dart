import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
      children: [
        DrawerScreen(),
        ProfileBody(context, _pcontroll),
      ],
    ));
  }

  Widget ProfileBody(BuildContext context, PageController pcontroll) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: Duration(milliseconds: 250),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    left: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    right: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                    bottom: BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 255, 214, 214)),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  )),
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      UserDetails(context),
                      NoticeApps(context, pcontroll),
                      UserSettings(context),
                    ])),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                top: MediaQuery.of(context).size.height * 0.02, 
                bottom: MediaQuery.of(context).size.height * 0.02),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                children: [
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
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepPurple.shade200),
                                child: NeumorphicIcon(
                                  Icons.keyboard_arrow_left,
                                  size: 30,
                                  style: const NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      surfaceIntensity: 0.5,
                                      color: Colors.white,
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
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepPurple.shade200),
                                child: NeumorphicIcon(
                                  Icons.menu,
                                  size: 30,
                                  style: const NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      surfaceIntensity: 0.5,
                                      color: Colors.white,
                                      lightSource: LightSource.topLeft),
                                ),
                              ))
                  ),
                  SizedBox(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('전체 설정',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}