import 'dart:io';
import 'package:clickbyme/UI/Home/secondContentNet/drawingmemo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' show get;
import 'package:permission_handler/permission_handler.dart';
import '../../../Tool/BGColor.dart';
import '../../../Tool/FlushbarStyle.dart';
import '../../../BACKENDPART/Getx/memosetting.dart';
import '../../../BACKENDPART/Getx/selectcollection.dart';
import '../../../BACKENDPART/Getx/uisetting.dart';
import '../../../Tool/IconBtn.dart';
import '../../../Tool/Loader.dart';
import '../../../Tool/NoBehavior.dart';
import '../../../Tool/TextSize.dart';
import '../Widgets/ImageSlider.dart';

class Memodrawer extends StatefulWidget {
  Memodrawer({Key? key, required this.imagelist, required this.doc})
      : super(key: key);
  final double translateX = 0.0;
  final double translateY = 0.0;
  final myWidth = 0;
  final List imagelist;
  final String doc;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List eventtitle = [];
  final List eventcontent = [];
  final List eventpage = [];
  bool isresponsive = false;
  @override
  State<StatefulWidget> createState() => MemodrawerState();
}

class MemodrawerState extends State<Memodrawer> with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  List updateid = [];
  List deleteid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String username = Hive.box('user_info').get(
    'id',
  );
  String usercode = Hive.box('user_setting').get('usercode');
  final scollection = Get.put(selectcollection());
  final controll_memo = Get.put(memosetting());
  List savepicturelist = [];
  final imagePicker = ImagePicker();
  bool isresponsive = false;
  late FToast fToast;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

  Future<bool> _onBackPressed() async {
    Get.back();

    return false;
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

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            resizeToAvoidBottomInset: true,
            body: GetBuilder<memosetting>(
              builder: (_) => WillPopScope(
                onWillPop: _onBackPressed,
                child: GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      UI(),
                      uisetting().loading == true
                          ? const Loader(
                              wherein: 'memoeach',
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            )));
  }

  UI() {
    double height = MediaQuery.of(context).size.height;
    return StatefulBuilder(builder: ((context, setState) {
      return GetBuilder<memosetting>(
          builder: (_) => SizedBox(
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
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Row(
                                        children: [
                                          GetPlatform.isMobile == false
                                              ? IconBtn(
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        Get.back();
                                                      },
                                                      icon: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                        height: 30,
                                                        child: NeumorphicIcon(
                                                          Icons
                                                              .keyboard_arrow_left,
                                                          size: 30,
                                                          style: const NeumorphicStyle(
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
                                                  color: Colors.black)
                                              : const SizedBox(),
                                          SizedBox(
                                              width:
                                                  GetPlatform.isMobile == false
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          70
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          20,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Row(
                                                    children: [
                                                      const Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          '메모서랍',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      IconBtn(
                                                          child: IconButton(
                                                            onPressed: () {
                                                              firstdialog();
                                                            },
                                                            icon: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons.add,
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
                                                            ),
                                                          ),
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
                                    onTap: () {},
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

  Contents() {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return index == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        child: controll_memo.imagelist.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: RichText(
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: '상단바의 ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400),
                                        ),
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '아이콘을 클릭하여 추가하세요',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400),
                                        ),
                                      ]),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: RichText(
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: '사진을 클릭하여 크게 키워보세요',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400),
                                        ),
                                      ]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:
                                            controll_memo.imagelist.length,
                                        itemBuilder: ((context, index) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  controll_memo
                                                      .setimageindex(index);
                                                  Get.to(
                                                      () => ImageSliderPage(
                                                          index: index,
                                                          doc: ''),
                                                      transition: Transition
                                                          .rightToLeft);
                                                },
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child: Image.network(
                                                            controll_memo
                                                                    .imagelist[
                                                                index],
                                                            fit: BoxFit.fill,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
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
                                        })),
                                  )
                                ],
                              )),
                  ),
                ],
              )
            : (index == 1
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '음성파일',
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
                            child: controll_memo.voicelist.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: RichText(
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: '상단바의 ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '아이콘을 클릭하여 추가하세요',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ]),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: RichText(
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: '파일을 클릭하여 재생해보세요',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      /*SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                controll_memo.voicelist.length,
                                            itemBuilder: ((context, index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        child: SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image.network(
                                                                controll_memo
                                                                        .voicelist[
                                                                    index],
                                                                fit:
                                                                    BoxFit.fill,
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
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
                                            })),
                                      )*/
                                    ],
                                  )),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '드로잉',
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
                            child: controll_memo.drawinglist.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: RichText(
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: '상단바의 ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '아이콘을 클릭하여 추가하세요',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ]),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: RichText(
                                          softWrap: true,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: '파일을 클릭하시면 드로잉을 볼수 있어요',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      /*SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                controll_memo.drawinglist.length,
                                            itemBuilder: ((context, index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      controll_memo
                                                          .setimageindex(index);
                                                      Get.to(
                                                          () => ImageSliderPage(
                                                              index: index,
                                                              doc: ''),
                                                          transition: Transition
                                                              .rightToLeft);
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        child: SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image.network(
                                                                controll_memo
                                                                        .imagelist[
                                                                    index],
                                                                fit:
                                                                    BoxFit.fill,
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
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
                                            })),
                                      )*/
                                    ],
                                  )),
                      ),
                    ],
                  ));
      },
    );
  }

  firstdialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('선택',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          picturedialog();
                        },
                        child: ListTile(
                          title: Text('사진첨부',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                          leading: Icon(
                            Icons.add_a_photo,
                            color: Colors.blue.shade400,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          Snack.toast(
                              title: '준비중입니다~',
                              color: Colors.white,
                              backgroundcolor: Colors.greenAccent,
                              fToast: fToast);
                          //voicesheet();
                        },
                        child: ListTile(
                          title: Text('음성파일첨부',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                          leading: Icon(
                            Icons.mic,
                            color: Colors.blue.shade400,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          /*Snack.toast(
                              title: '준비중입니다~',
                              color: Colors.white,
                              backgroundcolor: Colors.greenAccent,
                              fToast: fToast);*/
                          Get.to(
                              () => drawingmemo(
                                    doc: widget.doc,
                                  ),
                              transition: Transition.downToUp);
                        },
                        child: ListTile(
                          title: Text('드로잉첨부',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                          leading: Icon(
                            Icons.draw,
                            color: Colors.blue.shade400,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  )),
                );
              },
            ));
      },
    );
  }

  picturedialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('선택',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final image = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          setState(() {
                            uisetting().setloading(true, 0);
                            _uploadFile(
                              context,
                              File(image!.path),
                              widget.doc,
                            );
                            uisetting().setloading(false, 0);
                          });
                        },
                        child: ListTile(
                          title: Text('사진 촬영',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                          leading: Icon(
                            Icons.add_a_photo,
                            color: Colors.blue.shade400,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            uisetting().setloading(true, 0);
                            _uploadFile(context, File(image!.path), widget.doc);
                            uisetting().setloading(false, 0);
                          });
                        },
                        child: ListTile(
                          title: Text('갤러리 선택',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                          leading: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.blue.shade400,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  )),
                );
              },
            ));
      },
    );
  }

  urlimage(element) async {
    final providerimage = await get(Uri.parse(element));
    var data = providerimage.bodyBytes;
    return data;
  }
}
