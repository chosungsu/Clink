import 'package:async/async.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_redirect/store_redirect.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/secondContentNet/PeopleGroup.dart';
import '../UI/Setting/ShowLicense.dart';
import '../UI/Setting/UserDetails.dart';
import '../sheets/addgroupmember.dart';
import '../sheets/readycontent.dart';
import '../sheets/userinfo_draggable.dart';
import '../sheets/userinfotalk.dart';
import 'DrawerScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool login_state = false;
  String secondname = '';
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  final draw = Get.put(navibool());
  var _controller = TextEditingController();
  late final PageController _pController1;
  late final PageController _pController2;
  int currentPage = 1;
  bool showsharegroups = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> list_app_setting = <String>[
    '배경색',
    '글자크기',
    '메뉴바 위치',
  ];
  final List<String> list_user_setting = <String>[
    '개인정보 수집 및 이용 동의',
    '라이선스',
  ];
  String appuserversion = '';
  String appstoreversion = '';
  final searchNode = FocusNode();
  String name = Hive.box('user_info').get('id');
  final peopleadd = Get.put(PeopleAdd());
  final friendnamelist = [];
  final calnamelist = [];
  final sharelist = [];
  final colorlist = [];
  late PackageInfo info;
  String versioninfo = '';
  int pagesetnumber = 0;
  late FToast fToast;
  String usercode = Hive.box('user_setting').get('usercode');

  @override
  void initState() {
    super.initState();
    firestore
        .collection('User')
        .where('name', isEqualTo: Hive.box('user_info').get('id'))
        .get()
        .then(
      (value) {
        peopleadd.code = value.docs[0]['code'];
      },
    );
    fToast = FToast();
    fToast.init(context);
    Hive.box('user_setting').put('page_index', 3);
    _controller = TextEditingController();
    isdraweropen = draw.drawopen;
    firestore.collection('User').doc(name).get().then((value) {
      if (value.exists) {
        //peopleadd.secondname = value.data()!['subname'];
        peopleadd.secondnameset(value.data()!['subname']);
      }
    });
    _pController1 = PageController(initialPage: 0, viewportFraction: 1);
    _pController2 = PageController(initialPage: 0, viewportFraction: 1);
    //peopleadd.secondnameset(name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _pController2.dispose();
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
                          index: Hive.box('user_setting').get('page_index')),
                    ),
                    ProfileBody(context),
                  ],
                )
              : Stack(
                  children: [
                    ProfileBody(context),
                  ],
                ))
          : Stack(
              children: [
                ProfileBody(context),
              ],
            ),
    ));
  }

  Widget ProfileBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
        transform: Matrix4.translationValues(xoffset, yoffset, 0)
          ..scale(scalefactor),
        duration: const Duration(milliseconds: 250),
        child: GetBuilder<navibool>(
          builder: (_) => GestureDetector(
            onTap: () {
              searchNode.unfocus();
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
                                              child: Text('',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 25,
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
                              return ExpandablePageView.builder(
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                controller: _pController2,
                                itemCount: currentPage,
                                onPageChanged: ((value) {
                                  setState(() {
                                    showsharegroups = false;
                                    _getAppInfo();
                                    if (value == 0) {
                                      currentPage = 1;
                                    }
                                  });
                                }),
                                itemBuilder: ((context, index) {
                                  return index == 0
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              S_Container0(height),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              S_Container1(height),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              OptionChoice(height, context),
                                              //S_Container2(),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ))
                                      : (pagesetnumber == 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  T_Container(height),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  T_Container0(height),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  /*G_Container1(height),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),*/
                                                ],
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  G_Container(height),
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
                                              )));
                                }),
                              );
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

  T_Container(double height) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_double_arrow_right,
            color: TextColor_shadowcolor(),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text('왼쪽으로 스와이프하여 설정페이지 이동',
                maxLines: 2,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: TextColor_shadowcolor(),
                    overflow: TextOverflow.fade)),
          )
        ],
      ),
    );
  }

  Future<void> _getAppInfo() async {
    info = await PackageInfo.fromPlatform();
    versioninfo = info.version;
  }

  T_Container0(double height) {
    final List eventtitle = [];
    final List eventcontent = [];
    final List eventsmallcontent = [];
    final List dates = [];
    return SizedBox(
        height: MediaQuery.of(context).size.height - 300,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FutureBuilder(
                future: firestore
                    .collection("AppNoticeByCompany")
                    .orderBy('date', descending: true)
                    .limit(5)
                    .get()
                    .then(((QuerySnapshot querySnapshot) => {
                          eventtitle.clear(),
                          eventcontent.clear(),
                          eventsmallcontent.clear(),
                          dates.clear(),
                          querySnapshot.docs.forEach((doc) {
                            eventtitle.add(doc.get('title'));
                            for (int i = 0;
                                i < doc.get('content').length;
                                i++) {
                              eventcontent.add(doc.get('content')[i]);
                            }
                            for (int i = 0;
                                i < doc.get('summaries').length;
                                i++) {
                              eventsmallcontent.add(doc.get('summaries')[i]);
                            }
                            dates.add(doc.get('date'));
                          })
                        })),
                builder: (context, future) => future.connectionState ==
                        ConnectionState.waiting
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height - 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: NeumorphicText(
                                '릴리즈 노트를 불러오고 있습니다...',
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  color: TextColor(),
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
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: eventtitle.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: ContainerDesign(
                                    color: Colors.blue.shade200,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  backgroundColor: BGColor(),
                                                  child: Icon(
                                                    Icons.new_releases,
                                                    color:
                                                        TextColor_shadowcolor(),
                                                  ),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                eventtitle[index].toString() +
                                                    ' 릴리즈노트',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                    color: TextColor()),
                                              ),
                                            ),
                                            versioninfo !=
                                                    eventtitle[index].toString()
                                                ? InkWell(
                                                    onTap: () {
                                                      StoreRedirect.redirect(
                                                        androidAppId:
                                                            'com.jss.habittracker', // Android app bundle package name
                                                      );
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor(),
                                                          child: Icon(
                                                            Icons.play_for_work,
                                                            color: Colors
                                                                .red.shade400,
                                                          ),
                                                        )),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Snack.toast(
                                                          title:
                                                              '최신버전이거나 지난버전입니다.',
                                                          color: Colors.white,
                                                          backgroundcolor:
                                                              Colors
                                                                  .greenAccent,
                                                          fToast: fToast);
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              BGColor(),
                                                          child: Icon(
                                                            Icons.verified,
                                                            color: Colors
                                                                .green.shade400,
                                                          ),
                                                        ))),
                                          ],
                                        ),
                                        Divider(
                                          height: 20,
                                          color: TextColor_shadowcolor(),
                                          thickness: 1,
                                          indent: 10.0,
                                          endIndent: 10.0,
                                        ),
                                        ListView.builder(
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: eventcontent.length,
                                            itemBuilder: ((context, index2) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                BGColor(),
                                                            child: Icon(
                                                              Icons.tag,
                                                              color:
                                                                  TextColor_shadowcolor(),
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          eventcontent[index2],
                                                          maxLines: 2,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize(),
                                                              color:
                                                                  TextColor(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    eventsmallcontent[index2],
                                                    maxLines: 3,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize(),
                                                        color: TextColor(),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            })),
                                        Divider(
                                          height: 20,
                                          color: TextColor_shadowcolor(),
                                          thickness: 1,
                                          indent: 10.0,
                                          endIndent: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                dates[index].toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: contentTextsize(),
                                                    color: TextColor()),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }),
              )
            ],
          ),
        ));
  }

  G_Container(double height) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_double_arrow_right,
            color: TextColor_shadowcolor(),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text('왼쪽으로 스와이프하여 설정페이지 이동',
                maxLines: 2,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: TextColor_shadowcolor(),
                    overflow: TextOverflow.fade)),
          )
        ],
      ),
    );
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
        .collection('CalendarSheetHome_update')
        .where('madeUser', isEqualTo: usercode)
        .snapshots();
    Stream<QuerySnapshot> stream2 = firestore
        .collection('ShareHome_update')
        .where('showingUser', isEqualTo: usercode)
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
          }
          for (var sp2 in documentSnapshot) {
            if (sp2.get('share') == null ||
                sp2.get('share').toString() == '[]') {
            } else {
              sharelist.add(sp2.get('share'));
              colorlist.add(sp2.get('color'));
              calnamelist.add(sp2.get('calname'));
              if (sp2.get('share').toString().contains(peopleadd.secondname)) {
                sharelist
                    .removeWhere((element) => element == peopleadd.secondname);
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
                          controller: _pController1,
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
                            controller: _pController1,
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

  S_Container0(double height) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('설정',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: secondTitleTextsize(),
                color: TextColor(),
              )),
        ],
      ),
    );
  }

  S_Container1(double height) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: UserDetails(
              height: height,
              controller: _controller,
              node: searchNode,
            ),
          )
        ],
      ),
    );
  }

  S_Container2() {
    //프로버전 구매시 보이지 않게 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  OptionChoice(double height, BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OptView1(),
            const SizedBox(
              height: 20,
            ),
            OptView2(),
            const SizedBox(
              height: 20,
            ),
            OptView3(),
            const SizedBox(
              height: 20,
            ),
            OptView4(),
            const SizedBox(
              height: 20,
            ),
            OptView5(),
          ],
        ),
      ),
    );
  }

  OptView1() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: TextColor_shadowcolor(),
                    foregroundColor: TextColor_shadowcolor(),
                    child: Icon(
                      Icons.tune,
                      color: BGColor_shadowcolor(),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                '앱 UI 설정',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
          Opt1_body()
        ],
      ),
    );
  }

  Opt1_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list_app_setting.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list_app_setting[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: TextColor()),
                      ),
                      index == 0
                          ? SizedBox(
                              height: 30,
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                Hive.box('user_setting').put(
                                                    'which_color_background',
                                                    0);
                                                draw.setnavicolor();
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Hive.box('user_setting').get(
                                                              'which_color_background') ==
                                                          0 ||
                                                      Hive.box('user_setting').get(
                                                              'which_color_background') ==
                                                          null
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: NeumorphicIcon(
                                                        Icons.check,
                                                        size: 25,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            color: Colors
                                                                .blue.shade300,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ))),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                Hive.box('user_setting').put(
                                                    'which_color_background',
                                                    1);
                                                draw.setnavicolor();
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Hive.box('user_setting').get(
                                                          'which_color_background') ==
                                                      1
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: NeumorphicIcon(
                                                        Icons.check,
                                                        size: 25,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            color: Colors
                                                                .blue.shade300,
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ))),
                                ],
                              ),
                            )
                          : (index == 1
                              ? SizedBox(
                                  height: 30,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_text_size',
                                                            0);
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting').get(
                                                                            'which_text_size') ==
                                                                        0 ||
                                                                    Hive.box('user_setting').get(
                                                                            'which_text_size') ==
                                                                        null
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons.format_size,
                                                      size: 15,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_text_size',
                                                            1);
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_text_size') ==
                                                                    1
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons.text_fields,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_menu_pick',
                                                            0);
                                                    draw.setnavi();
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting')
                                                                        .get(
                                                                            'which_menu_pick') ==
                                                                    0
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons
                                                          .align_horizontal_left,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Hive.box('user_setting')
                                                        .put('which_menu_pick',
                                                            1);
                                                    draw.setnavi();
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      BGColor_shadowcolor(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Hive.box('user_setting').get(
                                                                            'which_menu_pick') ==
                                                                        1 ||
                                                                    Hive.box('user_setting').get(
                                                                            'which_menu_pick') ==
                                                                        null
                                                                ? Colors.blue
                                                                    .shade400
                                                                : BGColor_shadowcolor())),
                                                    alignment: Alignment.center,
                                                    child: NeumorphicIcon(
                                                      Icons
                                                          .align_vertical_bottom,
                                                      size: 25,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          color: Colors
                                                              .blue.shade300,
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                ))
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView2() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: TextColor_shadowcolor(),
                    foregroundColor: TextColor_shadowcolor(),
                    child: Icon(
                      Icons.help_center,
                      color: BGColor_shadowcolor(),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                '도움 및 문의',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
          Opt2_body()
        ],
      ),
    );
  }

  Opt2_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    showreadycontent(context);
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '개발자에게 문의하기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView3() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: TextColor_shadowcolor(),
                    foregroundColor: TextColor_shadowcolor(),
                    child: Icon(
                      Icons.help_center,
                      color: BGColor_shadowcolor(),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                '실험실',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
          Opt3_body()
        ],
      ),
    );
  }

  Opt3_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      pagesetnumber = 0;
                      currentPage++;
                      _pController2.animateToPage(1,
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeIn);
                    });
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '넥스트버전',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  OptView4() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: TextColor_shadowcolor(),
                    foregroundColor: TextColor_shadowcolor(),
                    child: Icon(
                      Icons.groups,
                      color: BGColor_shadowcolor(),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                '친구추가',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
          Opt4_body()
        ],
      ),
    );
  }

  Opt4_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: [
                index == 0
                    ? GestureDetector(
                        onTap: () async {},
                        child: GetBuilder<PeopleAdd>(
                          builder: (_) => SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: '개인코드',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color: TextColor()),
                                  ),
                                  const WidgetSpan(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  WidgetSpan(
                                      child: GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: peopleadd.code));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.content_copy,
                                          color: TextColor_shadowcolor(),
                                        ),
                                        Text(
                                          '복사',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: contentTextsize(),
                                              decoration:
                                                  TextDecoration.underline,
                                              color: TextColor_shadowcolor()),
                                        ),
                                      ],
                                    ),
                                  )),
                                ])),
                                Text(peopleadd.code,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize())),
                              ],
                            ),
                          ),
                        ))
                    : (index == 1
                        ? GestureDetector(
                            onTap: () async {
                              addgroupmember(context, searchNode, _controller,
                                  peopleadd.code);
                            },
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '친구검색하기',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color: TextColor()),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: TextColor(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                pagesetnumber = 1;
                                currentPage++;
                                _pController2.animateToPage(1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              });
                            },
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '친구목록',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                        color: TextColor()),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: TextColor(),
                                  ),
                                ],
                              ),
                            ),
                          ))
              ],
            );
          }),
    );
  }

  OptView5() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: TextColor_shadowcolor(),
                    foregroundColor: TextColor_shadowcolor(),
                    child: Icon(
                      Icons.portrait,
                      color: BGColor_shadowcolor(),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                '약관 및 정책',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: TextColor()),
              ),
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
          Opt5_body()
        ],
      ),
    );
  }

  Opt5_body() {
    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: list_user_setting.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    index == 0
                        ? userinfo_draggable(context)
                        : Get.to(() => ShowLicense(),
                            transition: Transition.rightToLeft);
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list_user_setting[index],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: TextColor()),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: TextColor(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
