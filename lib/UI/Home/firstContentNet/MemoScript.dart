import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../Tool/NoBehavior.dart';

class MemoScript extends StatefulWidget {
  MemoScript({Key? key, required this.index, required this.cardindex})
      : super(key: key);
  final int index;
  final String cardindex;
  @override
  State<StatefulWidget> createState() => _MemoScriptState();
}

class _MemoScriptState extends State<MemoScript> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  final _formkey_title = GlobalKey<FormState>();
  final _formkey_content = GlobalKey<FormState>();
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  final List memostar = [1, 2, 1, 1, 3];
  final List memotitle = ['memo1', 'memo2', 'memo3', 'memo4', 'memo5'];
  final List memocontent = [
    '하루 한번 채식식단 실천하기',
    '대중교통 이용하여 출근하기',
    '토익공부 하루에 유닛4과씩 진도 나가기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기',
    '알고리즘 하루에 4개씩 파이썬 자바 두언어로 만들기 fighting!!!',
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('ememo_stars', 1);
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
                                                style: const TextStyle(
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
                              const SizedBox(
                                height: 20,
                              ),
                              buildSheetTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              Title(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildContentTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              Content(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildStarTitle(),
                              const SizedBox(
                                height: 20,
                              ),
                              Star(),
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

  buildSheetTitle() {
    return const SizedBox(
      height: 30,
      child: Text(
        '메모제목',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }

  Title() {
    return SizedBox(
      height: 30,
      child: TextFormField(
        key: _formkey_title,
        readOnly: widget.index == 2 ? true : false,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: widget.index == 0 ? '제목 입력' : memotitle[int.parse(widget.cardindex)],
        ),
        onFieldSubmitted: (_) {
          //saveForm();
        },
        controller: textEditingController1,
      ),
    );
  }

  buildContentTitle() {
    return const SizedBox(
      height: 30,
      child: Text(
        '메모내용',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }

  Content() {
    return SizedBox(
      height: 100,
      child: TextFormField(
        key: _formkey_content,
        readOnly: widget.index == 2 ? true : false,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: widget.index == 0 ? '내용 입력' : memocontent[int.parse(widget.cardindex)],
        ),
        onFieldSubmitted: (_) {
          //saveForm();
        },
        controller: textEditingController1,
      ),
    );
  }

  buildStarTitle() {
    return const SizedBox(
      height: 30,
      child: Text(
        '중요도 선택',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }

  Star() {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        primary:
                            Hive.box('user_setting').get('ememo_stars') == 1
                                ? Colors.grey.shade400
                                : Colors.white,
                        side: const BorderSide(
                          width: 1,
                          color: Colors.black45,
                        )),
                    onPressed: () {
                      setState(() {
                        Hive.box('user_setting').put('ememo_stars', 1);
                      });
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '+1',
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: Hive.box('user_setting')
                                            .get('ememo_stars') ==
                                        1
                                    ? Colors.white
                                    : Colors.black45,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              )),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      primary: Hive.box('user_setting').get('ememo_stars') == 2
                          ? Colors.grey.shade400
                          : Colors.white,
                      side: const BorderSide(
                        width: 1,
                        color: Colors.black45,
                      )),
                  onPressed: () {
                    setState(() {
                      Hive.box('user_setting').put('ememo_stars', 2);
                    });
                  },
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: NeumorphicText(
                            '+2',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color:
                                  Hive.box('user_setting').get('ememo_stars') ==
                                          2
                                      ? Colors.white
                                      : Colors.black45,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      primary: Hive.box('user_setting').get('ememo_stars') == 3
                          ? Colors.grey.shade400
                          : Colors.white,
                      side: const BorderSide(
                        width: 1,
                        color: Colors.black45,
                      )),
                  onPressed: () {
                    setState(() {
                      Hive.box('user_setting').put('ememo_stars', 3);
                    });
                  },
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: NeumorphicText(
                            '+3',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color:
                                  Hive.box('user_setting').get('ememo_stars') ==
                                          3
                                      ? Colors.white
                                      : Colors.black45,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Pictures() {
    return const SizedBox(
      height: 30,
      child: Text(
        '첨부사진 및 영상',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }
}
