import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:clickbyme/UI/Events/EnterCheckEvents.dart';
import 'package:clickbyme/UI/Home/TopContentNet/ClipsContentNet/ClipsCard.dart';
import 'package:clickbyme/UI/Home/TopContentNet/ClipsContentNet/HabitCard.dart';
import 'package:clickbyme/UI/Home/TopContentNet/ClipsContentNet/TodayRoadView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TodayChoiceFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodayChoiceFeedState();
}

class _TodayChoiceFeedState extends State<TodayChoiceFeed> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int currentPage = 0;
  late final PageController _pController;

  @override
  void initState() {
    super.initState();
    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
  }
  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: ChoiceFeedAi(),
    ));
  }

  ChoiceFeedAi() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(
                        width: 50,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              child: NeumorphicIcon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: 2,
                                    surfaceIntensity: 0.5,
                                    color: Colors.black45,
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TCF_1(),
                              SizedBox(
                                height: 30,
                              ),
                              TCF_2(),
                              SizedBox(
                                height: 30,
                              ),
                              TCF_3(),
                              SizedBox(
                                height: 150,
                              ),
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  TCF_1() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('#클립모음',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ClipsCard()
        ],
      ),
    );
  }

  TCF_2() {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('#하루 길라잡이',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TodayRoadView(pageController: _pController),
        ],
      ),
    );
  }

  TCF_3() {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('#동기부여',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          HabitCard()
        ],
      ),
    );
  }
}
