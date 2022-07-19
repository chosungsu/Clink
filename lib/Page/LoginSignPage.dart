import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Dialogs/destroyBackKey.dart';
import '../route.dart';

class LoginSignPage extends StatefulWidget {
  const LoginSignPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginSignPageState();
}

class _LoginSignPageState extends State<LoginSignPage> {
  bool _ischecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            makeBody(context, _ischecked),
            const Divider(
              height: 30,
              color: Colors.grey,
              thickness: 0.5,
              indent: 30.0,
              endIndent: 30.0,
            ),
            const Text(
              '동의항목',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold, // bold
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: _ischecked,
                        onChanged: (value) {
                          setState(() {
                            _ischecked = value!;
                          });
                        }),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Row(
                          children: const [
                            Text(
                              '(선택)자동 로그인 사용',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black,
                                  letterSpacing: 2),
                            ),
                          ],
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, bool ischecked) {
  double height =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: height * 0.75,
          child: LoginPlus(context, ischecked, height),
        ),
      ],
    ),
  );
}

LoginPlus(BuildContext context, bool ischecked, double height) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        '간단 소셜 로그인',
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 20,
          fontWeight: FontWeight.w600, // bold
        ),
      ),
      SizedBox(
        height: height * 0.25,
      ),
      InkWell(
          onTap: () async {
            await Provider.of<GoogleSignInController>(context, listen: false)
                .login(context, ischecked);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(
                  index: 0,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 200 * (MediaQuery.of(context).size.width / 392),
            height: 50,
            child: Image.asset(
              'assets/images/google_signin.png',
              fit: BoxFit.fitWidth,
            ),
          )),
      const SizedBox(
        height: 10,
      ),
      InkWell(
          onTap: () async {
            await Provider.of<KakaoSignInController>(context, listen: false)
                .login(context, ischecked);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(
                  index: 0,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 200 * (MediaQuery.of(context).size.width / 392),
            height: 50,
            child: Image.asset(
              'assets/images/kakao_login_medium_wide.png',
              fit: BoxFit.fitWidth,
            ),
          )),
    ],
  );
}
