import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/firstContentNet/ChooseCalendar.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/RoutineHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import 'DayContentHome.dart';

class TopCard extends StatelessWidget {
  const TopCard({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: BGColor(),
            child: Column(
              children: [
                //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                SizedBox(
                    height: 60,
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
                                      /*Get.to(
                                        () => DayContentHome(),
                                        transition: Transition.rightToLeft,
                                      );*/
                                      Get.off(
                                        () => ChooseCalendar(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: SizedBox(
                                      height: 55,
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
                                                  Icons.calendar_month,
                                                  size: 25,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      color: TextColor(),
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Center(
                                              child: Text('캘린더',
                                                  style: TextStyle(
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize())),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : (index == 1
                                    ? GestureDetector(
                                        onTap: () {
                                          /*Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: DayNoteHome()),
                                      );*/
                                          Get.off(
                                            () => DayNoteHome(
                                              title: '',
                                            ),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: SizedBox(
                                          height: 55,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                child: Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  width: 25,
                                                  height: 25,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons.description,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                child: Center(
                                                  child: Text('일상메모',
                                                      style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          /*Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: RoutineHome()),
                                      );*/
                                          Get.off(
                                            () => RoutineHome(),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: SizedBox(
                                            height: 55,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 25,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 25,
                                                    height: 25,
                                                    child: NeumorphicIcon(
                                                      Icons.add_task,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text('갓생루틴',
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                  ),
                                                ),
                                              ],
                                            ))))
                          ],
                        );
                      }),
                    ))
              ],
            )));
  }
}
