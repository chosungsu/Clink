import 'dart:async';
import 'package:clickbyme/Sub/DayLog.dart';
import 'package:clickbyme/Sub/WritePost.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../../DB/PageList.dart';
import '../../Futures/quickmenuasync.dart';
import '../../Sub/YourTags.dart';

UserPicks(BuildContext context, String s, PageController pController) {
  StreamController _sController = StreamController<int>()..add(0);
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
                            s,
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
                      /*onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: QuickMenuPage(),
                                type: PageTransitionType.leftToRightWithFade));
                      },*/
                      child: Container(
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200),
                        child: NeumorphicIcon(
                          Icons.settings,
                          size: 20,
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              depth: 5,
                              surfaceIntensity: 0.5,
                              color: Colors.deepPurpleAccent.shade100,
                              lightSource: LightSource.topLeft),
                        ),
                      )),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 2 / 3 * 2 + 20,
            child: PageView(
              controller: pController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                _sController.add(value);
              },
              children: [
                Main_Pick(context, 0),
                Main_Pick(context, 1),
              ],
            ),
          ),
          SizedBox(
            height: 25,
            child: StreamBuilder(
              stream: _sController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (snapshot.data == index)
                                  ? Colors.deepPurple.shade200
                                  : Colors.grey));
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
          )
        ],
      ),
    ],
  );
}

Main_Pick(context, int i) {
  final List<PageList> _list_ad = [
    PageList(
      id: '1',
      title: '데이로그',
      date: DateTime.now(),
    ),
    PageList(
      id: '2',
      title: '챌린지',
      date: DateTime.now(),
    ),
    PageList(
      id: '3',
      title: '페이지마크',
      date: DateTime.now(),
    ),
    PageList(
      id: '4',
      title: '탐색기록',
      date: DateTime.now(),
    ),
  ];
  final List<String> itemImg = [
    'assets/images/date.png',
    'assets/images/challenge.png',
    'assets/images/icon-link.png',
    'assets/images/playlist.png',
  ];
  return i == 0
      ? SizedBox(
          height: MediaQuery.of(context).size.width / 2 / 3 * 2 + 20,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: FutureBuilder<List<String>>(
                future: quickmenuasync(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 10, //수평 Padding
                          crossAxisSpacing: 10, //수직 Padding
                        ),
                        itemBuilder: (context, index) {
                          return Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  border: NeumorphicBorder(
                                      width: 1, color: Colors.grey),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(5)),
                                  depth: 5,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                              child: InkWell(
                                  onTap: () {
                                    if (snapshot.data![index] == '데이로그') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: DayLog(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (snapshot.data![index] == '챌린지') {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: WritePost(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    } else if (snapshot.data![index] ==
                                        '페이지마크') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (snapshot.data![index] ==
                                        '탐색기록') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: storepw(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          //itemImg[index],
                                          snapshot.data![index] == '데이로그'
                                              ? itemImg[0]
                                              : (snapshot.data![index] == '챌린지'
                                                  ? itemImg[1]
                                                  : (snapshot.data![index] ==
                                                          '페이지마크'
                                                      ? itemImg[2]
                                                      : (snapshot.data![
                                                                  index] ==
                                                              '탐색기록'
                                                          ? itemImg[3]
                                                          : itemImg[3]))),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          snapshot.data![index],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        });
                  } else {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 10, //수평 Padding
                          crossAxisSpacing: 10, //수직 Padding
                        ),
                        itemBuilder: (context, index) {
                          return Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  border: NeumorphicBorder(
                                      width: 1, color: Colors.grey),
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
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (index == 1) {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: WritePost(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    } else if (index == 2) {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: storepw(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                        });
                  }
                },
              )))
      : SizedBox(
          height: MediaQuery.of(context).size.width / 2 / 3 * 2 + 20,
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: FutureBuilder<List<String>>(
                future: quickmenuasync(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 10, //수평 Padding
                          crossAxisSpacing: 10, //수직 Padding
                        ),
                        itemBuilder: (context, index) {
                          return Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  border: NeumorphicBorder(
                                      width: 1, color: Colors.grey),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(5)),
                                  depth: 5,
                                  color: Colors.white,
                                  lightSource: LightSource.topLeft),
                              child: InkWell(
                                  onTap: () {
                                    if (snapshot.data![index + 3] == '데이로그') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: DayLog(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (snapshot.data![index + 3] ==
                                        '챌린지') {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: WritePost(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    } else if (snapshot.data![index + 3] ==
                                        '페이지마크') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (snapshot.data![index + 3] ==
                                        '탐색기록') {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: storepw(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          //itemImg[index],
                                          index + 3 < 4
                                              ? snapshot.data![index + 3] ==
                                                      '데이로그'
                                                  ? itemImg[0]
                                                  : (snapshot.data![
                                                              index + 3] ==
                                                          '챌린지'
                                                      ? itemImg[1]
                                                      : (snapshot.data![
                                                                  index + 3] ==
                                                              '페이지마크'
                                                          ? itemImg[2]
                                                          : (snapshot.data![
                                                                      index +
                                                                          3] ==
                                                                  '탐색기록'
                                                              ? itemImg[3]
                                                              : itemImg[3])))
                                              : itemImg[3],
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          index + 3 < 4
                                              ? snapshot.data![index + 3]
                                              : '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        });
                  } else {
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _list_ad.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                          childAspectRatio: 3 / 1, //item 의 가로 1, 세로 2 의 비율
                          mainAxisSpacing: 10, //수평 Padding
                          crossAxisSpacing: 10, //수직 Padding
                        ),
                        itemBuilder: (context, index) {
                          return Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  border: NeumorphicBorder(
                                      width: 1, color: Colors.grey),
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
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else if (index == 1) {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: WritePost(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    } else if (index == 2) {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: YourTags(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));
                                    } else {
                                      /*Navigator.push(
                                          context,
                                          PageTransition(
                                              child: storepw(),
                                              type: PageTransitionType
                                                  .leftToRightWithFade));*/
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                        });
                  }
                },
              )));
}
