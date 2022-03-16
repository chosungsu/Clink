import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:transition/transition.dart';
import '../Sub/HowToUsePage.dart';

UserSettings(BuildContext context) {
  final List<String> list_title = <String>[
    '이용안내',
    '문의하기',
    'Pro 버전 구매',
    '기본값 설정',
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
        child: const Text(
          '부가기능',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
              depth: 4,
              intensity: 0.5,
              color: Colors.white,
            ),
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: ListView.separated(
                    //physics : 스크롤 막기 기능
                    //shrinkWrap : 리스트뷰 오버플로우 방지
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list_title.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            child: Text('${list_title[index]}'),
                            onTap: () {
                              if (index == 0) {
                                //이용안내페이지 호출
                                Navigator.push(
                                    context,
                                    Transition(
                                        child: HowToUsePage(),
                                        transitionEffect:
                                            TransitionEffect.RIGHT_TO_LEFT));
                              } else if (index == 1) {
                              } else if (index == 2) {
                              } else {}
                            },
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ),
            )),
      )
    ],
  );
}
