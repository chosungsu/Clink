import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import '../../Sub/showUserSetting.dart';

showAfterSignUp(
    String name, String email, String whatlogin, BuildContext context) {
  var logged = "";

  switch (whatlogin) {
    case "1":
      logged = "Google 유저인증";
      break;
    case "2":
      logged = "카카오 유저인증";
      break;
  }
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        depth: 4,
        intensity: 0.5,
        color: Colors.white.withOpacity(0.1),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.orange,
          ),
          borderRadius: BorderRadius.circular(16.0)
        ),
        //너비는 최대너비로 생성, 높이는 자식개체만큼으로 후에 변경할것임.
        height: 80,
        child: Center(
          //crossAxisAlignment: CrossAxisAlignment.start,
          child: InkWell(
              onTap: () {
                //개인정보 페이지로 이동
                Navigator.push(
                    context,
                    PageTransition(
                        child: showUserSetting(
                            name: name, email: email, login: logged),
                        type: PageTransitionType.leftToRightWithFade));
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
                                  letterSpacing: 2),
                            ),
                            const Text(
                              '님 안녕하세요',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey,
                                  letterSpacing: 2),
                            ),
                          ],
                        )),
                    NeumorphicIcon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: Colors.deepPurpleAccent.shade100,
                          lightSource: LightSource.topLeft),
                    ),
                  ],
                ),
              )),
        ),
      ),
    ),
  );
}
