import 'package:carousel_slider/carousel_slider.dart';
import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/Sub/SettingPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transition/transition.dart';

class EventShowCard extends StatelessWidget {
  EventShowCard({Key? key, required this.height, required this.pageController})
      : super(key: key);
  final double height;
  final PageController pageController;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;

  final List eventtitle = [
    '출석체크 이벤트',
    '룰렛 이벤트',
    '버전 업그레이드 혜택',
  ];
  final List eventcontent = [
    '메모리북 작성권과 하루분석결과 열람권을 드립니다. 지금 즉시 바로가기를 눌러 확인해보세요!',
    '룰렛을 돌려 루틴업그레이드 포인트를 꽝 없이 획득해보세요!',
    '버전 업그레이드 시 잠금된 기능을 해제해드립니다. 지금 즉시 확인해보세요!',
  ];

  @override
  Widget build(BuildContext context) {
    return Flexible(
        fit: FlexFit.tight,
        child: ContainerDesign(
            child: SizedBox(
                height: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 210,
                      child: PageView.builder(
                        itemCount: eventtitle.length,
                        controller: pageController,
                        itemBuilder: (_, index) => Container(
                            child: Column(
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          index == 0
                                              ? NeumorphicIcon(
                                                  Icons.confirmation_number,
                                                  size: 25,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      color: Colors.black45,
                                                      lightSource:
                                                          LightSource.topLeft),
                                                )
                                              : NeumorphicIcon(
                                                  Icons.sports_esports,
                                                  size: 25,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      color: Colors.black45,
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(eventtitle[index].toString(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      height: 80,
                                      child: Text(
                                          eventcontent[index].toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                  ],
                                )),
                            Column(
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 80) *
                                          0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.grey.shade400,
                                          ),
                                          onPressed: () {
                                            //구독관리페이지 호출
                                            Navigator.push(
                                                context,
                                                Transition(
                                                    child: SettingPage(),
                                                    transitionEffect:
                                                        TransitionEffect
                                                            .BOTTOM_TO_TOP));
                                          },
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '바로가기',
                                                    style:
                                                        const NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: Colors.white,
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        )),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          count: eventtitle.length,
                          effect: ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              dotColor: Colors.grey,
                              activeDotColor: Colors.black),
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
