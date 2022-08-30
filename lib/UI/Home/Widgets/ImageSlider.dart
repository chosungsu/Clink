import 'dart:io';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../../Tool/NoBehavior.dart';

class ImageSliderPage extends StatefulWidget {
  const ImageSliderPage({
    Key? key,
    required this.index,
    required this.doc,
  }) : super(key: key);
  final int index;
  final String doc;
  @override
  State<StatefulWidget> createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage>
    with WidgetsBindingObserver {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  bool isChecked = false;
  TextEditingController textEditingController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var controll_memo = Get.put(memosetting());
  List _image = [];
  final imagePicker = ImagePicker();
  int isclickwhat = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.removeObserver(this);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      SystemNavigator.pop();
    }
  }

  Future _uploadFile(BuildContext context, File _image, String doc) async {
    await Permission.photos.request();
    var pstatus = await Permission.photos.status;
    isclickwhat = 1;
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

  Future _deleteFile(String doc, int index) async {
    isclickwhat = 2;
    await FirebaseStorage.instance
        .refFromURL(controll_memo.imagelist[index])
        .delete();
    controll_memo.deleteimagelist(index);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: imageSlide(),
    ));
  }

  imageSlide() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
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
                                    lightSource: LightSource.topLeft),
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 60 - 160,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: contentTitleTextsize(),
                                        color: TextColor()),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
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
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ImageShow(widget.index, context),
                              const SizedBox(
                                height: 20,
                              ),
                              SelectionBtn(),
                              const SizedBox(
                                height: 20,
                              ),
                              ImageSlider(context),
                              const SizedBox(
                                height: 50,
                              ),
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

  ImageShow(int index, BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              GetBuilder<memosetting>(
                builder: (_) => controll_memo.imagelist.isEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 300,
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text('불러올 이미지가 없습니다.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                            height: 300,
                            width: MediaQuery.of(context).size.width - 60,
                            child: Image.network(
                                controll_memo.imagelist[isclickwhat == 1
                                    ? 0
                                    : (isclickwhat == 2
                                        ? (controll_memo.imagelist.length <
                                                controll_memo.imageindex
                                            ? controll_memo.imageindex - 1
                                            : 0)
                                        : controll_memo.imageindex)],
                                fit: BoxFit.fill, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }))),
              ),
              const SizedBox(width: 10)
            ],
          )
        ],
      ),
    );
  }

  SelectionBtn() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.grey,
              ),
              onPressed: () {
                //추가기능
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('선택'),
                      content: SingleChildScrollView(
                          child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              final image = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                _uploadFile(
                                    context, File(image!.path), widget.doc);
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
                                _uploadFile(
                                    context, File(image!.path), widget.doc);
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
                );
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '추가하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.red.shade400,
              ),
              onPressed: () {
                //삭제기능
                _deleteFile(widget.doc, controll_memo.imageindex);
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        '삭제하기',
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          depth: 3,
                          color: Colors.white,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize(),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }

  ImageSlider(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
              child: Text(
                '전체',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: secondTitleTextsize(),
                    color: TextColor()),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<memosetting>(
              builder: (_) => GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 20, //수평 Padding
                    crossAxisSpacing: 20, //수직 Padding
                  ),
                  itemCount: controll_memo.imagelist.length,
                  itemBuilder: ((context, index) {
                    return controll_memo.imagelist.length == 0
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width - 60,
                              child: Text('불러올 이미지가 없습니다.',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize())),
                            ))
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controll_memo.setimageindex(index);
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: Image.network(
                                            controll_memo.imagelist[index],
                                            fit: BoxFit.fill, loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
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
                              const SizedBox(width: 10)
                            ],
                          );
                  })),
            )
          ],
        ));
  }
}
