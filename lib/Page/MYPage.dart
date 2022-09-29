import 'package:async/async.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/userinfotalk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
import '../UI/Home/secondContentNet/PeopleGroup.dart';
import '../UI/Sign/UserCheck.dart';
import '../sheets/addgroupmember.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final draw = Get.put(navibool());
  final cal_share_person = Get.put(PeopleAdd());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  final searchNode = FocusNode();
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    isdraweropen = draw.drawopen;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: draw.navi == 0
          ? (draw.drawopen == true
              ? Stack(
                  children: [
                    Container(
                      width: 80,
                      child: DrawerScreen(
                        index: Hive.box('user_setting').get('page_index'),
                      ),
                    ),
                    GroupBody(context),
                  ],
                )
              : Stack(
                  children: [
                    GroupBody(context),
                  ],
                ))
          : Stack(
              children: [
                GroupBody(context),
              ],
            ),
    ));
  }

  Widget GroupBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
        transform: Matrix4.translationValues(xoffset, yoffset, 0)
          ..scale(scalefactor),
        duration: const Duration(milliseconds: 250),
        child: GetBuilder<navibool>(
          builder: (_) => GestureDetector(
            onTap: () {
              isdraweropen == true
                  ? setState(() {
                      xoffset = 0;
                      yoffset = 0;
                      scalefactor = 1;
                      isdraweropen = false;
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
                    children: [
                      SizedBox(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                draw.navi == 0
                                    ? draw.drawopen == true
                                        ? IconBtn(
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    xoffset = 0;
                                                    yoffset = 0;
                                                    scalefactor = 1;
                                                    isdraweropen = false;
                                                    draw.setclose();
                                                    Hive.box('user_setting')
                                                        .put('page_opened',
                                                            false);
                                                  });
                                                },
                                                icon: Container(
                                                  alignment: Alignment.center,
                                                  width: 30,
                                                  height: 30,
                                                  child: NeumorphicIcon(
                                                    Icons.keyboard_arrow_left,
                                                    size: 30,
                                                    style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        depth: 2,
                                                        surfaceIntensity: 0.5,
                                                        color: TextColor(),
                                                        lightSource: LightSource
                                                            .topLeft),
                                                  ),
                                                )),
                                            color: TextColor())
                                        : IconBtn(
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    xoffset = 80;
                                                    yoffset = 0;
                                                    scalefactor = 1;
                                                    isdraweropen = true;
                                                    draw.setopen();
                                                    Hive.box('user_setting')
                                                        .put('page_opened',
                                                            true);
                                                  });
                                                },
                                                icon: Container(
                                                  alignment: Alignment.center,
                                                  width: 30,
                                                  height: 30,
                                                  child: NeumorphicIcon(
                                                    Icons.menu,
                                                    size: 30,
                                                    style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .convex,
                                                        surfaceIntensity: 0.5,
                                                        depth: 2,
                                                        color: TextColor(),
                                                        lightSource: LightSource
                                                            .topLeft),
                                                  ),
                                                )),
                                            color: TextColor())
                                    : const SizedBox(),
                                SizedBox(
                                    width: draw.navi == 0
                                        ? MediaQuery.of(context).size.width - 70
                                        : MediaQuery.of(context).size.width -
                                            20,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text('MY',
                                                  style: TextStyle(
                                                    fontSize:
                                                        secondTitleTextsize(),
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ))),
                              ],
                            ),
                          )),
                      Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(
                          child: ScrollConfiguration(
                            behavior: NoBehavior(),
                            child: SingleChildScrollView(child: StatefulBuilder(
                                builder: (_, StateSetter setState) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      M_Container0(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      M_Container1(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ));
                            })),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }

  M_Container0(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('캘린더 모음',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor_shadowcolor(),
                    )),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                      () => const ChooseCalendar(
                            isfromwhere: 'mypagehome',
                            index: 0,
                          ),
                      transition: Transition.rightToLeft);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: NeumorphicIcon(
                    Icons.shortcut,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        surfaceIntensity: 0.5,
                        depth: 2,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                ),
              )
            ],
          ),
          Text(
            '우측아이콘을 클릭하여 캘린더 확인',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: TextColor(),
            ),
          ),
          const Divider(
            height: 20,
            color: Colors.grey,
            thickness: 1,
            indent: 10.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }

  M_Container1(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('메모장 모음',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor_shadowcolor(),
                    )),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                      () => const DayNoteHome(
                            title: '',
                            isfromwhere: 'mypagehome',
                          ),
                      transition: Transition.rightToLeft);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: NeumorphicIcon(
                    Icons.shortcut,
                    size: 30,
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        surfaceIntensity: 0.5,
                        depth: 2,
                        color: TextColor(),
                        lightSource: LightSource.topLeft),
                  ),
                ),
              )
            ],
          ),
          Text(
            '우측아이콘을 클릭하여 메모 확인',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: TextColor(),
            ),
          ),
          const Divider(
            height: 20,
            color: Colors.grey,
            thickness: 1,
            indent: 10.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }
}
