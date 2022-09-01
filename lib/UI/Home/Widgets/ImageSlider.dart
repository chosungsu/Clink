import 'dart:io';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Dialogs/checkdeleteimagememo.dart';
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
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pageController =
        PageController(initialPage: widget.index, viewportFraction: 1);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.removeObserver(this);
    super.didChangeDependencies();
  }

  Future _uploadFile(BuildContext context, File _image, String doc) async {
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

  Future _deleteFile(String doc, int index) async {
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
      bottomNavigationBar: SelectionBtn(),
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
                    GetBuilder<memosetting>(
                      builder: (_) => SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Center(
                            child: Text(
                              (controll_memo.imageindex + 1).toString() +
                                  '/' +
                                  controll_memo.imagelist.length.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize(),
                                  color: TextColor()),
                            ),
                          )),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10)),
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
                              ImageShow(widget.index, context),
                              /*const SizedBox(
                                height: 20,
                              ),
                              ImageSlider(context),*/
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
          SizedBox(
            height: MediaQuery.of(context).size.height - 170,
            width: MediaQuery.of(context).size.width - 40,
            child: GetBuilder<memosetting>(
                builder: (_) => PageView.builder(
                    onPageChanged: (int pageindex) {
                      setState(() {
                        controll_memo.setimageindex(pageindex);
                      });
                    },
                    itemCount: controll_memo.imagelist.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return controll_memo.imagelist.isEmpty
                          ? Center(
                              child: Text('불러올 이미지가 없습니다!',
                                  style: TextStyle(
                                      color: TextColor(),
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize())),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              170,
                                      width: MediaQuery.of(context).size.width -
                                          60,
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
                                      }))
                                ],
                              ));
                    })),
          ),
        ],
      ),
    );
  }

  SelectionBtn() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 50,
            child: InkWell(
                onTap: () {
                  //추가기능
                  showDialog(
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
                                        final image =
                                            await imagePicker.pickImage(
                                                source: ImageSource.camera);
                                        setState(() {
                                          _uploadFile(context,
                                              File(image!.path), widget.doc);
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
                                        final image =
                                            await imagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        setState(() {
                                          _uploadFile(context,
                                              File(image!.path), widget.doc);
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
                },
                child: Container(
                  color: Colors.grey.shade400,
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
                  ),
                )),
          ),
        ),
        Flexible(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: InkWell(
                  onTap: () async {
                    //삭제기능
                    final reloadpage =
                        await Get.dialog(checkdeleteimagememo(context)) ??
                            false;
                    if (reloadpage) {
                      _deleteFile(widget.doc, controll_memo.imageindex);
                    }
                  },
                  child: Container(
                      color: Colors.red.shade400,
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
                      ))),
            ))
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
                builder: (_) => SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                            childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                            mainAxisSpacing: 20, //수평 Padding
                            crossAxisSpacing: 20, //수직 Padding
                          ),
                          itemCount: controll_memo.imagelist.length,
                          itemBuilder: ((context, index) {
                            return controll_memo.imagelist.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width -
                                          60,
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
                                          setState(() {
                                            print('yes');
                                            controll_memo.setimageindex(index);
                                            ImageShow(index, context);
                                          });
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
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
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
                                      const SizedBox(width: 10)
                                    ],
                                  );
                          })),
                    ))
          ],
        ));
  }
}
