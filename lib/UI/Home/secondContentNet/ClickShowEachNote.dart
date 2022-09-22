import 'dart:io';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/IconBtn.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:clickbyme/UI/Home/Widgets/MemoFocusedHolder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import '../../../Dialogs/destroyBackKey.dart';
import '../../../Tool/AndroidIOS.dart';
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
    required this.doccolorfont,
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
  final int doccolorfont;
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
  Color _colorfont = Colors.white;
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
    scollection.memolistin.clear();
    scollection.memolistcontentin.clear();
    scollection.memoindex = 0;
    controll_memo.imagelist.clear();
    Hive.box('user_setting').put('coloreachmemo', widget.doccolor);
    Hive.box('user_setting').put('coloreachmemofont', widget.doccolorfont);
    print(widget.doccolorfont);
    textEditingController1 = TextEditingController(text: widget.docname);
    textEditingController_add_sheet = TextEditingController();
    Hive.box('user_setting').put('memocollection', widget.doccollection);
    controll_memo.color = Color(Hive.box('user_setting').get('coloreachmemo'));
    _color = widget.doccolor != null ? Color(widget.doccolor) : Colors.white;
    controll_memo.colorfont =
        Color(Hive.box('user_setting').get('coloreachmemofont'));
    _colorfont =
        widget.doccolorfont != null ? Color(widget.doccolorfont) : Colors.black;
    for (int j = 0; j < widget.docindex.length; j++) {
      Hive.box('user_setting').put('optionmemoinput', widget.docindex[j]);
      scollection.memolistin
          .insert(j, Hive.box('user_setting').get('optionmemoinput'));
      scollection.memoindex++;
    }
    for (int k = 0; k < widget.docindex.length; k++) {
      Hive.box('user_setting')
          .put('optionmemocontentinput', widget.docsummary[k]);
      widget.docsummary[k] == null
          ? scollection.memolistcontentin.insert(k, '')
          : scollection.memolistcontentin.insert(
              k, Hive.box('user_setting').get('optionmemocontentinput'));
      nodes.add(FocusNode());
      widget.docsummary[k] == null
          ? controllers.insert(k, TextEditingController(text: null))
          : controllers.insert(
              k,
              TextEditingController(
                  text:
                      Hive.box('user_setting').get('optionmemocontentinput')));
    }
    for (int i = 0; i < widget.image.length; i++) {
      if (widget.image[i] != null) {
        controll_memo.imagelist.insert(i, widget.image[i]);
        controll_memo.imageindex++;
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

  Future _deleteFile(String doc) async {
    await FirebaseFirestore.instance
        .collection('MemoDataBase')
        .doc(doc)
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!['photoUrl'].length; i++) {
          String deleteimagepath = value.data()!['photoUrl'][i];
          String filePath = deleteimagepath
              .replaceAll(
                  RegExp(
                      r'https://firebasestorage.googleapis.com/v0/b/habit-tracker-8dad1.appspot.com/o/${doc}%2F'),
                  '')
              .split('?')[0];
          FirebaseStorage.instance.refFromURL(filePath).delete();
        }
      }
    });
    // 문서 작성
    if (doc != '') {
      await FirebaseFirestore.instance
          .collection('MemoDataBase')
          .doc(doc)
          .update({
        'photoUrl': '',
      });
    } else {}
  }

  Future<bool> _onBackPressed() async {
    final reloadpage = await Get.dialog(OSDialog(
            context,
            '경고',
            Text('뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: Colors.blueGrey)),
            pressed2)) ??
        false;
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
                                                    final reloadpage = await Get.dialog(OSDialog(
                                                            context,
                                                            '경고',
                                                            Text(
                                                                '뒤로 나가시면 작성중인 내용은 사라지게 됩니다. 나가시겠습니까?',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize(),
                                                                    color: Colors
                                                                        .blueGrey)),
                                                            pressed2)) ??
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
                                                      style:
                                                          const NeumorphicStyle(
                                                              shape:
                                                                  NeumorphicShape
                                                                      .convex,
                                                              depth: 2,
                                                              surfaceIntensity:
                                                                  0.5,
                                                              color:
                                                                  Colors.black,
                                                              lightSource:
                                                                  LightSource
                                                                      .topLeft),
                                                    ),
                                                  )),
                                              color: Colors.black),
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
                                                      const Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      MFHolder(
                                                          checkbottoms,
                                                          nodes,
                                                          scollection,
                                                          _color,
                                                          widget.doc,
                                                          controll_memo
                                                              .ischeckedtohideminus,
                                                          controllers,
                                                          Color(widget
                                                              .doccolorfont)),
                                                      const SizedBox(
                                                        width: 10,
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
                                                                  style: const NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: Colors.black),
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
                                                                final reloadpage =
                                                                    await Get.dialog(OSDialog(
                                                                            context,
                                                                            '알림',
                                                                            Builder(
                                                                          builder:
                                                                              (context) {
                                                                            return SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.85,
                                                                              child: SingleChildScrollView(
                                                                                child: Text('저장하시겠습니까?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: Colors.blueGrey)),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ), pressed2)) ??
                                                                        false;
                                                                if (reloadpage) {
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
                                                                          textEditingController1
                                                                              .text +
                                                                          '] 메모가 변경되었습니다.',
                                                                      'date': DateFormat('yyyy-MM-dd hh:mm').parse(DateTime.now().toString()).toString().split(' ')[0] +
                                                                          ' ' +
                                                                          DateFormat('yyyy-MM-dd hh:mm').parse(DateTime.now().toString()).toString().split(' ')[1].split(':')[
                                                                              0] +
                                                                          ':' +
                                                                          DateFormat('yyyy-MM-dd hh:mm')
                                                                              .parse(DateTime.now().toString())
                                                                              .toString()
                                                                              .split(' ')[1]
                                                                              .split(':')[1],
                                                                      'username':
                                                                          username,
                                                                      'sharename':
                                                                          [],
                                                                      'read':
                                                                          'no',
                                                                    });
                                                                    for (int i =
                                                                            0;
                                                                        i < scollection.memolistin.length;
                                                                        i++) {
                                                                      checklisttexts.add(MemoList(
                                                                          memocontent: scollection.memolistcontentin[
                                                                              i],
                                                                          contentindex:
                                                                              scollection.memolistin[i]));
                                                                    }
                                                                    for (int j =
                                                                            0;
                                                                        j < controll_memo.imagelist.length;
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
                                                                            textEditingController1.text,
                                                                        'photoUrl':
                                                                            savepicturelist,
                                                                        'Collection': Hive.box('user_setting').get('memocollection') == '' || Hive.box('user_setting').get('memocollection') == null
                                                                            ? null
                                                                            : (widget.doccollection != Hive.box('user_setting').get('memocollection')
                                                                                ? Hive.box('user_setting').get('memocollection')
                                                                                : widget.doccollection),
                                                                        'memolist': checklisttexts.map((e) => e.memocontent).toList().isEmpty
                                                                            ? null
                                                                            : checklisttexts.map((e) => e.memocontent).toList(),
                                                                        'memoindex': checklisttexts.map((e) => e.contentindex).toList().isEmpty
                                                                            ? null
                                                                            : checklisttexts.map((e) => e.contentindex).toList(),
                                                                        'OriginalUser':
                                                                            username,
                                                                        'securewith':
                                                                            widget.securewith,
                                                                        'color':
                                                                            Hive.box('user_setting').get('coloreachmemo') ??
                                                                                _color.value.toInt(),
                                                                        'colorfont': controll_memo
                                                                            .colorfont
                                                                            .value
                                                                            .toInt(),
                                                                        'EditDate': editDateTo.toString().split('-')[0] +
                                                                            '-' +
                                                                            editDateTo.toString().split('-')[
                                                                                1] +
                                                                            '-' +
                                                                            editDateTo.toString().split('-')[2].substring(0,
                                                                                2) +
                                                                            '일',
                                                                      },
                                                                    ).whenComplete(
                                                                            () {
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              seconds: 2),
                                                                          () {
                                                                        CreateCalandmemoSuccessFlushbarSub(
                                                                            context,
                                                                            '메모');
                                                                      });
                                                                    });
                                                                  } else {
                                                                    CreateCalandmemoFailSaveTitle(
                                                                        context);
                                                                  }
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
                                                                  Icons
                                                                      .save_alt,
                                                                  size: 30,
                                                                  style: const NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: Colors.black),
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
                                                                var reloadpage =
                                                                    await Get.dialog(OSDialog(
                                                                            context,
                                                                            '경고',
                                                                            Builder(
                                                                          builder:
                                                                              (context) {
                                                                            return SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.85,
                                                                              child: SingleChildScrollView(
                                                                                child: Text('정말 이 일정을 삭제하시겠습니까?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: contentTextsize(), color: Colors.blueGrey)),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ), pressed2)) ??
                                                                        false;
                                                                if (reloadpage) {
                                                                  CreateCalandmemoSuccessFlushbar(
                                                                      context);
                                                                  Hive.box(
                                                                          'user_setting')
                                                                      .put(
                                                                          'alarm_memo_${widget.docname}',
                                                                          false);
                                                                  controll_memo
                                                                      .setalarmmemo(
                                                                          widget
                                                                              .docname,
                                                                          widget
                                                                              .doc);
                                                                  _deleteFile(
                                                                      widget
                                                                          .doc);
                                                                  firestore
                                                                      .collection(
                                                                          'AppNoticeByUsers')
                                                                      .add({
                                                                    'title': '[' +
                                                                        textEditingController1
                                                                            .text +
                                                                        '] 메모가 삭제되었습니다.',
                                                                    'date': DateFormat('yyyy-MM-dd hh:mm').parse(DateTime.now().toString()).toString().split(' ')[0] +
                                                                        ' ' +
                                                                        DateFormat('yyyy-MM-dd hh:mm').parse(DateTime.now().toString()).toString().split(' ')[1].split(':')[
                                                                            0] +
                                                                        ':' +
                                                                        DateFormat('yyyy-MM-dd hh:mm')
                                                                            .parse(DateTime.now().toString())
                                                                            .toString()
                                                                            .split(' ')[1]
                                                                            .split(':')[1],
                                                                    'username':
                                                                        username,
                                                                    'sharename':
                                                                        [],
                                                                    'read':
                                                                        'no',
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
                                                                    reloadpage =
                                                                        true;
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            seconds:
                                                                                2),
                                                                        () async {
                                                                      CreateCalandmemoFlushbardelete(
                                                                          context,
                                                                          '메모');
                                                                    });
                                                                    if (reloadpage) {
                                                                      Get.back();
                                                                    }
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
                                                                  style: const NeumorphicStyle(
                                                                      shape: NeumorphicShape
                                                                          .convex,
                                                                      depth: 2,
                                                                      surfaceIntensity:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                      lightSource:
                                                                          LightSource
                                                                              .topLeft),
                                                                ),
                                                              )),
                                                          color: Colors.black),
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
                                        mainAxisSize: MainAxisSize.min,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: '최초 작성시간 : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              TextSpan(
                  text: widget.date.toString(),
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ]),
          ),
          RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: '마지막 수정시간 : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              TextSpan(
                  text: widget.editdate.toString(),
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                '메모제목',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize(),
                    color: Colors.black),
              )
            ],
          ),
        ],
      ),
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
            GetBuilder<memosetting>(
                builder: (_) => ContainerDesign(
                    child: TextField(
                      minLines: 1,
                      maxLines: 1,
                      focusNode: searchNode_first_section,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: contentTextsize(),
                          color: controll_memo.colorfont),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: InputBorder.none,
                        hintText: '제목 입력',
                        hintStyle: TextStyle(
                            fontSize: contentTextsize(),
                            color: Colors.grey.shade400),
                      ),
                      controller: textEditingController1,
                    ),
                    color: controll_memo.color)),
            const SizedBox(
              height: 20,
            ),
            Text(
              '첨부사진',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize(),
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: Center(
                                          child: RichText(
                                        softWrap: true,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: '상단바의 ',
                                            style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: Colors.grey.shade400),
                                          ),
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '아이콘을 클릭하여 추가하세요',
                                            style: TextStyle(
                                                fontSize: contentTextsize(),
                                                color: Colors.grey.shade400),
                                          ),
                                        ]),
                                      )),
                                    )
                                  ],
                                )
                        ];
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        children_imagelist = <Widget>[
                          SizedBox(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.grey.shade400,
                                ))
                              ],
                            ),
                          )
                        ];
                      } else {
                        children_imagelist = <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100,
                                child: Center(
                                    child: RichText(
                                  softWrap: true,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '상단바의 ',
                                      style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: Colors.grey.shade400),
                                    ),
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '아이콘을 클릭하여 추가하세요',
                                      style: TextStyle(
                                          fontSize: contentTextsize(),
                                          color: Colors.grey.shade400),
                                    ),
                                  ]),
                                )),
                              )
                            ],
                          )
                        ];
                      }
                      return Column(children: children_imagelist);
                    })),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '컬렉션 선택',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: Colors.black),
                  ),
                ),
                IconBtn(
                    child: InkWell(
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Click',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.black),
                          ),
                        )),
                    color: Colors.black)
              ],
            ),
            GetBuilder<selectcollection>(
              builder: (_) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Hive.box('user_setting').get('memocollection') == '' ||
                            Hive.box('user_setting').get('memocollection') ==
                                null
                        ? '지정된 컬렉션이 없습니다.'
                        : (widget.doccollection !=
                                Hive.box('user_setting').get('memocollection')
                            ? '지정한 컬렉션 이름 : ' +
                                Hive.box('user_setting').get('memocollection')
                            : '지정한 컬렉션 이름 : ' + widget.doccollection),
                    maxLines: 2,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: contentTextsize(),
                        color: Colors.grey.shade400),
                  )
                ],
              ),
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
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              softWrap: true,
              textAlign: TextAlign.start,
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                  text: '상단바의 ',
                  style: TextStyle(
                      fontSize: contentTextsize(), color: Colors.grey.shade400),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '아이콘을 클릭하여 추가하세요',
                  style: TextStyle(
                      fontSize: contentTextsize(), color: Colors.grey.shade400),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<selectcollection>(
                builder: (_) => scollection.memolistin.isNotEmpty
                    ? ReorderableListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scollection.memolistin.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            key: ValueKey(index),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    scollection.memolistin[index] == 0
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            child: GetBuilder<memosetting>(
                                                builder: (_) => ContainerDesign(
                                                      color:
                                                          controll_memo.color,
                                                      child: TextField(
                                                        onChanged: (text) {
                                                          scollection
                                                                  .memolistcontentin[
                                                              index] = text;
                                                        },
                                                        minLines: null,
                                                        maxLines: null,
                                                        focusNode: nodes[index],
                                                        style: TextStyle(
                                                          fontSize:
                                                              contentTextsize(),
                                                          color: controll_memo
                                                              .colorfont,
                                                        ),
                                                        controller:
                                                            controllers[index],
                                                        decoration:
                                                            InputDecoration(
                                                          isCollapsed: true,
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          suffixIconConstraints:
                                                              const BoxConstraints(
                                                                  maxWidth: 30),
                                                          border:
                                                              InputBorder.none,
                                                          suffixIcon: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              controll_memo
                                                                          .ischeckedtohideminus ==
                                                                      true
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {},
                                                                      child: const SizedBox(
                                                                          width:
                                                                              30),
                                                                    )
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          scollection
                                                                              .removelistitem(index);
                                                                          controllers
                                                                              .removeAt(index);

                                                                          for (int i = 0;
                                                                              i < scollection.memolistin.length;
                                                                              i++) {
                                                                            controllers[i].text =
                                                                                scollection.memolistcontentin[i];
                                                                          }
                                                                        });
                                                                      },
                                                                      child: const Icon(
                                                                          Icons
                                                                              .remove_circle_outline,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                            ],
                                                          ),
                                                          hintText: '내용 입력',
                                                          hintStyle: TextStyle(
                                                              fontSize:
                                                                  contentTextsize(),
                                                              color: Colors.grey
                                                                  .shade400),
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                      ),
                                                    )))
                                        : (scollection.memolistin[index] == 1 ||
                                                scollection.memolistin[index] ==
                                                    999
                                            ? SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                child: GetBuilder<memosetting>(
                                                    builder: (_) =>
                                                        ContainerDesign(
                                                          color: controll_memo
                                                              .color,
                                                          child: TextField(
                                                            minLines: 1,
                                                            maxLines: 3,
                                                            onChanged: (text) {
                                                              scollection
                                                                      .memolistcontentin[
                                                                  index] = text;
                                                            },
                                                            focusNode:
                                                                nodes[index],
                                                            textAlign:
                                                                TextAlign.start,
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    contentTextsize(),
                                                                color: controll_memo
                                                                    .colorfont,
                                                                decorationThickness:
                                                                    2.3,
                                                                decoration: scollection.memolistin[
                                                                            index] ==
                                                                        999
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null),
                                                            decoration:
                                                                InputDecoration(
                                                              isCollapsed: true,
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              suffixIconConstraints:
                                                                  const BoxConstraints(
                                                                      maxWidth:
                                                                          30),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              prefixIcon:
                                                                  InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    scollection.memolistin[index] ==
                                                                            999
                                                                        ? scollection.memolistin[index] =
                                                                            1
                                                                        : scollection.memolistin[index] =
                                                                            999;
                                                                  });
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .check_box_outline_blank,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              suffixIcon: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  controll_memo
                                                                              .ischeckedtohideminus ==
                                                                          true
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              const SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                        )
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              scollection.removelistitem(index);
                                                                              controllers.removeAt(index);

                                                                              for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                controllers[i].text = scollection.memolistcontentin[i];
                                                                              }
                                                                            });
                                                                          },
                                                                          child: const Icon(
                                                                              Icons.remove_circle_outline,
                                                                              color: Colors.red),
                                                                        ),
                                                                ],
                                                              ),
                                                              hintText: '내용 입력',
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      contentTextsize(),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400),
                                                            ),
                                                            controller:
                                                                controllers[
                                                                    index],
                                                          ),
                                                        )))
                                            : SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70,
                                                child: GetBuilder<memosetting>(
                                                    builder:
                                                        (_) => ContainerDesign(
                                                              color:
                                                                  controll_memo
                                                                      .color,
                                                              child: TextField(
                                                                  onChanged:
                                                                      (text) {
                                                                    scollection
                                                                            .memolistcontentin[
                                                                        index] = text;
                                                                  },
                                                                  minLines: 1,
                                                                  maxLines: 3,
                                                                  focusNode:
                                                                      nodes[
                                                                          index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          contentTextsize(),
                                                                      color: controll_memo
                                                                          .colorfont),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isCollapsed:
                                                                        true,
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                    suffixIconConstraints:
                                                                        const BoxConstraints(
                                                                            maxWidth:
                                                                                30),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    prefixIcon: const Icon(
                                                                        Icons
                                                                            .star_rate,
                                                                        color: Colors
                                                                            .black),
                                                                    prefixIconColor:
                                                                        Colors
                                                                            .black,
                                                                    suffixIcon:
                                                                        Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        controll_memo.ischeckedtohideminus ==
                                                                                true
                                                                            ? InkWell(
                                                                                onTap: () {},
                                                                                child: const SizedBox(width: 30),
                                                                              )
                                                                            : InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    scollection.removelistitem(index);
                                                                                    controllers.removeAt(index);

                                                                                    for (int i = 0; i < scollection.memolistin.length; i++) {
                                                                                      controllers[i].text = scollection.memolistcontentin[i];
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                    hintText:
                                                                        '내용 입력',
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            contentTextsize(),
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400),
                                                                  ),
                                                                  controller:
                                                                      controllers[
                                                                          index]),
                                                            )))),
                                    ReorderableDragStartListener(
                                      index: index,
                                      child: Icon(
                                        Icons.drag_indicator_outlined,
                                        color: _colorfont,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            String content_prev =
                                scollection.memolistcontentin[oldIndex];
                            int indexcontent_prev =
                                scollection.memolistin[oldIndex];
                            scollection.removelistitem(oldIndex);
                            Hive.box('user_setting')
                                .put('optionmemoinput', indexcontent_prev);
                            Hive.box('user_setting')
                                .put('optionmemocontentinput', content_prev);
                            scollection.addmemolistin(newIndex);
                            scollection.addmemolistcontentin(newIndex);
                            for (int i = 0;
                                i < scollection.memolistcontentin.length;
                                i++) {
                              controllers[i].text =
                                  scollection.memolistcontentin[i];
                            }
                          });
                        },
                        /*proxyDecorator: (Widget child, int index,
                            Animation<double> animation) {
                          return Material(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: TextColor_shadowcolor(),
                                      width: 1)),
                              child: child,
                            ),
                          );
                        },*/
                      )
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
      if (checklisttexts.isEmpty) {
        checklisttexts.clear();
        checklisttexts
            .add(MemoList(memocontent: '작성된 메모리스트가 없습니다.', contentindex: 0));
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
                  collection == null
                      ? pw.Text('컬렉션 : 지정된 컬렉션이 없습니다.',
                          style: pw.TextStyle(fontSize: 15, font: ttf))
                      : pw.Text('컬렉션 : ' + collection,
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
