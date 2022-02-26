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
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.indigo,
                    letterSpacing: 2
                ),
              ),
              const Text(
                '님 안녕하세요',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                    letterSpacing: 2
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.3,
                  color: Colors.orange,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                    Radius.circular(4.0)
                )
            ),
            child: Text(
              logged,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.yellow,
                  letterSpacing: 2
              ),
            ),
          ),
          Center(
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  '사용가능하신 서비스',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 2
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1.3,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Material(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
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