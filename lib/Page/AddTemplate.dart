// ignore_for_file: non_constant_identifier_names

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../Route/subuiroute.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';

class AddTemplate extends StatefulWidget {
  const AddTemplate({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  String name = Hive.box('user_info').get('id');
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  final readlist = [];
  final listid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Animation animation;
  int currentstep = 0;

  @override
  void initState() {
    super.initState();
    draw.navi = 1;
    uiset.currentstepper = 0;
    Hive.box('user_setting').put('page_index', 3);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //notilist.noticontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGColor(),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: UI(),
          ),
        ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
                  draw.drawopen == true
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: height,
                  child: Container(
                      color: BGColor(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 60,
                            child: title(),
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                child: ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: SingleChildScrollView(
                                      physics: const ScrollPhysics(),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        child: Pagination(),
                                      ),
                                    )),
                              )),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  Pagination() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        GetBuilder<uisetting>(builder: (_) => choosecategory())
      ],
    );
  }

  title() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: RichText(
          text: TextSpan(children: [
        WidgetSpan(
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: mainTitleTextsize(),
              color: TextColor_shadowcolor()),
          child: Row(
            children: [
              Text(
                '작성폼',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: mainTitleTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
        ),
      ])),
    );
  }

  choosecategory() {
    List<StepperData> stepperData = [
      StepperData(
          title: "카테고리",
          iconWidget: GestureDetector(
            onTap: () {
              uiset.setstepperindex(0);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.looks_one, color: Colors.white),
            ),
          )),
      StepperData(
          title: "본문 작성",
          iconWidget: GestureDetector(
            onTap: () {
              uiset.setstepperindex(1);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.looks_two_sharp, color: Colors.white),
            ),
          )),
      StepperData(
          title: "게시",
          iconWidget: GestureDetector(
            onTap: () {
              uiset.setstepperindex(2);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.looks_3, color: Colors.white),
            ),
          )),
    ];
    return Column(
      children: [
        ContainerDesign(
            color: BGColor(),
            child: GetBuilder<uisetting>(
              builder: (_) => AnotherStepper(
                activeIndex: uiset.currentstepper,
                stepperList: stepperData,
                stepperDirection: Axis.horizontal,
                inverted: true,
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ))

        /*GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  '카테고리 선택',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize()),
                ),
              ),
              const Icon(
                Icons.expand_more,
                color: Colors.black45,
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      StatusBarControl.setColor(BGColor(), animated: true);
      draw.setnavi();
      if (uiset.searchpagemove != '') {
        Hive.box('user_setting').put('page_index', 11);
      } else {
        Hive.box('user_setting').put('page_index', 0);
      }

      Get.back();
    });
    return false;
  }
}
