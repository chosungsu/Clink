import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SizedBox(
        height: height * 0.7,
        child: Row(
          children: [
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    flex: 3,
                    child: ContainerDesign(
                        child: GestureDetector(
                      onTap: () {
                        //일정관리로 넘어가기
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            child: const Center(
                              child: Text('Head1',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          SizedBox(
                            height: height * 0.03,
                            child: const Center(
                              child: Text('Text1',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: height * 0.03,
                            height: height * 0.03,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: NeumorphicIcon(
                              Icons.navigate_next,
                              size: height * 0.03,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                            ),
                          )
                        ],
                      ),
                    ))),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                    flex: 2,
                    child: ContainerDesign(
                        child: GestureDetector(
                      onTap: () {
                        //대중교통 홈으로 넘어가기
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            child: const Center(
                              child: Text('Head2',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: height * 0.03,
                            height: height * 0.03,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: NeumorphicIcon(
                              Icons.navigate_next,
                              size: height * 0.03,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                            ),
                          )
                        ],
                      ),
                    ))),
              ],
            )),
            SizedBox(
              width: 20,
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    flex: 2,
                    child: ContainerDesign(
                        child: GestureDetector(
                      onTap: () {
                        //건강관리로 넘어가기
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            child: const Center(
                              child: Text('Head3',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: height * 0.03,
                            height: height * 0.03,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: NeumorphicIcon(
                              Icons.navigate_next,
                              size: height * 0.03,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                            ),
                          )
                        ],
                      ),
                    ))),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                    flex: 3,
                    child: ContainerDesign(
                        child: GestureDetector(
                      onTap: () {
                        //메모리 북으로 넘어가기
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                            child: const Center(
                              child: Text('Head4',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          SizedBox(
                            height: height * 0.05,
                            child: const Center(
                              child: Text('Text4',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: height * 0.03,
                            height: height * 0.03,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: NeumorphicIcon(
                              Icons.navigate_next,
                              size: height * 0.03,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                            ),
                          )
                        ],
                      ),
                    ))),
              ],
            )),
          ],
        ),
      ),
    );
  }
}