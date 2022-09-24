import 'package:async/async.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/userinfotalk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/secondContentNet/PeopleGroup.dart';
import '../sheets/addgroupmember.dart';
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
  final cal_share_person = Get.put(PeopleAdd());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  bool showsharegroups = false;
  late final PageController _pController;
  final searchNode = FocusNode();
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    isdraweropen = draw.drawopen;
    _pController = PageController(initialPage: 0, viewportFraction: 1);
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
                                              child: Text('피플',
                                                  style: TextStyle(
                                                    fontSize:
                                                        secondTitleTextsize(),
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            IconBtn(
                                                color: TextColor(),
                                                child: IconButton(
                                                    onPressed: () async {
                                                      addgroupmember(
                                                          context,
                                                          searchNode,
                                                          _controller,
                                                          cal_share_person
                                                              .code);
                                                    },
                                                    icon: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                        height: 30,
                                                        child: NeumorphicIcon(
                                                          Icons.add,
                                                          size: 30,
                                                          style: NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              surfaceIntensity:
                                                                  0.5,
                                                              depth: 2,
                                                              color:
                                                                  TextColor(),
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ))))
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
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('공유그룹',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor(),
                    )),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (showsharegroups) {
                      showsharegroups = false;
                    } else {
                      showsharegroups = true;
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: NeumorphicIcon(
                    showsharegroups ? Icons.expand_less : Icons.expand_more,
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
          !showsharegroups
              ? Text(
                  '우측아이콘을 클릭하여 공유그룹 보기',
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: TextColor(),
                  ),
                )
              : Text(
                  '카드를 길게클릭하여 정보확인',
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: TextColor(),
                  ),
                ),
          showsharegroups ? G_Container0_body() : const SizedBox(),
          const Divider(
            height: 10,
            color: Colors.grey,
            thickness: 1,
            indent: 10.0,
            endIndent: 10.0,
          ),
        ],
      ),
    );
  }

  Stream<List<QuerySnapshot>> combineStream() {
    Stream<QuerySnapshot> stream1 = firestore
        .collection('CalendarSheetHome')
        .where('madeUser', isEqualTo: cal_share_person.secondname)
        .snapshots();
    Stream<QuerySnapshot> stream2 = firestore
        .collection('ShareHome')
        .where('showingUser', isEqualTo: cal_share_person.secondname)
        .snapshots();

    return StreamZip([stream1, stream2]);
  }

  G_Container0_body() {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: combineStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          sharelist.clear();
          colorlist.clear();
          calnamelist.clear();
          List<DocumentSnapshot> documentSnapshot = [];
          final valuespace = snapshot.data!.toList();
          for (var sp in valuespace) {
            documentSnapshot.addAll(sp.docs);
            print(sp.docs.toList());
          }
          for (var sp2 in documentSnapshot) {
            if (sp2.get('share') == null ||
                sp2.get('share').toString() == '[]') {
            } else {
              sharelist.add(sp2.get('share'));
              colorlist.add(sp2.get('color'));
              calnamelist.add(sp2.get('calname'));
              if (sp2
                  .get('share')
                  .toString()
                  .contains(cal_share_person.secondname)) {
                sharelist.removeWhere(
                    (element) => element == cal_share_person.secondname);
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
                                        FocusedMenuHolder(
                                            child: ContainerDesign(
                                              color: Color(colorlist[index]),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
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
                                                              fit:
                                                                  FlexFit.loose,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    calnamelist[
                                                                        index],
                                                                    softWrap:
                                                                        true,
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
                                                                    softWrap:
                                                                        true,
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
                                                              child:
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              height: 25,
                                                                              width: 25,
                                                                              child: Text(sharelist.isNotEmpty ? sharelist[index][0].toString().substring(0, 1) : '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              sharelist.isNotEmpty ? sharelist[index][0] : '',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: TextColor()),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              sharelist.isNotEmpty ? ' 외 ' + (sharelist[index].length - 1).toString() + '명' : '공유인원 없음',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: TextColor()),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
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
                                            onPressed: () {},
                                            duration:
                                                const Duration(seconds: 0),
                                            animateMenuItems: true,
                                            menuOffset: 20,
                                            menuBoxDecoration: BoxDecoration(
                                                color: BGColor(),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.zero)),
                                            bottomOffsetHeight: 10,
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            openWithTap: false,
                                            menuItems: [
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.chevron_right,
                                                    size: 30,
                                                  ),
                                                  title: Text('바로확인',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () {
                                                    Get.to(
                                                      () => DayContentHome(
                                                        title: documentSnapshot[
                                                                index]
                                                            .id,
                                                        share: documentSnapshot[
                                                            index]['share'],
                                                        origin:
                                                            documentSnapshot[
                                                                    index]
                                                                ['madeUser'],
                                                        theme: documentSnapshot[
                                                                index]
                                                            ['themesetting'],
                                                        view: documentSnapshot[
                                                                index]
                                                            ['viewsetting'],
                                                        calname:
                                                            documentSnapshot[
                                                                    index]
                                                                ['calname'],
                                                      ),
                                                      transition: Transition
                                                          .rightToLeft,
                                                    );
                                                  }),
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.share,
                                                    size: 30,
                                                  ),
                                                  title: Text('공유자 검색',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () {
                                                    //공유자 검색
                                                    Hive.box('user_setting')
                                                        .put(
                                                            'share_cal_person',
                                                            documentSnapshot[
                                                                    index]
                                                                ['share']);

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      Get.to(
                                                        () => PeopleGroup(
                                                          doc: documentSnapshot[
                                                                  index]
                                                              .id
                                                              .toString(),
                                                          when:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['date'],
                                                          type:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['type'],
                                                          color:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['color'],
                                                          nameid:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['calname'],
                                                          share:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['share'],
                                                          made:
                                                              documentSnapshot[
                                                                      index]
                                                                  ['madeUser'],
                                                          allow_share:
                                                              documentSnapshot[
                                                                      index][
                                                                  'allowance_share'],
                                                          allow_change_set:
                                                              documentSnapshot[
                                                                      index][
                                                                  'allowance_change_set'],
                                                          themesetting:
                                                              documentSnapshot[
                                                                      index][
                                                                  'themesetting'],
                                                          viewsetting:
                                                              documentSnapshot[
                                                                      index][
                                                                  'viewsetting'],
                                                        ),
                                                        transition:
                                                            Transition.downToUp,
                                                      );
                                                    });
                                                  }),
                                            ]),
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
          Text('전체',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: contentTitleTextsize(),
                color: TextColor(),
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            '유저이름을 클릭하여 프로필 확인',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: TextColor(),
            ),
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
          friendnamelist.sort(((a, b) {
            return a.toString().compareTo(b.toString());
          }));
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  userinfotalk(context, index, friendnamelist);
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    decoration: BoxDecoration(
                                        color: BGColor(),
                                        borderRadius: BorderRadius.circular(0),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.blue.shade200)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: 25,
                                              width: 25,
                                              child: Text(
                                                  friendnamelist[index]
                                                      .toString()
                                                      .substring(0, 1),
                                                  style: TextStyle(
                                                      color:
                                                          BGColor_shadowcolor(),
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                friendnamelist[index],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                    color: TextColor()),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
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
