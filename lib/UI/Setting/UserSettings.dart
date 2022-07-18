import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Setting/DeleteUser.dart';
import 'package:clickbyme/UI/Setting/OptionChangePage.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:clickbyme/sheets/addgroupmember.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transition/transition.dart';

import '../../Sub/HowToUsePage.dart';
import 'BuyingPage.dart';
import '../../Tool/ContainerDesign.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key, required this.height}) : super(key: key);
  final double height;
  final List<String> list_title = <String>[
    '도움 & 문의',
    '설정값 변경',
    '구매하기',
    '친구 초대하기',
    '로그인',
  ];
  var name = Hive.box('user_info').get('id');
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          list_title.isNotEmpty ? 100 * list_title.length.toDouble() : (200),
      width: MediaQuery.of(context).size.width - 40,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: list_title.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  index == 0
                      ? Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: DayContentHome()),
                        )
                      : (index == 1
                          ? Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: OptionChangePage()),
                            )
                          : (index == 2
                              ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: BuyingPage()),
                                )
                              : (index == 3
                                  ? addgroupmember(context)
                                  : (index == 4 && name == null
                                      ? GoToLogin(context)
                                      : DeleteUserVerify(context, name)))));
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ContainerDesign(
                        color: Colors.white,
                        child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                                Hive.box('user_info').get('id') != null &&
                                        index == 4
                                    ? '회원탈퇴'
                                    : list_title[index],
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 25,
                            height: 25,
                            child: NeumorphicIcon(
                              Icons.navigate_next,
                              size: 20,
                              style: const NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.black45,
                                  lightSource: LightSource.topLeft),
                            ),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ));
          }),
    );
  }
}
