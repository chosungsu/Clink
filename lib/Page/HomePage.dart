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
import '../UI/Home/firstContentNet/RoutineHome.dart';
import '../sheets/addcalendar.dart';
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
  static final categoryset = Get.put(category());
  final draw = Get.put(navibool());
  List showspacelist = [];
  List content = [];
  String name = Hive.box('user_info').get('id');
  List<SpaceList> _user_ad = [];
  final List<SpaceList> _default_ad = [
    SpaceList(title: '일정공간'),
    SpaceList(title: '메모공간'),
  ];
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
    categoryset.setcategory();
    isdraweropen = draw.drawopen;
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
              setState(() {
                xoffset = 0;
                yoffset = 0;
                scalefactor = 1;
                isdraweropen = false;
                draw.setclose();
                Hive.box('user_setting').put('page_opened', false);
              });
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
                                      /*const SizedBox(
                                        height: 20,
                                      ),
                                      H_Container_3(height, _pController),*/
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      H_Container_1(height),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder<void>(
                                        future: firestore
                                            .collection('CalendarDataBase')
                                            .where('OriginalUser',
                                                isEqualTo: name)
                                            .where('Date',
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
                                            .get()
                                            .then((value) {
                                          content.clear();
                                          value.docs.isEmpty
                                              ? firestore
                                                  .collection(
                                                      'CalendarDataBase')
                                                  .where('Date',
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
                                                  .get()
                                                  .then(((value) {
                                                  value.docs.forEach((element) {
                                                    for (int i = 0;
                                                        i <
                                                            element['Shares']
                                                                .length;
                                                        i++) {
                                                      if (element['Shares'][i]
                                                          .contains(name)) {
                                                        if (int.parse(element[
                                                                    'Timestart']
                                                                .toString()
                                                                .substring(
                                                                    0, 2)) >=
                                                            Date.hour) {
                                                          content.add(SpaceContent(
                                                              title: element[
                                                                  'Daytodo'],
                                                              date: element[
                                                                      'Timestart'] +
                                                                  '-' +
                                                                  element[
                                                                      'Timefinish']));
                                                        }
                                                      }
                                                    }
                                                  });
                                                }))
                                              : value.docs.forEach((element) {
                                                  if (int.parse(
                                                          element['Timestart']
                                                              .toString()
                                                              .substring(
                                                                  0, 2)) >=
                                                      Date.hour) {
                                                    content.add(SpaceContent(
                                                        title:
                                                            element['Daytodo'],
                                                        date: element[
                                                                'Timestart'] +
                                                            '-' +
                                                            element[
                                                                'Timefinish']));
                                                  }
                                                });
                                        }), // a previously-obtained Future<String> or null
                                        builder: (context, snapshot) {
                                          return H_Container_4(
                                            height,
                                          );
                                        },
                                      ),
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

  H_Container_4(double height) {
    return SizedBox(
        height: categoryset.number * 80 + 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '데이로그 모아보기',
              maxLines: 2,
              style: TextStyle(
                  color: TextColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize()),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 20,
            ),
            StatefulBuilder(builder: (_, StateSetter setState) {
              return StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('HomeCategories')
                      .orderBy('number')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var nameText;
                      var readyText;
                      final valuespace = snapshot.data!.docs;
                      for (var sp in valuespace) {
                        nameText = sp.get('name');
                        readyText = sp.get('ready');
                        fillcategory
                            .add(Category(title: nameText, ready: readyText));
                      }
                      return GetBuilder<category>(
                          builder: (_) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                      duration: Duration(seconds: 0),
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: categoryset.number,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  index == 0
                                                      ? Get.to(
                                                          () =>
                                                              ChooseCalendar(),
                                                          transition: Transition
                                                              .rightToLeft,
                                                        )
                                                      : (index == 1
                                                          ? Get.to(
                                                              () =>
                                                                  const DayNoteHome(
                                                                title: '',
                                                              ),
                                                              transition:
                                                                  Transition
                                                                      .rightToLeft,
                                                            )
                                                          : Get.to(
                                                              () =>
                                                                  const DayNoteHome(
                                                                title: '',
                                                              ),
                                                              transition:
                                                                  Transition
                                                                      .rightToLeft,
                                                            ));
                                                },
                                                child: SizedBox(
                                                  height: 80,
                                                  child: Column(
                                                    children: [
                                                      ContainerDesign(
                                                        color: BGColor(),
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                    height: 50,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        40,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const SizedBox(width: 50),
                                                                            Text(content.isEmpty ? '' : content[0].date,
                                                                                style: TextStyle(color: TextColor(), fontWeight: FontWeight.bold, fontSize: 18)),
                                                                            const SizedBox(width: 20),
                                                                            Text(
                                                                              content.isEmpty ? '작성된 것이 없습니다.' : content[0].title,
                                                                              maxLines: 2,
                                                                              style: TextStyle(color: TextColor(), fontWeight: FontWeight.bold, fontSize: 18),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )),
                                                                Positioned(
                                                                  top: 0,
                                                                  left: 0,
                                                                  child: Container(
                                                                      width: 30,
                                                                      height: 30,
                                                                      child: fillcategory[index].title == 'note'
                                                                          ? NeumorphicIcon(
                                                                              Icons.note,
                                                                              size: 25,
                                                                              style: NeumorphicStyle(shape: NeumorphicShape.convex, depth: 2, color: TextColor(), lightSource: LightSource.topLeft),
                                                                            )
                                                                          : (fillcategory[index].title == 'calendar'
                                                                              ? NeumorphicIcon(
                                                                                  Icons.today,
                                                                                  size: 25,
                                                                                  style: NeumorphicStyle(shape: NeumorphicShape.convex, depth: 2, color: TextColor(), lightSource: LightSource.topLeft),
                                                                                )
                                                                              : NeumorphicIcon(
                                                                                  Icons.payment,
                                                                                  size: 25,
                                                                                  style: NeumorphicStyle(shape: NeumorphicShape.convex, depth: 2, color: TextColor(), lightSource: LightSource.topLeft),
                                                                                ))),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          }))
                                ],
                              ));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: NeumorphicText(
                          '불러오는 중 오류가 발생하였습니다.\n지속될 경우 문의바랍니다.',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return AnimatedSwitcher(
                          duration: Duration(seconds: 2),
                          child: Shimmer_home(context));
                    }
                    return AnimatedSwitcher(
                        duration: Duration(seconds: 2),
                        child: Shimmer_home(context));
                  });
            }),
          ],
        ));
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
                                              setState(() {
                                                H_Container_4(height);
                                              });
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
                                                  setState(() {
                                                    H_Container_4(height);
                                                  });
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
                                              onTap: () {
                                                /*final reloadpage = await Get.to(
                                                    () => RoutineHome(),
                                                    transition:
                                                        Transition.rightToLeft);
                                                if (reloadpage) {
                                                  setState(() {
                                                    H_Container_4(height);
                                                  });
                                                }*/
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

  /*H_Container_4(
    double height,
  ) {
    //프로버전 구매시 사용할 코드
    //isbought == false일 경우와 isbought == true일 경우 사이즈박스 크기를 제한 풀기...
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return SizedBox(
        height: 80 * 2 + 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('스페이스',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize())),
                  ),
                  /*GestureDetector(
                    onTap: () async {
                      final reloadpage = await Get.to(() => ChangeSpace(),
                          transition: Transition.fadeIn);
                      if (reloadpage) {
                        setState(() {
                          H_Container_4(
                            height,
                          );
                        });
                      }
                    },
                    child: Text('변경',
                        style: TextStyle(
                            color: TextColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize())),
                  )*/
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 80 * 2,
                child: StatefulBuilder(builder: (_, StateSetter setState) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('UserSpaceDataBase')
                        .where('name', isEqualTo: name)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _user_ad.clear();
                        var messageText;
                        final valuespace = snapshot.data!.docs;
                        for (var sp in valuespace) {
                          for (int i = 0; i < 2; i++) {
                            messageText = sp.get('$i');
                            _user_ad.add(SpaceList(title: messageText));
                          }
                        }
                        firestore
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
                            .get()
                            .then((value) {
                          content.clear();
                          value.docs.isEmpty
                              ? firestore
                                  .collection('CalendarDataBase')
                                  .where('Date',
                                      isEqualTo: Date.toString().split('-')[0] +
                                          '-' +
                                          Date.toString().split('-')[1] +
                                          '-' +
                                          Date.toString()
                                              .split('-')[2]
                                              .substring(0, 2) +
                                          '일')
                                  .get()
                                  .then(((value) {
                                  value.docs.forEach((element) {
                                    for (int i = 0;
                                        i < element['Shares'].length;
                                        i++) {
                                      if (element['Shares'][i].contains(name)) {
                                        if (int.parse(element['Timestart']
                                                .toString()
                                                .substring(0, 2)) >=
                                            Date.hour) {
                                          content.add(SpaceContent(
                                              title: element['Daytodo'],
                                              date: element['Timestart'] +
                                                  '-' +
                                                  element['Timefinish']));
                                        }
                                      }
                                    }
                                  });
                                }))
                              : value.docs.forEach((element) {
                                  if (int.parse(element['Timestart']
                                          .toString()
                                          .substring(0, 2)) >=
                                      Date.hour) {
                                    content.add(SpaceContent(
                                        title: element['Daytodo'],
                                        date: element['Timestart'] +
                                            '-' +
                                            element['Timefinish']));
                                  }
                                });
                        });

                        return snapshot.data!.docs.isEmpty
                            ? GetBuilder<SpaceShowRoom>(
                                init: SpaceShowRoom(),
                                builder: (_) => ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: _default_ad.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            _default_ad[index].title == '메모공간'
                                                ? Get.to(
                                                    () => const DayNoteHome(
                                                      title: '',
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  )
                                                : Get.to(
                                                    () => ChooseCalendar(),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Column(
                                              children: [
                                                ContainerDesign(
                                                  color: BGColor(),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              height: 50,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  40,
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                          width:
                                                                              50),
                                                                      Text(
                                                                          content.isEmpty
                                                                              ? ''
                                                                              : content[0]
                                                                                  .date,
                                                                          style: TextStyle(
                                                                              color: TextColor(),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18)),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      Text(
                                                                        content.isEmpty
                                                                            ? '작성된 것이 없습니다.'
                                                                            : content[0].title,
                                                                        maxLines:
                                                                            2,
                                                                        style: TextStyle(
                                                                            color:
                                                                                TextColor(),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                child: _default_ad[index]
                                                                            .title ==
                                                                        '메모공간'
                                                                    ? NeumorphicIcon(
                                                                        Icons
                                                                            .note,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                TextColor(),
                                                                            lightSource:
                                                                                LightSource.topLeft),
                                                                      )
                                                                    : NeumorphicIcon(
                                                                        Icons
                                                                            .today,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                TextColor(),
                                                                            lightSource:
                                                                                LightSource.topLeft),
                                                                      )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ));
                                    }))
                            : GetBuilder<SpaceShowRoom>(
                                init: SpaceShowRoom(),
                                builder: (_) => ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: _user_ad.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            _user_ad[index].title == '메모공간'
                                                ? Get.to(
                                                    () => const DayNoteHome(
                                                      title: '',
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  )
                                                : Get.to(
                                                    () => ChooseCalendar(),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  );
                                          },
                                          child: SizedBox(
                                            height: 80,
                                            child: Column(
                                              children: [
                                                ContainerDesign(
                                                  color: BGColor(),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              height: 50,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  40,
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                          width:
                                                                              50),
                                                                      Text(
                                                                          content.isEmpty
                                                                              ? ''
                                                                              : content[0]
                                                                                  .date,
                                                                          style: TextStyle(
                                                                              color: TextColor(),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18)),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      Text(
                                                                        content.isEmpty
                                                                            ? '작성된 것이 없습니다.'
                                                                            : content[0].title,
                                                                        maxLines:
                                                                            2,
                                                                        style: TextStyle(
                                                                            color:
                                                                                TextColor(),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                child: _user_ad[index]
                                                                            .title ==
                                                                        '메모공간'
                                                                    ? NeumorphicIcon(
                                                                        Icons
                                                                            .note,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                TextColor(),
                                                                            lightSource:
                                                                                LightSource.topLeft),
                                                                      )
                                                                    : NeumorphicIcon(
                                                                        Icons
                                                                            .today,
                                                                        size:
                                                                            25,
                                                                        style: NeumorphicStyle(
                                                                            shape: NeumorphicShape
                                                                                .convex,
                                                                            depth:
                                                                                2,
                                                                            color:
                                                                                TextColor(),
                                                                            lightSource:
                                                                                LightSource.topLeft),
                                                                      )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ));
                                    }));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: NeumorphicText(
                            '불러오는 중 오류가 발생하였습니다.\n지속될 경우 문의바랍니다.',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: TextColor(),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Center(
                        child: NeumorphicText(
                          '생성된 일정표가 없습니다.\n추가 버튼으로 생성해보세요~',
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            color: TextColor(),
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                          ),
                        ),
                      );
                    },
                  );
                }))
          ],
        ),
      );
    });
  }*/

  showreadycontent(
    BuildContext context,
    double height,
    PageController pController,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  height: 280,
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
                  child: readycontent(context, height, pController),
                )),
          );
        }).whenComplete(() {
      H_Container_4(height);
    });
  }
}

addcalendar(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String username,
  DateTime date,
  String s,
) {
  Get.bottomSheet(
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: s == 'home' ? 440 : 340,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                  onTap: () {
                    searchNode.unfocus();
                  },
                  child: SheetPageAC(
                      context, searchNode, controller, username, date, s)),
            ),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    controller.clear();
    final cntget = Get.put(onequeform());
    cntget.setcnt();
    final spaceroomset = Get.put(SpaceShowRoom());
    spaceroomset.onInit();
  });
}
