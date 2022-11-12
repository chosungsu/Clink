// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Tool/BGColor.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/TextSize.dart';
import 'package:flutter/material.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/memosetting.dart';
import '../Tool/Getx/uisetting.dart';
import '../mongoDB/mongodatabase.dart';

settingseparatedlinkspace(
    BuildContext context,
    List<PageList> pagelist,
    TextEditingController textEditingController,
    FocusNode searchnode,
    int index) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: space(context, pagelist, textEditingController,
                    searchnode, index),
              )),
        );
      }).whenComplete(() {});
}

space(
  BuildContext context,
  List<PageList> pagelist,
  TextEditingController textEditingController,
  FocusNode searchnode,
  int index,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(
                  context, pagelist, textEditingController, searchnode, index),
            ],
          )));
}

content(
  BuildContext context,
  List<PageList> pagelist,
  TextEditingController textEditingController,
  FocusNode searchnode,
  int index,
) {
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final updatelist = [];
  final uniquecodelist = [];

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            textEditingController.text = pagelist[index].title;
            SetChangeLink(context, textEditingController, searchnode,
                pagelist[index].title);
          },
          trailing: const Icon(
            Icons.edit,
            color: Colors.black,
          ),
          title: Text(
            '이름 바꾸기',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: TextColor(),
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ListTile(
          onTap: () async {
            final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Text('정말 이 링크를 삭제하시겠습니까?',
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
              uiset.setloading(true);
              updatelist.clear();

              var id = '';
              await firestore.collection('Pinchannel').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('username') == usercode &&
                      value.docs[i].get('linkname') == pagelist[index].title) {
                    id = value.docs[i].id;
                  }
                }
                firestore.collection('Pinchannel').doc(id).delete();
              }).whenComplete(() async {
                final idlist = [];
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('username') == usercode &&
                        value.docs[i].get('linkname') ==
                            pagelist[index].title) {
                      id = value.docs[i].id;
                      uniquecodelist.add(value.docs[i].get('uniquecode'));
                      firestore.collection('Pinchannelin').doc(id).delete();
                    }
                  }
                });

                await firestore.collection('Linknet').get().then((value) async {
                  for (int i = 0; i < value.docs.length; i++) {
                    for (int i = 0; i < uniquecodelist.length; i++) {
                      if (value.docs[i].get('uniquecode') ==
                          uniquecodelist[i]) {
                        id = value.docs[i].id;
                        for (int j = 0; j < idlist.length; j++) {
                          firestore.collection('Linknet').doc(id).delete();
                        }
                      } else {}
                    }
                  }
                }).whenComplete(() {
                  uiset.setloading(false);

                  linkspaceset.resetspacelink();
                  for (int k = 0; k < updatelist.length; k++) {
                    linkspaceset.setspacelink(updatelist[k]);
                  }
                  Get.back();
                  linkspaceset.setcompleted(true);
                });
              });
            }
          },
          trailing: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text(
            '삭제하기',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  });
}

movetolinkspacesecond(BuildContext context, String str) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: spacesecond(context, str),
              )),
        );
      }).whenComplete(() {});
}

spacesecond(BuildContext context, String str) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              titlesecond(context, str),
              const SizedBox(
                height: 20,
              ),
              contentsecond(context, str),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titlesecond(BuildContext context, String str) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          str == '공유'
              ? const Text('공유스페이스',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25))
              : const Text('MY스페이스',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25))
        ],
      ));
}

contentsecond(BuildContext context, String str) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.groups,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('공유 스페이스',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          Text('지인과 함께 사용하는 스페이스',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      )
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
      ],
    );
  });
}

addmylink(
  BuildContext context,
  String username,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
) {
  Get.bottomSheet(
          Container(
            margin: const EdgeInsets.only(
                left: 10, right: 10, bottom: kBottomNavigationBarHeight),
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: StatefulBuilder(
                      builder: ((context, setState) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              searchNodeAddSection.unfocus();
                            });
                          },
                          child: linkstation(
                              context,
                              textEditingControllerAddSheet,
                              searchNodeAddSection,
                              username),
                        );
                      }),
                    ))),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    final linkspaceset = Get.put(linkspacesetting());
    if (linkspaceset.iscompleted) {
      textEditingControllerAddSheet.clear();
      linkspaceset.resetcompleted();
      Snack.show(
          context: context,
          title: '알림',
          content: '정상적으로 추가되었습니다.',
          snackType: SnackType.info,
          behavior: SnackBarBehavior.floating);
    } else {}
  });
}

linkstation(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String username,
) {
  return SizedBox(
      child: Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: (MediaQuery.of(context).size.width - 40) * 0.2,
                    alignment: Alignment.topCenter,
                    color: Colors.black45),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        titlethird(context),
        const SizedBox(
          height: 20,
        ),
        contentthird(context, textEditingControllerAddSheet,
            searchNodeAddSection, username),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  ));
}

titlethird(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('스페이스 추가',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

contentthird(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String username,
) {
  bool serverstatus = Hive.box('user_info').get('server_status');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final updatelist = [];
  final linkspaceset = Get.put(linkspacesetting());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ContainerDesign(
          color: Colors.white,
          child: TextField(
            focusNode: searchNodeAddSection,
            style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10),
              border: InputBorder.none,
              isCollapsed: true,
              hintText: '추가할 스페이스 제목 입력',
              hintStyle:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black45),
            ),
            controller: textEditingControllerAddSheet,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: ButtonColor(),
              ),
              onPressed: () async {
                if (textEditingControllerAddSheet.text.isEmpty) {
                  Snack.show(
                      title: '알림',
                      content: '추가할 스페이스 제목이 비어있어요!',
                      context: context,
                      snackType: SnackType.warning);
                } else {
                  linkspaceset.setcompleted(false);
                  firestore.collection('Pinchannel').add({
                    'username': username,
                    'linkname': textEditingControllerAddSheet.text,
                  }).whenComplete(() {
                    linkspaceset.setcompleted(true);
                    linkspaceset
                        .setspacelink(textEditingControllerAddSheet.text);
                    Get.back();
                  });
                }
              },
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicText(
                        linkspaceset.iscompleted == false ? '생성하기' : '처리중...',
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
      ],
    );
  });
}

SetChangeLink(
  BuildContext context,
  TextEditingController controller,
  FocusNode searchNode,
  String link,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GetBuilder<memosetting>(
            builder: (_) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, bottom: kBottomNavigationBarHeight),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            searchNode.unfocus();
                          },
                          child: SizedBox(
                              child: SetchangeLink(
                                  context, controller, searchNode, link))),
                    ],
                  ),
                )));
      }).whenComplete(() async {
    final linkspaceset = Get.put(linkspacesetting());
    if (linkspaceset.iscompleted) {
      linkspaceset.resetcompleted();
      Snack.show(
          context: context,
          title: '알림',
          content: '정상적으로 처리되었습니다.',
          snackType: SnackType.info,
          behavior: SnackBarBehavior.floating);
    } else {}
  });
}

SetchangeLink(BuildContext context, TextEditingController controller,
    FocusNode searchNode, String link) {
  return SizedBox(
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              titleforth(context),
              const SizedBox(
                height: 20,
              ),
              contentforth(context, searchNode, controller, link),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

titleforth(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름 변경',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

contentforth(BuildContext context, FocusNode searchNode,
    TextEditingController controller, String link) {
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');
  final updatelist = [];
  final uniquecodelist = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final linkspaceset = Get.put(linkspacesetting());
  final uiset = Get.put(uisetting());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContainerDesign(
          color: Colors.white,
          child: TextField(
            focusNode: searchNode,
            style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10),
              border: InputBorder.none,
              isCollapsed: true,
              hintText: '변경할 제목입력',
              hintStyle:
                  TextStyle(fontSize: contentTextsize(), color: Colors.black45),
            ),
            controller: controller,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        primary: Colors.blue,
                      ),
                      onPressed: () async {
                        if (controller.text.isEmpty) {
                          Snack.show(
                              context: context,
                              title: '알림',
                              content: '변경할 이름이 비어있어요!',
                              snackType: SnackType.warning,
                              behavior: SnackBarBehavior.floating);
                        } else {
                          updatelist.clear();
                          uiset.setloading(true);
                          var id = '';
                          uiset.setloading(false);
                          Get.back();
                          firestore
                              .collection('Pinchannel')
                              .get()
                              .then((value) {
                            for (int i = 0; i < value.docs.length; i++) {
                              if (value.docs[i].get('linkname') == link) {
                                if (value.docs[i].get('username') == usercode) {
                                  id = value.docs[i].id;
                                }
                              }
                            }
                            firestore.collection('Pinchannel').doc(id).update({
                              'linkname': controller.text,
                            });
                          });
                          linkspaceset.setcompleted(true);
                        }
                      },
                      child: GetBuilder<uisetting>(
                        builder: (_) => Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              uiset.loading == true
                                  ? Center(
                                      child: NeumorphicText(
                                        '처리중',
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
                                    )
                                  : Center(
                                      child: NeumorphicText(
                                        '변경',
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
                                    )
                            ],
                          ),
                        ),
                      )),
                )
              ],
            )),
      ],
    ));
  });
}
