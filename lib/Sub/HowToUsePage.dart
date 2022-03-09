import 'package:clickbyme/DB/User_Info.dart';
import 'package:flutter/material.dart';

import '../Page/ProfilePage.dart';
import '../Tool/NoBehavior.dart';


class HowToUsePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> {
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
            '이용안내',
            style: TextStyle(color: Colors.blueGrey)),
        elevation: 0,
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              makeBody(context)
            ],
          )
      ),
    );
  }
}
// 바디 만들기
Widget makeBody(BuildContext context) {

  return ScrollConfiguration(
    behavior: NoBehavior(),
    child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          First(context),
        ],
      ),
    ),
  );
}
First(BuildContext context) {
  List _list_permission_title = [
    '파일 접근권한',
  ];
  List _list_permission_content = [
    '포스팅 시 필요한 권한으로 사용자의 파일에 접근하기 위함이다.',
  ];
  return Column(
    children: [
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 15,
          ),
          child: Text(
            'HabitMind 이용 시 허용사항',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black45,
                letterSpacing: 2
            ),
          ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _list_permission_title[0],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 2
                    ),
                  ),
                  Divider(
                    height: 15,
                    indent: 0,
                    endIndent: 0,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  Text(
                    _list_permission_content[0],
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black,
                        letterSpacing: 2
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(
              top: 10, bottom: 10, left: 10, right: 10
          ),
        child: Text(
          '위 허용사항을 하나라도 거부하시면 앱 이용에 어려움이 있을 수 있습니다.',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.red,
              letterSpacing: 2
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
                  Text(
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
                        children: [
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