import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../Tool/NoBehavior.dart';

class EnterCheckPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnterCheckPageState();
}

class _EnterCheckPageState extends State<EnterCheckPage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: EnterCheckUi(),
    ));
  }

  EnterCheckUi() {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                        width: 50,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              child: NeumorphicIcon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: Colors.black45,
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '출석체크 이벤트',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.85,
                child: ScrollConfiguration(
                  behavior: NoBehavior(),
                  child: SingleChildScrollView(child:
                      StatefulBuilder(builder: (_, StateSetter setState) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PosterView(height),
                          CheckSystem(height),
                        ],
                      ),
                    );
                  })),
                ),
              )
            ],
          )),
    );
  }

  CheckSystem(double height) {
    return SizedBox(
      height: height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onHorizontalDragUpdate: (event) async {
              if (event.primaryDelta! > 10) {
                _incTansXVal();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                paymentSuccessful(),
                myWidth == 0.0
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "화살표를 우측으로 끌고 오세요",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.00),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget paymentSuccessful() => Transform.translate(
        offset: Offset(translateX, translateY),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
          width: 30 + myWidth,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.00),
            color: Colors.blue,
          ),
          child: myWidth > 0.0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                    Flexible(
                      child: Text(
                        " 출석체크 완료 ",
                        style: TextStyle(color: Colors.white, fontSize: 20.00),
                      ),
                    ),
                  ],
                )
              : Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 30.00,
                ),
        ),
      );

  _incTansXVal() async {
    int canLoop = -1;
    for (var i = 0; canLoop == -1; i++)
      await Future.delayed(Duration(milliseconds: 1), () {
        setState(() {
          if (translateX + 1 <
              MediaQuery.of(context).size.width - (200 + myWidth)) {
            translateX += 1;
            myWidth = MediaQuery.of(context).size.width - (200 + myWidth);
          } else {
            canLoop = 1;
          }
        });
      });
  }
}

PosterView(double height) {
  return SizedBox(
    height: height * 0.6,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        EnterCheckEvents(height: height),
      ],
    ),
  );
}
