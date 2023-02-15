import 'dart:io';
import 'package:clickbyme/BACKENDPART/Getx/selectcollection.dart';
import 'package:clickbyme/UI/Home/Widgets/CreateCalandmemo.dart';
import 'package:clickbyme/UI/Home/secondContentNet/Memodrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../BACKENDPART/Enums/MemoList.dart';
import '../../../FRONTENDPART/Route/subuiroute.dart';
import '../../../Tool/AndroidIOS.dart';
import '../../../BACKENDPART/Getx/memosetting.dart';
import '../../../BACKENDPART/Getx/uisetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/TextSize.dart';
import '../../../sheets/showmemocontent.dart';

MFHolder(
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  Color _color,
  String doc,
  bool ischeckedtohideminus,
  List<TextEditingController> controllers,
  Color _colorfont,
  List imagelist,
) {
  final controll_memo = Get.put(memosetting());
  List _image = [];
  final imagePicker = ImagePicker();
  bool isresponsible = false;
  return StatefulBuilder(builder: ((context, setState) {
    return FocusedMenuHolder(
        child: IconBtn(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              width: 30,
              height: 30,
              child: NeumorphicIcon(
                Icons.more_vert,
                size: 30,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: controll_memo.color == Colors.black
                        ? Colors.white
                        : Colors.black,
                    lightSource: LightSource.topLeft),
              ),
            ),
            color: controll_memo.color == Colors.black
                ? Colors.white
                : Colors.black),
        onPressed: () {},
        duration: const Duration(seconds: 0),
        animateMenuItems: true,
        menuOffset: 20,
        bottomOffsetHeight: 10,
        menuWidth: MediaQuery.of(context).size.width / 2,
        openWithTap: true,
        menuItems: [
          FocusedMenuItem(
              title: Text('메모작성',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  showmemocontent(
                      context, checkbottoms, nodes, scollection, controllers);
                });
              }),
          FocusedMenuItem(
              title: Text('메모서랍',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                Get.to(() => Memodrawer(imagelist: imagelist, doc: doc),
                    transition: Transition.downToUp);
              }),
          FocusedMenuItem(
              title: Text('바탕색상변경',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    nodes[i].unfocus();
                  }
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text('선택',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          content: Builder(
                            builder: (context) {
                              return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SingleChildScrollView(
                                      child: BlockPicker(
                                    availableColors: [
                                      Colors.red,
                                      Colors.pink,
                                      Colors.deepOrangeAccent,
                                      Colors.yellowAccent,
                                      Colors.green,
                                      Colors.lightGreen,
                                      Colors.lightGreenAccent,
                                      Colors.greenAccent.shade200,
                                      Colors.indigo,
                                      Colors.blue,
                                      Colors.lightBlue,
                                      Colors.lightBlueAccent,
                                      Colors.purple,
                                      Colors.deepPurple,
                                      Colors.blueGrey.shade300,
                                      Colors.grey,
                                      Colors.amber,
                                      Colors.brown,
                                      Colors.white,
                                      Colors.black,
                                    ],
                                    itemBuilder:
                                        ((color, isCurrentColor, changeColor) {
                                      return GestureDetector(
                                        onTap: () {
                                          changeColor();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          child: isCurrentColor
                                              ? CircleAvatar(
                                                  backgroundColor: color,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color:
                                                          color != Colors.black
                                                              ? Colors.black
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: color,
                                                ),
                                        ),
                                      );
                                    }),
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        Hive.box('user_setting').put(
                                            'coloreachmemo',
                                            color.value.toInt());
                                        controll_memo.setcolor();
                                        _color = controll_memo.color;
                                        if (_color == Colors.black) {
                                          Hive.box('user_setting').put(
                                              'coloreachmemofont',
                                              Colors.white.value.toInt());
                                          controll_memo.setcolorfont();
                                          _colorfont = controll_memo.colorfont;
                                        } else {
                                          Hive.box('user_setting').put(
                                              'coloreachmemofont',
                                              Colors.black.value.toInt());
                                          controll_memo.setcolorfont();
                                          _colorfont = controll_memo.colorfont;
                                        }
                                      });
                                    },
                                    pickerColor: _color == controll_memo.color
                                        ? _color
                                        : controll_memo.color,
                                  )
                                      /*ColorPicker(
                                      pickerColor: _color,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          Hive.box('user_setting').put(
                                              'coloreachmemo',
                                              color.value.toInt());
                                          controll_memo.setcolor();
                                          _color = controll_memo.color;
                                        });
                                      },
                                    ),*/
                                      ));
                            },
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('반영하기'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                });
              }),
          FocusedMenuItem(
              title: Text('글자색변경',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < nodes.length; i++) {
                    nodes[i].unfocus();
                  }
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text('선택',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          content: Builder(
                            builder: (context) {
                              return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SingleChildScrollView(
                                      child: BlockPicker(
                                    availableColors: [
                                      Colors.red,
                                      Colors.pink,
                                      Colors.deepOrangeAccent,
                                      Colors.yellowAccent,
                                      Colors.green,
                                      Colors.lightGreen,
                                      Colors.lightGreenAccent,
                                      Colors.greenAccent.shade200,
                                      Colors.indigo,
                                      Colors.blue,
                                      Colors.lightBlue,
                                      Colors.lightBlueAccent,
                                      Colors.purple,
                                      Colors.deepPurple,
                                      Colors.blueGrey.shade300,
                                      Colors.grey,
                                      Colors.amber,
                                      Colors.brown,
                                      Colors.white,
                                      Colors.black,
                                    ],
                                    itemBuilder:
                                        ((color, isCurrentColor, changeColor) {
                                      return GestureDetector(
                                        onTap: () {
                                          changeColor();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          child: isCurrentColor
                                              ? CircleAvatar(
                                                  backgroundColor: color,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color:
                                                          color != Colors.black
                                                              ? Colors.black
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: color,
                                                ),
                                        ),
                                      );
                                    }),
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        Hive.box('user_setting').put(
                                            'coloreachmemofont',
                                            color.value.toInt());
                                        controll_memo.setcolorfont();
                                        _colorfont = controll_memo.colorfont;
                                      });
                                    },
                                    pickerColor:
                                        _colorfont == controll_memo.colorfont
                                            ? _colorfont
                                            : controll_memo.colorfont,
                                  )
                                      /*ColorPicker(
                                      pickerColor: _colorfont,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          Hive.box('user_setting').put(
                                              'coloreachmemofont',
                                              color.value.toInt());
                                          controll_memo.setcolorfont();
                                          _colorfont = controll_memo.colorfont;
                                        });
                                      },
                                    ),*/
                                      ));
                            },
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('반영하기'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                });
              }),
          FocusedMenuItem(
              backgroundColor: Colors.red.shade200,
              title: RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red.shade400,
                    ),
                  ),
                  TextSpan(
                    text: controll_memo.ischeckedtohideminus == true
                        ? '아이콘 띄우기'
                        : '아이콘 지우기',
                    style: TextStyle(
                        fontSize: contentTextsize(), color: Colors.black),
                  ),
                ]),
              ),
              onPressed: () {
                setState(() {
                  controll_memo.sethideminus(!ischeckedtohideminus);
                });
              })
        ]);
  }));
}

Future _uploadFile(BuildContext context, File _image, String doc) async {
  final controll_memo = Get.put(memosetting());
  await Permission.photos.request();
  var pstatus = await Permission.photos.status;
  if (pstatus.isGranted) {
    DateTime now = DateTime.now();
    var datestamp = DateFormat("yyyyMMdd'T'HHmmss");
    String currentdate = datestamp.format(now);
    // 스토리지에 업로드할 파일 경로
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child(doc).child('$currentdate.jpg');

    // 파일 업로드
    final uploadTask = firebaseStorageRef.putFile(
        _image, SettableMetadata(contentType: 'image/png'));

    // 완료까지 기다림
    await uploadTask.whenComplete(() {});

    // 업로드 완료 후 url
    final downloadUrl = await firebaseStorageRef.getDownloadURL();
    controll_memo.setimagelist(downloadUrl);

    // 문서 작성
    if (doc != '') {
      await FirebaseFirestore.instance
          .collection('MemoDataBase')
          .doc(doc)
          .update({
        'photoUrl': controll_memo.imagelist,
      });
    } else {}
  }
}

MFHolder_second(
  List<bool> checkbottoms,
  List<FocusNode> nodes,
  selectcollection scollection,
  List<MemoList> checklisttexts,
  String text,
  String doccollection,
  BuildContext context,
  String usercode,
  int securewith,
  Color color,
  DateTime editDateTo,
  String isfromwhere,
  FToast fToast,
  String doc,
  String docname,
  String date,
) {
  final controll_memo = Get.put(memosetting());
  return StatefulBuilder(builder: ((context, setState) {
    return FocusedMenuHolder(
        child: IconBtn(
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: NeumorphicIcon(
                Icons.menu,
                size: 30,
                style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: controll_memo.color == Colors.black
                        ? Colors.white
                        : Colors.black,
                    lightSource: LightSource.topLeft),
              ),
            ),
            color: controll_memo.color == Colors.black
                ? Colors.white
                : Colors.black),
        onPressed: () {},
        duration: const Duration(seconds: 0),
        animateMenuItems: true,
        menuOffset: 20,
        bottomOffsetHeight: 10,
        menuWidth: MediaQuery.of(context).size.width / 2,
        openWithTap: true,
        menuItems: [
          FocusedMenuItem(
            title: Text('PDF공유',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            onPressed: () async {
              checklisttexts.clear();
              for (int i = 0; i < scollection.memolistin.length; i++) {
                checklisttexts.add(MemoList(
                    memocontent: scollection.memolistcontentin[i],
                    contentindex: scollection.memolistin[i]));
              }
              /*final pdfFile = await MakePDF(
                  text,
                  controll_memo.imagelist,
                  Hive.box('user_setting').get('memocollection') == '' ||
                          Hive.box('user_setting').get('memocollection') == null
                      ? null
                      : (doccollection !=
                              Hive.box('user_setting').get('memocollection')
                          ? Hive.box('user_setting').get('memocollection')
                          : doccollection),
                  checklisttexts);*/
            },
          ),
          FocusedMenuItem(
            title: Text('저장하기',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            onPressed: () async {
              autosavelogic(
                  context,
                  controll_memo,
                  nodes,
                  text,
                  scollection,
                  doccollection,
                  usercode,
                  securewith,
                  color,
                  editDateTo,
                  fToast,
                  doc,
                  isfromwhere,
                  docname);
            },
          ),
          FocusedMenuItem(
            backgroundColor: Colors.red.shade200,
            title: RichText(
              softWrap: true,
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                WidgetSpan(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red.shade400,
                  ),
                ),
                TextSpan(
                  text: '삭제하기',
                  style: TextStyle(
                      fontSize: contentTextsize(), color: Colors.black),
                ),
              ]),
            ),
            onPressed: () async {
              autodeletelogic(context, controll_memo, nodes, text, docname, doc,
                  usercode, color, date, isfromwhere, fToast);
            },
          ),
        ]);
  }));
}

void autodeletelogic(
    BuildContext context,
    memosetting controll_memo,
    List<FocusNode> nodes,
    String text,
    String docname,
    String doc,
    String usercode,
    Color color,
    String date,
    String isfromwhere,
    FToast fToast) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  List deleteid = [];
  //삭제
  for (int i = 0; i < nodes.length; i++) {
    nodes[i].unfocus();
  }
  var reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
        builder: (context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Text('정말 이 메모를 삭제하시겠습니까?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      color: Colors.blueGrey)),
            ),
          );
        },
      ), pressed2)) ??
      false;
  if (reloadpage) {
    uisetting().setloading(true);
    Hive.box('user_setting').put('alarm_memo_${docname}', false);
    controll_memo.setalarmmemo(docname, doc);
    _deleteFile(doc);
    firestore.collection('AppNoticeByUsers').add({
      'title': '[' + text + '] 메모가 삭제되었습니다.',
      'date': DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[0] +
          ' ' +
          DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[1]
              .split(':')[0] +
          ':' +
          DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[1]
              .split(':')[1],
      'username': username,
      'sharename': [],
      'read': 'no',
    });
    firestore
        .collection('MemoDataBase')
        .where('memoTitle', isEqualTo: text)
        .where('OriginalUser', isEqualTo: usercode)
        .where('color', isEqualTo: color.value.toInt())
        .where('Date',
            isEqualTo: date.toString().split('-')[0] +
                '-' +
                date.toString().split('-')[1] +
                '-' +
                date.toString().split('-')[2].substring(0, 2) +
                '일')
        .get()
        .then((value) {
      deleteid.clear();
      value.docs.forEach((element) {
        deleteid.add(element.id);
      });
      for (int i = 0; i < deleteid.length; i++) {
        firestore.collection('MemoDataBase').doc(deleteid[i]).delete();
      }
    }).whenComplete(() {
      uisetting().setloading(false);
      CreateCalandmemoSuccessFlushbar('메모삭제 완료!', fToast);
      isfromwhere == 'home' ? GoToMain() : Get.back();
    });
  }
}

void autosavelogic(
    BuildContext context,
    memosetting controll_memo,
    List<FocusNode> nodes,
    String text,
    selectcollection scollection,
    String doccollection,
    String usercode,
    int securewith,
    Color color,
    DateTime editDateTo,
    FToast fToast,
    String doc,
    String isfromwhere,
    String docname) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  fToast = FToast();
  fToast.init(context);
  List<MemoList> checklisttexts = [];
  List savepicturelist = [];

  for (int i = 0; i < nodes.length; i++) {
    nodes[i].unfocus();
  }
  if (text != docname) {
    //제목이 달라진 경우
  } else {
    //제목이 같은 경우
  }
  if (text.isNotEmpty) {
    uisetting().setloading(true);
    firestore.collection('AppNoticeByUsers').add({
      'title': '[' + text + '] 메모가 변경되었습니다.',
      'date': DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[0] +
          ' ' +
          DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[1]
              .split(':')[0] +
          ':' +
          DateFormat('yyyy-MM-dd hh:mm')
              .parse(DateTime.now().toString())
              .toString()
              .split(' ')[1]
              .split(':')[1],
      'username': username,
      'sharename': [],
      'read': 'no',
    });
    for (int i = 0; i < scollection.memolistin.length; i++) {
      checklisttexts.add(MemoList(
          memocontent: scollection.memolistcontentin[i],
          contentindex: scollection.memolistin[i]));
    }
    for (int j = 0; j < controll_memo.imagelist.length; j++) {
      savepicturelist.add(controll_memo.imagelist[j]);
    }

    firestore.collection('MemoDataBase').doc(doc).update(
      {
        'memoTitle': text,
        'photoUrl': savepicturelist,
        'Collection': Hive.box('user_setting').get('memocollection') == '' ||
                Hive.box('user_setting').get('memocollection') == null
            ? null
            : (doccollection != Hive.box('user_setting').get('memocollection')
                ? Hive.box('user_setting').get('memocollection')
                : doccollection),
        'memolist': checklisttexts.map((e) => e.memocontent).toList().isEmpty
            ? null
            : checklisttexts.map((e) => e.memocontent).toList(),
        'memoindex': checklisttexts.map((e) => e.contentindex).toList().isEmpty
            ? null
            : checklisttexts.map((e) => e.contentindex).toList(),
        'OriginalUser': usercode,
        'securewith': securewith,
        'color': Hive.box('user_setting').get('coloreachmemo') ??
            color.value.toInt(),
        'colorfont': controll_memo.colorfont.value.toInt(),
        'EditDate': editDateTo.toString().split('-')[0] +
            '-' +
            editDateTo.toString().split('-')[1] +
            '-' +
            editDateTo.toString().split('-')[2].substring(0, 2) +
            '일',
      },
    ).whenComplete(() {
      CreateCalandmemoSuccessFlushbar('저장완료', fToast);
      Future.delayed(const Duration(seconds: 1), () {
        uisetting().setloading(false);
        if (isfromwhere == 'home') {
          GoToMain();
        } else {
          Get.back();
        }
      });
    });
  } else {
    CreateCalandmemoFailSaveTitle(context);
  }
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
        .get()
        .then((value) {
      List photolist = [];
      if (value.exists) {
        if (value.data()!['photoUrl'].length > 0) {
          FirebaseFirestore.instance
              .collection('MemoDataBase')
              .doc(doc)
              .update({
            'photoUrl': '',
          });
        } else {}
      }
    });
  } else {}
}

/*MakePDF(
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
}*/

MFHolder_third(
  List imagelist,
  String doc,
) {
  final controll_memo = Get.put(memosetting());
  List _image = [];
  final imagePicker = ImagePicker();
  bool isresponsible = false;
  return StatefulBuilder(builder: ((context, setState) {
    return FocusedMenuHolder(
        child: IconBtn(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              width: 30,
              height: 30,
              child: NeumorphicIcon(
                Icons.add,
                size: 30,
                style: const NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    depth: 2,
                    surfaceIntensity: 0.5,
                    color: Colors.black,
                    lightSource: LightSource.topLeft),
              ),
            ),
            color: Colors.black),
        onPressed: () {},
        duration: const Duration(seconds: 0),
        animateMenuItems: true,
        menuOffset: 20,
        bottomOffsetHeight: 10,
        menuWidth: MediaQuery.of(context).size.width / 2,
        openWithTap: true,
        menuItems: [
          FocusedMenuItem(
              title: Text('사진추가',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
              onPressed: () {
                setState(() {});
              }),
        ]);
  }));
}
