import 'package:clickbyme/Sub/DayLog.dart';
import 'package:clickbyme/Sub/QuickMenuPage.dart';
import 'package:clickbyme/Sub/WritePost.dart';
import 'package:clickbyme/Sub/storepw.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import '../../DB/AD_Home.dart';
import '../../Sub/YourTags.dart';

UserPicks(BuildContext context) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          NeumorphicText(
                            '퀵메뉴',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: Colors.black54,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              PageTransition(
                                  child: QuickMenuPage(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                    },
                    child: NeumorphicIcon(
                      Icons.settings,
                      size: 20,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          color: Colors.deepPurpleAccent.shade100,
                          lightSource: LightSource.topLeft),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Main_Pick(context),
        ],
      ),
    ],
  );
}

Main_Pick(context) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '1',
      title: '데이로그',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '챌린지',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '페이지마크',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '탐색기록',
      person_num: 4,
      date: DateTime.now(),
    ),
  ];
  final List<String> itemImg = [
    'assets/images/date.png',
    'assets/images/challenge.png',
    'assets/images/icon-link.png',
    'assets/images/playlist.png',
  ];
  return SizedBox(
      height: MediaQuery.of(context).size.width / 2 / 3 * 2 + 20,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _list_ad.length,
            /*gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2),*/
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (context, index) {
              return Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      border: NeumorphicBorder(width: 1, color: Colors.grey),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(5)),
                      depth: 5,
                      color: Colors.white,
                      lightSource: LightSource.topLeft),
                  child: InkWell(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: DayLog(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: WritePost(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: YourTags(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                        } else {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: storepw(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              itemImg[index],
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              _list_ad[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      )));
            }),
      ));
}
