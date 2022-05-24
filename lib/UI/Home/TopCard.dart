import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class TopCard extends StatelessWidget {
  const TopCard({Key? key, required this.height}) : super(key: key);
  final double height;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ContainerDesign(
            child: SizedBox(
          height: height * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: height * 0.05,
                child: Row(
                  children: [
                    NeumorphicIcon(
                      Icons.confirmation_number,
                      size: 25,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: Colors.black45,
                          lightSource: LightSource.topLeft),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('출석체크로 일상을 시작해보세요 :)',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: height * 0.1,
                child: Text(
                    '아래 스크롤바를 우측으로 밀어서 출석체크를 하시면 '+
                    '메모리북 작성권과 하루분석결과 열람권을 드립니다.',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                height: height * 0.05,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: EnterCheckPage()),
                      );
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '바로가기',
                              style: const NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: Colors.white,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        )));
  }
}
