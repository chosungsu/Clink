import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Home_Rec_title.dart';
import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/UI/Home/ListViewChipRecommend.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'ListViewDayTimeLine.dart';
import 'ListViewHome.dart';

UserChoice(BuildContext context, List<TODO> str_todo_list) {
  final List<Home_Rec_title> _list_recommend = [
    Home_Rec_title(sub: '오늘의 일정'),
    Home_Rec_title(sub: '이런 활동은 어떠신가요?'),
    Home_Rec_title(sub: '챌린지 진행도'),
  ];

  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Subscript(context, _list_recommend, str_todo_list),
    ],
  );
}

ContentSub(BuildContext context, List<Home_Rec_title> list_recommend,
    List<TODO> str_todo_list) {
  final List<Contents> _list_content = [
    Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
    Contents(content: 'bbbb', date: DateTime.now(), id: '2', title: 'b'),
    Contents(content: 'cccc', date: DateTime.now(), id: '3', title: 'c'),
    Contents(content: 'dddd', date: DateTime.now(), id: '4', title: 'd'),
    Contents(content: 'eeee', date: DateTime.now(), id: '5', title: 'e'),
  ];
  final List<Contents> _list_challenges = [
    //Contents(content: 'aaaa', date: DateTime.now(), id: '1', title: 'a'),
  ];
  return Column(children: [
    ListViewDayTimeLine(
        context, list_recommend[0].sub.toString(), str_todo_list),
    ListViewChipRecommend(context, list_recommend[1].sub.toString(), _list_content),
    ListViewHome(context, list_recommend[2].sub.toString(), _list_challenges),
  ]);
}

Subscript(
    context, List<Home_Rec_title> list_recommend, List<TODO> str_todo_list) {
  return list_recommend.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              FeedVertical(context, list_recommend, str_todo_list),
            ],
          ),
        );
}

FeedVertical(
    context, List<Home_Rec_title> list_recommend, List<TODO> str_todo_list) {
  return Container(
    child: ContentSub(context, list_recommend, str_todo_list),
  );
}
