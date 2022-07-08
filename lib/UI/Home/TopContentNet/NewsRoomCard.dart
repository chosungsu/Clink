import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/TopContentNet/DayContentHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class NewsRoomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          childAspectRatio: 2 / 1,
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
                        child: SizedBox(
                          height: 50,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  width: 25,
                                  height: 25,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: NeumorphicIcon(
                                      Icons.newspaper,
                                      size: 25,
                                      style: const NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          depth: 2,
                                          color: Colors.black45,
                                          lightSource: LightSource.topLeft),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: Center(
                                  child: Text('IT',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : (index == 1
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: DayContentHome()),
                              );
                            },
                            child: SizedBox(
                              height: 50,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      width: 25,
                                      height: 25,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.newspaper,
                                          size: 25,
                                          style: const NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: Text('World',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: DayContentHome()),
                              );
                            },
                            child: SizedBox(
                              height: 50,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      width: 25,
                                      height: 25,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.newspaper,
                                          size: 25,
                                          style: const NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: Colors.black45,
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: Text('기타',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
              ],
            );
          }),
        )));
  }
}
