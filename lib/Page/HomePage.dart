import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/LocalNotiPlatform/localnotification.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/SheetGetx/Spacesetting.dart';
import 'package:clickbyme/Tool/SheetGetx/navibool.dart';
import 'package:clickbyme/Tool/SheetGetx/onequeform.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/HomeView.dart';
import 'package:clickbyme/UI/Home/secondContentNet/EventShowCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shimmer/shimmer.dart';
import '../DB/SpaceContent.dart';
import '../DB/Category.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/SheetGetx/SpaceShowRoom.dart';
import '../Tool/SheetGetx/category.dart';
import '../Tool/ShimmerDesign/Shimmer_home.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/PayHome.dart';
import '../UI/Home/firstContentNet/RoutineHome.dart';
import '../sheets/addWhole.dart';
import '../sheets/readycontent.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;
  int navi = 0;
  int currentPage = 0;
  int categorynumber = 0;
  List<SpaceContent> sc = [];
  late DateTime Date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final spaceset = Get.put(Spacesetting());
  final draw = Get.put(navibool());
  List showspacelist = [];
  List content = [];
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
  String docid = '';
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

  @override
  void initState() {
    super.initState();
    localnotification.requestPermission();
    Hive.box('user_setting').put('page_index', 0);
    spaceset.setspace();
    showspacelist = spaceset.space;
    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
    navi = NaviWhere();
    isdraweropen = draw.drawopen;
    docid = email_first + email_second + name_second;
    firestore
        .collection('HomeViewCategories')
        .where('usercode', isEqualTo: docid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
      } else {
        firestore.collection('HomeViewCategories').doc(docid).set({
          'usercode': value.docs.isEmpty ? docid : value.docs[0].id,
          'viewcategory': defaulthomeviewlist,
          'hidecategory': userviewlist
        }, SetOptions(merge: true));
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: navi == 0
                ? (draw.drawopen == true
                    ? Stack(
                        children: [
                          Container(
                            width: 50,
                            child: DrawerScreen(),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            SizedBox(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  navi == 0
                                      ? SizedBox(
                                          width: 50,
                                          child: draw.drawopen == true
                                              ? InkWell(
                                                  onTap: () {
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
                                                  child: Container(
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
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  ))
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      xoffset = 50;
                                                      yoffset = 0;
                                                      scalefactor = 1;
                                                      isdraweropen = true;
                                                      draw.setopen();
                                                      Hive.box('user_setting')
                                                          .put('page_opened',
                                                              true);
                                                    });
                                                  },
                                                  child: Container(
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
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  )))
                                      : const SizedBox(),
                                  SizedBox(
                                      width: navi == 0
                                          ? MediaQuery.of(context).size.width -
                                              60
                                          : MediaQuery.of(context).size.width -
                                              10,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 20),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text('Habit Tracker',
                                                    style: GoogleFonts.lobster(
                                                      fontSize: 25,
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Get.to(NotiAlarm());
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    child: NeumorphicIcon(
                                                      Icons.notifications_none,
                                                      size: 30,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          surfaceIntensity: 0.5,
                                                          depth: 2,
                                                          color: TextColor(),
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  )),
                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
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
                                      H_Container_3(height),
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

  H_Container_0(double height, PageController pController) {
    //프로버전 구매시 보이지 않게 함
    return SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventShowCard(
              height: height,
              pageController: pController,
              pageindex: 0,
              buy: isbought),
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
      height: 80,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width - 40,
              child: ContainerDesign(
                  color: BGColor(),
                  child: Column(
                    children: [
                      //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                      //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                      SizedBox(
                          height: 60,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            shrinkWrap: true,
                            childAspectRatio: 2 / 1,
                            children: List.generate(3, (index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  index == 0
                                      ? GestureDetector(
                                          onTap: () async {
                                            final reloadpage = await Get.to(
                                                () => ChooseCalendar(),
                                                transition:
                                                    Transition.rightToLeft);
                                            print(reloadpage);
                                            if (reloadpage) {
                                              H_Container_3(height);
                                            }
                                          },
                                          child: SizedBox(
                                            height: 55,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 25,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width: 25,
                                                    height: 25,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: NeumorphicIcon(
                                                        Icons.calendar_month,
                                                        size: 25,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text('캘린더',
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : (index == 1
                                          ? GestureDetector(
                                              onTap: () async {
                                                final reloadpage = await Get.to(
                                                    () => const DayNoteHome(
                                                          title: '',
                                                        ),
                                                    transition:
                                                        Transition.rightToLeft);
                                                if (reloadpage) {
                                                  H_Container_3(height);
                                                }
                                              },
                                              child: SizedBox(
                                                height: 55,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        width: 25,
                                                        height: 25,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: NeumorphicIcon(
                                                            Icons.description,
                                                            size: 25,
                                                            style: NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                depth: 2,
                                                                color:
                                                                    TextColor(),
                                                                lightSource:
                                                                    LightSource
                                                                        .topLeft),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: Center(
                                                        child: Text('일상메모',
                                                            style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize())),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                final reloadpage = await Get.to(
                                                    () => const PayHome(),
                                                    transition:
                                                        Transition.rightToLeft);
                                                if (reloadpage) {
                                                  H_Container_3(height);
                                                }
                                              },
                                              child: SizedBox(
                                                  height: 55,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 25,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 25,
                                                          height: 25,
                                                          child: NeumorphicIcon(
                                                            Icons.payment,
                                                            size: 25,
                                                            style: NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                depth: 2,
                                                                color:
                                                                    TextColor(),
                                                                lightSource:
                                                                    LightSource
                                                                        .topLeft),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                        child: Center(
                                                          child: Text('페이스토리',
                                                              style: TextStyle(
                                                                  color:
                                                                      TextColor(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize())),
                                                        ),
                                                      ),
                                                    ],
                                                  ))))
                                ],
                              );
                            }),
                          ))
                    ],
                  )))
        ],
      ),
    );
  }

  H_Container_3(double height) {
    firestore
        .collection('HomeViewCategories')
        .where('usercode', isEqualTo: docid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
      } else {
        firestore.collection('HomeViewCategories').doc(docid).set({
          'usercode': value.docs.isEmpty ? docid : value.docs[0].id,
          'viewcategory': defaulthomeviewlist,
          'hidecategory': userviewlist
        }, SetOptions(merge: true));
      }
    });
    //프로버전 구매시 보이지 않게 함
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('HomeViewCategories')
            .where('usercode', isEqualTo: docid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs[0]['viewcategory'].length,
                itemBuilder: (context, index) {
                  return snapshot.data!.docs[0]['viewcategory'][index]
                              .toString() ==
                          '오늘의 일정'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                              child: Text('오늘의 일정',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize())),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('CalendarDataBase')
                                  .where('OriginalUser', isEqualTo: name)
                                  .where('Date',
                                      isEqualTo: Date.toString().split('-')[0] +
                                          '-' +
                                          Date.toString().split('-')[1] +
                                          '-' +
                                          Date.toString()
                                              .split('-')[2]
                                              .substring(0, 2) +
                                          '일')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  content.clear();
                                  var timsestart, timefinish, codes, todo;
                                  final valuespace = snapshot.data!.docs;
                                  for (var sp in valuespace) {
                                    todo = sp.get('Daytodo');
                                    timsestart = sp.get('Timestart');
                                    timefinish = sp.get('Timefinish');
                                    codes = sp.get('calname');
                                    if (int.parse(timsestart
                                            .toString()
                                            .substring(0, 2)) >=
                                        Date.hour) {
                                      content.add(SpaceContent(
                                          title: todo,
                                          date: timsestart + '-' + timefinish,
                                          calendarcode: codes));
                                    }
                                  }
                                  return ContainerDesign(
                                      child: content.isEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '보여드릴 오늘의 일정이 없습니다.',
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: TextColor(),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: content.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: ListTile(
                                                        onTap: () {},
                                                        horizontalTitleGap: 10,
                                                        dense: true,
                                                        leading: Icon(
                                                          Icons.calendar_month,
                                                          color: TextColor(),
                                                        ),
                                                        subtitle: Text(
                                                            content[index]
                                                                .title,
                                                            style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize())),
                                                        title: Text(
                                                            content[index].date,
                                                            style: TextStyle(
                                                              color:
                                                                  TextColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                );
                                              }),
                                      color: BGColor());
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ContainerDesign(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Center(
                                              child:
                                                  CircularProgressIndicator())
                                        ],
                                      ),
                                      color: BGColor());
                                }
                                return ContainerDesign(
                                    child: content.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: NeumorphicText(
                                                  '보여드릴 오늘의 일정이 없습니다.',
                                                  style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: TextColor(),
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: contentTextsize(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: content.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: ListTile(
                                                      onTap: () {},
                                                      horizontalTitleGap: 10,
                                                      dense: true,
                                                      leading: Icon(
                                                        Icons.calendar_month,
                                                        color: TextColor(),
                                                      ),
                                                      subtitle: Text(
                                                          content[index].title,
                                                          style: TextStyle(
                                                              color:
                                                                  TextColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                      title: Text(
                                                          content[index].date,
                                                          style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              );
                                            }),
                                    color: BGColor());
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : (snapshot.data!.docs[0]['viewcategory'][index]
                                  .toString() ==
                              '공유된 오늘의 일정'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Text('공유된 오늘의 일정',
                                      style: TextStyle(
                                          color: TextColor(),
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTitleTextsize())),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: firestore
                                      .collection('CalendarDataBase')
                                      .where('Date',
                                          isEqualTo: Date.toString()
                                                  .split('-')[0] +
                                              '-' +
                                              Date.toString().split('-')[1] +
                                              '-' +
                                              Date.toString()
                                                  .split('-')[2]
                                                  .substring(0, 2) +
                                              '일')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List nameList = [];
                                      var timsestart, timefinish, codes, todo;
                                      final valuespace = snapshot.data!.docs;
                                      for (var sp in valuespace) {
                                        nameList = sp.get('Shares');
                                        todo = sp.get('Daytodo');
                                        timsestart = sp.get('Timestart');
                                        timefinish = sp.get('Timefinish');
                                        codes = sp.get('calname');
                                        for (int i = 0;
                                            i < nameList.length;
                                            i++) {
                                          if (nameList[i].contains(name)) {
                                            if (int.parse(timsestart
                                                    .toString()
                                                    .substring(0, 2)) >=
                                                Date.hour) {
                                              content.add(SpaceContent(
                                                  title: todo,
                                                  date: timsestart +
                                                      '-' +
                                                      timefinish,
                                                  calendarcode: codes));
                                            }
                                          }
                                        }
                                      }
                                      return ContainerDesign(
                                          child: content.isEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '보여드릴 공유된 오늘의 일정이 없습니다.',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: TextColor(),
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize:
                                                              contentTextsize(),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: content.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: ListTile(
                                                            onTap: () {},
                                                            horizontalTitleGap:
                                                                10,
                                                            dense: true,
                                                            leading: Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            subtitle: Text(
                                                                content[index]
                                                                    .title,
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize())),
                                                            title: Text(
                                                                content[index]
                                                                    .date,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      TextColor(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                          color: BGColor());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ContainerDesign(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Center(
                                                  child:
                                                      CircularProgressIndicator())
                                            ],
                                          ),
                                          color: BGColor());
                                    }
                                    return ContainerDesign(
                                        child: content.isEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: NeumorphicText(
                                                      '보여드릴 공유된 오늘의 일정이 없습니다.',
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 3,
                                                        color: TextColor(),
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            contentTextsize(),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: content.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: ListTile(
                                                          onTap: () {},
                                                          horizontalTitleGap:
                                                              10,
                                                          dense: true,
                                                          leading: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: TextColor(),
                                                          ),
                                                          subtitle: Text(
                                                              content[index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  color:
                                                                      TextColor(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize())),
                                                          title: Text(
                                                              content[index]
                                                                  .date,
                                                              style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                        color: BGColor());
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : (snapshot.data!.docs[0]['viewcategory'][index]
                                      .toString() ==
                                  '홈뷰에 저장된 메모'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Text('홈뷰에 저장된 메모',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  contentTitleTextsize())),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: firestore
                                          .collection('MemoDataBase')
                                          .where('OriginalUser',
                                              isEqualTo: name)
                                          .where('EditDate',
                                              isEqualTo: Date.toString()
                                                      .split('-')[0] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[1] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[2]
                                                      .substring(0, 2) +
                                                  '일')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          ContainerDesign(
                                              child: snapshot.data!.docs.isEmpty
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child: NeumorphicText(
                                                            '오늘 수정된 메모는 없습니다.',
                                                            style:
                                                                NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .flat,
                                                              depth: 3,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  contentTextsize(),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {},
                                                              child: ListTile(
                                                                onTap: () {},
                                                                horizontalTitleGap:
                                                                    10,
                                                                dense: true,
                                                                leading: Icon(
                                                                  Icons
                                                                      .description,
                                                                  color:
                                                                      TextColor(),
                                                                ),
                                                                title: Text(
                                                                    snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'memoTitle'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            TextColor(),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            contentTextsize())),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                              color: BGColor());
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ContainerDesign(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                ],
                                              ),
                                              color: BGColor());
                                        }
                                        return ContainerDesign(
                                            child: snapshot.data!.docs.isEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '오늘 수정된 메모는 없습니다.',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: TextColor(),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                contentTextsize(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              onTap: () {},
                                                              horizontalTitleGap:
                                                                  10,
                                                              dense: true,
                                                              leading: Icon(
                                                                Icons
                                                                    .description,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              title: Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'memoTitle'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize())),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                            color: BGColor());
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Text('오늘 수정 및 생성된 메모',
                                          style: TextStyle(
                                              color: TextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  contentTitleTextsize())),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: firestore
                                          .collection('MemoDataBase')
                                          .where('OriginalUser',
                                              isEqualTo: name)
                                          .where('EditDate',
                                              isEqualTo: Date.toString()
                                                      .split('-')[0] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[1] +
                                                  '-' +
                                                  Date.toString()
                                                      .split('-')[2]
                                                      .substring(0, 2) +
                                                  '일')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          ContainerDesign(
                                              child: snapshot.data!.docs.isEmpty
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child: NeumorphicText(
                                                            '오늘 수정된 메모는 없습니다.',
                                                            style:
                                                                NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .flat,
                                                              depth: 3,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  contentTextsize(),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {},
                                                              child: ListTile(
                                                                onTap: () {},
                                                                horizontalTitleGap:
                                                                    10,
                                                                dense: true,
                                                                leading: Icon(
                                                                  Icons
                                                                      .description,
                                                                  color:
                                                                      TextColor(),
                                                                ),
                                                                title: Text(
                                                                    snapshot.data!
                                                                            .docs[index]
                                                                        [
                                                                        'memoTitle'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            TextColor(),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            contentTextsize())),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                              color: BGColor());
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ContainerDesign(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                ],
                                              ),
                                              color: BGColor());
                                        }
                                        return ContainerDesign(
                                            child: snapshot.data!.docs.isEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '오늘 수정된 메모는 없습니다.',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: TextColor(),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                contentTextsize(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              onTap: () {},
                                                              horizontalTitleGap:
                                                                  10,
                                                              dense: true,
                                                              leading: Icon(
                                                                Icons
                                                                    .description,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              title: Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'memoTitle'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize())),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                            color: BGColor());
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )));
                });
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: defaulthomeviewlist.length,
              itemBuilder: (context, index) {
                return defaulthomeviewlist[index].toString() == '오늘의 일정'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Text('오늘의 일정',
                                style: TextStyle(
                                    color: TextColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize())),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: firestore
                                .collection('CalendarDataBase')
                                .where('OriginalUser', isEqualTo: name)
                                .where('Date',
                                    isEqualTo: Date.toString().split('-')[0] +
                                        '-' +
                                        Date.toString().split('-')[1] +
                                        '-' +
                                        Date.toString()
                                            .split('-')[2]
                                            .substring(0, 2) +
                                        '일')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                content.clear();
                                var timsestart, timefinish, codes, todo;
                                final valuespace = snapshot.data!.docs;
                                for (var sp in valuespace) {
                                  todo = sp.get('Daytodo');
                                  timsestart = sp.get('Timestart');
                                  timefinish = sp.get('Timefinish');
                                  codes = sp.get('calname');
                                  if (int.parse(timsestart
                                          .toString()
                                          .substring(0, 2)) >=
                                      Date.hour) {
                                    content.add(SpaceContent(
                                        title: todo,
                                        date: timsestart + '-' + timefinish,
                                        calendarcode: codes));
                                  }
                                }
                                return ContainerDesign(
                                    child: content.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: NeumorphicText(
                                                  '보여드릴 오늘의 일정이 없습니다.',
                                                  style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    depth: 3,
                                                    color: TextColor(),
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: contentTextsize(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: content.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: ListTile(
                                                      onTap: () {},
                                                      horizontalTitleGap: 10,
                                                      dense: true,
                                                      leading: Icon(
                                                        Icons.calendar_month,
                                                        color: TextColor(),
                                                      ),
                                                      subtitle: Text(
                                                          content[index].title,
                                                          style: TextStyle(
                                                              color:
                                                                  TextColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                      title: Text(
                                                          content[index].date,
                                                          style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              );
                                            }),
                                    color: BGColor());
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ContainerDesign(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Center(
                                            child: CircularProgressIndicator())
                                      ],
                                    ),
                                    color: BGColor());
                              }
                              return ContainerDesign(
                                  child: content.isEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: NeumorphicText(
                                                '보여드릴 오늘의 일정이 없습니다.',
                                                style: NeumorphicStyle(
                                                  shape: NeumorphicShape.flat,
                                                  depth: 3,
                                                  color: TextColor(),
                                                ),
                                                textStyle: NeumorphicTextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: contentTextsize(),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: content.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: ListTile(
                                                    onTap: () {},
                                                    horizontalTitleGap: 10,
                                                    dense: true,
                                                    leading: Icon(
                                                      Icons.calendar_month,
                                                      color: TextColor(),
                                                    ),
                                                    subtitle: Text(
                                                        content[index].title,
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize())),
                                                    title: Text(
                                                        content[index].date,
                                                        style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            );
                                          }),
                                  color: BGColor());
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : (defaulthomeviewlist[index].toString() == '공유된 오늘의 일정'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text('공유된 오늘의 일정',
                                    style: TextStyle(
                                        color: TextColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize())),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: firestore
                                    .collection('CalendarDataBase')
                                    .where('Date',
                                        isEqualTo:
                                            Date.toString().split('-')[0] +
                                                '-' +
                                                Date.toString().split('-')[1] +
                                                '-' +
                                                Date.toString()
                                                    .split('-')[2]
                                                    .substring(0, 2) +
                                                '일')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List nameList = [];
                                    var timsestart, timefinish, codes, todo;
                                    final valuespace = snapshot.data!.docs;
                                    for (var sp in valuespace) {
                                      nameList = sp.get('Shares');
                                      todo = sp.get('Daytodo');
                                      timsestart = sp.get('Timestart');
                                      timefinish = sp.get('Timefinish');
                                      codes = sp.get('calname');
                                      for (int i = 0;
                                          i < nameList.length;
                                          i++) {
                                        if (nameList[i].contains(name)) {
                                          if (int.parse(timsestart
                                                  .toString()
                                                  .substring(0, 2)) >=
                                              Date.hour) {
                                            content.add(SpaceContent(
                                                title: todo,
                                                date: timsestart +
                                                    '-' +
                                                    timefinish,
                                                calendarcode: codes));
                                          }
                                        }
                                      }
                                    }
                                    return ContainerDesign(
                                        child: content.isEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: NeumorphicText(
                                                      '보여드릴 공유된 오늘의 일정이 없습니다.',
                                                      style: NeumorphicStyle(
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        depth: 3,
                                                        color: TextColor(),
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            contentTextsize(),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: content.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: ListTile(
                                                          onTap: () {},
                                                          horizontalTitleGap:
                                                              10,
                                                          dense: true,
                                                          leading: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: TextColor(),
                                                          ),
                                                          subtitle: Text(
                                                              content[index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  color:
                                                                      TextColor(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize())),
                                                          title: Text(
                                                              content[index]
                                                                  .date,
                                                              style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                        color: BGColor());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ContainerDesign(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ],
                                        ),
                                        color: BGColor());
                                  }
                                  return ContainerDesign(
                                      child: content.isEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: NeumorphicText(
                                                    '보여드릴 공유된 오늘의 일정이 없습니다.',
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: TextColor(),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: content.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: ListTile(
                                                        onTap: () {},
                                                        horizontalTitleGap: 10,
                                                        dense: true,
                                                        leading: Icon(
                                                          Icons.calendar_month,
                                                          color: TextColor(),
                                                        ),
                                                        subtitle: Text(
                                                            content[index]
                                                                .title,
                                                            style: TextStyle(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize())),
                                                        title: Text(
                                                            content[index].date,
                                                            style: TextStyle(
                                                              color:
                                                                  TextColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                );
                                              }),
                                      color: BGColor());
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        : (defaulthomeviewlist[index].toString() == '홈뷰에 저장된 메모'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Text('홈뷰에 저장된 메모',
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTitleTextsize())),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: firestore
                                        .collection('MemoDataBase')
                                        .where('OriginalUser', isEqualTo: name)
                                        .where('EditDate',
                                            isEqualTo: Date.toString()
                                                    .split('-')[0] +
                                                '-' +
                                                Date.toString().split('-')[1] +
                                                '-' +
                                                Date.toString()
                                                    .split('-')[2]
                                                    .substring(0, 2) +
                                                '일')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        ContainerDesign(
                                            child: snapshot.data!.docs.isEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '오늘 수정된 메모는 없습니다.',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: TextColor(),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                contentTextsize(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              onTap: () {},
                                                              horizontalTitleGap:
                                                                  10,
                                                              dense: true,
                                                              leading: Icon(
                                                                Icons
                                                                    .description,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              title: Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'memoTitle'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize())),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                            color: BGColor());
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ContainerDesign(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Center(
                                                    child:
                                                        CircularProgressIndicator())
                                              ],
                                            ),
                                            color: BGColor());
                                      }
                                      return ContainerDesign(
                                          child: snapshot.data!.docs.isEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '오늘 수정된 메모는 없습니다.',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: TextColor(),
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize:
                                                              contentTextsize(),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: ListTile(
                                                            onTap: () {},
                                                            horizontalTitleGap:
                                                                10,
                                                            dense: true,
                                                            leading: Icon(
                                                              Icons.description,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            title: Text(
                                                                snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    [
                                                                    'memoTitle'],
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize())),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                          color: BGColor());
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Text('오늘 수정 및 생성된 메모',
                                        style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTitleTextsize())),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: firestore
                                        .collection('MemoDataBase')
                                        .where('OriginalUser', isEqualTo: name)
                                        .where('EditDate',
                                            isEqualTo: Date.toString()
                                                    .split('-')[0] +
                                                '-' +
                                                Date.toString().split('-')[1] +
                                                '-' +
                                                Date.toString()
                                                    .split('-')[2]
                                                    .substring(0, 2) +
                                                '일')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        ContainerDesign(
                                            child: snapshot.data!.docs.isEmpty
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: NeumorphicText(
                                                          '오늘 수정된 메모는 없습니다.',
                                                          style:
                                                              NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .flat,
                                                            depth: 3,
                                                            color: TextColor(),
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize:
                                                                contentTextsize(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              onTap: () {},
                                                              horizontalTitleGap:
                                                                  10,
                                                              dense: true,
                                                              leading: Icon(
                                                                Icons
                                                                    .description,
                                                                color:
                                                                    TextColor(),
                                                              ),
                                                              title: Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'memoTitle'],
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize())),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                            color: BGColor());
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ContainerDesign(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Center(
                                                    child:
                                                        CircularProgressIndicator())
                                              ],
                                            ),
                                            color: BGColor());
                                      }
                                      return ContainerDesign(
                                          child: snapshot.data!.docs.isEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: NeumorphicText(
                                                        '오늘 수정된 메모는 없습니다.',
                                                        style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          depth: 3,
                                                          color: TextColor(),
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize:
                                                              contentTextsize(),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: ListTile(
                                                            onTap: () {},
                                                            horizontalTitleGap:
                                                                10,
                                                            dense: true,
                                                            leading: Icon(
                                                              Icons.description,
                                                              color:
                                                                  TextColor(),
                                                            ),
                                                            title: Text(
                                                                snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    [
                                                                    'memoTitle'],
                                                                style: TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize())),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                          color: BGColor());
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )));
              });
        });
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
                  Get.to(() => HomeView(), transition: Transition.zoom);
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
