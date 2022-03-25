import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Recommend.dart';
import 'package:clickbyme/UI/ListViewHome.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

UserChoice(BuildContext context) {
  final List<Recommend> _list_recommend = [
    Recommend(sub: '취향맞춤 피드추천'),
    Recommend(sub: '오늘의 주요 일정'),
    Recommend(sub: '챌린지 진행도'),
  ];
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          border: NeumorphicBorder.none(),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
          depth: 5,
          color: Colors.white,
        ),
        child: Subscript(context, _list_recommend),
      ),
    ],
  );
}

ContentSub(BuildContext context, List<Recommend> list_recommend) {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List _list_background_color = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.orange,
  ];
  return Column(children: [
    ListViewHome(context, list_recommend[0].sub.toString(), _list_content),
    ListViewHome(context, list_recommend[1].sub.toString(), _list_content),
    ListViewHome(context, list_recommend[2].sub.toString(), _list_content),
  ]);
}

Subscript(context, List<Recommend> list_recommend) {
  return list_recommend.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              FeedVertical(context, list_recommend),
            ],
          ),
        );
}

FeedVertical(context, List<Recommend> list_recommend) {
  return Container(
    child: ContentSub(context, list_recommend),
  );
}
