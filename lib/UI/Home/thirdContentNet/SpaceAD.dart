import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import '../../Setting/BuyingPage.dart';

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
                  primary: BGColor(), side: BorderSide(color: TextColor())),
              onPressed: () {
                /*Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: BuyingPage()),
                );*/
                Get.to(() => BuyingPage(), transition: Transition.fadeIn);
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '구매화면 이동',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: TextColor(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize(),
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
