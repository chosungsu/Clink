import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import '../../../Sub/SettingPage.dart';

class SpaceAD extends StatelessWidget {
  final List eventtitle = [
    '버전 업그레이드 혜택',
  ];
  final List eventcontent = [
    '버전 업그레이드 시 잠금된 기능을 해제해드립니다. 지금 즉시 확인해보세요!',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: (MediaQuery.of(context).size.width - 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade400,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: SettingPage()),
                );
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '구매화면 이동',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
