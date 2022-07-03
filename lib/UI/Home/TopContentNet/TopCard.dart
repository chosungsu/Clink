import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/TopContentNet/TodayChoiceFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import 'DayContentHome.dart';

class TopCard extends StatelessWidget {
  const TopCard({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
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
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/date.png',
                                    color: Colors.black45,
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  child: const Center(
                                    child: Text('캘린더',
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
                    : (index == 1
                        ? GestureDetector(
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
                                    child: Image.asset(
                                      'assets/images/phrase.png',
                                      color: Colors.black45,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      child: const Center(
                                        child: Text('오늘의클립',
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
                        : GestureDetector(
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
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      'assets/images/book.png',
                                      color: Colors.black45,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      child: const Center(
                                        child: Text('메모리 북',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )))
              ],
            );
          }),
        )));
  }
}
