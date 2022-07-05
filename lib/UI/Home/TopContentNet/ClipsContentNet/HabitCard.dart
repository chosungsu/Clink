import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/TopContentNet/ClipsContentNet/TodayChoiceFeed.dart';
import 'package:clickbyme/UI/Home/TopContentNet/DayContentHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class HabitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(3, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                index == 0
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: DayContentHome()),
                          );
                        },
                        child: Column(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topCenter,
                                width: 30,
                                height: 30,
                                child: NeumorphicIcon(
                                  Icons.alt_route,
                                  size: 25,
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      color: Colors.black45,
                                      lightSource: LightSource.topLeft),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  child: const Center(
                                    child: Text('선택의 순간',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: TodayChoiceFeed()),
                          );
                        },
                        child: Column(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                child: NeumorphicIcon(
                                  Icons.psychology,
                                  size: 25,
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 2,
                                      color: Colors.black45,
                                      lightSource: LightSource.topLeft),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  child: const Center(
                                    child: Text('성공한 마인드',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
              ],
            );
          }),
        )));
  }
}
