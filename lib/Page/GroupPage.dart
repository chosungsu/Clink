import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info/package_info.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Setting/ShowLicense.dart';
import '../UI/Setting/UserDetails.dart';
import '../UI/Setting/UserSettings.dart';
import '../sheets/addgroupmember.dart';
import '../sheets/readycontent.dart';
import '../sheets/userinfo_draggable.dart';
import 'DrawerScreen.dart';

class GroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final draw = Get.put(navibool());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  late final PageController _pController;

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    isdraweropen = draw.drawopen;
    _pController = PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  void dispose() {
    super.dispose();
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
                                              child: Text('피플',
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
                                      G_Container0(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      G_Container1(height),
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

  G_Container0(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('공유 그룹',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: TextColor(),
              )),
          G_Container0_body()
        ],
      ),
    );
  }

  G_Container0_body() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('CalendarSheetHome')
          .where('madeUser', isEqualTo: name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          sharelist.clear();
          colorlist.clear();
          calnamelist.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            if (sp.get('share') == null || sp.get('share') == []) {
            } else {
              sharelist.add(sp.get('share'));
              colorlist.add(sp.get('color'));
              calnamelist.add(sp.get('calname'));
              if (sp.get('share').toString().contains(name)) {
                sharelist.removeWhere((element) => element == name);
              }
            }
          }
          return sharelist.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '공유그룹이 비어있습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor_shadowcolor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: _pController,
                          itemCount: sharelist.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ContainerDesign(
                                          color: Color(colorlist[index]),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                          fit: FlexFit.loose,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                calnamelist[
                                                                    index],
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Text(
                                                                '캘린더 공유그룹',
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            ],
                                                          )),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ContainerDesign(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ListView.builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: 1,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index2) {
                                                                    return Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () {},
                                                                            child:
                                                                                Container(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    height: 25,
                                                                                    width: 25,
                                                                                    child: Text(sharelist[index][index2].toString().substring(0, 1), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(100),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    sharelist[index][index2],
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: TextColor()),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    ' 외 ' + sharelist[index].length.toString() + '명',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: TextColor()),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    );
                                                                  })
                                                            ],
                                                          ),
                                                          color:
                                                              BGColor_shadowcolor()),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ));
                          }),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SmoothPageIndicator(
                            controller: _pController,
                            count: calnamelist.length,
                            effect: ExpandingDotsEffect(
                                dotHeight: 10,
                                dotWidth: 10,
                                dotColor: Colors.grey,
                                activeDotColor: Colors.purple.shade100),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator())],
              ));
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  '공유그룹이 비어있습니다.',
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    color: TextColor_shadowcolor(),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  G_Container1(double height) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('전체인원',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: TextColor(),
              )),
          const SizedBox(
            height: 10,
          ),
          G_Container1_body()
        ],
      ),
    );
  }

  G_Container1_body() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('PeopleList').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          friendnamelist.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            if (sp.id == name) {
              for (int i = 0; i < sp.get('friends').length; i++) {
                friendnamelist.add(sp.get('friends')[i]);
              }
            }
          }
          return friendnamelist.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '친구리스트가 비어있습니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor_shadowcolor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: friendnamelist.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 25,
                                        width: 25,
                                        child: Text(
                                            friendnamelist[index]
                                                .toString()
                                                .substring(0, 1),
                                            style: TextStyle(
                                                color: BGColor_shadowcolor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        decoration: BoxDecoration(
                                          color: TextColor_shadowcolor(),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        friendnamelist[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                            color: TextColor()),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator())],
              ));
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  '친구리스트가 비어있습니다.',
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 3,
                    color: TextColor_shadowcolor(),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
