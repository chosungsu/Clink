import 'dart:async';
import 'dart:math';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/HomeView.dart';
import 'package:clickbyme/UI/Home/secondContentNet/ShowTips.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:new_version/new_version.dart';
import 'package:badges/badges.dart';
import '../DB/SpaceContent.dart';
import '../DB/Category.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/Widgets/ViewSet.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../sheets/readycontent.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.secondname}) : super(key: key);
  final String secondname;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  bool isresponsive = false;
  int currentPage = 0;
  int categorynumber = 0;
  List<SpaceContent> sc = [];
  late DateTime Date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final draw = Get.put(navibool());
  List contentmy = [];
  List contentshare = [];
  String name = Hive.box('user_info').get('id');
  String name_second = Hive.box('user_info').get('id').toString().length > 5
      ? Hive.box('user_info').get('id').toString().substring(0, 4)
      : Hive.box('user_info').get('id').toString().substring(0, 2);
  String email_first =
      Hive.box('user_info').get('email').toString().substring(0, 3);
  String email_second = Hive.box('user_info')
      .get('email')
      .toString()
      .split('@')[1]
      .substring(0, 2);
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  static final List<Category> fillcategory = [];
  late final PageController _pController;
  //프로 버전 구매시 사용하게될 코드
  bool isbought = false;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();
  var newversion;
  var status;
  bool sameversion = true;
  List updateid = [];
  bool isread = false;
  final notilist = Get.put(notishow());
  List updatefriends = [];
  String docid = '';
  final peopleadd = Get.put(PeopleAdd());

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 1);

    firestore.collection('User').doc(name).get().then((value) {
      if (value.exists) {
        peopleadd.secondnameset(value.data()!['subname']);
      }
    });

    /*firestore.collection('CalendarDataBase').get().then((value) {
      List valueid = [];
      final List<bool> _ischecked_alarmslist = [false, false];
      for (int i = 0; i < value.docs.length; i++) {
        valueid.add(value.docs[i].id);
      }
      for (int j = 0; j < valueid.length; j++) {
        firestore
            .collection('CalendarDataBase')
            .doc(valueid[j])
            .collection('AlarmTable')
            .doc('sungsu cho')
            .set({
          'alarmtype': _ischecked_alarmslist,
          'alarmhour': '99',
          'alarmminute': '99',
          'alarmmake': false,
          'calcode': valueid[j]
        }, SetOptions(merge: true));
        firestore
            .collection('CalendarDataBase')
            .doc(valueid[j])
            .collection('AlarmTable')
            .doc('조성수')
            .delete();
      }
    });*/
    docid = Hive.box('user_setting').get('usercode');

    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
    isdraweropen = draw.drawopen;

    if (draw.drawopen == true) {
      setState(() {
        xoffset = 50;
        yoffset = 0;
      });
    } else {
      setState(() {
        xoffset = 0;
        yoffset = 0;
      });
    }
    firestore
        .collection('HomeViewCategories')
        .doc(Hive.box('user_setting').get('usercode'))
        .get()
        .then((value) {
      peopleadd.defaulthomeviewlist.clear();
      peopleadd.userviewlist.clear();
      if (value.exists) {
        print(1);
        for (int i = 0; i < value.data()!['viewcategory'].length; i++) {
          peopleadd.defaulthomeviewlist.add(value.data()!['viewcategory'][i]);
        }
        for (int j = 0; j < value.data()!['hidecategory'].length; j++) {
          peopleadd.userviewlist.add(value.data()!['hidecategory'][j]);
        }
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      } else {
        print(2);
        peopleadd.defaulthomeviewlist.add(defaulthomeviewlist);
        peopleadd.userviewlist.add(userviewlist);
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      }
    });
    firestore.collection('AppNoticeByUsers').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['username'] == name ||
            element.data()['sharename'].toString().contains(name)) {
          updateid.add(element.data()['read']);
        }
      }
      if (updateid.contains('no')) {
        isread = false;
        notilist.isread = false;
      } else {
        isread = true;
        notilist.isread = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: GetBuilder<navibool>(
              init: navibool(),
              builder: (_) => draw.navi == 0
                  ? (draw.drawopen == true
                      ? Stack(
                          children: [
                            Container(
                              width: 80,
                              child: DrawerScreen(
                                  index: Hive.box('user_setting')
                                      .get('page_index')),
                            ),
                            HomeUi(
                              _pController,
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            HomeUi(
                              _pController,
                            ),
                          ],
                        ))
                  : Stack(
                      children: [
                        HomeUi(
                          _pController,
                        ),
                      ],
                    ),
            )));
  }

  HomeUi(
    PageController pController,
  ) {
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
                  //decoration: BoxDecoration(color: colorselection),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              child: Text('Habit Tracker',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 25,
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                            /*GetBuilder<notishow>(
                                                builder: (_) => notilist
                                                            .isread ==
                                                        true
                                                    ? IconBtn(
                                                        color: TextColor(),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Get.to(
                                                                  () =>
                                                                      NotiAlarm(),
                                                                  transition:
                                                                      Transition
                                                                          .zoom);
                                                            },
                                                            icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons
                                                                      .notifications_none,
                                                                  size: 30,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
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
                                                    : IconBtn(
                                                        color: TextColor(),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Get.to(
                                                                () =>
                                                                    NotiAlarm(),
                                                                transition:
                                                                    Transition
                                                                        .zoom);
                                                          },
                                                          icon: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 30,
                                                              height: 30,
                                                              child: Badge(
                                                                  child:
                                                                      NeumorphicIcon(
                                                                Icons
                                                                    .notifications_none,
                                                                size: 30,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    surfaceIntensity:
                                                                        0.5,
                                                                    depth: 2,
                                                                    color:
                                                                        TextColor(),
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ))),
                                                        )))*/
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
                              child: SingleChildScrollView(child:
                                  StatefulBuilder(
                                      builder: (_, StateSetter setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    children: [
                                      H_Container_0_eventcompany(
                                          height, _pController),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      H_Container_0(height, _pController),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      H_Container_2(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      H_Container_1(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GetBuilder<PeopleAdd>(
                                          builder: (_) => ViewSet(
                                              peopleadd.defaulthomeviewlist,
                                              peopleadd.userviewlist)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      H_Container_4(height),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                );
                              })),
                            ),
                          )),
                    ],
                  )),
            ),
          ),
        ));
  }

  H_Container_0_eventcompany(double height, PageController pController) {
    //프로버전 구매시 보이지 않게 함
    return EventApps(
      height: height,
      pageController: pController,
      pageindex: 0,
    );
  }

  H_Container_0(double height, PageController pController) {
    //프로버전 구매시 보이지 않게 함
    return SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowTips(
            height: height,
            pageController: pController,
            pageindex: 0,
          ),
        ],
      ),
    );
  }

  H_Container_1(double height) {
    //프로버전 구매시 보이지 않게 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  H_Container_2(double height) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: ContainerDesign(
            color: BGColor(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  childAspectRatio: 2 / 1,
                  children: List.generate(2, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        index == 0
                            ? GestureDetector(
                                onTap: () async {
                                  final reloadpage = await Get.to(
                                      () => const ChooseCalendar(
                                            isfromwhere: 'home',
                                            index: 0,
                                          ),
                                      transition: Transition.rightToLeft);
                                  if (reloadpage) {
                                    GoToMain(context);
                                  }
                                },
                                child: SizedBox(
                                  height: isresponsive == true ? 110 : 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.calendar_month,
                                          size: isresponsive == true ? 50 : 25,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: TextColor(),
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                      SizedBox(
                                        height: isresponsive == true ? 40 : 30,
                                        child: Center(
                                          child: Text('캘린더',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  final reloadpage = await Get.to(
                                      () => const DayNoteHome(
                                            title: '',
                                            isfromwhere: 'home',
                                          ),
                                      transition: Transition.rightToLeft);
                                  if (reloadpage) {
                                    GoToMain(context);
                                  }
                                },
                                child: SizedBox(
                                  height: isresponsive == true ? 110 : 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.description,
                                          size: isresponsive == true ? 50 : 25,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: TextColor(),
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                      SizedBox(
                                        height: isresponsive == true ? 40 : 30,
                                        child: Center(
                                          child: Text('일상메모',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    );
                  }),
                )
              ],
            )));
  }

  H_Container_4(double height) {
    //프로버전 구매시 보이지 않게 함
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => HomeView(), transition: Transition.zoom);
                },
                child: Text('홈뷰설정',
                    style: TextStyle(
                        color: TextColor_shadowcolor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
              VerticalDivider(
                thickness: 1,
                color: TextColor_shadowcolor(),
              ),
              InkWell(
                onTap: () {
                  showreadycontent(context);
                },
                child: Text('문의하기',
                    style: TextStyle(
                        color: TextColor_shadowcolor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
            ],
          ),
        )
      ],
    );
  }
}
