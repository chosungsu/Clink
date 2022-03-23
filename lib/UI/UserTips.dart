import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../DB/AD_Home.dart';

UserTips(BuildContext context) {
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
                Icons.tips_and_updates,
                color: Colors.deepPurpleAccent.shade100,
              ),
              SizedBox(
                width: 10,
              ),
              const Text(
                '왓 인 HabitMind?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          )),
      Container(
        padding: EdgeInsets.only(top: 15),
        child: TipClips(context),
      )
    ],
  );
}

TipClips(context) {
  return CarouselSlider(
      items: [
        PageTipsCarousel(context, 0),
        PageTipsCarousel(context, 1),
        PageTipsCarousel(context, 2),
        PageTipsCarousel(context, 3),
      ],
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height / 4.5,
          autoPlay: true,
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          reverse: false,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8));
}

PageTipsCarousel(BuildContext context, int index) {
  final List<AD_Home> _list_ad = [
    AD_Home(
      id: '1',
      title: '데이로그 관리',
      person_num: 3,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '2',
      title: '챌린지 관리',
      person_num: 4,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '3',
      title: '페이지마크 관리',
      person_num: 5,
      date: DateTime.now(),
    ),
    AD_Home(
      id: '4',
      title: '개인키 관리',
      person_num: 5,
      date: DateTime.now(),
    )
  ];
  final List _list_background_color = [
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.red.shade200
  ];
  return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: SizedBox(
          child: Neumorphic(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
                  depth: 4,
                  intensity: 0.5,
                  color: _list_background_color[index],
                  lightSource: LightSource.topLeft),
              child: InkWell(
                onTap: () {
                  if (index == 1) {
                  } else if (index == 2) {
                  } else if (index == 3) {
                  } else {}
                },
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: NeumorphicText(
                            _list_ad[index].title,
                            style: const NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: Colors.white,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: NeumorphicText(
                            'Tip 톺아보기',
                            style: const NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 4,
                              color: Colors.white,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            color: Colors.grey.withOpacity(0.2)
                          ),
                          child: Text(
                            (index + 1).toString() + '/' + _list_ad.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ))
                  ],
                ),
              ))));
}
