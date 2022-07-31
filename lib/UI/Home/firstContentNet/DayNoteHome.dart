import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/SheetGetx/memosearchsetting.dart';
import 'package:clickbyme/Tool/SheetGetx/memosortsetting.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/UI/Home/firstContentNet/MemoScript.dart';
import 'package:clickbyme/sheets/DelOrEditMemo.dart';
import 'package:clickbyme/sheets/settingMemoHome.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
    ));
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
                                                      /*Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .bottomToTop,
                                                            child: DayScript(
                                                              index: 0,
                                                              date: DateTime.now(),
                                                              position: 'note',
                                                            )),
                                                      );*/
                                                      Get.to(
                                                          () => DayScript(
                                                                index: 0,
                                                                date: DateTime
                                                                    .now(),
                                                                position:
                                                                    'note',
                                                                title: '',
                                                                share: [],
                                                              ),
                                                          transition: Transition
                                                              .downToUp);
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
                                                            color: TextColor(),
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
                                                      settingMemoHome(context, controll_memo,
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
                              MemoBox(),
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
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: '톱니바퀴 -> 조건설정 후 검색',
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
  }
  settingMemoHome(
      BuildContext context, memosearchsetting controll_memo, memosortsetting controll_memo2,
      ) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20), topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),)),
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
                ))
          );
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

  MemoBox() {
    return SizedBox(
        height: memocontent.isEmpty
            ? MediaQuery.of(context).size.height * 0.5
            : 160 * (memocontent.length.toDouble()) + 50,
        child: memo());
  }

  memo() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return SizedBox(
          height: memocontent.isEmpty
              ? MediaQuery.of(context).size.height * 0.5
              : 150 * (memocontent.length.toDouble()),
          width: MediaQuery.of(context).size.width - 40,
          child: memocontent.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '기록된 메모가 없네요;;;',
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: TextColor(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: memocontent.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            DelOrEditMemo(context, index);
                          },
                          child: ContainerDesign(
                              child: SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            height: 30,
                                            child: Center(
                                              child: Text(memotitle[index],
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: TextColor(),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                            )),
                                        SizedBox(
                                          height: 50,
                                          child: Text(
                                            memocontent[index],
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: 20,
                                        child: memostar[index] == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: NeumorphicIcon(
                                                  Icons.star,
                                                  size: 20,
                                                  style: NeumorphicStyle(
                                                      shape: NeumorphicShape
                                                          .convex,
                                                      depth: 2,
                                                      color: TextColor(),
                                                      lightSource:
                                                          LightSource.topLeft),
                                                ),
                                              )
                                            : (memostar[index] == 2
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.star,
                                                          size: 20,
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
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.star,
                                                          size: 20,
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
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.star,
                                                          size: 20,
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
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.star,
                                                          size: 20,
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
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: NeumorphicIcon(
                                                          Icons.star,
                                                          size: 20,
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
                                                    ],
                                                  ))),
                                  ],
                                ),
                              ),
                              color: BGColor()),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ));
    });
  }
}
