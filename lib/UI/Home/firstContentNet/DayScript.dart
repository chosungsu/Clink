import 'package:clickbyme/sheets/addCalendarTodo.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/NoBehavior.dart';

class DayScript extends StatefulWidget {
  DayScript(
      {Key? key, required this.index, required this.date})
      : super(key: key);
  final int index;
  final DateTime date;
  @override
  State<StatefulWidget> createState() => _DayScriptState();
}

class _DayScriptState extends State<DayScript> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  DateTime _selectedDay = DateTime.now();
  bool isclickedshowmore = false;
  final _formkey = GlobalKey<FormState>();
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    textEditingController2 = TextEditingController();
    textEditingController3 = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
    textEditingController3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: UI(),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
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
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: NeumorphicIcon(
                                            Icons.keyboard_arrow_left,
                                            size: 30,
                                            style: const NeumorphicStyle(
                                                shape: NeumorphicShape.convex,
                                                depth: 2,
                                                surfaceIntensity: 0.5,
                                                color: Colors.black45,
                                                lightSource:
                                                    LightSource.topLeft),
                                          ),
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        60 -
                                        160,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                widget.index == 0
                                                    ? '작성하기'
                                                    : (widget.index == 1
                                                        ? '수정하기'
                                                        : '삭제하기'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black45),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ],
                            )),
                        SizedBox(
                            width: 50,
                            child: InkWell(
                                onTap: () {
                                  settingRoutineHome(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 30,
                                  height: 30,
                                  child: NeumorphicIcon(
                                    Icons.done_all,
                                    size: 30,
                                    style: const NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 2,
                                        surfaceIntensity: 0.5,
                                        color: Colors.black45,
                                        lightSource: LightSource.topLeft),
                                  ),
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
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSheetTitle(widget.date),
                              const SizedBox(
                                height: 20,
                              ),
                              Title(),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 120,
                                child: Row(
                                  children: [
                                    Content(context, textEditingController2,
                                        'prev', widget.date),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Content(context, textEditingController3,
                                        'after', widget.date),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Pictures(),
                              const SizedBox(
                                height: 150,
                              )
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

  buildSheetTitle(DateTime fromDate) {
    return SizedBox(
      height: 30,
      child: Text(
        '세부내용',
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }

  Title() {
    return SizedBox(
      height: 30,
      child: TextFormField(
        key: _formkey,
        readOnly: widget.index == 2 ? true : false,
        style: const TextStyle(fontSize: 18),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: '일정 제목 추가',
        ),
        onFieldSubmitted: (_) {
          //saveForm();
        },
        controller: textEditingController1,
      ),
    );
  }

  Content(
    BuildContext context,
    TextEditingController textEditingController,
    String s,
    DateTime fromDate,
  ) {
    return SizedBox(
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            s == 'prev'
                ? const SizedBox(
                    height: 30,
                    child: Text(
                      '시작시각',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ))
                : const SizedBox(
                    height: 30,
                    child: Text(
                      '종료시각',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black45),
                            decoration:
                                const InputDecoration(hintText: '시간 : 분'),
                            readOnly: true,
                            controller: textEditingController,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.index == 2) {
                      } else {
                        pickDates(context, textEditingController, fromDate);
                      }
                    },
                    child: const Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Pictures() {
    return SizedBox(
      height: 30,
      child: Text(
        '첨부사진 및 영상',
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }
}
