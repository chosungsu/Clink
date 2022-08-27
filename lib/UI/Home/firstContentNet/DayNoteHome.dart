import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/ClickShowEachNote.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/settingMemoHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/Getx/memosearchsetting.dart';
import '../../../Tool/Getx/memosortsetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/NoBehavior.dart';

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
  final scollection = Get.put(selectcollection());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final searchNode = FocusNode();
  String username = Hive.box('user_info').get(
    'id',
  );
  int sort = 0;
  List<String> textsummary = [];
  String tmpsummary = '';
  DateTime Date = DateTime.now();
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

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
    super.dispose();
    _scrollController.dispose();
    controller.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
    if (_scrollController.offset == 300) {
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
            backgroundColor: BGColor(),
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: UI(),
            ),
            floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _showBackToTopButton == false
                    ? const SizedBox()
                    : FloatingActionButton(
                        onPressed: _scrollToTop,
                        backgroundColor: BGColor(),
                        child: Icon(
                          Icons.arrow_upward,
                          color: TextColor(),
                        ),
                      ),
                const SizedBox(width: 10),
                SpeedDial(
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
                          Icons.local_offer,
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
                          addmemocollector(context, username, controller,
                              searchNode, 'outside', scollection);
                        },
                        label: '메모태그 추가',
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
                                    firstdate: DateTime.now(),
                                    lastdate: DateTime.now(),
                                    position: 'note',
                                    title: '',
                                    share: const [],
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
                    ]),
              ],
            )));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(color: BGColor()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                    'sort_memo_card',
                                                                    1)
                                                            : Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'sort_memo_card',
                                                                    0);
                                                        Hive.box('user_setting')
                                                                        .get(
                                                                            'sort_memo_card') ==
                                                                    0 ||
                                                                Hive.box('user_setting')
                                                                        .get(
                                                                            'sort_memo_card') ==
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
                                                        Icons.filter_list,
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
              ADBox(),
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
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
  }*/

  settingMemoHome(
    BuildContext context,
    memosearchsetting controllMemo,
    memosortsetting controllMemo2,
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
                        controllMemo, controllMemo2, searchmemo_fromsheet),
                  )));
        }).whenComplete(() {
      setState(() {
        sortmemo_fromsheet = controllMemo2.memosort;
        searchmemo_fromsheet = controllMemo.memosearch;
      });
    });
  }

  ADBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ADEvents(context),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  listy_My() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('MemoDataBase')
            .where('OriginalUser', isEqualTo: username)
            .orderBy('EditDate', descending: sort == 0 ? true : false)
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
                          '생성된 메모가 없습니다.\n추가 버튼으로 생성해보세요~',
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
                            childAspectRatio: 3 / 6,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    itemBuilder: (context, index) {
                      tmpsummary = '';
                      if (snapshot.data!.docs[index]['memolist'] != null) {
                        for (String textsummarytmp in snapshot.data!.docs[index]
                            ['memolist']) {
                          tmpsummary += textsummarytmp + '\n';
                        }
                      } else {
                        tmpsummary = '홈에서 직접 생성한 메모장입니다.';
                      }

                      textsummary.insert(index, tmpsummary);
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              child: FocusedMenuHolder(
                            menuItems: [
                              FocusedMenuItem(
                                  trailingIcon: Icon(
                                    snapshot.data!.docs[index]['homesave'] ==
                                            false
                                        ? Icons.launch
                                        : Icons.block,
                                    color: snapshot.data!.docs[index]
                                                ['homesave'] ==
                                            false
                                        ? Colors.blue.shade400
                                        : Colors.red.shade400,
                                  ),
                                  title: Text(
                                      snapshot.data!.docs[index]['homesave'] ==
                                              false
                                          ? '내보내기'
                                          : '내보내기 중단',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize())),
                                  onPressed: () {
                                    setState(() {
                                      snapshot.data!.docs[index]['homesave'] ==
                                              false
                                          ? firestore
                                              .collection('MemoDataBase')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                              'homesave': true,
                                            })
                                          : firestore
                                              .collection('MemoDataBase')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                              'homesave': false,
                                            });
                                    });
                                  }),
                              FocusedMenuItem(
                                  trailingIcon: Icon(
                                    snapshot.data!.docs[index]['security'] ==
                                            false
                                        ? Icons.lock_open
                                        : Icons.lock,
                                    color: snapshot.data!.docs[index]
                                                ['security'] ==
                                            false
                                        ? Colors.blue.shade400
                                        : Colors.red.shade400,
                                  ),
                                  title: Text(
                                      snapshot.data!.docs[index]['security'] ==
                                              false
                                          ? '잠금설정'
                                          : '잠금해제',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: contentTextsize())),
                                  onPressed: () {
                                    setState(() {
                                      //하단 시트로 지문, 얼굴인식 로직 띄우기
                                      snapshot.data!.docs[index]['security'] ==
                                              false
                                          ? firestore
                                              .collection('MemoDataBase')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                              'security': true,
                                            })
                                          : firestore
                                              .collection('MemoDataBase')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                              'security': false,
                                            });
                                    });
                                  }),
                            ],
                            duration: const Duration(seconds: 0),
                            animateMenuItems: true,
                            menuOffset: 20,
                            bottomOffsetHeight: 10,
                            menuWidth:
                                (MediaQuery.of(context).size.width - 50) / 2,
                            openWithTap: false,
                            onPressed: () {
                              //개별 노트로 이동로직
                              Get.to(
                                  () => ClickShowEachNote(
                                        date: snapshot.data!.docs[index]
                                            ['Date'],
                                        doc: snapshot.data!.docs[index].id,
                                        doccollection: snapshot.data!
                                                .docs[index]['Collection'] ??
                                            '',
                                        doccolor: snapshot.data!.docs[index]
                                            ['color'],
                                        docindex: snapshot.data!.docs[index]
                                                ['memoindex'] ??
                                            [],
                                        docname: snapshot.data!.docs[index]
                                            ['memoTitle'],
                                        docsummary: snapshot.data!.docs[index]
                                                ['memolist'] ??
                                            [],
                                        editdate: snapshot.data!.docs[index]
                                            ['EditDate'],
                                      ),
                                  transition: Transition.downToUp);
                            },
                            child: Stack(
                              children: [
                                ContainerDesign(
                                    child: SizedBox(
                                        height: 260,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    80) /
                                                2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  height: 60,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    child: Text(
                                                      snapshot.data!.docs[index]
                                                          ['memoTitle'],
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTitleTextsize(),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        )),
                                    color: BGColor()),
                                SizedBox(
                                  height: 200,
                                  child: ContainerDesign(
                                      child: Column(
                                        children: [
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 110,
                                                        child: Text(
                                                          textsummary[index],
                                                          softWrap: true,
                                                          maxLines: 3,
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
                                                    ],
                                                  ))),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              RotatedBox(
                                                quarterTurns: 0,
                                                child: TextButton.icon(
                                                  style: TextButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        color:
                                                            TextColor_shadowcolor()),
                                                    backgroundColor: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['color'] !=
                                                            null
                                                        ? Color(snapshot.data!
                                                                .docs[index]
                                                            ['color'])
                                                        : Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.0),
                                                    ),
                                                  ),
                                                  onPressed: () => {},
                                                  icon: Icon(Icons.local_offer,
                                                      color:
                                                          TextColor_shadowcolor()),
                                                  label: Text(
                                                    snapshot.data!.docs[index]
                                                            ['Collection'] ??
                                                        '지정안됨',
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color:
                                                          TextColor_shadowcolor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          contentTextsize(),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      color: snapshot.data!.docs[index]
                                                  ['color'] !=
                                              null
                                          ? Color(snapshot.data!.docs[index]
                                              ['color'])
                                          : Colors.white),
                                ),
                              ],
                            ),
                          ))
                        ],
                      );
                    });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Center(child: CircularProgressIndicator())],
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
