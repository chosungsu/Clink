import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
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
    Hive.box('user_setting').put('page_index', 1);
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
            body: GetBuilder<navibool>(
              builder: (_) => draw.navi == 0
                  ? (draw.drawopen == true
                      ? Stack(
                          children: [
                            Container(
                              width: 80,
                              child: DrawerScreen(
                                index:
                                    Hive.box('user_setting').get('page_index'),
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
            )));
  }

  Widget GroupBody(BuildContext context) {
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
                        children: [
                          const AppBarCustom(
                            title: 'MY',
                            righticon: false,
                            func: null,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(child:
                                    StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
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
            )));
  }

  M_Container0(double height) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => const ChooseCalendar(
                  isfromwhere: 'mypagehome',
                  index: 0,
                ),
            transition: Transition.rightToLeft);
      },
      child: SizedBox(
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
                Container(
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
      ),
    );
  }

  M_Container1(double height) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => const DayNoteHome(
                  title: '',
                  isfromwhere: 'mypagehome',
                ),
            transition: Transition.rightToLeft);
      },
      child: SizedBox(
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
                Container(
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
      ),
    );
  }
}
