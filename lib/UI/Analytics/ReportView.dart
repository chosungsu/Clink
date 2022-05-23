import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ReportView extends StatelessWidget {
  const ReportView({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Flexible(
          fit: FlexFit.tight,
          child: ContainerDesign(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height * 0.05,
                  child: Row(
                    children: [
                      NeumorphicIcon(
                        Icons.task_alt_outlined,
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
                      Text('오늘의 걸음 수',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.03,
                  child: Text('8800보 걸으셨습니다.',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              ],
            ),
          )),
    );
  }
}
