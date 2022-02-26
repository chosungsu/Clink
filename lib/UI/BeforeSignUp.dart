import 'dart:ui';
import 'package:clickbyme/Page/LoginSignPage.dart';
import 'package:flutter/material.dart';


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
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
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
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)
                            => LoginSignPage()
                        ),
                      );},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '3초 로그인',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.amberAccent,
                              letterSpacing: 2
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_sharp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  '로그인을 하시면 이용가능하십니다.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 2
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child : Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
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
                        Column(
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
                        Column(
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
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    ),
  );
}