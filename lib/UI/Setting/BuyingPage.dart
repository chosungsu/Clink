import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../../Tool/NoBehavior.dart';
import '../../Tool/ContainerDesign.dart';

class BuyingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BuyingPageState();
}

class _BuyingPageState extends State<BuyingPage> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool isChecked = false;
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: VersionBuy(),
    ));
  }

  VersionBuy() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
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
                                //Navigator.pop(context);
                                Get.back();
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
                                    color: TextColor(),
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60 - 160,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '구매',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                        color: TextColor()),
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
                              const SizedBox(
                                height: 20,
                              ),
                              BuyItem1(height, context),
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

  BuyItem1(double height, BuildContext context) {
    return SizedBox(
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('구독하기',
                  style: TextStyle(
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Item1View(),
          const SizedBox(
            height: 20,
          ),
          isChecked == true
              ? ConsoleBuy()
              : SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }

  Item1View() {
    return SizedBox(
        height: 330,
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: BGColor(),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.looks_one_outlined,
                                        color: TextColor(),
                                        size: 30,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text('프로 버전 구매',
                                    style: TextStyle(
                                        color: TextColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize())),
                              ],
                            )),
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: BGColor(),
                            ),
                            child: Checkbox(
                                side: BorderSide(
                                  // POINT
                                  color: TextColor(),
                                  width: 2.0,
                                ),
                                activeColor: BGColor(),
                                checkColor: Colors.blue,
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                }))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('프로 버전을 구매 시 주어지는 혜택',
                          style: TextStyle(
                              color: TextColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize())),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 2,
                  child: ListView.separated(
                    //physics : 스크롤 막기 기능
                    //shrinkWrap : 리스트뷰 오버플로우 방지
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          index == 0
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Text((index + 1).toString() + '.',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize())),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text('광고 제거',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize())),
                                    )
                                  ],
                                )
                              : (index == 1
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                              (index + 1).toString() + '.',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text('하루 일상 스페이스 개수 잠금 해제',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                              (index + 1).toString() + '.',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text('하루 분석표 일부 기능 잠금 해제',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        )
                                      ],
                                    ))
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: TextColor(),
                      height: 10,
                      thickness: 3,
                    ),
                  ),
                ),
              ],
            )));
  }

  ConsoleBuy() {
    return SizedBox(
      height: 50,
      width: (MediaQuery.of(context).size.width - 40) * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: BGColor(), side: BorderSide(color: TextColor())),
              onPressed: () {},
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
