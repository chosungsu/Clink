import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Day.dart';
import 'package:clickbyme/DB/Recommend.dart';
import 'package:clickbyme/UI/ListViewHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../DB/AD_Home.dart';

UserSubscription(BuildContext context, TabController tabController, int tabindex) {
  final List<Recommend> _list_recommend = [
    Recommend(sub: '전체'),
    Recommend(sub: '추천'),
    Recommend(sub: 'My'),
  ];
  return Column(
    children: [
      Subscript(context, _list_recommend, tabController, tabindex),
    ],
  );
}

ContentSub(BuildContext context, TabController tabController) {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List<Recommend> _list_all = [
    Recommend(sub: '오늘의 추천'),
    Recommend(sub: '오늘의 일정'),
    Recommend(sub: '읽지 않은 스크립스'),
    Recommend(sub: '새로 생긴 챌린지'),
    Recommend(sub: '인기 많은 데이로그'),
  ];
  final List<Recommend> _list_recommend = [
    Recommend(sub: '오늘의 추천'),
    Recommend(sub: '새로 생긴 챌린지'),
    Recommend(sub: '인기 많은 데이로그'),
  ];
  final List<Recommend> _list_my = [
    Recommend(sub: '오늘의 일정'),
    Recommend(sub: '읽지 않은 스크립스'),
  ];
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return TabBarView(controller: tabController, children: [
      ListViewHome(context, _list_all),
      ListViewHome(context, _list_recommend),
      ListViewHome(context, _list_my),
    ]);
}

Subscript(
    context, List<Recommend> list_recommend, TabController tabController, int tabindex) {
  return list_recommend.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              Sticky(context, list_recommend, tabController, tabindex),
            ],
          ),
        );
}

Sticky(context, List<Recommend> list_recommend, TabController tabController, int tabindex) {
  return StickyHeader(
    header: Container(
        color: Colors.grey.shade100,
        alignment: Alignment.topLeft,
        height: MediaQuery.of(context).size.height / 13,
        child: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.deepPurpleAccent,
          controller: tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.only(left: 25, right: 25),
          indicator: CircleIndicator(color: Colors.black, radius: 4),
          tabs: [
            Tab(
              text: list_recommend[0].sub.toString(),
            ),
            Tab(
              text: list_recommend[1].sub.toString(),
            ),
            Tab(
              text: list_recommend[2].sub.toString(),
            ),
          ],
        )),
    content: Container(
      height: tabindex == 0 ? (MediaQuery.of(context).size.height / 3.5)*5 : 
      (tabindex == 1 ? (MediaQuery.of(context).size.height / 3.5) * 3: 
      (MediaQuery.of(context).size.height / 3.5)*2),
      child: ContentSub(context, tabController),
  ));
}

class CircleIndicator extends Decoration {
  final Color color;
  double radius;

  CircleIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
