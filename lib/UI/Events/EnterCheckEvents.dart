import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class EnterCheckEvents extends StatelessWidget {
  const EnterCheckEvents({Key? key, required this.height}) : super(key: key);
  final double height;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ContainerDesign(
            color: Colors.yellow.shade400,
            child: SizedBox(
          height: height * 0.5,
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
                height: height * 0.3,
                child: Text(
                    '아래 스크롤바를 우측으로 밀어서 출석체크를 하시면 ' +
                        '메모리북 작성권과 하루분석결과 열람권을 드립니다.',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: height * 0.10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(
                    '이벤트 기간 : 2022/06/01 ~ 2022/06/30',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                    )
                  ],
                )
              ),
            ],
          ),
        )));
  }
}
