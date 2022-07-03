import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/TopContentNet/TodayChoiceFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Page/EnterCheckPage.dart';

class SpaceAD extends StatelessWidget {
  final List eventtitle = [
    '출석체크 이벤트',
    '룰렛 이벤트',
    '모어 스페이스 이벤트',
  ];
  final List eventcontent = [
    '메모리북 작성권과 하루분석결과 열람권을 드립니다. 지금 즉시 바로가기를 눌러 확인해보세요!',
    '룰렛을 돌려 AI건강지킴 사용포인트를 꽝 없이 획득해보세요!',
    '광고제거 시 스페이스를 4개 더 드립니다. 지금 즉시 확인해보세요!',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            child: GestureDetector(
          onTap: () {
            //타일변경으로 넘어가기
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: EnterCheckPage()),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eventtitle[2].toString(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text(eventcontent[2].toString(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
        )));
  }
}
