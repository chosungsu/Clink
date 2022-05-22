import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  FeedCard({Key? key, required this.height}) : super(key: key);
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
    return ListView.builder(
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
          SizedBox(
              height: height * 0.15,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ContainerDesign(
                    child: SizedBox(
                  height: height * 0.15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                        child: Text(titlelist[index],
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
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
              )),
          SizedBox(
            height: height * 0.03,
          ),
        ],
      );
    }));
  }
}
