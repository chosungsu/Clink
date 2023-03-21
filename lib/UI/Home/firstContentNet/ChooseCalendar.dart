import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/BACKENDPART/Getx/uisetting.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/Widgets/SortMenuHolder.dart';
import 'package:clickbyme/sheets/settingChoiceC.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../FRONTENDPART/Route/subuiroute.dart';
import '../../../FRONTENDPART/UI/DayContentHome.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../BACKENDPART/Getx/UserInfo.dart';
import '../../../BACKENDPART/Getx/calendarsetting.dart';
import '../../../BACKENDPART/Getx/memosetting.dart';
import '../../../Tool/NoBehavior.dart';
import 'package:focused_menu/focused_menu.dart';
import '../../../sheets/infoshow.dart';
import '../../../sheets/settingChoiceC_Cards.dart';
import '../secondContentNet/PeopleGroup.dart';

class ChooseCalendar extends StatefulWidget {
  const ChooseCalendar(
      {Key? key, required this.isfromwhere, required this.index})
      : super(key: key);
  final String isfromwhere;
  final int index;
  @override
  State<StatefulWidget> createState() => _ChooseCalendarState();
}

class _ChooseCalendarState extends State<ChooseCalendar>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  String username = Hive.box('user_info').get(
    'id',
  );
  late FToast fToast;
  static final cal_share_person = Get.put(UserInfo());
  final controll_memo = Get.put(memosetting());
  final cal_sort = Get.put(calendarsetting());
  final uiset = Get.put(uisetting());
  List finallist = cal_share_person.people;
  TextEditingController controller = TextEditingController();
  final searchNode = FocusNode();
  final inputNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List list_calendar_home = [];
  List updateid = [];
  DateTime Date = DateTime.now();
  ScrollController scrollController = ScrollController();
  final List noticalendarlist = [
    'MY',
    '공유된 캘린더',
  ];
  int code = 0;
  int sortsection = 0;
  late TabController tabController;
  int pageindex = 0;
  String realusername = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    WidgetsBinding.instance.addObserver(this);
    Hive.box('user_setting').put('noti_calendar_click', 0);
    code = Hive.box('user_setting').get('noti_calendar_click') ?? 0;
    Hive.box('user_setting').put('sort_cal_card', 0);
    cal_sort.sort = Hive.box('user_setting').get('sort_cal_card');
    sortsection = cal_sort.sort;
    controller = TextEditingController();
    Hive.box('user_setting').put('share_cal_person', '');
    cal_share_person.people = [];
    tabController = TabController(
      initialIndex: widget.index,
      length: 2,
      vsync: this,
    );

    finallist = cal_share_person.people;
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (scrollController.offset >= 150) {
            uiset.showtopbutton = true; // show the back-to-top button
          } else {
            uiset.showtopbutton = false; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      if (widget.isfromwhere == 'home') {
        GoToMain();
      } else {
        Get.back();
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: BGColor(),
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: ChoiceC(),
      ),

      floatingActionButton: uiset.showtopbutton == false
          ? null
          : FloatingActionButton(
              onPressed: (() {
                scrollToTop(scrollController);
              }),
              backgroundColor: BGColor(),
              child: Icon(
                Icons.arrow_upward,
                color: TextColor(),
              ),
            ),
    ));
  }

  ChoiceC() {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        inputNode.unfocus();
      },
      child: SizedBox(
        height: height,
        child: Container(
            decoration: BoxDecoration(color: BGColor()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  IconBtn(
                                      child: IconButton(
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(seconds: 0), () {
                                              if (widget.isfromwhere ==
                                                  'home') {
                                                GoToMain();
                                              } else {
                                                Get.back();
                                              }
                                            });
                                          },
                                          icon: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 30,
                                            child: NeumorphicIcon(
                                              Icons.keyboard_arrow_left,
                                              size: 30,
                                              style: NeumorphicStyle(
                                                  shape: NeumorphicShape.convex,
                                                  depth: 2,
                                                  surfaceIntensity: 0.5,
                                                  color: TextColor(),
                                                  lightSource:
                                                      LightSource.topLeft),
                                            ),
                                          )),
                                      color: TextColor()),
                                  Flexible(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text('일정표 목록',
                                              style: TextStyle(
                                                fontSize: mainTitleTextsize(),
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        SortMenuHolder(cal_sort.sort, '캘린더'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconBtn(
                                            child: IconButton(
                                                onPressed: () async {},
                                                icon: Container(
                                                  alignment: Alignment.center,
                                                  width: 30,
                                                  height: 30,
                                                  child: NeumorphicIcon(
                                                    Icons.add,
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
                                            color: TextColor()),
                                      ],
                                    ),
                                  )),
                                ],
                              )),
                        ],
                      ),
                    )),
                TabViewScreen(),
                //Selectisshare(),
                Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                      child: ScrollConfiguration(
                          behavior: NoBehavior(),
                          child: SingleChildScrollView(
                              controller: scrollController,
                              physics: const ScrollPhysics(),
                              child: StatefulBuilder(
                                  builder: (_, StateSetter setState) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*const SizedBox(
                                        height: 20,
                                      ),
                                      SearchBox(),*/
                                      CalList(),
                                      //code == 0 ? listy_My() : listy_Shared(),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                );
                              }))),
                    )),
              ],
            )),
      ),
    );
  }

  TabViewScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: TextColor_shadowcolor(),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: TabBar(
                onTap: (index) {
                  setState(() {
                    pageindex = index;
                  });
                },
                controller: tabController,
                labelColor: TextColor(),
                unselectedLabelColor: BGColor(),
                indicator: BoxDecoration(
                    color: BGColor(), borderRadius: BorderRadius.circular(30)),
                tabs: [
                  Text(
                    'My',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Shared',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          )),
    );
  }

  CalList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 210,
      child: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [listy_My(), listy_Shared()],
      ),
    );
  }

  /*SearchBox() {
    return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Search()],
      ),
    );
  }

  Search() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 50,
            child: ContainerDesign(
              child: TextField(
                focusNode: inputNode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: '검색어를 입력하세요',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black45),
                  prefixIcon: Icon(Icons.search),
                  isCollapsed: true,
                  prefixIconColor: Colors.black45,
                ),
              ),
              color: Colors.white,
            ))
      ],
    );
  }*/

  listy_My() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return GetBuilder<calendarsetting>(
          builder: (_) => StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('CalendarSheetHome_update')
                    .where('madeUser', isEqualTo: usercode)
                    .orderBy('date',
                        descending: cal_sort.sort == 0 ? true : false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
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
                              )
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          child: FocusedMenuHolder(
                                            menuItems: [
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.style,
                                                    size: 30,
                                                  ),
                                                  title: Text('카드정보',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () async {
                                                    await firestore
                                                        .collection('User')
                                                        .where('code',
                                                            isEqualTo: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['madeUser'])
                                                        .get()
                                                        .then(
                                                      (value) {
                                                        realusername = value
                                                            .docs[0]['subname'];
                                                      },
                                                    );
                                                    infoshow(
                                                        index,
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['date'],
                                                        '',
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['calname'],
                                                        context,
                                                        realusername,
                                                        '',
                                                        'calendar');
                                                  }),
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.settings,
                                                    size: 30,
                                                  ),
                                                  title: Text('권한설정',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () {
                                                    //카드별 설정 ex.공유자 권한설정
                                                    settingCalendarHome(
                                                      index,
                                                      snapshot
                                                          .data!.docs[index].id,
                                                      snapshot.data!.docs[index]
                                                          ['allowance_share'],
                                                      snapshot.data!.docs[index]
                                                          [
                                                          'allowance_change_set'],
                                                      context,
                                                      snapshot.data!.docs[index]
                                                          ['calname'],
                                                      snapshot.data!.docs[index]
                                                          ['themesetting'],
                                                      snapshot.data!.docs[index]
                                                          ['viewsetting'],
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
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['share']);

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      Get.to(
                                                        () => PeopleGroup(
                                                          doc: snapshot.data!
                                                              .docs[index].id
                                                              .toString(),
                                                          when: snapshot.data!
                                                                  .docs[index]
                                                              ['date'],
                                                          type: snapshot.data!
                                                                  .docs[index]
                                                              ['type'],
                                                          color: snapshot.data!
                                                                  .docs[index]
                                                              ['color'],
                                                          nameid: snapshot.data!
                                                                  .docs[index]
                                                              ['calname'],
                                                          share: snapshot.data!
                                                                  .docs[index]
                                                              ['share'],
                                                          made: snapshot.data!
                                                                  .docs[index]
                                                              ['madeUser'],
                                                          allow_share: snapshot
                                                                  .data!
                                                                  .docs[index][
                                                              'allowance_share'],
                                                          allow_change_set: snapshot
                                                                  .data!
                                                                  .docs[index][
                                                              'allowance_change_set'],
                                                          themesetting: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['themesetting'],
                                                          viewsetting: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['viewsetting'],
                                                        ),
                                                        transition:
                                                            Transition.downToUp,
                                                      );
                                                    });
                                                  }),
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.edit,
                                                    size: 30,
                                                  ),
                                                  backgroundColor:
                                                      Colors.red.shade200,
                                                  title: Text('카드설정',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () {
                                                    //삭제 및 이름변경 띄우기
                                                    controller =
                                                        TextEditingController(
                                                            text: snapshot.data!
                                                                    .docs[index]
                                                                ['calname']);
                                                    settingChoiceCal(
                                                        context,
                                                        controller,
                                                        snapshot.data!
                                                            .docs[index].id,
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['type'],
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['color'],
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['calname'],
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['madeUser'],
                                                        searchNode,
                                                        finallist,
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['share'],
                                                        appnickname,
                                                        fToast);
                                                  })
                                            ],
                                            duration:
                                                const Duration(seconds: 0),
                                            animateMenuItems: true,
                                            menuOffset: 20,
                                            bottomOffsetHeight: 10,
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            openWithTap: false,
                                            onPressed: () {
                                              Get.to(
                                                () => DayContentHome(
                                                  snapshot.data!.docs[index].id,
                                                  /*share: snapshot.data!
                                                      .docs[index]['share'],
                                                  origin: snapshot.data!
                                                      .docs[index]['madeUser'],
                                                  theme:
                                                      snapshot.data!.docs[index]
                                                          ['themesetting'],
                                                  view:
                                                      snapshot.data!.docs[index]
                                                          ['viewsetting'],
                                                  calname: snapshot.data!
                                                      .docs[index]['calname'],*/
                                                ),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            child: ContainerDesign(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'calname'],
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTitleTextsize(),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                    height: 30,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          'with',
                                                                          softWrap:
                                                                              true,
                                                                          style:
                                                                              GoogleFonts.lobster(
                                                                            color:
                                                                                TextColor(),
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            fontSize:
                                                                                contentTextsize(),
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        ListView.builder(
                                                                            shrinkWrap: true,
                                                                            scrollDirection: Axis.horizontal,
                                                                            itemCount: snapshot.data!.docs[index]['share'].length,
                                                                            itemBuilder: (context, index2) {
                                                                              return Row(
                                                                                children: [
                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    height: 25,
                                                                                    width: 25,
                                                                                    child: Text(snapshot.data!.docs[index]['share'][index2].toString().substring(0, 1), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(100),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            }),
                                                                      ],
                                                                    ))
                                                              ],
                                                            ))),
                                                  ],
                                                ),
                                                color: snapshot.data!
                                                                .docs[index]
                                                            ['color'] !=
                                                        null
                                                    ? Color(snapshot.data!
                                                        .docs[index]['color'])
                                                    : Colors.blue),
                                          ))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            });
                  } else if (snapshot.hasError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
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
                        )
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
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
                      )
                    ],
                  );
                },
              ));
    });
  }

  listy_Shared() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return GetBuilder<calendarsetting>(
          builder: (_) => StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('ShareHome_update')
                    .where('showingUser', isEqualTo: appnickname)
                    .orderBy('date',
                        descending: cal_sort.sort == 0 ? true : false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: NeumorphicText(
                                  '공유된 일정표가 없습니다.',
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
                              )
                            ],
                          )
                        : ListView.builder(
                            /*gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),*/
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          child: FocusedMenuHolder(
                                            menuItems: [
                                              FocusedMenuItem(
                                                  trailingIcon: const Icon(
                                                    Icons.style,
                                                    size: 30,
                                                  ),
                                                  title: Text('카드정보',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize())),
                                                  onPressed: () async {
                                                    await firestore
                                                        .collection('User')
                                                        .where('code',
                                                            isEqualTo: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['madeUser'])
                                                        .get()
                                                        .then(
                                                      (value) {
                                                        realusername = value
                                                            .docs[0]['subname'];
                                                      },
                                                    );
                                                    infoshow(
                                                        index,
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['date'],
                                                        '',
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['calname'],
                                                        context,
                                                        realusername,
                                                        '',
                                                        'calendar');
                                                  }),
                                              FocusedMenuItem(
                                                  trailingIcon: snapshot
                                                              .data!.docs[index]
                                                          ['allowance_share']
                                                      ? const Icon(
                                                          Icons.share,
                                                          size: 30,
                                                        )
                                                      : const Icon(
                                                          Icons.block,
                                                          size: 30,
                                                          color: Colors.red,
                                                        ),
                                                  title: Text('재공유하기',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize(),
                                                      )),
                                                  onPressed: () {
                                                    //공유자 검색
                                                    if (snapshot
                                                            .data!.docs[index]
                                                        ['allowance_share']) {
                                                      Hive.box('user_setting')
                                                          .put(
                                                              'share_cal_person',
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['share']);

                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        Get.to(
                                                          () => PeopleGroup(
                                                            doc: snapshot.data!
                                                                    .docs[index]
                                                                ['doc'],
                                                            when: snapshot.data!
                                                                    .docs[index]
                                                                ['date'],
                                                            type: snapshot.data!
                                                                    .docs[index]
                                                                ['type'],
                                                            color: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['color'],
                                                            nameid: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['calname'],
                                                            share: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['share'],
                                                            made: snapshot.data!
                                                                    .docs[index]
                                                                ['madeUser'],
                                                            allow_share: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'allowance_share'],
                                                            allow_change_set: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'allowance_change_set'],
                                                            themesetting: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'themesetting'],
                                                            viewsetting: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['viewsetting'],
                                                          ),
                                                          transition: Transition
                                                              .downToUp,
                                                        );
                                                      });
                                                    } else {
                                                      Snack.show(
                                                          context: context,
                                                          title: '경고',
                                                          content:
                                                              '원작성자에게 권한을 요청하세요!',
                                                          snackType:
                                                              SnackType.warning,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                    }
                                                  }),
                                              FocusedMenuItem(
                                                  backgroundColor:
                                                      Colors.red.shade200,
                                                  trailingIcon: snapshot.data!
                                                              .docs[index][
                                                          'allowance_change_set']
                                                      ? const Icon(
                                                          Icons.edit,
                                                          size: 30,
                                                        )
                                                      : const Icon(
                                                          Icons.block,
                                                          size: 30,
                                                          color: Colors.red,
                                                        ),
                                                  title: Text('카드 설정',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize(),
                                                      )),
                                                  onPressed: () {
                                                    //삭제 및 이름변경 띄우기
                                                    if (snapshot
                                                            .data!.docs[index][
                                                        'allowance_change_set']) {
                                                      controller =
                                                          TextEditingController(
                                                              text: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['calname']);
                                                      settingChoiceCal(
                                                          context,
                                                          controller,
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['doc'],
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['type'],
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['color'],
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['calname'],
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['madeUser'],
                                                          searchNode,
                                                          finallist,
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['share'],
                                                          appnickname,
                                                          fToast);
                                                    } else {
                                                      Snack.show(
                                                          context: context,
                                                          title: '경고',
                                                          content:
                                                              '원작성자에게 권한을 요청하세요!',
                                                          snackType:
                                                              SnackType.warning,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating);
                                                    }
                                                  }),
                                            ],
                                            duration:
                                                const Duration(seconds: 0),
                                            animateMenuItems: true,
                                            menuOffset: 20,
                                            bottomOffsetHeight: 10,
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            openWithTap: false,
                                            onPressed: () {
                                              Get.to(
                                                () => DayContentHome(
                                                  snapshot.data!.docs[index]
                                                      ['doc'],
                                                  /*share: snapshot.data!
                                                      .docs[index]['share'],
                                                  origin: snapshot.data!
                                                      .docs[index]['madeUser'],
                                                  theme: snapshot
                                                              .data!.docs[index]
                                                          ['themesetting'] ??
                                                      0,
                                                  view:
                                                      snapshot.data!.docs[index]
                                                              ['viewsetting'] ??
                                                          0,
                                                  calname: snapshot.data!
                                                      .docs[index]['calname'],*/
                                                ),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            child: ContainerDesign(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'calname'],
                                                                  maxLines: 5,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTitleTextsize(),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'share']
                                                                            .length >
                                                                        0
                                                                    ? SizedBox(
                                                                        height:
                                                                            30,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              'with',
                                                                              softWrap: true,
                                                                              style: GoogleFonts.lobster(
                                                                                color: TextColor(),
                                                                                fontWeight: FontWeight.w200,
                                                                                fontSize: contentTextsize(),
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            ListView.builder(
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.horizontal,
                                                                                itemCount: snapshot.data!.docs[index]['share'].length,
                                                                                itemBuilder: (context, index2) {
                                                                                  return Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        alignment: Alignment.center,
                                                                                        height: 25,
                                                                                        width: 25,
                                                                                        child: Text(snapshot.data!.docs[index]['share'][index2].toString().substring(0, 1), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.circular(100),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                }),
                                                                          ],
                                                                        ))
                                                                    : const SizedBox(
                                                                        height:
                                                                            0,
                                                                      ),
                                                              ],
                                                            ))),
                                                  ],
                                                ),
                                                color: snapshot.data!
                                                                .docs[index]
                                                            ['color'] !=
                                                        null
                                                    ? Color(snapshot.data!
                                                        .docs[index]['color'])
                                                    : Colors.blue),
                                          ))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            });
                  } else if (snapshot.hasError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
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
                        )
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator())
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '공유된 일정표가 없습니다.',
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
                      )
                    ],
                  );
                },
              ));
    });
  }
}
