import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/showaddLink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
import '../providers/mongodatabase.dart';
import '../sheets/addmemocollection.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  const MYPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> with TickerProviderStateMixin {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
  final draw = Get.put(navibool());
  final notilist = Get.put(notishow());
  final cal_share_person = Get.put(PeopleAdd());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  final searchNode = FocusNode();
  var _controller = TextEditingController();
  final scollection = Get.put(selectcollection());
  late Animation animation;
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 1);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
    //notilist.noticontroller.dispose();
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
                            SizedBox(
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
                            title: '',
                            righticon: true,
                            iconname: Icons.settings,
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
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      M_Container1(height),
                                      Container(
                                        height: 20,
                                        color: Colors.grey.shade200,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      M_Container0(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
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
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('템플릿',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: TextColor(),
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              index == 0
                                  ? Get.to(
                                      () => const ChooseCalendar(
                                            isfromwhere: 'mypagehome',
                                            index: 0,
                                          ),
                                      transition: Transition.rightToLeft)
                                  : Get.to(
                                      () => const DayNoteHome(
                                            title: '',
                                            isfromwhere: 'mypagehome',
                                          ),
                                      transition: Transition.rightToLeft);
                            },
                            child: ContainerDesign(
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: index == 0
                                                  ? const Icon(
                                                      Icons.event,
                                                      color: Colors.white,
                                                      size: 35,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .format_list_bulleted,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                            )),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: Text(
                                              index == 0 ? '공유캘린더' : '커스텀메모',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                color: Colors.green.shade300),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      );
                    })),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  M_Container1(double height) {
    final link = [];
    return SizedBox(
        width: double.infinity,
        height: 120,
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text('MY LINK',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                              color: TextColor(),
                            )),
                      ),
                      InkWell(
                        onTap: () => addmylink(context, usercode, _controller,
                            searchNode, scollection),
                        child: Text('추가',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: contentTextsize(),
                              color: TextColor_shadowcolor(),
                            )),
                      )
                    ],
                  ),
                ),
                GetBuilder<selectcollection>(builder: ((controller) {
                  return SizedBox(
                      height: 50,
                      child: FutureBuilder(
                        future: MongoDB.getData(collectionname: 'linknet')
                            .then((value) {
                          scollection.resetcollectionlink();
                          for (int j = 0; j < value.length; j++) {
                            link.clear();
                            final user = value[j]['username'];

                            if (user == usercode) {
                              for (int i = 0;
                                  i < value[j]['link'].length;
                                  i++) {
                                link.add(value[j]['link'][i]);
                                scollection.addmemolistlink(link[i]);
                              }
                            }
                          }
                        }),
                        builder: (context, snapshot) {
                          return scollection.collectionlink.isEmpty
                              ? ContainerDesign(
                                  color: Colors.grey.shade300,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              '추가버튼으로 추가하세요',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: scollection.collectionlink.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade200,
                                            ),
                                            child: SizedBox(
                                              width: 80,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        scollection
                                                            .collectionlink[
                                                                index]
                                                            .toString(),
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    );
                                  }));
                        },
                      ));
                }))
              ],
            )));
  }

  addmylink(
    BuildContext context,
    String username,
    TextEditingController textEditingController_add_sheet,
    FocusNode searchNode_add_section,
    selectcollection scollection,
  ) {
    Get.bottomSheet(
            Container(
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            searchNode_add_section.unfocus();
                          });
                        },
                        child: linkstation(
                            context,
                            textEditingController_add_sheet,
                            searchNode_add_section,
                            scollection,
                            username),
                      ))),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
        .whenComplete(() {
      textEditingController_add_sheet.clear();
    });
  }

  /*M_Container0(double height) {
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
  }*/
}
