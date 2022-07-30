import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/MyTheme.dart';
import 'package:clickbyme/Tool/SheetGetx/calendarshowsetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayContentHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayScript.dart';
import 'package:clickbyme/sheets/DelOrEditCalendar.dart';
import 'package:clickbyme/sheets/addcalendar.dart';
import 'package:clickbyme/sheets/settingCalendarHome.dart';
import 'package:clickbyme/sheets/settingChoiceC.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../DB/Event.dart';
import '../../../Tool/ContainerDesign.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/calendarthemesetting.dart';

class ChooseCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseCalendarState();
}

class _ChooseCalendarState extends State<ChooseCalendar>
    with TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final controll_cals = Get.put(calendarshowsetting());
  static final controll_cals2 = Get.put(calendarthemesetting());
  int setcal_fromsheet = 0;
  int themecal_fromsheet = controll_cals2.themecalendar;
  String username = Hive.box('user_info').get(
    'id',
  );
  TextEditingController controller = TextEditingController();
  final searchNode = FocusNode();
  final inputNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List list_calendar_home = [];
  bool _showBackToTopButton = false;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    setcal_fromsheet = controll_cals.showcalendar;
    themecal_fromsheet = controll_cals2.themecalendar;
    controller = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 20) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: BGColor(),
      resizeToAvoidBottomInset: false,
      body: ChoiceC(),
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
                                                        //리스트 추가하는 창 띄우기
                                                        Hive.box('user_setting')
                                                            .put('typecalendar',
                                                                0);
                                                        addcalendar(
                                                            context,
                                                            searchNode,
                                                            controller,
                                                            username);
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SearchBox(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      listy(),
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
  }

  listy() {
    return StatefulBuilder(builder: (_, StateSetter setState) {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('CalendarSheetHome')
            .where('madeUser', isEqualTo: username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: NeumorphicText(
                      '기록된 일정이 없네요;;;',
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
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => DayContentHome(
                                title: snapshot.data!.docs[index].id),
                            transition: Transition.rightToLeft,
                          );
                        },
                        onLongPress: () {
                          //삭제 및 이름변경 띄우기
                          settingChoiceCal(context, controller, 
                          snapshot.data!.docs[index].id, snapshot.data!.docs[index]['type'],
                          snapshot.data!.docs[index]['color']);
                        },
                        child: ContainerDesign(
                            child: Column(
                              children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['calname'],
                                          maxLines: 5,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: TextColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: contentTitleTextsize(),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    NeumorphicText(
                                      'Made By ' +
                                          snapshot.data!.docs[index]
                                              ['madeUser'],
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        depth: 3,
                                        color: TextColor(),
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTextsize(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            color: snapshot.data!.docs[index]['color'] != null
                                ? Color(snapshot.data!.docs[index]['color'])
                                : Colors.blue),
                      );
                    });
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    });
  }

  settingChoiceCal(
    BuildContext context,
    TextEditingController controller, 
    doc, 
    doc_type, 
    doc_color,
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
                      child: SheetPageC(context, controller, searchNode, doc, doc_type, doc_color),
                    )),
              ));
        }).whenComplete(() {
      setState(() {
        controller.clear();
      });
    });
  }
}
