import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/SheetGetx/memosearchsetting.dart';
import 'package:clickbyme/Tool/SheetGetx/memosortsetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/settingMemoHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../sheets/addcalendar.dart';

class DayNoteHome extends StatefulWidget {
  const DayNoteHome({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _DayNoteHomeState();
}

class _DayNoteHomeState extends State<DayNoteHome> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int sortmemo_fromsheet = 0;
  int searchmemo_fromsheet = 0;
  final controll_memo = Get.put(memosearchsetting());
  final controll_memo2 = Get.put(memosortsetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchNode = FocusNode();
  final List memostar = [1, 2, 1, 1, 3];
  final List memotitle = ['memo1', 'memo2', 'memo3', 'memo4', 'memo5'];
  final List memocontent = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기 fighting!!!',
  ];
  String username = Hive.box('user_info').get(
    'id',
  );
  int sort = 0;
  DateTime Date = DateTime.now();
  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    searchmemo_fromsheet = controll_memo.memosearch;
    sortmemo_fromsheet = controll_memo2.memosort;
    controller = TextEditingController();
    sort = Hive.box('user_setting').get('sort_cal_card') ?? 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: GestureDetector(
              onTap: () {
                searchNode.unfocus();
              },
              child: UI(),
            ),
            floatingActionButton: SpeedDial(
                activeIcon: Icons.close,
                icon: Icons.add,
                backgroundColor: Colors.blue,
                overlayColor: BGColor(),
                overlayOpacity: 0.4,
                spacing: 10,
                spaceBetweenChildren: 10,
                children: [
                  SpeedDialChild(
                    child: NeumorphicIcon(
                      Icons.collections_bookmark,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                    backgroundColor: Colors.blue.shade200,
                    onTap: () {
                      addcalendar(context, searchNode, controller, username,
                          Date, 'memo');
                    },
                    label: '컬렉션 추가',
                    labelStyle: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                  SpeedDialChild(
                    child: NeumorphicIcon(
                      Icons.add,
                      size: 30,
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 2,
                          surfaceIntensity: 0.5,
                          color: TextColor(),
                          lightSource: LightSource.topLeft),
                    ),
                    backgroundColor: Colors.orange.shade200,
                    onTap: () {
                      Get.to(
                          () => DayScript(
                                date: DateTime.now(),
                                position: 'note',
                                title: '',
                                share: [],
                                orig: '',
                              ),
                          transition: Transition.downToUp);
                    },
                    label: '메모 추가',
                    labelStyle: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()),
                  ),
                ])));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
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
                                            //Navigator.pop(context);
                                            Get.back();
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
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text('Memo',
                                                  style: GoogleFonts.lobster(
                                                    fontSize: 25,
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
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
                                                      settingMemoHome(
                                                          context,
                                                          controll_memo,
                                                          controll_memo2);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
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
                                                    ))),
                                          ],
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  )),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SearchBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              ADBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              listy_My(),
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );
  }

  SearchBox() {
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
                focusNode: searchNode,
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
                  hintText: '톱니바퀴 -> 조건설정 후 검색',
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black45),
                  prefixIcon: const Icon(Icons.search),
                  isCollapsed: true,
                  prefixIconColor: Colors.black45,
                ),
              ),
              color: Colors.white,
            ))
      ],
    );
  }

  settingMemoHome(
    BuildContext context,
    memosearchsetting controll_memo,
    memosortsetting controll_memo2,
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
                    height: 320,
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
                    child: SheetPage_memo(context, sortmemo_fromsheet,
                        controll_memo, controll_memo2, searchmemo_fromsheet),
                  )));
        }).whenComplete(() {
      setState(() {
        sortmemo_fromsheet = controll_memo2.memosort;
        searchmemo_fromsheet = controll_memo.memosearch;
      });
    });
  }

  ADBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  listy_My() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('MemoSheetHome')
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
                          '생성된 메모컬렉션이 없습니다.\n추가 버튼으로 생성해보세요~',
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
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
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
                                /*Get.to(
                                  () => DayContentHome(
                                    title: snapshot.data!.docs[index].id,
                                    share: snapshot.data!.docs[index]['share'],
                                    origin: snapshot.data!.docs[index]
                                        ['madeUser'],
                                  ),
                                  transition: Transition.rightToLeft,
                                );*/
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
                                                        //공유자 검색
                                                        /*Hive.box('user_setting').put(
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
                                                                  .id.toString(),
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
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .downToUp,
                                                          );

                                                        });*/
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
                                                        /*controller =
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
                                                                ['madeUser']);*/
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
                  '생성된 메모컬렉션이 없습니다.\n추가 버튼으로 생성해보세요~',
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
}
