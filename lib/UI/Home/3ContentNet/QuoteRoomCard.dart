import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/2ContentNet/DayContentHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class QuoteRoomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: Column(
          children: [
            SizedBox(
              height: 20,
              child: Container(
                alignment: Alignment.topLeft,
                child: NeumorphicIcon(
                  Icons.format_quote,
                  size: 20,
                  style: const NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 2,
                      color: Colors.black45,
                      lightSource: LightSource.topLeft),
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: Center(
                child: Text('이 공간은 매일 아침 6시에 추천드리는 인용문이 뜨게 됩니다.',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
            SizedBox(
              height: 20,
              child: Container(
                alignment: Alignment.topRight,
                child: NeumorphicIcon(
                  Icons.format_quote,
                  size: 20,
                  style: const NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 2,
                      color: Colors.black45,
                      lightSource: LightSource.topLeft),
                ),
              ),
            ),
          ],
        )));
  }
}
