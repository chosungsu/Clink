import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/DB/SpaceList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/NaviWhere.dart';
import 'package:clickbyme/Tool/SheetGetx/Spacesetting.dart';
import 'package:clickbyme/Tool/SheetGetx/onequeform.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/NotiAlarm.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/TopCard.dart';
import 'package:clickbyme/UI/Home/secondContentNet/EventShowCard.dart';
import 'package:clickbyme/UI/Home/thirdContentNet/ChangeSpace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import '../DB/SpaceContent.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/SheetGetx/SpaceShowRoom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/RoutineHome.dart';
import '../sheets/addcalendar.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key, required this.colorbackground, required this.coloritems})
      : super(key: key);
  final Color colorbackground;
  final Color coloritems;
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
  List<SpaceContent> sc = [];
  late DateTime Date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final spaceset = Get.put(Spacesetting());

  List showspacelist = [];
  String name = Hive.box('user_info').get('id');
  List<SpaceList> _user_ad = [];
  final List<SpaceList> _default_ad = [
    SpaceList(title: '????????????'),
    SpaceList(title: '????????????'),
    SpaceList(title: '????????????'),
  ];

  late final PageController _pController;
  //?????? ?????? ????????? ??????????????? ??????
  bool isbought = false;
  TextEditingController controller = TextEditingController();
  var searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    spaceset.setspace();
    showspacelist = spaceset.space;
    _pController =
        PageController(initialPage: currentPage, viewportFraction: 1);
    navi = NaviWhere();
  }

  @override
  void dispose() {
    super.dispose();
    _pController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cntget = Get.put(onequeform());
    cntget.onInit();
    final spaceroomset = Get.put(SpaceShowRoom());
    spaceroomset.onInit();
    print('22');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: StatusColor(), statusBarBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: navi == 0
                ? (isdraweropen == true
                    ? Stack(
                        children: [
                          Container(
                            width: 50,
                            child: DrawerScreen(),
                          ),
                          HomeUi(_pController, cntget, spaceroomset),
                        ],
                      )
                    : Stack(
                        children: [
                          HomeUi(_pController, cntget, spaceroomset),
                        ],
                      ))
                : Stack(
                    children: [
                      HomeUi(_pController, cntget, spaceroomset),
                    ],
                  )));
  }

  HomeUi(PageController pController, onequeform cntget,
      SpaceShowRoom spaceroomset) {
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scalefactor),
      duration: const Duration(milliseconds: 250),
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
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            navi == 0
                                ? SizedBox(
                                    width: 50,
                                    child: isdraweropen
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                xoffset = 0;
                                                yoffset = 0;
                                                scalefactor = 1;
                                                isdraweropen = false;
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    depth: 2,
                                                    surfaceIntensity: 0.5,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            ))
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                xoffset = 50;
                                                yoffset = 0;
                                                scalefactor = 1;
                                                isdraweropen = true;
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    surfaceIntensity: 0.5,
                                                    depth: 2,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
                                              ),
                                            )))
                                : const SizedBox(),
                            SizedBox(
                                width: navi == 0
                                    ? MediaQuery.of(context).size.width - 60
                                    : MediaQuery.of(context).size.width - 10,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
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
                                        InkWell(
                                            onTap: () {
                                              /*Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    child: NotiAlarm()),
                                              );*/
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
                                                    shape:
                                                        NeumorphicShape.convex,
                                                    surfaceIntensity: 0.5,
                                                    depth: 2,
                                                    color: TextColor(),
                                                    lightSource:
                                                        LightSource.topLeft),
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
                            StatefulBuilder(builder: (_, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                /*FutureBuilder<List<TODO>>(
                            future: homeasync(
                                selectedDay), // a previously-obtained Future<String> or null
                            builder: (BuildContext context,
                                AsyncSnapshot<List<TODO>> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return UserChoice(
                                    context, snapshot.data!, pController);
                              } else {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.convex,
                                          border: const NeumorphicBorder.none(),
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(5)),
                                          depth: 5,
                                          color: Colors.white,
                                        ),
                                        child: Shimmer_home(context))
                                  ],
                                );
                              }
                            },
                          ),*/
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_0(height, cntget),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_1(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_2(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_3(height, _pController),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_5(height),
                                const SizedBox(
                                  height: 20,
                                ),
                                H_Container_4(height, spaceroomset),
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
    );
  }

  H_Container_0(double height, onequeform cntget) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width - 40,
              child: ContainerDesign(
                  color: Colors.blue.shade400,
                  child: Column(
                    children: [
                      GetBuilder<onequeform>(
                          init: onequeform(),
                          builder: (_) => SizedBox(
                              height: 60,
                              child: GestureDetector(
                                onTap: () {
                                  cntget.cnt != 0
                                      ? addcalendar(context, searchNode,
                                          controller, name, Date, 'home')
                                      : Flushbar(
                                          backgroundColor: Colors.red.shade400,
                                          titleText: Text('Notice',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    contentTitleTextsize(),
                                                fontWeight: FontWeight.bold,
                                              )),
                                          messageText: Text(
                                              '?????? ???????????? ?????????????????????.\n?????? ??????????????? ??? ?????????????????????!',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: contentTextsize(),
                                                fontWeight: FontWeight.bold,
                                              )),
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 25.0,
                                            color: Colors.white,
                                          ),
                                          duration: const Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                              Colors.red.shade100,
                                        ).show(context);
                                },
                                child: SizedBox(
                                  height: 45,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 45,
                                        width: 45,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.blue.shade500,
                                              child: const Icon(
                                                Icons.smart_toy,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      const Flexible(
                                        fit: FlexFit.tight,
                                        child: SizedBox(
                                          height: 45,
                                          child: Center(
                                            child: Text(
                                              '????????? ???????????? ?????????',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                      ),
                                      cntget.cnt != 0
                                          ? SizedBox(
                                              height: 45,
                                              width: 45,
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue.shade500,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            cntget.cnt
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                          const Text(
                                                            '/5',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ],
                                                      ))),
                                            )
                                          : SizedBox(
                                              height: 45,
                                              width: 45,
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue.shade500,
                                                    child: const Icon(
                                                      Icons.lock,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                              ))),
                    ],
                  )))
        ],
      ),
    );
  }

  H_Container_1(double height) {
    //???????????? ????????? ????????? ?????? ???
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  H_Container_2(double height) {
    return SizedBox(
      height: 130,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text('????????????',
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
          ),
          const SizedBox(
            height: 20,
          ),
          TopCard(height: height),
        ],
      ),
    );
  }

  H_Container_3(double height, PageController pController) {
    //???????????? ????????? ????????? ?????? ???
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

  H_Container_4(double height, SpaceShowRoom spaceroomset) {
    //???????????? ????????? ????????? ??????
    //isbought == false??? ????????? isbought == true??? ?????? ??????????????? ????????? ?????? ??????...
    return SizedBox(
      height: 80 * 3 + 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text('????????????',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTitleTextsize())),
                ),
                GestureDetector(
                  onTap: () {
                    Get.off(() => ChangeSpace(), transition: Transition.fadeIn);
                  },
                  child: Text('??????',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 80 * 3,
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
                        for (int i = 0; i < 3; i++) {
                          messageText = sp.get('$i');
                          _user_ad.add(SpaceList(title: messageText));
                        }
                      }
                      final spaceroomset = Get.put(SpaceShowRoom());
                      spaceroomset.onInit();

                      return snapshot.data!.docs.isEmpty
                          ? GetBuilder<SpaceShowRoom>(
                              init: SpaceShowRoom(),
                              builder: (_) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: _default_ad.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          _default_ad[index].title == '????????????'
                                              ? Get.to(
                                                  () => const DayNoteHome(
                                                    title: '',
                                                  ),
                                                  transition:
                                                      Transition.rightToLeft,
                                                )
                                              : (_default_ad[index].title ==
                                                      '????????????'
                                                  ? Get.to(
                                                      () => RoutineHome(),
                                                      transition: Transition
                                                          .rightToLeft,
                                                    )
                                                  : Get.to(
                                                      () => ChooseCalendar(),
                                                      transition: Transition
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
                                                                    SizedBox(
                                                                        width:
                                                                            50),
                                                                    Text(
                                                                        spaceroomset.content.isEmpty
                                                                            ? ''
                                                                            : spaceroomset
                                                                                .content[
                                                                                    0]
                                                                                .date,
                                                                        style: TextStyle(
                                                                            color:
                                                                                TextColor(),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18)),
                                                                    SizedBox(
                                                                        width:
                                                                            20),
                                                                    Text(
                                                                      spaceroomset
                                                                              .content
                                                                              .isEmpty
                                                                          ? '????????? ?????? ????????????.'
                                                                          : spaceroomset
                                                                              .content[0]
                                                                              .title,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          color:
                                                                              TextColor(),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                              child: _default_ad[
                                                                              index]
                                                                          .title ==
                                                                      '????????????'
                                                                  ? NeumorphicIcon(
                                                                      Icons
                                                                          .note,
                                                                      size: 25,
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
                                                                  : (_default_ad[index]
                                                                              .title ==
                                                                          '????????????'
                                                                      ? NeumorphicIcon(
                                                                          Icons
                                                                              .add_task,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: TextColor(),
                                                                              lightSource: LightSource.topLeft),
                                                                        )
                                                                      : NeumorphicIcon(
                                                                          Icons
                                                                              .today,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: TextColor(),
                                                                              lightSource: LightSource.topLeft),
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
                          : GetBuilder<SpaceShowRoom>(
                              init: SpaceShowRoom(),
                              builder: (_) => ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: _user_ad.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          _user_ad[index].title == '????????????'
                                              ? Get.to(
                                                  () => const DayNoteHome(
                                                    title: '',
                                                  ),
                                                  transition:
                                                      Transition.rightToLeft,
                                                )
                                              : (_user_ad[index].title == '????????????'
                                                  ? Get.to(
                                                      () => RoutineHome(),
                                                      transition: Transition
                                                          .rightToLeft,
                                                    )
                                                  : Get.to(
                                                      () => ChooseCalendar(),
                                                      transition: Transition
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
                                                                    SizedBox(
                                                                        width:
                                                                            50),
                                                                    Text(
                                                                        spaceroomset.content.isEmpty
                                                                            ? ''
                                                                            : spaceroomset
                                                                                .content[
                                                                                    0]
                                                                                .date,
                                                                        style: TextStyle(
                                                                            color:
                                                                                TextColor(),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18)),
                                                                    SizedBox(
                                                                        width:
                                                                            20),
                                                                    Text(
                                                                      spaceroomset
                                                                              .content
                                                                              .isEmpty
                                                                          ? '????????? ?????? ????????????.'
                                                                          : spaceroomset
                                                                              .content[0]
                                                                              .title,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          color:
                                                                              TextColor(),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                                      '????????????'
                                                                  ? NeumorphicIcon(
                                                                      Icons
                                                                          .note,
                                                                      size: 25,
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
                                                                  : (_user_ad[index]
                                                                              .title ==
                                                                          '????????????'
                                                                      ? NeumorphicIcon(
                                                                          Icons
                                                                              .add_task,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: TextColor(),
                                                                              lightSource: LightSource.topLeft),
                                                                        )
                                                                      : NeumorphicIcon(
                                                                          Icons
                                                                              .today,
                                                                          size:
                                                                              25,
                                                                          style: NeumorphicStyle(
                                                                              shape: NeumorphicShape.convex,
                                                                              depth: 2,
                                                                              color: TextColor(),
                                                                              lightSource: LightSource.topLeft),
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
                                  }));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: NeumorphicText(
                          '???????????? ??? ????????? ?????????????????????.\n????????? ?????? ??????????????????.',
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
                        '????????? ???????????? ????????????.\n?????? ???????????? ??????????????????~',
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
  }

  H_Container_5(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
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
              height: 440,
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
