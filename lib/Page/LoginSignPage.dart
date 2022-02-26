import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Sub/LoginPage.dart';
import '../route.dart';


class LoginSignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginSignPageState();
}

class _LoginSignPageState extends State<LoginSignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          color: Colors.white,
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
        Container(
            child : Center(
                child : Column(
                    children : <Widget>[
                      LoginIsSuccessed(context)
                    ]
                )
            )
        ),
      ],
    ),

  );
}
LoginIsSuccessed(BuildContext context) {
  FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData == false) {
        return const LoginPlus();
      }
      else {
        String name = snapshot.data.toString().split("/")[1];
        String email = snapshot.data.toString().split("/")[3];

        return success(name, email, context);
      }
    },
    future: issuccess(context),
  );
}
// 사용자 선택 부분(소셜 로그인)
class LoginPlus extends StatelessWidget {
  const LoginPlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          const Text(
            'SuChip Login',
            style: TextStyle(
              color: Colors.indigoAccent,
              fontSize: 30,
              fontWeight: FontWeight.w600, // bold
            ),
          ),
          SizedBox(height: 100,),
          InkWell(
            onTap: () async {
              await Provider.of<GoogleSignInController>
                (context, listen: false).login(context);
              await LoginIsSuccessed(context);
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
              await LoginIsSuccessed(context);
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
      ),
    );
  }
}