import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/TodayChoiceFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import 'DayContentHome.dart';

class YourDayfulAd extends StatelessWidget {
  const YourDayfulAd({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width - 40,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: DayContentHome()),
              );
            },
            child: ContainerDesign(
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: ContainerDesign(
                                  child: GestureDetector(
                                onTap: () {
                                  //일정관리로 넘어가기
                                },
                                child: Stack(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text('맑음/25도/서울',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ],
                                        )),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: NeumorphicIcon(
                                          Icons.sunny,
                                          size: 15,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: ContainerDesign(
                                  child: GestureDetector(
                                onTap: () {
                                  //대중교통 홈으로 넘어가기
                                },
                                child: Stack(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text('2500걸음',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ],
                                        )),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: NeumorphicIcon(
                                          Icons.directions_walk,
                                          size: 15,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: ContainerDesign(
                                  child: GestureDetector(
                                onTap: () {
                                  //일정관리로 넘어가기
                                },
                                child: Stack(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '이렇게 해보시는 건 어떠세요?',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: NeumorphicIcon(
                                          Icons.bookmark,
                                          size: 15,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: ContainerDesign(
                                  child: GestureDetector(
                                onTap: () {
                                  //대중교통 홈으로 넘어가기
                                },
                                child: Stack(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '친구 만나기',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: NeumorphicIcon(
                                          Icons.calendar_today,
                                          size: 15,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                        ],
                      )),
                ],
              ),
            )));
  }
}
