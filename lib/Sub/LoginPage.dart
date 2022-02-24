import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          issuccess(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          issuccess(context);
        });
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('로그인', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: makeBody(
              context
          ),
        ),
      ),
    );

  }

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

// 바디 만들기
Widget makeBody(BuildContext context) {

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child : Center(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return const SocialLogin();
                    }
                    else {
                      String name = snapshot.data.toString().split("/")[1];
                      String email = snapshot.data.toString().split("/")[3];

                      return success(name, email, context);
                    }
                  },
                  future: issuccess(context),
                ),
              ],
            ),
          )
        ),
      ],
    ),

  );
}
Timer timer(BuildContext context) {
  Timer? _time = Timer(const Duration(seconds: 3), (){
    if (Navigator?.canPop(context)) {
      Navigator.pop(context);
    } else {
    }
  });
  return _time;
}
success(String name, String email, BuildContext context){
  timer(context);
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2// bold
              ),
            ),
            const Text(
              '님',
              style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 3// bold
              ),
            ),
          ],
        ),
        const Text(
          '로그인이 정상적으로 완료되었습니다 :)',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        ),
        const SpinKitFadingCircle(
          color: Colors.greenAccent,
        ),
        const Text(
          '약 3초 후 메인화면으로 이동합니다.\n잠시만 기다려주세요~',
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 2// bold
          ),
        ),

      ],
    ),
  );
}
// 사용자 선택 부분(소셜 로그인)
class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    loginControll(BuildContext context) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {

              return Container(
                height: 180,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                child: Column(
                    children: [
                      const Text(
                        '소셜 로그인',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22,
                          fontWeight: FontWeight.w600, // bold
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(
                        bottom: 30,
                      )),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await Provider.of<GoogleSignInController>
                                  (context, listen: false).login(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0
                              ),
                              child: const Text(
                                '구글 로그인',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await Provider.of<KakaoSignInController>
                                  (context, listen: false).login(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amberAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0
                              ),
                              child: const Text(
                                '카톡 로그인',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    ]
                ),
              );
            });
      });
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              side: const BorderSide(
                  color: Colors.black12,
                  width: 2.0
              ),
              minimumSize: const Size(300, 50),
            ),
            child: const Center(
              child: Text(
                '소셜 로그인을 통해 가입하기',
                style: TextStyle(
                  backgroundColor: Colors.transparent,
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
            ),
            onPressed: () => {
              //loginUI(),
              loginControll(context),
            },
          ),
        ],
      ),
    );
  }
}
