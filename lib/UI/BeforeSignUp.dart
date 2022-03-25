import 'package:clickbyme/Page/LoginSignPage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

showBeforeSignUp(BuildContext context) {

  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
          depth: 4,
          intensity: 0.5,
          color: Colors.white.withOpacity(0.1),
          lightSource: LightSource.topLeft),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.orange,
          ),
          borderRadius: BorderRadius.circular(16.0)
        ),
        //너비는 최대너비로 생성, 높이는 자식개체만큼으로 후에 변경할것임.
        width: MediaQuery.of(context).size.width * 0.95,
        height: 100,
        child: Center(
            //crossAxisAlignment: CrossAxisAlignment.start,
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: Text(
                  '로그인이 필요합니다.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black54,
                      letterSpacing: 2),
                ),
              ),
              SizedBox(
                  height: 40,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10.0)),
                        depth: 4,
                        intensity: 0.5,),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: LoginSignPage(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
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
                                    letterSpacing: 2),
                              ),
                              Icon(Icons.arrow_forward_ios_sharp),
                            ],
                          ),
                        )),
                  ))
            ],
          ),
        )),
      ),
    ),
  );
}
