import 'package:clickbyme/DB/Contents.dart';
import 'package:clickbyme/DB/Home_Rec_title.dart';
import 'package:clickbyme/DB/TODO.dart';
import 'package:clickbyme/UI/Explore/ListViewRecommendSet.dart';
import 'package:clickbyme/UI/Explore/ListViewWidget.dart';
import 'package:clickbyme/UI/Home/ListViewChipRecommend.dart';
import 'package:clickbyme/UI/Home/UserPicks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

WidgetChoose(BuildContext context, PageController pController) {
  final List<Home_Rec_title> _list_recommend = [
    Home_Rec_title(sub: 'Icon'),
    Home_Rec_title(sub: '이런 분들께 추천드려요'),
  ];

  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Subscript(context, _list_recommend, pController),
    ],
  );
}
Subscript(
    context, List<Home_Rec_title> list_recommend, PageController pController) {
  return list_recommend.isEmpty
      ? Container(
          height: 0,
        )
      : SizedBox(
          child: Column(
            children: [
              FeedVertical(context, list_recommend, pController),
            ],
          ),
        );
}

FeedVertical(
    context, List<Home_Rec_title> list_recommend, PageController pController) {
  return Container(
    child: ContentSub(context, list_recommend, pController),
  );
}
ContentSub(BuildContext context, List<Home_Rec_title> list_recommend, PageController pController) {
  return Column(children: [
    ListViewWidget(context, list_recommend[0].sub.toString()),
    ListViewRecommendSet(context, list_recommend[1].sub.toString())
  ]);
}