import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Sub/EcoproPage.dart';
import '../Sub/showUserSetting.dart';

showAfterSignUp(String name, String email, String whatlogin, BuildContext context) {

  //아래 변수들은 회원가입 완료한 유저분들에게 선보이는 Aindrop의 서비스목록이다.
  final List<String> itemPro = ['캠페인 참여', '구독 정보', '마이룸'];
  final List<String> itemImg = ['assets/images/eye-scanner.png', 'assets/images/eye-scanner.png', 'assets/images/eye-scanner.png'];
  var logged = "";

  switch(whatlogin) {
    case "1" :
      logged = "Google 유저인증";
      break;
    case "2" :
      logged = "카카오 유저인증";
      break;
  }
  return Card(
    color: const Color(0xffd3f1ff),
    elevation: 4.0,
    child: Container(
      //너비는 최대너비로 생성, 높이는 자식개체만큼으로 후에 변경할것임.
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {

              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                        child: Row(
                          children: [
                            new Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                  letterSpacing: 2
                              ),
                            ),
                            const Text(
                              '님 안녕하세요',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                  letterSpacing: 2
                              ),
                            ),
                          ],
                        )
                    ),
                    Icon(
                        Icons.arrow_forward_ios
                    ),
                  ],
                ),
              )
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey,
            thickness: 0.5,
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          const Text(
                            '현재 등급',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black45,
                                letterSpacing: 2
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                              width: 80,
                              child: Card(
                                  color: Colors.lightGreenAccent.withOpacity(0.8),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(width: 0.5, color: Colors.white24),
                                  ),
                                  child: const Center(
                                      child: Text(
                                        '방문자',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15,
                                            color: Colors.black,
                                            letterSpacing: 2
                                        ),
                                      ),
                                  )
                              )
                          )
                        ],
                      ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white24.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                    ),
                    onPressed: () {

                    },
                    child: Text(
                      '등급별 혜택',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.black,
                          letterSpacing: 2
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          Divider(
            height: 0,
            color: Colors.grey,
            thickness: 0.5,
          ),
          Flexible(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)
                                  => EcoproPage()
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                itemImg[0],
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                itemPro[0],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Image.asset(
                                itemImg[1],
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                itemPro[1],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)
                                  => showUserSetting(name : name, email : email)
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                itemImg[2],
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                itemPro[2],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),

        ],
      ),
    ),
  );
}