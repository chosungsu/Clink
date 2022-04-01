import 'dart:async';
import 'package:clickbyme/UI/UserDetails.dart';
import 'package:clickbyme/UI/UserSettings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Tool/NoBehavior.dart';
import '../UI/NoticeApps.dart';
import '../route.dart';
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
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02, 
                bottom: MediaQuery.of(context).size.height * 0.02),
              alignment: Alignment.topLeft,
              color: Colors.deepPurple.shade200,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: isdraweropen
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                xoffset = 0;
                                yoffset = 0;
                                scalefactor = 1;
                                isdraweropen = false;
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_left),
                            color: Colors.white,
                            iconSize: 20,
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                xoffset = 180;
                                yoffset = 100;
                                scalefactor = 0.8;
                                isdraweropen = true;
                              });
                            },
                            icon: Icon(Icons.menu),
                            color: Colors.white,
                            iconSize: 20,
                          ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              color: Colors.white,
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
          )
        ],
      ),
    );
  }
}