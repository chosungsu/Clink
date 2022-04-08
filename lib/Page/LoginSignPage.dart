import 'package:flutter/material.dart';
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
  bool _ischecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          makeBody(context, _ischecked),
          const Text(
            '자동 로그인',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold, // bold
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: _ischecked,
                  onChanged: (value) {
                    setState(() {
                      _ischecked = value!;
                    });
                  }),
              _ischecked != false
                  ? const Text(
                      '자동 로그인 on',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // bold
                      ),
                    )
                  : const Text(
                      '자동 로그인 off',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // bold
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}

// 바디 만들기
Widget makeBody(BuildContext context, bool ischecked) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(child: LoginPlus(context, ischecked)),
        const Divider(
            height: 30,
            color: Colors.grey,
            thickness: 0.5,
            indent: 30.0,
            endIndent: 30.0,
          ),
      ],
    ),
  );
}

LoginPlus(BuildContext context, bool ischecked) {
  return Column(
    children: [
      const Text(
        '바쁜 일상 속 여유로운 티타임처럼\n'
        '모든 것들을 한 곳에서\n'
        '조각조각 즐길 수 있는 StormDot입니다.',
        style: TextStyle(
          color: Colors.lightGreenAccent,
          fontSize: 20,
          fontWeight: FontWeight.w600, // bold
        ),
      ),
      const SizedBox(
        height: 100,
      ),
      InkWell(
          onTap: () async {
            await Provider.of<GoogleSignInController>(context, listen: false)
                .login(context, ischecked);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(title: 'StormDot', index: 0,),
              ),
            );
          },
          child: SizedBox(
            width: 250 * (MediaQuery.of(context).size.width / 392),
            child: Image.asset('assets/images/google_signin.png'),
          )),
      const SizedBox(
        height: 5,
      ),
      InkWell(
          onTap: () async {
            await Provider.of<KakaoSignInController>(context, listen: false)
                .login(context, ischecked);
            await Navigator.of(context).pushReplacement(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const MyHomePage(title: 'StormDot', index: 0,),
              ),
            );
          },
          child: SizedBox(
            width: 250 * (MediaQuery.of(context).size.width / 392),
            child: Image.asset('assets/images/kakao_login_medium_wide.png'),
          )),
    ],
  );
}
