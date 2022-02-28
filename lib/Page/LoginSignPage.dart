import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../route.dart';


class LoginSignPage extends StatefulWidget {
  const LoginSignPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginSignPageState();
}

class _LoginSignPageState extends State<LoginSignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          child: Center(
            child: makeBody(context),
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: new Text('아니요'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('네'),
          ),
        ],
      ),
    )) ?? false;
  }
}
// 바디 만들기
Widget makeBody(BuildContext context) {

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
            child : LoginPlus(context)
        ),
      ],
    ),

  );
}
LoginPlus(BuildContext context) {
  return Column(
    children: [
      const Text(
        '자신의 관심사에 맞게 고르고\n'
            '다른 이에게 역추천의 재미까지\n'
            'AI로 당신의 관심사를 채워드리겠습니다.',
        style: TextStyle(
          color: Colors.lightGreenAccent,
          fontSize: 20,
          fontWeight: FontWeight.w600, // bold
        ),
      ),
      SizedBox(height: 100,),
      InkWell(
          onTap: () async {
            await Provider.of<GoogleSignInController>
              (context, listen: false).login(context);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(title: 'SuChip'),
              ),
            );
          },
          child: SizedBox(
            width: 250 * (MediaQuery.of(context).size.width/392),
            child: Image.asset('assets/images/google_signin.png'),
          )
      ),
      SizedBox(height: 5,),
      InkWell(
          onTap: () async {
            await Provider.of<KakaoSignInController>
              (context, listen: false).login(context);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(title: 'SuChip'),
              ),
            );
          },
          child: SizedBox(
            width: 250 * (MediaQuery.of(context).size.width/392),
            child: Image.asset('assets/images/kakao_login_medium_wide.png'),
          )
      ),
      const Divider(
        height: 30,
        color: Colors.grey,
        thickness: 0.5,
        indent: 30.0,
        endIndent: 30.0,
      ),
      TextButton(
        onPressed: () async {
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const MyHomePage(title: 'SuChip'),
            ),
          );
        },
        child: const Text(
          '익명으로 먼저 즐기기',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w600, // bold
          ),
        ),
      ),
    ],
  );
}
issuccess(BuildContext context) async {
  String? userInfo = "", userInfo2 = "";
  final storage = FlutterSecureStorage();
  userInfo = await storage.read(
      key: "google_login"
  );
  userInfo2 = await storage.read(
      key: "kakao_login"
  );
  if (userInfo != null && userInfo2 == null) {
    return userInfo;
  } else if (userInfo2 != null && userInfo == null) {
    return userInfo2;
  } else {
    return userInfo;
  }
}
