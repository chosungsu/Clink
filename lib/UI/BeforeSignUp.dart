import 'dart:ui';
import 'package:clickbyme/Page/LoginSignPage.dart';
import 'package:flutter/material.dart';

import '../Sub/EcoproPage.dart';
import '../Sub/showUserSetting.dart';


showBeforeSignUp(BuildContext context) {
  //아래 변수들은 회원가입 완료한 유저분들에게 선보이는 Aindrop의 서비스목록이다.
  final List<String> itemPro = ['캠페인 참여', '구독 정보', '마이룸'];
  final List<String> itemImg = ['assets/images/eye-scanner.png', 'assets/images/eye-scanner.png', 'assets/images/eye-scanner.png'];

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
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '로그인이 필요합니다.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black54,
                          letterSpacing: 2
                      ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)
                            => LoginSignPage()
                        ),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            '3초 로그인',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.amberAccent,
                                letterSpacing: 2
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_sharp),
                        ],
                      ),
                    )
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
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '로그인을 하시면 이용가능하십니다.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                          letterSpacing: 2
                      ),
                    ),
                  ],
                ),
              ),
          ),
          Divider(
            height: 0,
            color: Colors.grey,
            thickness: 0.5,
          ),
          Flexible(
            flex: 2,
            child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
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
          ),
        ],
      ),
    ),
  );
}