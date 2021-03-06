import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../Dialogs/checkSave.dart';
import '../Dialogs/checkaddwhat.dart';
import '../Tool/NoBehavior.dart';
import '../Dialogs/checkhowtag.dart';

/*class WritePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  final myTextController = TextFieldTagsController();
  final List<String> _list_post_where = [
    '위치태그설정하기',
    '영화',
    '음악',
    '뉴스',
    '게임',
    '자기계발',
  ];
  String _selectedVal = '위치태그설정하기';
  final multiPicker = ImagePicker();
  List<XFile>? images_file = [];
  @override
  void dispose() {
    // TODO: implement dispose
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              //Navigator.pop(context);
              //저장이 안되므로 나가면 정보 사라진다고 경고하는 UI
              checkSave(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.orangeAccent,
            iconSize: 18,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send,
                color: Colors.orangeAccent,
              ),
              iconSize: 18,
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            color: Colors.white,
            child: Center(
              child: makeBody(context),
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    return (await checkSave(context)) ?? false;
  }

  checkPermissions(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      //허용이 된 경우
      AddActive(context);
    } else {
      //허용이 안된 경우
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "알림",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
              content: const Text(
                "[설정] > [권한 설정]을 확인해주세요",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
              actions: [
                TextButton(
                  child: Text("설정하기"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await openAppSettings();
                  },
                ),
              ],
            );
          });
    }
  }

  AddActive(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      color: Colors.white54.withOpacity(0.8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          choiceAdditional(context);
                        },
                        child: Column(
                          children: const [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(Icons.add_a_photo),
                            ),
                            Text(
                              "사진 추가하기",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.w600, // bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                        elevation: 4,
                        color: Colors.white54.withOpacity(0.8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: const [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(Icons.add_link),
                              ),
                              Text(
                                "링크 추가하기",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600, // bold
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ));
        });
  }

  checkDeletePicture(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Text(
              '알림',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              '선택하신 사진을 삭제하시겠습니까?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("아니요."),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("네."),
                onPressed: () {
                  setState(() {
                    images_file!.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future choiceAdditional(BuildContext context) async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        images_file!.addAll(selectedImages);
      });
    }
    selectedImages!.clear();
  }

  Widget makeBody(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        behavior: NoBehavior(),
        child: SingleChildScrollView(
            child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
              },
              child: Column(
                //내부를 최소만큼 키움.
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                          child: Text(
                            "포스팅 위치",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.white),
                            child: DropdownButton<String>(
                              underline: Container(
                                height: 0.5,
                                color: Colors.blueGrey,
                              ),
                              value: _selectedVal,
                              items: _list_post_where.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedVal = value!;
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                        child: Text(
                          "제목",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: '이 곳에 제목을 작성해주세요.',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                        child: Text(
                          "본문",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ScrollConfiguration(
                                  behavior: NoBehavior(),
                                  child: const SingleChildScrollView(
                                      child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: '이 곳에 내용을 작성해주세요.',
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none),
                                    ),
                                  ))))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                          child: Row(
                            children: [
                              Text(
                                "부가기능",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    checkaddwhat(context);
                                  },
                                  icon: const Icon(Icons.info_outlined))
                            ],
                          )),
                      images_file!.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await checkPermissions(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0),
                                child: const Text(
                                  "가능한 부가기능은 무엇이 있나요?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600, // bold
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await checkPermissions(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0),
                                child: const Text(
                                  "더 추가하시려면 클릭해주세요!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600, // bold
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  //프리미엄 결제시 사진 무한대로 포스팅 가능케 할것
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: DottedBorder(
                          child: Container(
                              alignment: Alignment.center,
                              child: index < images_file!.length
                                  ? Stack(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            height: 150,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        3, 3, 3, 3),
                                                child: Image.file(
                                                  File(
                                                      images_file![index].path),
                                                  fit: BoxFit.cover,
                                                ))),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                //사진을 삭제시키는 로직
                                                checkDeletePicture(
                                                    context, index);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null),
                          color: Colors.grey,
                          dashPattern: const [5, 3],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                        ),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1),
                    ),
                  ),
                  //태그 sizedbox추가하기

                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 20),
                          child: Row(
                            children: [
                              Text(
                                "태그",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    checkhowtag(context);
                                  },
                                  icon: const Icon(Icons.info_outlined))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: TextFieldTags(
                            textFieldTagsController: myTextController,
                              tagsStyler: TagsStyler(
                                  tagTextStyle:
                                      TextStyle(fontWeight: FontWeight.normal),
                                  tagDecoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  tagCancelIcon: Icon(Icons.cancel,
                                      size: 18.0, color: Colors.blue[900]),
                                  tagPadding: const EdgeInsets.all(10.0)),
                              textFieldStyler: TextFieldStyler(),
                              onTag: (tag) {},
                              onDelete: (tag) {},
                              validator: (tag) {
                                if (tag.length > 15) {
                                  return "이 이상 작성은 무리에요.";
                                }
                                return null;
                              })),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}*/
