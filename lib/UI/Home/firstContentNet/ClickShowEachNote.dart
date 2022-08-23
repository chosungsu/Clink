import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/sheets/settingRoutineHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../DB/MemoList.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/SheetGetx/selectcollection.dart';
import '../../../Tool/TextSize.dart';
import 'DayScript.dart';

class ClickShowEachNote extends StatefulWidget {
  ClickShowEachNote({
    Key? key,
    required this.date,
    required this.doc,
    required this.docname,
    required this.doccollection,
    required this.docsummary,
    required this.doccolor,
    required this.docindex,
    required this.editdate,
  }) : super(key: key);
  final String date;
  final String editdate;
  final String doc;
  final String docname;
  final String doccollection;
  final List docsummary;
  final int doccolor;
  final List docindex;
  @override
  State<StatefulWidget> createState() => _ClickShowEachNoteState();
}

class _ClickShowEachNoteState extends State<ClickShowEachNote> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  late TextEditingController textEditingController1;
  late TextEditingController textEditingController_add_sheet;
  final searchNode_first_section = FocusNode();
  final searchNode_add_section = FocusNode();
  final searchNode = FocusNode();
  List updateid = [];
  List deleteid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  final scollection = Get.put(selectcollection());
  List<TextEditingController> controllers = [];
  List<FocusNode> nodes = [];
  List<bool> checkbottoms = [
    false,
    false,
    false,
  ];
  Color _color = Colors.white;
  List<MemoList> checklisttexts = [];
  DateTime editDateTo = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    scollection.resetmemolist();
    textEditingController1 = TextEditingController(text: widget.docname);
    textEditingController_add_sheet = TextEditingController();
    Hive.box('user_setting').put('memocollection', widget.doccollection);
    _color = widget.doccolor != null ? Color(widget.doccolor) : BGColor();
    //scollection.addmemolist(widget.docindex.length);
    for (int j = 0; j < widget.docindex.length; j++) {
      Hive.box('user_setting').put('optionmemoinput', widget.docindex[j]);
      scollection.addmemolistin(j);
    }
    for (int k = 0; k < widget.docindex.length; k++) {
      Hive.box('user_setting')
          .put('optionmemocontentinput', widget.docsummary[k]);
      scollection.addmemolistcontentin(k);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController_add_sheet.dispose();
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('경고',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: Colors.redAccent,
                      )),
                  content: Text('뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                          color: Colors.blueGrey)),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        '머무를게요',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    TextButton(
                      child: Text(
                        '나가기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                            color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: GestureDetector(
          onTap: () {
            searchNode_first_section.unfocus();
            searchNode_add_section.unfocus();
            for (int i = 0; i < nodes.length; i++) {
              nodes[i].unfocus();
            }
          },
          child: UI(),
        ),
      ),
      bottomNavigationBar: GetBuilder<selectcollection>(
          builder: (_) => Container(
              padding: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                  color: BGColor_shadowcolor(),
                  border: Border(
                      top: BorderSide(
                          color: TextColor_shadowcolor(), width: 2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.post_add),
                    color: checkbottoms[0] == false
                        ? NaviColor(false)
                        : NaviColor(true),
                    iconSize: 20,
                    onPressed: () {
                      setState(() {
                        checkbottoms[0] == false
                            ? checkbottoms[0] = true
                            : checkbottoms[0] = false;
                        if (checkbottoms[0] == true) {
                          Hive.box('user_setting').put('optionmemoinput', 0);
                          Hive.box('user_setting')
                              .put('optionmemocontentinput', null);
                          scollection.addmemolistin(scollection.memoindex);
                          scollection
                              .addmemolistcontentin(scollection.memoindex - 1);

                          checkbottoms[0] = false;
                        }
                        for (int i = 0; i < nodes.length; i++) {
                          nodes[i].unfocus();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_box_outline_blank),
                    color: checkbottoms[1] == false
                        ? NaviColor(false)
                        : NaviColor(true),
                    iconSize: 20,
                    onPressed: () {
                      setState(() {
                        checkbottoms[1] == false
                            ? checkbottoms[1] = true
                            : checkbottoms[1] = false;
                        if (checkbottoms[1] == true) {
                          Hive.box('user_setting').put('optionmemoinput', 1);
                          Hive.box('user_setting')
                              .put('optionmemocontentinput', null);
                          scollection.addmemolistin(scollection.memoindex);
                          scollection
                              .addmemolistcontentin(scollection.memoindex - 1);
                          checkbottoms[1] = false;
                        }
                        for (int i = 0; i < nodes.length; i++) {
                          nodes[i].unfocus();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_rate),
                    color: checkbottoms[2] == false
                        ? NaviColor(false)
                        : NaviColor(true),
                    iconSize: 20,
                    onPressed: () {
                      setState(() {
                        checkbottoms[2] == false
                            ? checkbottoms[2] = true
                            : checkbottoms[2] = false;
                        if (checkbottoms[2] == true) {
                          Hive.box('user_setting').put('optionmemoinput', 2);
                          Hive.box('user_setting')
                              .put('optionmemocontentinput', null);
                          scollection.addmemolistin(scollection.memoindex);
                          scollection
                              .addmemolistcontentin(scollection.memoindex - 1);
                          checkbottoms[2] = false;
                        }
                        for (int i = 0; i < nodes.length; i++) {
                          nodes[i].unfocus();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100.0)),
                        border: Border.all(
                          color: TextColor(),
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: _color,
                      ),
                    ),
                    color: checkbottoms[2] == false
                        ? NaviColor(false)
                        : NaviColor(true),
                    iconSize: 20,
                    onPressed: () {
                      for (int i = 0; i < nodes.length; i++) {
                        nodes[i].unfocus();
                      }
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('선택'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: _color,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      _color = color;
                                    });
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('반영하기'),
                                  onPressed: () {
                                    Hive.box('user_setting').put(
                                        'typecolorcalendar',
                                        _color.value.toInt());
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                  ),
                ],
              ))),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: _color != null ? Color(_color.value.toInt()) : BGColor(),
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
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text('경고',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTitleTextsize(),
                                                          color:
                                                              Colors.redAccent,
                                                        )),
                                                    content: Text(
                                                        '뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize(),
                                                            color: Colors
                                                                .blueGrey)),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          '머무를게요',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize(),
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, false);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          '나가기',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize(),
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                          Get.back();
                                                        },
                                                      )
                                                    ],
                                                  ));
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
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: TextColor(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () async {
                                                      //수정
                                                      for (int i = 0;
                                                          i < nodes.length;
                                                          i++) {
                                                        nodes[i].unfocus();
                                                      }
                                                      if (textEditingController1
                                                          .text.isNotEmpty) {
                                                        Flushbar(
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade400,
                                                          titleText: Text(
                                                              'Uploading...',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    contentTitleTextsize(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          messageText: Text(
                                                              '잠시만 기다려주세요~',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    contentTextsize(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          icon: const Icon(
                                                            Icons.info_outline,
                                                            size: 25.0,
                                                            color: Colors.white,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          leftBarIndicatorColor:
                                                              Colors.green
                                                                  .shade100,
                                                        ).show(context);
                                                        for (int i = 0;
                                                            i <
                                                                scollection
                                                                    .memolistin
                                                                    .length;
                                                            i++) {
                                                          checklisttexts.add(MemoList(
                                                              memocontent:
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      i],
                                                              contentindex:
                                                                  scollection
                                                                          .memolistin[
                                                                      i]));
                                                        }

                                                        firestore
                                                            .collection(
                                                                'MemoDataBase')
                                                            .doc(widget.doc)
                                                            .update(
                                                          {
                                                            'memoTitle':
                                                                textEditingController1
                                                                    .text,
                                                            'Collection': Hive.box('user_setting').get(
                                                                            'memocollection') ==
                                                                        '' ||
                                                                    Hive.box('user_setting').get(
                                                                            'memocollection') ==
                                                                        null
                                                                ? null
                                                                : (widget.doccollection !=
                                                                        Hive.box('user_setting').get(
                                                                            'memocollection')
                                                                    ? Hive.box(
                                                                            'user_setting')
                                                                        .get(
                                                                            'memocollection')
                                                                    : widget
                                                                        .doccollection),
                                                            'memolist': checklisttexts
                                                                    .map((e) => e
                                                                        .memocontent)
                                                                    .toList()
                                                                    .isEmpty
                                                                ? null
                                                                : checklisttexts
                                                                    .map((e) =>
                                                                        e.memocontent)
                                                                    .toList(),
                                                            'memoindex': checklisttexts
                                                                    .map((e) => e
                                                                        .contentindex)
                                                                    .toList()
                                                                    .isEmpty
                                                                ? null
                                                                : checklisttexts
                                                                    .map((e) =>
                                                                        e.contentindex)
                                                                    .toList(),
                                                            'OriginalUser':
                                                                username,
                                                            'color': _color
                                                                .value
                                                                .toInt(),
                                                            'EditDate': editDateTo
                                                                        .toString()
                                                                        .split(
                                                                            '-')[
                                                                    0] +
                                                                '-' +
                                                                editDateTo
                                                                        .toString()
                                                                        .split(
                                                                            '-')[
                                                                    1] +
                                                                '-' +
                                                                editDateTo
                                                                    .toString()
                                                                    .split(
                                                                        '-')[2]
                                                                    .substring(
                                                                        0, 2) +
                                                                '일',
                                                          },
                                                        ).whenComplete(() {
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 0),
                                                              () {
                                                            Flushbar(
                                                              backgroundColor:
                                                                  Colors.blue
                                                                      .shade400,
                                                              titleText: Text(
                                                                  'Notice',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        contentTitleTextsize(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                              messageText: Text(
                                                                  '메모가 정상적으로 변경되었습니다.',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        contentTextsize(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                              icon: const Icon(
                                                                Icons
                                                                    .info_outline,
                                                                size: 25.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              leftBarIndicatorColor:
                                                                  Colors.blue
                                                                      .shade100,
                                                            )
                                                                .show(context)
                                                                .whenComplete(
                                                                    () => Get
                                                                        .back());
                                                          });
                                                        });
                                                      } else {
                                                        Flushbar(
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          titleText: Text(
                                                              'Notice',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    contentTitleTextsize(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          messageText: Text(
                                                              '제목은 필수 입력사항입니다!',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    contentTextsize(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          icon: const Icon(
                                                            Icons.info_outline,
                                                            size: 25.0,
                                                            color: Colors.white,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          leftBarIndicatorColor:
                                                              Colors
                                                                  .red.shade100,
                                                        ).show(context);
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
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
                                                    ))),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: InkWell(
                                                    onTap: () {
                                                      for (int i = 0;
                                                          i < nodes.length;
                                                          i++) {
                                                        nodes[i].unfocus();
                                                      }
                                                      print(
                                                          widget.doccollection);
                                                      //삭제
                                                      Flushbar(
                                                        backgroundColor: Colors
                                                            .green.shade400,
                                                        titleText: Text(
                                                            'Uploading...',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  contentTitleTextsize(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        messageText: Text(
                                                            '잠시만 기다려주세요~',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  contentTextsize(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        icon: const Icon(
                                                          Icons.info_outline,
                                                          size: 25.0,
                                                          color: Colors.white,
                                                        ),
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        leftBarIndicatorColor:
                                                            Colors
                                                                .green.shade100,
                                                      ).show(context).whenComplete(() =>
                                                          firestore
                                                              .collection(
                                                                  'MemoDataBase')
                                                              .where('memoTitle',
                                                                  isEqualTo: textEditingController1
                                                                      .text)
                                                              .where('OriginalUser',
                                                                  isEqualTo:
                                                                      username)
                                                              .where('color',
                                                                  isEqualTo: widget
                                                                      .doccolor
                                                                      .toInt())
                                                              .where('Date', isEqualTo: widget.date.toString().split('-')[0] + '-' + widget.date.toString().split('-')[1] + '-' + widget.date.toString().split('-')[2].substring(0, 2) + '일')
                                                              .get()
                                                              .then((value) {
                                                            deleteid.clear();
                                                            value.docs.forEach(
                                                                (element) {
                                                              deleteid.add(
                                                                  element.id);
                                                            });
                                                            for (int i = 0;
                                                                i <
                                                                    deleteid
                                                                        .length;
                                                                i++) {
                                                              firestore
                                                                  .collection(
                                                                      'MemoDataBase')
                                                                  .doc(deleteid[
                                                                      i])
                                                                  .delete();
                                                            }
                                                          }).whenComplete(() {
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              Flushbar(
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade400,
                                                                titleText: Text(
                                                                    'Notice',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          contentTitleTextsize(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                messageText: Text(
                                                                    '메모가 정상적으로 삭제되었습니다.',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          contentTextsize(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 25.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue
                                                                        .shade100,
                                                              )
                                                                  .show(context)
                                                                  .whenComplete(
                                                                      () => Get
                                                                          .back());
                                                            });
                                                          }));
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 30,
                                                      height: 30,
                                                      child: NeumorphicIcon(
                                                        Icons.delete,
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
                        return GestureDetector(
                          onTap: () {
                            searchNode.unfocus();
                            searchNode_first_section.unfocus();
                            for (int i = 0;
                                i < scollection.memolistcontentin.length;
                                i++) {
                              if (nodes.isNotEmpty) {
                                nodes[i].unfocus();
                              }
                              scollection.memolistcontentin[i] =
                                  controllers[i].text;
                            }
                          },
                          child: Padding(
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
                                Contents(),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
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
    return Column(
      children: [
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text(
                  '최초 작성시간 : ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(widget.date.toString(),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            )),
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text(
                  '마지막 수정시간 : ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(widget.editdate.toString(),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 30,
            child: Row(
              children: [
                Text(
                  '메모제목',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text('필수항목',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ))
      ],
    );
  }

  Contents() {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: TextField(
                minLines: 1,
                maxLines: 3,
                focusNode: searchNode_first_section,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style:
                    TextStyle(fontSize: contentTextsize(), color: TextColor()),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '제목 입력',
                  hintStyle: TextStyle(
                      fontSize: contentTextsize(), color: TextColor()),
                ),
                controller: textEditingController1,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        '컬렉션 선택',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTitleTextsize(),
                            color: TextColor()),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        for (int i = 0;
                            i < scollection.memolistcontentin.length;
                            i++) {
                          nodes[i].unfocus();
                          scollection.memolistcontentin[i] =
                              controllers[i].text;
                        }
                        addmemocollector(
                          context,
                          username,
                          textEditingController_add_sheet,
                          searchNode_add_section,
                          'inside',
                          scollection,
                        );
                      },
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
                    )
                  ],
                )),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 30,
              child: Text(
                '+아이콘으로 MY컬렉션을 추가 및 지정해주세요',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GetBuilder<selectcollection>(
              builder: (_) => SizedBox(
                  height: 30,
                  child: Text(
                    Hive.box('user_setting').get('memocollection') == '' ||
                            Hive.box('user_setting').get('memocollection') ==
                                null
                        ? '지정된 컬렉션이 없습니다.'
                        : (widget.doccollection !=
                                Hive.box('user_setting').get('memocollection')
                            ? '지정한 컬렉션 이름 : ' +
                                Hive.box('user_setting').get('memocollection')
                            : '지정한 컬렉션 이름 : ' + widget.doccollection),
                    style: TextStyle(
                        fontSize: contentTextsize(), color: TextColor()),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              child: Text(
                '메모내용',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: TextColor()),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 30,
              child: Text(
                '하단 아이콘으로 메모내용 작성하시면 됩니다.',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blue),
              ),
            ),
            GetBuilder<selectcollection>(
                builder: (_) => scollection.memolistin.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: scollection.memolistin.length,
                        itemBuilder: (context, index) {
                          nodes.add(FocusNode());
                          controllers.add(TextEditingController());
                          widget.docsummary.length <= index
                              ? null
                              : controllers[index].text =
                                  scollection.memolistcontentin[index];
                          return Row(
                            children: [
                              const SizedBox(
                                width: 3,
                              ),
                              scollection.memolistin[index] == 0
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: DetectableTextField(
                                        onTap: () {
                                          scollection.memolistcontentin[index] =
                                              controllers[index].text;
                                        },
                                        onChanged: (text) {
                                          scollection.memolistcontentin[index] =
                                              text;
                                        },
                                        minLines: null,
                                        maxLines: null,
                                        focusNode: nodes[index]..hasFocus,
                                        basicStyle: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: TextColor(),
                                        ),
                                        controller: controllers[index]
                                          ..selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: controllers[index]
                                                          .text
                                                          .length)),
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    controllers[index].text =
                                                        '';
                                                    scollection
                                                        .removelistitem(index);
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.red),
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (index == 0) {
                                                        } else {
                                                          String content_prev =
                                                              controllers[
                                                                      index - 1]
                                                                  .text;
                                                          int indexcontent_prev =
                                                              scollection
                                                                      .memolistin[
                                                                  index - 1];
                                                          scollection
                                                              .removelistitem(
                                                                  index - 1);
                                                          Hive.box('user_setting').put(
                                                              'optionmemoinput',
                                                              indexcontent_prev);
                                                          Hive.box(
                                                                  'user_setting')
                                                              .put(
                                                                  'optionmemocontentinput',
                                                                  content_prev);
                                                          scollection
                                                              .addmemolistin(
                                                                  index);
                                                          scollection
                                                              .addmemolistcontentin(
                                                                  index);
                                                          controllers[index - 1]
                                                              .text = scollection
                                                                  .memolistcontentin[
                                                              index - 1];
                                                          controllers[index]
                                                              .text = scollection
                                                                  .memolistcontentin[
                                                              index];
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.expand_less,
                                                        color:
                                                            TextColor_shadowcolor()),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (index + 1 ==
                                                            scollection
                                                                .memoindex) {
                                                        } else {
                                                          String content =
                                                              scollection
                                                                      .memolistcontentin[
                                                                  index];
                                                          int indexcontent =
                                                              scollection
                                                                      .memolistin[
                                                                  index];
                                                          scollection
                                                              .removelistitem(
                                                                  index);
                                                          Hive.box(
                                                                  'user_setting')
                                                              .put(
                                                                  'optionmemoinput',
                                                                  indexcontent);
                                                          Hive.box(
                                                                  'user_setting')
                                                              .put(
                                                                  'optionmemocontentinput',
                                                                  content);
                                                          scollection
                                                              .addmemolistin(
                                                                  index + 1);
                                                          scollection
                                                              .addmemolistcontentin(
                                                                  index + 1);
                                                          controllers[index]
                                                              .text = scollection
                                                                  .memolistcontentin[
                                                              index];
                                                          controllers[index + 1]
                                                              .text = scollection
                                                                  .memolistcontentin[
                                                              index + 1];
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.expand_more,
                                                        color:
                                                            TextColor_shadowcolor()),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          hintText: '내용 입력',
                                          hintStyle: TextStyle(
                                              fontSize: contentTextsize(),
                                              color: TextColor_shadowcolor()),
                                        ),
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        detectionRegExp: detectionRegExp()!,
                                        onDetectionTyped: (text) {
                                          print(text);
                                        },
                                        onDetectionFinished: () {
                                          print('finished');
                                        },
                                      ))
                                  : (scollection.memolistin[index] == 1 ||
                                          scollection.memolistin[index] == 999
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: TextField(
                                            minLines: 1,
                                            maxLines: 1,
                                            onTap: () {
                                              scollection.memolistcontentin[
                                                      index] =
                                                  controllers[index].text;
                                            },
                                            onChanged: (text) {
                                              scollection.memolistcontentin[
                                                  index] = text;
                                            },
                                            focusNode: nodes[index],
                                            textAlign: TextAlign.start,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: TextColor(),
                                                decorationThickness: 2.3,
                                                decoration: scollection
                                                                .memolistin[
                                                            index] ==
                                                        999
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                            decoration: InputDecoration(
                                              isCollapsed: true,
                                              border: InputBorder.none,
                                              prefixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    scollection.memolistin[
                                                                index] ==
                                                            999
                                                        ? scollection
                                                                .memolistin[
                                                            index] = 1
                                                        : scollection
                                                                .memolistin[
                                                            index] = 999;
                                                  });
                                                },
                                                child: Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    color: TextColor()),
                                              ),
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        controllers[index]
                                                            .text = '';
                                                        scollection
                                                            .removelistitem(
                                                                index);
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.red),
                                                  ),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (index == 0) {
                                                            } else {
                                                              String
                                                                  content_prev =
                                                                  controllers[
                                                                          index -
                                                                              1]
                                                                      .text;
                                                              int indexcontent_prev =
                                                                  scollection
                                                                          .memolistin[
                                                                      index -
                                                                          1];
                                                              scollection
                                                                  .removelistitem(
                                                                      index -
                                                                          1);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemoinput',
                                                                  indexcontent_prev);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemocontentinput',
                                                                  content_prev);
                                                              scollection
                                                                  .addmemolistin(
                                                                      index);
                                                              scollection
                                                                  .addmemolistcontentin(
                                                                      index);
                                                              controllers[
                                                                      index - 1]
                                                                  .text = scollection
                                                                      .memolistcontentin[
                                                                  index - 1];
                                                              controllers[index]
                                                                      .text =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.expand_less,
                                                            color:
                                                                TextColor_shadowcolor()),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (index + 1 ==
                                                                scollection
                                                                    .memoindex) {
                                                            } else {
                                                              String content =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                              int indexcontent =
                                                                  scollection
                                                                          .memolistin[
                                                                      index];
                                                              scollection
                                                                  .removelistitem(
                                                                      index);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemoinput',
                                                                  indexcontent);
                                                              Hive.box(
                                                                      'user_setting')
                                                                  .put(
                                                                      'optionmemocontentinput',
                                                                      content);
                                                              scollection
                                                                  .addmemolistin(
                                                                      index +
                                                                          1);
                                                              scollection
                                                                  .addmemolistcontentin(
                                                                      index +
                                                                          1);
                                                              controllers[index]
                                                                      .text =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                              controllers[
                                                                      index + 1]
                                                                  .text = scollection
                                                                      .memolistcontentin[
                                                                  index + 1];
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.expand_more,
                                                            color:
                                                                TextColor_shadowcolor()),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              hintText: '내용 입력',
                                              hintStyle: TextStyle(
                                                  fontSize: contentTextsize(),
                                                  color:
                                                      TextColor_shadowcolor()),
                                            ),
                                            controller: controllers[index]
                                              ..selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              controllers[index]
                                                                  .text
                                                                  .length)),
                                          ),
                                        )
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: TextField(
                                            onTap: () {
                                              scollection.memolistcontentin[
                                                      index] =
                                                  controllers[index].text;
                                            },
                                            onChanged: (text) {
                                              scollection.memolistcontentin[
                                                  index] = text;
                                            },
                                            minLines: 1,
                                            maxLines: 1,
                                            focusNode: nodes[index],
                                            textAlign: TextAlign.start,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: TextColor_shadowcolor()),
                                            decoration: InputDecoration(
                                              isCollapsed: true,
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.star_rate,
                                                  color: TextColor()),
                                              prefixIconColor: TextColor(),
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        controllers[index]
                                                            .text = '';
                                                        scollection
                                                            .removelistitem(
                                                                index);
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.red),
                                                  ),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (index == 0) {
                                                            } else {
                                                              String
                                                                  content_prev =
                                                                  controllers[
                                                                          index -
                                                                              1]
                                                                      .text;
                                                              int indexcontent_prev =
                                                                  scollection
                                                                          .memolistin[
                                                                      index -
                                                                          1];
                                                              scollection
                                                                  .removelistitem(
                                                                      index -
                                                                          1);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemoinput',
                                                                  indexcontent_prev);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemocontentinput',
                                                                  content_prev);
                                                              scollection
                                                                  .addmemolistin(
                                                                      index);
                                                              scollection
                                                                  .addmemolistcontentin(
                                                                      index);
                                                              controllers[
                                                                      index - 1]
                                                                  .text = scollection
                                                                      .memolistcontentin[
                                                                  index - 1];
                                                              controllers[index]
                                                                      .text =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.expand_less,
                                                            color:
                                                                TextColor_shadowcolor()),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (index + 1 ==
                                                                scollection
                                                                    .memoindex) {
                                                            } else {
                                                              String content =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                              int indexcontent =
                                                                  scollection
                                                                          .memolistin[
                                                                      index];
                                                              scollection
                                                                  .removelistitem(
                                                                      index);
                                                              Hive.box('user_setting').put(
                                                                  'optionmemoinput',
                                                                  indexcontent);
                                                              Hive.box(
                                                                      'user_setting')
                                                                  .put(
                                                                      'optionmemocontentinput',
                                                                      content);
                                                              scollection
                                                                  .addmemolistin(
                                                                      index +
                                                                          1);
                                                              scollection
                                                                  .addmemolistcontentin(
                                                                      index +
                                                                          1);

                                                              controllers[index]
                                                                      .text =
                                                                  scollection
                                                                          .memolistcontentin[
                                                                      index];
                                                              controllers[
                                                                      index + 1]
                                                                  .text = scollection
                                                                      .memolistcontentin[
                                                                  index + 1];
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.expand_more,
                                                            color:
                                                                TextColor_shadowcolor()),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              hintText: '내용 입력',
                                              hintStyle: TextStyle(
                                                  fontSize: contentTextsize(),
                                                  color:
                                                      TextColor_shadowcolor()),
                                            ),
                                            controller: controllers[index]
                                              ..selection =
                                                  TextSelection.fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              controllers[index]
                                                                  .text
                                                                  .length)),
                                          ),
                                        )),
                              const SizedBox(
                                width: 3,
                              ),
                            ],
                          );
                        })
                    : const SizedBox())
          ],
        );
      },
    );
  }
}
