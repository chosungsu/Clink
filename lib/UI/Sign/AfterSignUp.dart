import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import '../../Sub/showUserSetting.dart';
import '../../Tool/ContainerDesign.dart';

showAfterSignUp(String name, String email, String whatlogin,
    BuildContext context, double height) {
  var logged = "";

  switch (whatlogin) {
    case "1":
      logged = "Google 유저인증";
      break;
    case "2":
      logged = "카카오 유저인증";
      break;
  }
  return ContainerDesign(
      child: SizedBox(
    height: height,
    child: Center(
      //crossAxisAlignment: CrossAxisAlignment.start,
      child: InkWell(
        onTap: () {
          //개인정보 페이지로 이동
          Navigator.push(
              context,
              PageTransition(
                  child:
                      showUserSetting(name: name, email: email, login: logged),
                  type: PageTransitionType.leftToRightWithFade));
        },
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
            Container(
              alignment: Alignment.center,
              width: 25,
              height: 25,
              child: NeumorphicIcon(
                Icons.navigate_next,
                size: 20,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    color: Colors.black45,
                    lightSource: LightSource.topLeft),
              ),
            )
          ],
        ),
      ),
    ),
  ));
}
