import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserView extends StatelessWidget {
  UserView({Key? key, required this.height}) : super(key: key);
  final double height;
  final List<String> combilist = [
    '김영헌',
    '최우성',
    '이제민',
    '송하원',
    '이선기',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height * 0.1,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: ((context, index) {
                  return Row(
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: index == 0
                              ? Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: ContainerDesign(
                                    child: SizedBox(
                                      height: height * 0.08,
                                      width: height * 0.08,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SizedBox(
                                            height: height * 0.08,
                                            width: height * 0.08,
                                            child: NeumorphicIcon(
                                              Icons.add,
                                              size: height * 0.08,
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  depth: 2,
                                                  color: Colors.grey.shade300,
                                                  lightSource:
                                                      LightSource.topLeft),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  child: ContainerDesign(
                                      child: SizedBox(
                                    height: height * 0.08,
                                    width: height * 0.08,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          height: height * 0.08,
                                          width: height * 0.08,
                                          child: Text(combilist[index - 1],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ),
                                      ],
                                    ),
                                  )),
                                ))
                    ],
                  );
                }))));
  }
}
