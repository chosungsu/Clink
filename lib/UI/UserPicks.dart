import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../DB/AD_Home.dart';
import '../Sub/GoToDoDate.dart';

UserPicks(BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Row(
            children: [
              Icon(
                Icons.push_pin,
                color: Colors.deepPurpleAccent.shade100,
              ),
              SizedBox(
                width: 10,
              ),
              const Text(
                '카테고리',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )),
      Main_Pick(context),
    ],
  );
}

Main_Pick(context) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '1',
      title: '식습관 작성',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '데이로그 작성',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '챌린지 작성',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '톡톡 PLUS',
      person_num: 4,
      date: DateTime.now(),
    ),
  ];
  final List<String> itemImg = [
    'assets/images/food.png',
    'assets/images/date.png',
    'assets/images/challenge.png',
    'assets/images/icon-chat.png',
  ];
  final List _list_background_color = [
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.yellow.shade200,
    Colors.red.shade200
  ];
  return SizedBox(
      height: 300,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _list_ad.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2),
          itemBuilder: (context, index) {
            return Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(16.0)),
                    depth: 4,
                    intensity: 0.5,
                    color: _list_background_color[index],
                    lightSource: LightSource.topLeft),
                child: InkWell(
                    onTap: () {
                      if (index == 0) {
                      } else if (index == 1) {
                      } else if (index == 2) {
                      } else {}
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            itemImg[index],
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            _list_ad[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )));
          }),
      ));
}
