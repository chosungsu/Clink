import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:transition/transition.dart';

import '../../Sub/HowToUsePage.dart';
import '../../Sub/SettingPage.dart';
import '../../Tool/ContainerDesign.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key, required this.height}) : super(key: key);
  final double height;
  final List<String> list_title = <String>[
    '이용안내',
    '문의하기',
    'Pro 버전 구매',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: ContainerDesign(
            child: SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      //physics : 스크롤 막기 기능
                      //shrinkWrap : 리스트뷰 오버플로우 방지
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list_title.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            height: 250 / 5.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Text('${list_title[index]}'),
                                  onTap: () {
                                    if (index == 0) {
                                      //이용안내페이지 호출
                                      Navigator.push(
                                          context,
                                          Transition(
                                              child: HowToUsePage(),
                                              transitionEffect: TransitionEffect
                                                  .RIGHT_TO_LEFT));
                                    } else if (index == 1) {
                                    } else {
                                      //구독관리페이지 호출
                                      Navigator.push(
                                          context,
                                          Transition(
                                              child: SettingPage(),
                                              transitionEffect: TransitionEffect
                                                  .BOTTOM_TO_TOP));
                                    } 
                                  },
                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  ],
                ))));
  }
}
