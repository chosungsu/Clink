import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Home_Rec_title.dart';
import 'package:clickbyme/UI/ListViewFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sticky_headers/sticky_headers.dart';

UserSubscription(BuildContext context, TabController tabController,
    int tabindex, List<Contents> contents) {
  final List<Home_Rec_title> _list_recommend = [
    Home_Rec_title(sub: 'My 피드'),
    Home_Rec_title(sub: 'dot 추천'),
  ];
  return Column(
    children: [
      Subscript(context, _list_recommend, tabController, tabindex, contents),
    ],
        
  );
}

ContentSub(BuildContext context, TabController tabController,
    List<Home_Rec_title> list_recommend, List<Contents> contents) {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List<Home_Rec_title> _list_all = [
    Home_Rec_title(sub: '오늘의 추천'),
    Home_Rec_title(sub: '오늘의 일정'),
    Home_Rec_title(sub: '읽지 않은 스크립스'),
    Home_Rec_title(sub: '새로 생긴 챌린지'),
    Home_Rec_title(sub: '인기 많은 데이로그'),
  ];
  final List<Home_Rec_title> _list_recommend = [
    Home_Rec_title(sub: '오늘의 추천'),
    Home_Rec_title(sub: '새로 생긴 챌린지'),
    Home_Rec_title(sub: '인기 많은 데이로그'),
  ];
  final List<Home_Rec_title> _list_my = [
    Home_Rec_title(sub: '오늘의 일정'),
    Home_Rec_title(sub: '읽지 않은 스크립스'),
  ];
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return TabBarView(controller: tabController, children: [
    ListViewFeed(context, _list_all, contents),
    ListViewFeed(context, _list_recommend, contents),
  ]);
}

Subscript(context, List<Home_Rec_title> list_recommend, TabController tabController,
    int tabindex, List<Contents> contents) {
  return list_recommend.isEmpty
      ? Container(
          height: 0,
        )
      : Column(
            children: [
              Sticky(
                context, list_recommend, tabController,
                tabindex, contents),
            ],
          );
}

Sticky(context, List<Home_Rec_title> list_recommend, TabController tabController,
    int tabindex, List<Contents> contents) {
  return StickyHeader(
    header: Container(
        color: Colors.white,
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
          ],
        )),
    content: ContentSub(context, tabController, list_recommend,
        contents), /*Container(
      height: tabindex == 0 ? (MediaQuery.of(context).size.height / 3.5)*5 : 
      (MediaQuery.of(context).size.height / 3.5) * 3,
      child: ContentSub(context, tabController, list_recommend, contents),
  )*/
  );
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
