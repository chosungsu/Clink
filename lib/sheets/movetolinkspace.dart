// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/Variables.dart';
import '../Tool/BGColor.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/TextSize.dart';
import 'package:flutter/material.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/memosetting.dart';
import '../Tool/Getx/uisetting.dart';

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
          },
          trailing: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          title: Text(
            '접근 권한 설정',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
                color: Colors.black,
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
                      value.docs[i].get('linkname') == pagelist[index].title &&
                      value.docs[i].id == pagelist[index].id) {
                    id = value.docs[i].id;
                  }
                }
                firestore.collection('Pinchannel').doc(id).delete();
              }).whenComplete(() async {
                final idlist = [];
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('nodeid') == pagelist[index].id) {
                      id = value.docs[i].id;
                      uniquecodelist.add(value.docs[i].get('uniquecode'));
                      firestore.collection('Pinchannelin').doc(id).delete();
                    }
                  }
                }).whenComplete(() {
                  uiset.setloading(false);

                  linkspaceset.resetspacelink();
                  for (int k = 0; k < uniquecodelist.length; k++) {
                    linkspaceset.setspacelink(uniquecodelist[k]);
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
  String where,
  String id,
  int categorynumber,
  int indexcnt,
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
                              username,
                              where,
                              id,
                              categorynumber,
                              indexcnt),
                        );
                      }),
                    ))),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    if (!linkspaceset.iscompleted) {
      textEditingControllerAddSheet.clear();
      linkspaceset.resetcompleted();
    } else {}
  });
}

linkstation(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String username,
  String where,
  String id,
  int categorynumber,
  int indexcnt,
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
        titlethird(context, where),
        const SizedBox(
          height: 20,
        ),
        contentthird(
            context,
            textEditingControllerAddSheet,
            searchNodeAddSection,
            username,
            where,
            id,
            categorynumber,
            indexcnt),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  ));
}

titlethird(
  BuildContext context,
  String where,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              where == 'addtemplate'
                  ? '스페이스 추가'
                  : (where == 'editnametemplate' ||
                          where == 'editnametemplatein'
                      ? '이름 변경'
                      : '페이지 추가'),
              style: const TextStyle(
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
  String where,
  String id,
  int categorynumber,
  int indexcnt,
) {
  final updatelist = [];
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  final initialtext = textEditingControllerAddSheet.text;
  var updateid;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ContainerTextFieldDesign(
          searchNodeAddSection: searchNodeAddSection,
          string: where == 'addtemplate'
              ? '추가할 스페이스 제목 입력'
              : (where == 'editnametemplate' || where == 'editnametemplatein'
                  ? '변경할 스페이스 이름 입력'
                  : '추가할 페이지 제목 입력'),
          textEditingControllerAddSheet: textEditingControllerAddSheet,
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
                  Snack.snackbars(
                      context: context,
                      title: where == 'addtemplate'
                          ? '추가할 스페이스 제목이 비어있어요!'
                          : (where == 'editnametemplate' ||
                                  where == 'editnametemplatein'
                              ? '변경할 스페이스 제목이 비어있어요!'
                              : '추가할 페이지 제목이 비어있어요!'),
                      backgroundcolor: Colors.red,
                      bordercolor: draw.backgroundcolor);
                } else {
                  linkspaceset.setcompleted(true);
                  if (where == 'addtemplate') {
                    if (categorynumber == 0) {
                      firestore.collection('PageView').add({
                        'id': id,
                        'spacename': textEditingControllerAddSheet.text,
                        'urllist': [],
                        'pagename': uiset.pagelist[uiset.mypagelistindex].title,
                        'type': categorynumber,
                        'index': indexcnt
                      }).whenComplete(() {
                        Snack.snackbars(
                            context: context,
                            title: '정상적으로 처리되었어요',
                            backgroundcolor: Colors.green,
                            bordercolor: draw.backgroundcolor);
                        linkspaceset.setcompleted(false);
                        linkspaceset
                            .setspacelink(textEditingControllerAddSheet.text);
                        Get.back(result: true);
                      });
                    } else if (categorynumber == 1) {
                      firestore.collection('PageView').add({
                        'id': id,
                        'spacename': textEditingControllerAddSheet.text,
                        'calendarname': textEditingControllerAddSheet.text,
                        'pagename': uiset.pagelist[uiset.mypagelistindex].title,
                        'type': categorynumber,
                        'index': indexcnt
                      }).whenComplete(() {
                        Snack.snackbars(
                            context: context,
                            title: '정상적으로 처리되었어요',
                            backgroundcolor: Colors.green,
                            bordercolor: draw.backgroundcolor);
                        linkspaceset.setcompleted(false);
                        linkspaceset
                            .setspacelink(textEditingControllerAddSheet.text);
                        Get.back(result: true);
                      });
                    } else if (categorynumber == 2) {
                      firestore.collection('PageView').add({
                        'id': id,
                        'spacename': textEditingControllerAddSheet.text,
                        'todolist': [],
                        'pagename': uiset.pagelist[uiset.mypagelistindex].title,
                        'type': categorynumber,
                        'index': indexcnt
                      }).whenComplete(() {
                        Snack.snackbars(
                            context: context,
                            title: '정상적으로 처리되었어요',
                            backgroundcolor: Colors.green,
                            bordercolor: draw.backgroundcolor);
                        linkspaceset.setcompleted(false);
                        linkspaceset
                            .setspacelink(textEditingControllerAddSheet.text);
                        Get.back(result: true);
                      });
                    } else if (categorynumber == 3) {
                      firestore.collection('PageView').add({
                        'id': id,
                        'spacename': textEditingControllerAddSheet.text,
                        'memolist': [],
                        'pagename': uiset.pagelist[uiset.mypagelistindex].title,
                        'type': categorynumber,
                        'index': indexcnt
                      }).whenComplete(() {
                        Snack.snackbars(
                            context: context,
                            title: '정상적으로 처리되었어요',
                            backgroundcolor: Colors.green,
                            bordercolor: draw.backgroundcolor);
                        linkspaceset.setcompleted(false);
                        linkspaceset
                            .setspacelink(textEditingControllerAddSheet.text);
                        Get.back(result: true);
                      });
                    }
                  } else if (where == 'editnametemplate') {
                    firestore.collection('PageView').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('id') == id &&
                            value.docs[i].get('type') == categorynumber &&
                            value.docs[i].get('spacename') == initialtext) {
                          updateid = value.docs[i].id;
                        }
                      }
                      firestore.collection('PageView').doc(updateid).update({
                        'spacename': textEditingControllerAddSheet.text
                      }).whenComplete(() {
                        Snack.snackbars(
                            context: context,
                            title: '정상적으로 처리되었어요',
                            backgroundcolor: Colors.green,
                            bordercolor: draw.backgroundcolor);
                        linkspaceset.setcompleted(false);
                        linkspaceset
                            .setspacelink(textEditingControllerAddSheet.text);
                        Get.back(result: true);
                      });
                    });
                  } else if (where == 'editnametemplatein') {
                    firestore.collection('Pinchannelin').get().then((value) {
                      if (value.docs.isNotEmpty) {
                        for (int j = 0; j < value.docs.length; j++) {
                          final messageuniquecode = value.docs[j]['uniquecode'];
                          final messageindex = value.docs[j]['index'];
                          if (messageindex == categorynumber &&
                              messageuniquecode == id) {
                            firestore
                                .collection('Pinchannelin')
                                .doc(value.docs[j].id)
                                .update({
                              'addname': textEditingControllerAddSheet.text
                            });
                          }
                        }
                      } else {}
                    }).whenComplete(() {
                      Snack.snackbars(
                          context: context,
                          title: '정상적으로 처리되었어요',
                          backgroundcolor: Colors.green,
                          bordercolor: draw.backgroundcolor);
                      linkspaceset.setcompleted(false);
                      linkspaceset
                          .setspacelink(textEditingControllerAddSheet.text);
                      Get.back(result: true);
                    });
                  } else {
                    firestore.collection('Pinchannel').add({
                      'username': username,
                      'linkname': textEditingControllerAddSheet.text,
                      'setting': 'block'
                    }).whenComplete(() {
                      Snack.snackbars(
                          context: context,
                          title: '정상적으로 처리되었어요',
                          backgroundcolor: Colors.green,
                          bordercolor: draw.backgroundcolor);
                      linkspaceset.setcompleted(false);
                      linkspaceset
                          .setspacelink(textEditingControllerAddSheet.text);
                      Get.back(result: true);
                    });
                  }
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
      Snack.snackbars(
          context: context,
          title: '정상적으로 처리되었어요',
          backgroundcolor: Colors.green,
          bordercolor: draw.backgroundcolor);
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
        ContainerTextFieldDesign(
          searchNodeAddSection: searchNode,
          string: '변경할 제목입력',
          textEditingControllerAddSheet: controller,
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
                          Snack.snackbars(
                              context: context,
                              title: '변경할 이름이 비어있어요',
                              backgroundcolor: Colors.red,
                              bordercolor: draw.backgroundcolor);
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
                          firestore
                              .collection('Favorplace')
                              .get()
                              .then((value) {
                            for (int i = 0; i < value.docs.length; i++) {
                              if (value.docs[i].get('title') == link) {
                                if (value.docs[i].get('originuser') ==
                                    usercode) {
                                  id = value.docs[i].id;
                                }
                              }
                            }
                            firestore.collection('Favorplace').doc(id).update({
                              'title': controller.text,
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
