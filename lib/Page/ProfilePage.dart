import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';

import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Sub/HowToUsePage.dart';
import '../UI/AfterSignUp.dart';
import '../UI/BeforeSignUp.dart';
import '../Tool/NoBehavior.dart';


class ProfilePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  bool login_state = false;
  String name = "null", email = "null";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          checkId(context);
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ProfileBody(context),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await destroyBackKey(context)) ?? false;
  }
}
checkId(BuildContext context) async {
  String? userInfo = "", userInfo2 = "";
  const storage = FlutterSecureStorage();
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
Widget ProfileBody(BuildContext context) {
  final List<String> list_title = <String>[
    '이용안내', '문의하기', 'Pro 버전 구매', '기본값 설정', '회원탈퇴'
  ];
  String name = "", email = "", cnt = "";
  return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ScrollConfiguration(
          behavior: NoBehavior(),
          child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                          child: const Text(
                            '내 정보',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData == false) {
                              return showBeforeSignUp(context);
                            }
                            else {
                              name = snapshot.data.toString().split("/")[1];
                              email = snapshot.data.toString().split("/")[3];
                              cnt = snapshot.data.toString().split("/")[5];
                              return showAfterSignUp(
                                  name,
                                  email,
                                  cnt,
                                  context
                              );
                            }
                          },
                          future: checkId(context),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                          child: const Text(
                            '부가기능',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Card(
                          color: const Color(0xffd3f1ff),
                          elevation: 4.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                                child: ListView.separated(
                                  //physics : 스크롤 막기 기능
                                  //shrinkWrap : 리스트뷰 오버플로우 방지
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: list_title.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          child: Text(
                                              '${list_title[index]}'
                                          ),
                                          onTap: () {
                                            if (index == 0) {
                                              //이용안내페이지 호출
                                              Navigator.push(
                                                  context,
                                                  Transition(
                                                      child: HowToUsePage(),
                                                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                                                  )
                                              );
                                            } else if (index == 1) {

                                            } else if (index == 2) {

                                            } else if (index == 3) {

                                            } else  {
                                              //회원탈퇴 바텀시트 호출
                                              if (name != "" && email != "") {
                                                DeleteUserVerify(context, name);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('알림'),
                                                    content: const Text('회원님께서는 현재 미로그인 상태로\n'
                                                        '로그아웃 기능은 사용불가하시며\n'
                                                        '이 기능은 로그인 후 탈퇴 시 사용가능합니다.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, false),
                                                        child: const Text('알겠습니다.'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        )
                                    );
                                  },
                                  separatorBuilder: (
                                      BuildContext context, int index
                                      ) => const Divider(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ]
              )
          ),
        );
      });
}

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(context: context, builder: (BuildContext context) {
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
              '회원탈퇴',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '회원탈퇴 진행하겠습니까?\n'
                  '아래 버튼을 클릭하시면 회원탈퇴처리가 완료됩니다.\n'
                  '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //탈퇴 로직 구현
                Navigator.popUntil(
                    context,
                        (route) => route.isFirst
                );
                Provider.of<GoogleSignInController>
                  (context, listen: false).logout(context, name);
                Provider.of<KakaoSignInController>
                  (context, listen: false).logout(context, name);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0
              ),
              child: const Text(
                '탈퇴하기',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
            ),
          ]
      ),
    );
  });
}