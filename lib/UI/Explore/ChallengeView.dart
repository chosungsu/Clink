import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ChallengeView extends StatelessWidget {
  ChallengeView({Key? key, required this.height}) : super(key: key);
  final double height;
  final List<String> titlelist = [
    'HeadLine1',
    'HeadLine2',
    'HeadLine3',
    'HeadLine4',
    'HeadLine5',
  ];
  final List<String> contextlist = [
    '여기에 내용1이 보여집니다.',
    '여기에 내용2이 보여집니다.',
    '여기에 내용3이 보여집니다.',
    '여기에 내용4이 보여집니다.',
    '여기에 내용5이 보여집니다.',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.9,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: titlelist.length,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ContainerDesign(
                      child: SizedBox(
                    height: height * 0.1,
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
                              Text(titlelist[index],
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
                          child: Text(contextlist[index],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            );
          })),
    );
  }
}
