import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/RoutineHome.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';

class YourDayfulAd extends StatelessWidget {
  YourDayfulAd({Key? key, required this.height}) : super(key: key);
  final double height;
  final List spacetitle = ['날씨', '다가오는 일정', '진행중인 루틴'];
  final List spacecontent = ['맑음/29도/서울시', '친구 만나기', '독서하기'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          spacetitle.isNotEmpty ? 110 * spacetitle.length.toDouble() : (200),
      width: MediaQuery.of(context).size.width - 40,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: spacetitle.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  spacetitle[index] == '날씨'
                      ? Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: DayContentHome()),
                        )
                      : (spacetitle[index] == '다가오는 일정'
                          ? Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: DayContentHome()),
                            )
                          : Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: RoutineHome()),
                            ));
                },
                child: Column(
                  children: [
                    ContainerDesign(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Stack(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(spacecontent[index],
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    ],
                                  )),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    child: spacetitle[index] == '날씨'
                                        ? NeumorphicIcon(
                                            Icons.sunny,
                                            size: 25,
                                            style: NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                color: Colors.black45,
                                                lightSource:
                                                    LightSource.topLeft),
                                          )
                                        : (spacetitle[index] == '다가오는 일정'
                                            ? NeumorphicIcon(
                                                Icons.calendar_today,
                                                size: 25,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    color: Colors.black45,
                                                    lightSource:
                                                        LightSource.topLeft),
                                              )
                                            : NeumorphicIcon(
                                                Icons.add_task,
                                                size: 25,
                                                style: NeumorphicStyle(
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    color: Colors.black45,
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ));
          }),
    );
  }
}
