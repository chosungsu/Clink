import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/PeopleGroup.dart';
import 'package:clickbyme/sheets/addcalendar.dart';
import 'package:clickbyme/sheets/settingChoiceC.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Page/HomePage.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/PeopleAdd.dart';
import '../../../Tool/SheetGetx/SpaceShowRoom.dart';
import '../../../route.dart';
import '../../../sheets/settingChoiceC_Cards.dart';

class ChooseCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseCalendarState();
}

class _ChooseCalendarState extends State<ChooseCalendar>
    with TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  String username = Hive.box('user_info').get(
    'id',
  );
  static final cal_share_person = Get.put(PeopleAdd());
  List finallist = cal_share_person.people;
  TextEditingController controller = TextEditingController();
  final searchNode = FocusNode();
  final inputNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List list_calendar_home = [];
  List updateid = [];
  bool _showBackToTopButton = false;
  DateTime Date = DateTime.now();
  ScrollController _scrollController = ScrollController();
  final List noticalendarlist = [
    'MY',
    '공유된 캘린더',
  ];
  int code = 0;
  int sort = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('noti_calendar_click', 0);
    Hive.box('user_setting').put('sort_cal_card', 0);
    code = Hive.box('user_setting').get('noti_calendar_click') ?? 0;
    sort = Hive.box('user_setting').get('sort_cal_card') ?? 0;
    controller = TextEditingController();
    cal_share_person.peoplecalendarrestart();
    finallist = cal_share_person.people;
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 150) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
    if (_scrollController.offset == 0) {
      _showBackToTopButton = false; // show the back-to-top button
    }
  }

  Future<bool> _onWillPop() async {
    Get.back(result: true);
    return true;
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

      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
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
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 50,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              Get.back(result: true);
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
                                                  shape: NeumorphicShape.convex,
                                                  depth: 2,
                                                  surfaceIntensity: 0.5,
                                                  color: TextColor(),
                                                  lightSource:
                                                      LightSource.topLeft),
                                            ),
                                          ))),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          70,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 10),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text('일정표 목록',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              SizedBox(
                                                  width: 30,
                                                  child: InkWell(
                                                      onTap: () {
                                                        //리스트 정렬
                                                        setState(() {
                                                          sort == 0
                                                              ? Hive.box(
                                                                      'user_setting')
                                                                  .put(
                                                                      'sort_cal_card',
                                                                      1)
                                                              : Hive.box(
                                                                      'user_setting')
                                                                  .put(
                                                                      'sort_cal_card',
                                                                      0);
                                                          Hive.box('user_setting')
                                                                          .get(
                                                                              'sort_cal_card') ==
                                                                      0 ||
                                                                  Hive.box('user_setting')
                                                                          .get(
                                                                              'sort_cal_card') ==
                                                                      null
                                                              ? sort = 0
                                                              : sort = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                        height: 30,
                                                        child: NeumorphicIcon(
                                                          Icons.swap_vert,
                                                          size: 30,
                                                          style: NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              surfaceIntensity:
                                                                  0.5,
                                                              color:
                                                                  TextColor(),
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                  width: 30,
                                                  child: InkWell(
                                                      onTap: () {
                                                        //리스트 추가하는 창 띄우기
                                                        Hive.box('user_setting')
                                                            .put('typecalendar',
                                                                0);
                                                        addcalendar(
                                                            context,
                                                            searchNode,
                                                            controller,
                                                            username,
                                                            Date,
                                                            'cal');
                                                      },
                                                      child: Container(
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
                                                              depth: 2,
                                                              surfaceIntensity:
                                                                  0.5,
                                                              color:
                                                                  TextColor(),
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                        ),
                                                      ))),
                                            ],
                                          ))),
                                ],
                              )),
                        ],
                      ),
                    )),
                Selectisshare(),
                Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                      child: ScrollConfiguration(
                          behavior: NoBehavior(),
                          child: SingleChildScrollView(
                              controller: _scrollController,
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      code == 0 ? listy_My() : listy_Shared(),
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

  Selectisshare() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ShareBox()],
      ),
    );
  }

  ShareBox() {
    return SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width - 60,
        child: ListView.builder(
            // the number of items in the list
            itemCount: noticalendarlist.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            // display each item of the product list
            itemBuilder: (context, index) {
              return index == 1
                  ? Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 30,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_calendar_click') ==
                                            null
                                        ? Colors.white
                                        : (Hive.box('user_setting').get(
                                                    'noti_calendar_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: BorderSide(
                                      width: 1,
                                      color: TextColor(),
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_calendar_click', index);
                                    code = index;
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          noticalendarlist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_calendar_click') ==
                                                    null
                                                ? Colors.black45
                                                : (Hive.box('user_setting').get(
                                                            'noti_calendar_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  : Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 30,
                            width: (MediaQuery.of(context).size.width - 40) / 4,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    primary: Hive.box('user_setting')
                                                .get('noti_calendar_click') ==
                                            null
                                        ? Colors.grey.shade400
                                        : (Hive.box('user_setting').get(
                                                    'noti_calendar_click') ==
                                                index
                                            ? Colors.grey.shade400
                                            : Colors.white),
                                    side: const BorderSide(
                                      width: 1,
                                      color: Colors.black45,
                                    )),
                                onPressed: () {
                                  setState(() {
                                    Hive.box('user_setting')
                                        .put('noti_calendar_click', index);
                                    code = index;
                                  });
                                },
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: NeumorphicText(
                                          noticalendarlist[index],
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            depth: 3,
                                            color: Hive.box('user_setting').get(
                                                        'noti_calendar_click') ==
                                                    null
                                                ? Colors.white
                                                : (Hive.box('user_setting').get(
                                                            'noti_calendar_click') ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black45),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTextsize(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    );
            }));
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
  settingCalendarHome(
    int index,
    doc_name,
    doc_shares,
    doc_change,
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
                  child: SheetPageCC(context, doc_name, doc_shares, doc_change),
                )),
          );
        }).whenComplete(() {
      setState(() {
        //setcal_fromsheet = controll_cals.showcalendar;
        //themecal_fromsheet = controll_cals2.themecalendar;
      });
    });
  }

  listy_My() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('CalendarSheetHome')
            .where('madeUser', isEqualTo: username)
            .orderBy('date', descending: sort == 0 ? true : false)
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
                              onTap: () {
                                Get.to(
                                  () => DayContentHome(
                                    title: snapshot.data!.docs[index].id,
                                    share: snapshot.data!.docs[index]['share'],
                                    origin: snapshot.data!.docs[index]
                                        ['madeUser'],
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: ContainerDesign(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                TextColor()))),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        //카드별 설정 ex.공유자 권한설정
                                                        settingCalendarHome(
                                                          index,
                                                          snapshot.data!
                                                              .docs[index].id,
                                                          snapshot.data!
                                                                  .docs[index][
                                                              'allowance_share'],
                                                          snapshot.data!
                                                                  .docs[index][
                                                              'allowance_change_set'],
                                                        );
                                                      },
                                                      child: NeumorphicIcon(
                                                        Icons.settings,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        //공유자 검색
                                                        Hive.box('user_setting').put(
                                                            'share_cal_person',
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['share']);

                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1),
                                                            () {
                                                          Get.to(
                                                            () => PeopleGroup(
                                                              doc: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id
                                                                  .toString(),
                                                              when: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['date'],
                                                              type: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['type'],
                                                              color: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['color'],
                                                              nameid: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['calname'],
                                                              share: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['share'],
                                                              made: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['madeUser'],
                                                              allow_share: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'allowance_share'],
                                                              allow_change_set: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'allowance_change_set'],
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .downToUp,
                                                          );
                                                        });
                                                      },
                                                      child: NeumorphicIcon(
                                                        Icons.share,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        //삭제 및 이름변경 띄우기
                                                        controller =
                                                            TextEditingController(
                                                                text: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    'calname']);
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
                                                                ['madeUser']);
                                                      },
                                                      child: NeumorphicIcon(
                                                        Icons.edit,
                                                        size: 30,
                                                        style: NeumorphicStyle(
                                                            shape:
                                                                NeumorphicShape
                                                                    .convex,
                                                            depth: 2,
                                                            surfaceIntensity:
                                                                0.5,
                                                            color: TextColor(),
                                                            lightSource:
                                                                LightSource
                                                                    .topLeft),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 70,
                                                      child: Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['calname'],
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTitleTextsize(),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      child: Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['date'],
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize(),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 30,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'with',
                                                              softWrap: true,
                                                              style: GoogleFonts
                                                                  .lobster(
                                                                color:
                                                                    TextColor(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize:
                                                                    contentTextsize(),
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                itemCount: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'share']
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index2) {
                                                                  return Row(
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child: Text(
                                                                            snapshot.data!.docs[index]['share'][index2].toString().substring(0,
                                                                                1),
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18)),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                          ],
                                                        ))
                                                  ],
                                                ))),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      left: BorderSide(
                                                          color: TextColor()))),
                                              child: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: NeumorphicText(
                                                    'Made By\n' +
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['madeUser'],
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: TextColor(),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    color: snapshot.data!.docs[index]
                                                ['color'] !=
                                            null
                                        ? Color(
                                            snapshot.data!.docs[index]['color'])
                                        : Colors.blue),
                              )),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Center(child: CircularProgressIndicator())],
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
      );
    });
  }

  listy_Shared() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('ShareHome')
            .where('showingUser', isEqualTo: username)
            .orderBy('date', descending: sort == 0 ? true : false)
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
                              onTap: () {
                                Get.to(
                                  () => DayContentHome(
                                    title: snapshot.data!.docs[index]['doc'],
                                    share: snapshot.data!.docs[index]['share'],
                                    origin: snapshot.data!.docs[index]
                                        ['madeUser'],
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: ContainerDesign(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                TextColor()))),
                                                child: Column(
                                                  children: [
                                                    snapshot.data!.docs[index]
                                                            ['allowance_share']
                                                        ? InkWell(
                                                            onTap: () {
                                                              //공유자 검색
                                                              Hive.box('user_setting').put(
                                                                  'share_cal_person',
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'share']);

                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                Get.to(
                                                                  () =>
                                                                      PeopleGroup(
                                                                    doc: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        ['doc'],
                                                                    when: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'date'],
                                                                    type: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'type'],
                                                                    color: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'color'],
                                                                    nameid: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'calname'],
                                                                    share: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'share'],
                                                                    made: snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'madeUser'],
                                                                    allow_share:
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['allowance_share'],
                                                                    allow_change_set:
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['allowance_change_set'],
                                                                  ),
                                                                  transition:
                                                                      Transition
                                                                          .downToUp,
                                                                );
                                                              });
                                                            },
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.share,
                                                              size: 30,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  surfaceIntensity:
                                                                      0.5,
                                                                  color:
                                                                      TextColor(),
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          )
                                                        : const SizedBox(
                                                            height: 0,
                                                          ),
                                                    snapshot.data!.docs[index]
                                                            ['allowance_share']
                                                        ? const SizedBox(
                                                            height: 10,
                                                          )
                                                        : const SizedBox(
                                                            height: 0,
                                                          ),
                                                    snapshot.data!.docs[index][
                                                            'allowance_change_set']
                                                        ? InkWell(
                                                            onTap: () {
                                                              //삭제 및 이름변경 띄우기
                                                              controller = TextEditingController(
                                                                  text: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'calname']);
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
                                                                              .docs[
                                                                          index]
                                                                      ['color'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'calname'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['madeUser']);
                                                            },
                                                            child:
                                                                NeumorphicIcon(
                                                              Icons.edit,
                                                              size: 30,
                                                              style: NeumorphicStyle(
                                                                  shape:
                                                                      NeumorphicShape
                                                                          .convex,
                                                                  depth: 2,
                                                                  surfaceIntensity:
                                                                      0.5,
                                                                  color:
                                                                      TextColor(),
                                                                  lightSource:
                                                                      LightSource
                                                                          .topLeft),
                                                            ),
                                                          )
                                                        : const SizedBox(
                                                            height: 0,
                                                          )
                                                  ],
                                                ))
                                          ],
                                        ),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['calname'],
                                                        maxLines: 5,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: TextColor(),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTitleTextsize(),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['share']
                                                                .length >
                                                            0
                                                        ? SizedBox(
                                                            height: 30,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'with',
                                                                  softWrap:
                                                                      true,
                                                                  style: GoogleFonts
                                                                      .lobster(
                                                                    color:
                                                                        TextColor(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        contentTextsize(),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount: snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'share']
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index2) {
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
                                                            height: 0,
                                                          ),
                                                  ],
                                                ))),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      left: BorderSide(
                                                          color: TextColor()))),
                                              child: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: NeumorphicText(
                                                    'Shared By\n' +
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['madeUser'],
                                                    style: NeumorphicStyle(
                                                      shape:
                                                          NeumorphicShape.flat,
                                                      depth: 3,
                                                      color: TextColor(),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    color: snapshot.data!.docs[index]
                                                ['color'] !=
                                            null
                                        ? Color(
                                            snapshot.data!.docs[index]['color'])
                                        : Colors.blue),
                              )),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Center(child: CircularProgressIndicator())],
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
      );
    });
  }

  settingChoiceCal(
    BuildContext context,
    TextEditingController controller,
    doc,
    doc_type,
    doc_color,
    doc_name,
    doc_made_user,
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
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: GestureDetector(
                    onTap: () {
                      searchNode.unfocus();
                    },
                    child: SizedBox(
                      height: 300,
                      child: SheetPageC(
                          context,
                          controller,
                          searchNode,
                          doc,
                          doc_type,
                          doc_color,
                          doc_name,
                          doc_made_user,
                          finallist),
                    )),
              ));
        }).whenComplete(() {
      setState(() {
        controller.clear();
      });
    });
  }
}
