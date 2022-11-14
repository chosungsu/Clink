// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables

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
import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/Getx/category.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/TextSize.dart';

class AddTemplate extends StatefulWidget {
  const AddTemplate({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<StatefulWidget> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  String name = Hive.box('user_info').get('id');
  String usercode = Hive.box('user_setting').get('usercode');
  final notilist = Get.put(notishow());
  final uiset = Get.put(uisetting());
  final draw = Get.put(navibool());
  final cg = Get.put(category());
  final readlist = [];
  final listid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List spaceindata = [];
  late Animation animation;
  int currentstep = 0;

  @override
  void initState() {
    super.initState();
    draw.navi = 1;
    uiset.currentstepper = 0;
    cg.categorypicknumber = 99;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          choosecategory(),
                          const SizedBox(
                            height: 20,
                          ),
                          GetBuilder<uisetting>(
                            builder: (_) => Flexible(
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
                          ),
                          ADSHOW(),
                        ],
                      )),
                ),
              ),
            )));
  }

  choosecategory() {
    List<StepperData> stepperData = [
      StepperData(
          title: "스페이스",
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
              if (cg.categorypicknumber == 99) {
              } else {
                uiset.setstepperindex(1);
              }
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
              if (cg.categorypicknumber == 99) {
              } else {
                uiset.setstepperindex(2);
              }
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
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              )),
        ],
      ),
    );
  }

  Pagination() {
    return uiset.currentstepper == 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '선택',
                style: TextStyle(
                  fontSize: contentTitleTextsize(),
                  color: TextColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '이미 존재하는 스페이스일 경우 본문작성 탭에서 선택 및 추가가 가능합니다.',
                style: TextStyle(
                  fontSize: contentTextsize(),
                  color: TextColor_shadowcolor(),
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Page1(),
              const SizedBox(
                height: 50,
              ),
              moveaction(),
            ],
          )
        : (uiset.currentstepper == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '작성',
                    style: TextStyle(
                      fontSize: contentTitleTextsize(),
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Page2(),
                  const SizedBox(
                    height: 50,
                  ),
                  moveaction(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '게시',
                    style: TextStyle(
                      fontSize: contentTitleTextsize(),
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Page3(),
                  const SizedBox(
                    height: 50,
                  ),
                  moveaction(),
                ],
              ));
  }

  moveaction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 1,
            child: GetBuilder<uisetting>(
              builder: (_) => uiset.currentstepper == 0
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          uiset.currentstepper--;
                        });
                      },
                      child: ContainerDesign(
                          color: BGColor(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.chevron_left,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '이전',
                                style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    ),
            )),
        Flexible(
            flex: 1,
            child: GetBuilder<category>(
              builder: (_) => uiset.currentstepper == 2
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          if (cg.categorypicknumber == 99) {
                          } else {
                            uiset.currentstepper++;
                          }
                        });
                      },
                      child: ContainerDesign(
                          color: BGColor(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '다음',
                                style: TextStyle(
                                  fontSize: contentTextsize(),
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 25,
                              ),
                            ],
                          )),
                    ),
            )),
      ],
    );
  }

  Page1() {
    List<String> listdata = [
      'URL, 파일, 사진 등을 담을 수 있는 스페이스',
      '일정정리를 도와주는 캘린더 스페이스',
      'Todo 리스트 스페이스',
      '메모 스페이스'
    ];
    return Column(
      children: [
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listdata.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<category>(
                      builder: (_) => GestureDetector(
                            onTap: () {
                              if (cg.categorypicknumber == index) {
                                cg.setcategorypicknumber(99);
                              } else {
                                cg.setcategorypicknumber(index);
                              }
                            },
                            child: ContainerDesign(
                                color: cg.categorypicknumber == index
                                    ? Colors.blue.shade200
                                    : BGColor(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    cg.categorypicknumber == index
                                        ? const Icon(
                                            Icons.done_all,
                                            color: Colors.white,
                                            size: 25,
                                          )
                                        : Icon(
                                            Icons.ads_click,
                                            color: TextColor(),
                                            size: 25,
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        listdata[index],
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )
                                  ],
                                )),
                          )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }))
      ],
    );
  }

  Page2() {
    return Column(
      children: [
        FutureBuilder(
            future: firestore.collection('PageView').get().then((value) {
              if (value.docs.isEmpty) {
              } else {
                uiset.pageviewlist.clear();
                final valuespace = value.docs;
                for (int i = 0; i < valuespace.length; i++) {
                  if (valuespace[i]['username'] == usercode) {
                    if (valuespace[i]['title'] ==
                            uiset.pagelist[uiset.mypagelistindex].title &&
                        valuespace[i]['space'] == cg.categorypicknumber) {
                      if (cg.categorypicknumber == 0) {
                        for (int i = 0;
                            i < valuespace[i]['urllist'].length;
                            i++) {
                          spaceindata.add(valuespace[i]['urllist'][i]);
                        }
                        uiset.pageviewlist.add(PageviewList(
                          title: valuespace[i]['title'],
                          seperatedindex: valuespace[i]['seperatedindex'],
                          boxseperatedindex: valuespace[i]['boxseperatedindex'],
                          username: valuespace[i]['username'],
                          urlcontent: spaceindata,
                        ));
                      } else if (cg.categorypicknumber == 1) {
                        uiset.pageviewlist.add(PageviewList(
                          title: valuespace[i]['title'],
                          seperatedindex: valuespace[i]['seperatedindex'],
                          boxseperatedindex: valuespace[i]['boxseperatedindex'],
                          username: valuespace[i]['username'],
                          calendarcontent: valuespace[i]['calendarname'],
                        ));
                      } else if (cg.categorypicknumber == 2) {
                        for (int i = 0;
                            i < valuespace[i]['todolist'].length;
                            i++) {
                          spaceindata.add(valuespace[i]['todolist'][i]);
                        }
                        uiset.pageviewlist.add(PageviewList(
                          title: valuespace[i]['title'],
                          seperatedindex: valuespace[i]['seperatedindex'],
                          boxseperatedindex: valuespace[i]['boxseperatedindex'],
                          username: valuespace[i]['username'],
                          todolistcontent: spaceindata,
                        ));
                      } else if (cg.categorypicknumber == 3) {
                        for (int i = 0;
                            i < valuespace[i]['memolist'].length;
                            i++) {
                          spaceindata.add(valuespace[i]['memolist'][i]);
                        }
                        uiset.pageviewlist.add(PageviewList(
                          title: valuespace[i]['title'],
                          seperatedindex: valuespace[i]['seperatedindex'],
                          boxseperatedindex: valuespace[i]['boxseperatedindex'],
                          username: valuespace[i]['username'],
                          memocontent: spaceindata,
                        ));
                      } else {}
                    }
                  }
                }
              }
            }),
            builder: ((context, snapshot) {
              return Column(
                children: [
                  Text(
                    '현재 이 페이지에 있는 스페이스 목록',
                    style: TextStyle(
                      fontSize: contentTextsize(),
                      color: TextColor_shadowcolor(),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }))
      ],
    );
  }

  Page3() {
    return Column(
      children: [],
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
