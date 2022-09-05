import 'dart:io';
import 'package:clickbyme/Dialogs/checkbackincandm.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:clickbyme/UI/Home/Widgets/MemoFocusedHolder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../DB/MemoList.dart';
import '../../../Dialogs/checkdeletecandm.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/Getx/memosetting.dart';
import '../../../Tool/Getx/selectcollection.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Widgets/ImageSlider.dart';
import '../firstContentNet/DayScript.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' show get;

class ClickShowEachNote extends StatefulWidget {
  const ClickShowEachNote({
    Key? key,
    required this.date,
    required this.doc,
    required this.docname,
    required this.doccollection,
    required this.docsummary,
    required this.doccolor,
    required this.docindex,
    required this.editdate,
    required this.image,
    required this.securewith,
  }) : super(key: key);
  final String date;
  final String editdate;
  final String doc;
  final String docname;
  final String doccollection;
  final List image;
  final List docsummary;
  final int doccolor;
  final List docindex;
  final int securewith;
  @override
  State<StatefulWidget> createState() => _ClickShowEachNoteState();
}

class _ClickShowEachNoteState extends State<ClickShowEachNote>
    with WidgetsBindingObserver {
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
  final controll_memo = Get.put(memosetting());
  List<TextEditingController> controllers = [];
  List<FocusNode> nodes = [];
  List<bool> checkbottoms = [
    false,
    false,
    false,
  ];
  List savepicturelist = [];
  final imagePicker = ImagePicker();
  bool ischeckedtohideminus = false;
  bool isresponsive = false;
  Color _color = Colors.white;
  Color tmpcolor = Colors.white;
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
    WidgetsBinding.instance.addObserver(this);
    scollection.resetmemolist();
    controll_memo.resetimagelist();
    Hive.box('user_setting').put('coloreachmemo', widget.doccolor);
    controll_memo.setcolor();
    textEditingController1 = TextEditingController(text: widget.docname);
    textEditingController_add_sheet = TextEditingController();
    Hive.box('user_setting').put('memocollection', widget.doccollection);
    _color = widget.doccolor != null ? Color(widget.doccolor) : BGColor();
    for (int j = 0; j < widget.docindex.length; j++) {
      Hive.box('user_setting').put('optionmemoinput', widget.docindex[j]);
      scollection.addmemolistin(j);
    }
    for (int k = 0; k < widget.docindex.length; k++) {
      Hive.box('user_setting')
          .put('optionmemocontentinput', widget.docsummary[k]);
      scollection.addmemolistcontentin(k);
    }
    for (int i = 0; i < widget.image.length; i++) {
      if (widget.image[i] != null) {
        controll_memo.setimagelist(widget.image[i]);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    textEditingController1.dispose();
    textEditingController_add_sheet.dispose();
  }

  Future<bool> _onBackPressed() async {
    final reloadpage = await Get.dialog(checkbackincandm(context)) ?? false;
    if (reloadpage) {
      Get.back();
    }
    return reloadpage;
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
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
                          color: TextColor_shadowcolor(), width: 1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: ((context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              index == 0
                                  ? MFHolderfirst(
                                      checkbottoms, nodes, scollection)
                                  : (index == 1
                                      ? MFthird(nodes, _color, widget.doc)
                                      : MFsecond(
                                          nodes,
                                          _color,
                                        )),
                            ],
                          );
                        })),
                  ),
                  MFforth(ischeckedtohideminus)
                ],
              ))),
    ));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<memosetting>(
          builder: (_) => SizedBox(
                height: height,
                child: Container(
                    decoration: BoxDecoration(
                      color: _color == controll_memo.color
                          ? _color
                          : controll_memo.color,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Row(
                                        children: [
                                          IconBtn(
                                              child: IconButton(
                                                  onPressed: () async {
                                                    final reloadpage =
                                                        await Get.dialog(
                                                                checkbackincandm(
                                                                    context)) ??
                                                            false;
                                                    if (reloadpage) {
                                                      Get.back();
                                                    }
                                                  },
                                                  icon: Container(
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    child: NeumorphicIcon(
                                                      Icons.keyboard_arrow_left,
                                                      size: 30,
                                                      style: NeumorphicStyle(
                                                          shape: NeumorphicShape
                                                              .convex,
                                                          depth: 2,
                                                          surfaceIntensity: 0.5,
                                                          color: TextColor(),
                                                          lightSource:
                                                              LightSource
                                                                  .topLeft),
                                                    ),
                                                  )),
                                              color: TextColor()),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                            color: TextColor(),
                                                          ),
                                                        ),
                                                      ),
                                                      IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                checklisttexts
                                                                    .clear();
                                                                for (int i = 0;
                                                                    i <
                                                                        scollection
                                                                            .memolistin
                                                                            .length;
                                                                    i++) {
                                                                  checklisttexts.add(MemoList(
                                                                      memocontent:
                                                                          scollection.memolistcontentin[
                                                                              i],
                                                                      contentindex:
                                                                          scollection
                                                                              .memolistin[i]));
                                                                }
                                                                final pdfFile = await MakePDF(
                                                                    textEditingController1
                                                                        .text,
                                                                    controll_memo
                                                                        .imagelist,
                                                                    Hive.box('user_setting').get('memocollection') ==
                                                                                '' ||
                                                                            Hive.box('user_setting').get('memocollection') ==
                                                                                null
                                                                        ? null
                                                                        : (widget.doccollection !=
                                                                                Hive.box('user_setting').get('memocollection')
                                                                            ? Hive.box('user_setting').get('memocollection')
                                                                            : widget.doccollection),
                                                                    checklisttexts);
                                                              },
                                                              icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.share,
                                                                  size: 30,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
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
                                                              )),
                                                          color: TextColor()),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                //수정
                                                                for (int i = 0;
                                                                    i <
                                                                        nodes
                                                                            .length;
                                                                    i++) {
                                                                  nodes[i]
                                                                      .unfocus();
                                                                }
                                                                if (textEditingController1
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  CreateCalandmemoSuccessFlushbar(
                                                                      context);
                                                                  firestore
                                                                      .collection(
                                                                          'AppNoticeByUsers')
                                                                      .add({
                                                                    'title': '[' +
                                                                        widget
                                                                            .docname +
                                                                        '] 메모가 변경되었습니다.',
                                                                    'date': DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .parse(DateTime.now()
                                                                            .toString())
                                                                        .toString()
                                                                        .split(
                                                                            ' ')[0],
                                                                    'username':
                                                                        username
                                                                  });
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          scollection
                                                                              .memolistin
                                                                              .length;
                                                                      i++) {
                                                                    checklisttexts.add(MemoList(
                                                                        memocontent:
                                                                            scollection.memolistcontentin[
                                                                                i],
                                                                        contentindex:
                                                                            scollection.memolistin[i]));
                                                                  }
                                                                  for (int j =
                                                                          0;
                                                                      j <
                                                                          controll_memo
                                                                              .imagelist
                                                                              .length;
                                                                      j++) {
                                                                    savepicturelist.add(
                                                                        controll_memo
                                                                            .imagelist[j]);
                                                                  }

                                                                  firestore
                                                                      .collection(
                                                                          'MemoDataBase')
                                                                      .doc(widget
                                                                          .doc)
                                                                      .update(
                                                                    {
                                                                      'memoTitle':
                                                                          textEditingController1
                                                                              .text,
                                                                      'photoUrl':
                                                                          savepicturelist,
                                                                      'Collection': Hive.box('user_setting').get('memocollection') == '' ||
                                                                              Hive.box('user_setting').get('memocollection') ==
                                                                                  null
                                                                          ? null
                                                                          : (widget.doccollection != Hive.box('user_setting').get('memocollection')
                                                                              ? Hive.box('user_setting').get('memocollection')
                                                                              : widget.doccollection),
                                                                      'memolist': checklisttexts
                                                                              .map((e) => e
                                                                                  .memocontent)
                                                                              .toList()
                                                                              .isEmpty
                                                                          ? null
                                                                          : checklisttexts
                                                                              .map((e) => e.memocontent)
                                                                              .toList(),
                                                                      'memoindex': checklisttexts
                                                                              .map((e) => e
                                                                                  .contentindex)
                                                                              .toList()
                                                                              .isEmpty
                                                                          ? null
                                                                          : checklisttexts
                                                                              .map((e) => e.contentindex)
                                                                              .toList(),
                                                                      'OriginalUser':
                                                                          username,
                                                                      'securewith':
                                                                          widget
                                                                              .securewith,
                                                                      'color': Hive.box('user_setting').get(
                                                                              'coloreachmemo') ??
                                                                          _color
                                                                              .value
                                                                              .toInt(),
                                                                      'EditDate': editDateTo.toString().split('-')[0] +
                                                                          '-' +
                                                                          editDateTo.toString().split('-')[
                                                                              1] +
                                                                          '-' +
                                                                          editDateTo
                                                                              .toString()
                                                                              .split('-')[2]
                                                                              .substring(0, 2) +
                                                                          '일',
                                                                    },
                                                                  ).whenComplete(
                                                                          () {
                                                                    CreateCalandmemoSuccessFlushbarSub(
                                                                        context,
                                                                        '메모');
                                                                  });
                                                                } else {
                                                                  CreateCalandmemoFailSaveTitle(
                                                                      context);
                                                                }
                                                              },
                                                              icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.edit,
                                                                  size: 30,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
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
                                                              )),
                                                          color: TextColor()),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconBtn(
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                //삭제
                                                                for (int i = 0;
                                                                    i <
                                                                        nodes
                                                                            .length;
                                                                    i++) {
                                                                  nodes[i]
                                                                      .unfocus();
                                                                }
                                                                final reloadpage =
                                                                    await Get.dialog(
                                                                        checkdeletecandm(
                                                                            context,
                                                                            '메모'));
                                                                if (reloadpage) {
                                                                  CreateCalandmemoSuccessFlushbar(
                                                                      context);
                                                                  firestore
                                                                      .collection(
                                                                          'AppNoticeByUsers')
                                                                      .add({
                                                                    'title': '[' +
                                                                        widget
                                                                            .docname +
                                                                        '] 메모가 삭제되었습니다.',
                                                                    'date': DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .parse(DateTime.now()
                                                                            .toString())
                                                                        .toString()
                                                                        .split(
                                                                            ' ')[0],
                                                                    'username':
                                                                        username
                                                                  });
                                                                  firestore
                                                                      .collection(
                                                                          'MemoDataBase')
                                                                      .where(
                                                                          'memoTitle',
                                                                          isEqualTo: textEditingController1
                                                                              .text)
                                                                      .where(
                                                                          'OriginalUser',
                                                                          isEqualTo:
                                                                              username)
                                                                      .where(
                                                                          'color',
                                                                          isEqualTo: widget
                                                                              .doccolor
                                                                              .toInt())
                                                                      .where(
                                                                          'Date',
                                                                          isEqualTo: widget.date.toString().split('-')[0] +
                                                                              '-' +
                                                                              widget.date.toString().split('-')[
                                                                                  1] +
                                                                              '-' +
                                                                              widget.date.toString().split('-')[2].substring(0,
                                                                                  2) +
                                                                              '일')
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    deleteid
                                                                        .clear();
                                                                    value.docs
                                                                        .forEach(
                                                                            (element) {
                                                                      deleteid.add(
                                                                          element
                                                                              .id);
                                                                    });
                                                                    for (int i =
                                                                            0;
                                                                        i < deleteid.length;
                                                                        i++) {
                                                                      firestore
                                                                          .collection(
                                                                              'MemoDataBase')
                                                                          .doc(deleteid[
                                                                              i])
                                                                          .delete();
                                                                    }
                                                                  }).whenComplete(
                                                                          () {
                                                                    CreateCalandmemoFlushbardelete(
                                                                        context,
                                                                        '메모');
                                                                  });
                                                                }
                                                              },
                                                              icon: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    NeumorphicIcon(
                                                                  Icons.delete,
                                                                  size: 30,
                                                                  style: NeumorphicStyle(
                                                                      shape: NeumorphicShape
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
                                                              )),
                                                          color: TextColor()),
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
                                    StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                  return GestureDetector(
                                    onTap: () {
                                      searchNode.unfocus();
                                      searchNode_first_section.unfocus();
                                      for (int i = 0;
                                          i <
                                              scollection
                                                  .memolistcontentin.length;
                                          i++) {
                                        if (nodes.isNotEmpty) {
                                          nodes[i].unfocus();
                                        }
                                        scollection.memolistcontentin[i] =
                                            controllers[i].text;
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
              ));
    }));
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
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ))
      ],
    );
  }

  Contents() {
    List<Widget> children_imagelist = [];
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
              child: Text(
                '첨부사진',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: TextColor()),
              ),
            ),
            GetBuilder<memosetting>(
              builder: (_) => SizedBox(
                height: 100,
                child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('MemoDataBase')
                        .where('memoTitle',
                            isEqualTo: textEditingController1.text)
                        .where('OriginalUser', isEqualTo: username)
                        .where('color', isEqualTo: widget.doccolor.toInt())
                        .where('Date',
                            isEqualTo: widget.date.toString().split('-')[0] +
                                '-' +
                                widget.date.toString().split('-')[1] +
                                '-' +
                                widget.date
                                    .toString()
                                    .split('-')[2]
                                    .substring(0, 2) +
                                '일')
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        children_imagelist = [
                          controll_memo.imagelist.isNotEmpty
                              ? SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: controll_memo.imagelist.length,
                                      itemBuilder: ((context, index) {
                                        return Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controll_memo
                                                    .setimageindex(index);
                                                Get.to(
                                                    () => ImageSliderPage(
                                                        index: index,
                                                        doc: widget.doc),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: SizedBox(
                                                      height: 90,
                                                      width: 90,
                                                      child: Image.network(
                                                          controll_memo
                                                              .imagelist[index],
                                                          fit: BoxFit.fill,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      }))),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      })))
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              '하단바의 사진아이콘을 클릭하여 추가하세요',
                                              style: TextStyle(
                                                  fontSize: contentTextsize(),
                                                  color: TextColor()),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                )
                        ];
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        print('wait');
                        children_imagelist = <Widget>[
                          SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: CircularProgressIndicator(
                                  color: TextColor_shadowcolor(),
                                ))
                              ],
                            ),
                          )
                        ];
                      } else {
                        children_imagelist = <Widget>[
                          Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        '하단바의 사진아이콘을 클릭하여 추가하세요',
                                        style: TextStyle(
                                            fontSize: contentTextsize(),
                                            color: TextColor()),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              )
                            ],
                          )
                        ];
                      }
                      return Column(children: children_imagelist);
                    })),
                /*controll_memo.imagelist.isEmpty
                    ? Center(
                        child: Text(
                          '하단바의 사진아이콘을 클릭하여 추가하세요',
                          style: TextStyle(
                              fontSize: contentTextsize(), color: TextColor()),
                        ),
                      )
                    : */
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
                            isresponsive);
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
                style: TextStyle(
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
                style: TextStyle(
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
                                              controll_memo
                                                          .ischeckedtohideminus ==
                                                      true
                                                  ? InkWell(
                                                      onTap: () {},
                                                      child: const SizedBox(
                                                          width: 30),
                                                    )
                                                  : InkWell(
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
                                                  controll_memo
                                                              .ischeckedtohideminus ==
                                                          true
                                                      ? InkWell(
                                                          onTap: () {},
                                                          child: const SizedBox(
                                                            width: 30,
                                                          ),
                                                        )
                                                      : InkWell(
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
                                                              color:
                                                                  Colors.red),
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
                                                  controll_memo
                                                              .ischeckedtohideminus ==
                                                          true
                                                      ? InkWell(
                                                          onTap: () {},
                                                          child: const SizedBox(
                                                              width: 30),
                                                        )
                                                      : InkWell(
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
                                                              color:
                                                                  Colors.red),
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

  MakePDF(
    String titletext,
    List savepicturelist,
    collection,
    List<MemoList> checklisttexts,
  ) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('fonts/NanumMyeongjo-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final headers = ['작성내용'];
    var images = [];
    try {
      for (int i = 0; i < savepicturelist.length; i++) {
        final provider =
            await flutterImageProvider(NetworkImage(savepicturelist[i]));
        images.add(provider);
      }
    } catch (e) {
      print("****ERROR: $e****");
      return;
    }
    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(titletext,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 30, font: ttf)),
                  pw.Divider(),
                ]),
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text('컬렉션 : ' + collection,
                      style: pw.TextStyle(fontSize: 15, font: ttf)),
                  pw.SizedBox(height: 10),
                  pw.Text('메모내용', style: pw.TextStyle(fontSize: 15, font: ttf)),
                  pw.SizedBox(height: 10),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(children: [
                          pw.Padding(
                            child: pw.Text(headers[0],
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(font: ttf, fontSize: 15)),
                            padding: const pw.EdgeInsets.all(20),
                          )
                        ]),
                        ...checklisttexts.map((memo) => pw.TableRow(children: [
                              pw.Padding(
                                child: pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(memo.memocontent,
                                        style: pw.TextStyle(
                                            font: ttf, fontSize: 12))),
                                padding: const pw.EdgeInsets.all(10),
                              )
                            ]))
                      ]),
                  pw.SizedBox(height: 20),
                  /*pw.Text('첨부사진', style: pw.TextStyle(fontSize: 25, font: ttf)),
                pw.SizedBox(height: 10),
                ...savepicturelist.map((element) {
                  return ;
                })
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Image(images[0], width: 300, height: 300)
                        ]))*/
                ])
          ];
        }));
    return savefile(name: titletext, pdf: pdf);
  }

  urlimage(element) async {
    final providerimage = await get(Uri.parse(element));
    var data = providerimage.bodyBytes;
    return data;
  }

  savefile({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    Directory? directory;
    directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.path}/$name.pdf");
    if (file.existsSync()) {
      //존재시 저장로직
      await file.writeAsBytes(await pdf.save());
    } else {
      //미존재시 생성로직
      file.create(recursive: true);
      await file.writeAsBytes(await pdf.save());
    }
    Share.shareFiles(['${directory.path}/$name.pdf']);
  }
}
