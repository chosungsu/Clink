import 'package:carousel_slider/carousel_slider.dart';
import 'package:clickbyme/Page/EnterCheckPage.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TodayRoadView extends StatelessWidget {
  TodayRoadView({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;

  final List eventtitle = [
    '메모 길라잡이',
    '퀵URLs 길라잡이',
    '갓생루틴 길라잡이',
  ];
  final List eventcontent = [
    '메모를 작성하실 때 주제별로 정리하시면 편하게 찾으실 수 있습니다.',
    '퀵URLs에는 사용자분께서 나중에도 찾아보실 유용한 사이트링크를 주제별로 기록해두시기 바랍니다.',
    '현시대를 살아가는 사람들은 일정하고 스텝업이 가능한 루틴생성이 필요합니다. 루틴을 지키며 열리게 될 새로운 삶으로 저희가 이끌어 드리겠습니다.',
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
                                          NeumorphicIcon(
                                            Icons.help_outline,
                                            size: 25,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
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
                                      height: 150,
                                      child: Text(
                                          eventcontent[index].toString(),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                  ],
                                )),
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
