import 'package:clickbyme/DB/User_Info.dart';
import 'package:flutter/material.dart';

import '../Page/ProfilePage.dart';
import '../Tool/NoBehavior.dart';


class showUserSetting extends StatefulWidget {
  const showUserSetting({Key? key,
    required this.name, required this.email, required this.login})
      : super(key: key);
  final String name, email, login;

  @override
  State<StatefulWidget> createState() => _showUserSettingState();
}

class _showUserSettingState extends State<showUserSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black54,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
            widget.name + '님의 Room',
            style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            makeBody(context, widget.name, widget.login)
          ],
        )
      ),
    );
  }
}
// 바디 만들기
Widget makeBody(BuildContext context, String name, String login) {
  final List<User_Info> list_user_info = [
    User_Info(
      title: '방문자',
    ),
    User_Info(
      title: '프로',
    ),
    User_Info(
      title: '스페셜리스트',
    ),
  ];
  return ScrollConfiguration(
    behavior: NoBehavior(),
    child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          First(context, name, login),
          Second(context),
        ],
      ),
    ),
  );
}
First(BuildContext context, String name, String login) {
  return Column(
    children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15,
          ),
          child: Row(
            children: const [
              Icon(
                  Icons.face
              ),
              SizedBox(width: 10,),
              Text(
                '나의 프로필',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black45,
                    letterSpacing: 2
                ),
              ),
            ],
          )
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이름(닉네임) : ' + name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black45,
                        letterSpacing: 2
                    ),
                  ),
                  Divider(),
                  Text(
                    '로그인 인증 : ' + login,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black45,
                        letterSpacing: 2
                    ),
                  ),
                  Divider(),
                  InkWell(
                      child: Row(
                        children: const [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '회원탈퇴하기',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black45,
                                  letterSpacing: 2
                              ),
                            ),
                          ),
                          Icon(
                              Icons.arrow_forward
                          ),
                        ],
                      ),
                      onTap: () {
                        //탈퇴 바텀시트로 이동
                        DeleteUserVerify(context, name);
                      }
                  )
                ],
              )
          ),
        ),
      ),
    ],
  );
}
Second(BuildContext context) {
  return Column(
    children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15,
          ),
          child: Row(
            children: const [
              Icon(
                  Icons.trending_up
              ),
              SizedBox(width: 10,),
              Text(
                '현재 등급',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black45,
                    letterSpacing: 2
                ),
              ),
            ],
          )
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '등급 : ' + '방문자',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black45,
                        letterSpacing: 2
                    ),
                  ),
                  Divider(),
                  InkWell(
                      child: Row(
                        children: const [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              '등급 변경하기',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black45,
                                  letterSpacing: 2
                              ),
                            ),
                          ),
                          Icon(
                              Icons.arrow_forward
                          ),
                        ],
                      ),
                      onTap: () {
                        //결제페이지로 이동
                      }
                  )
                ],
              )
          ),
        ),
      ),
    ],
  );
}