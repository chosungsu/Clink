// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:clickbyme/BACKENDPART/Getx/linkspacesetting.dart';
import 'package:clickbyme/Tool/NoBehavior.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../BACKENDPART/Enums/PageList.dart';
import '../BACKENDPART/Enums/Variables.dart';
import '../Tool/BGColor.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/TextSize.dart';
import '../FRONTENDPART/Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../BACKENDPART/Getx/memosetting.dart';
import '../BACKENDPART/Getx/uisetting.dart';

settingseparatedlinkspace(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode searchnode,
    int index) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
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
        return Padding(
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
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return space(
                          context, textEditingController, searchnode, index);
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

space(
  BuildContext context,
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              content(context, textEditingController, searchnode, index),
            ],
          )));
}

content(
  BuildContext context,
  TextEditingController textEditingController,
  FocusNode searchnode,
  int index,
) {
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
            textEditingController.text = uiset.pagelist[index].title;
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
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: SingleChildScrollView(
                        child: Text('정말 이 링크를 삭제하시겠습니까?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.blueGrey)),
                      ),
                    );
                  },
                ), GetBackWithTrue)) ??
                false;
            if (reloadpage) {
              linkspaceset.setcompleted(true);

              var id = '';
              await firestore.collection('Pinchannel').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('username') == usercode &&
                      value.docs[i].get('linkname') ==
                          uiset.pagelist[index].title &&
                      value.docs[i].id == uiset.pagelist[index].id) {
                    id = value.docs[i].id;
                  }
                }
                firestore.collection('Pinchannel').doc(id).delete();
              }).whenComplete(() async {
                var ids;
                await firestore.collection('PageView').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('id') == id) {
                      ids = value.docs[i].id;
                    }
                  }
                  firestore.collection('PageView').doc(ids).delete();
                }).whenComplete(() async {
                  final idlist = [];
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('uniquecode') ==
                          uiset.pagelist[index].id) {
                        id = value.docs[i].id;
                        firestore.collection('Pinchannelin').doc(id).delete();
                      }
                    }
                  }).whenComplete(() {
                    linkspaceset.setcompleted(false);
                    Get.back();
                  });
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
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
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
        return Padding(
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
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: StatefulBuilder(
                    builder: ((context, setState) {
                      return spacesecond(context, str);
                    }),
                  ),
                ),
              ),
            ));
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
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
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String where,
  String id,
  int categorynumber,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 3,
      ),
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
        return Padding(
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
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: kBottomNavigationBarHeight),
              child: ScrollConfiguration(
                behavior: NoBehavior(),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
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
                          where,
                          id,
                          categorynumber,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ));
      }).whenComplete(() {});
}

linkstation(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String where,
  String id,
  int categorynumber,
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
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? (MediaQuery.of(context).size.width - 40) * 0.2
                        : (Get.width / 3 - 40) * 0.2,
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
          where,
          id,
          categorynumber,
        ),
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
              where == 'editnametemplate' || where == 'editnametemplatein'
                  ? '이름 변경'
                  : '페이지 추가',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

contentthird(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String where,
  String id,
  int categorynumber,
) {
  return Column(
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchNodeAddSection,
        string: where == 'editnametemplate' || where == 'editnametemplatein'
            ? '변경할 스페이스 이름 입력'
            : '추가할 페이지 제목 입력',
        textEditingControllerAddSheet: textEditingControllerAddSheet,
        section: 1,
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
              Summitthird(context, textEditingControllerAddSheet,
                  searchNodeAddSection, where, id, categorynumber);
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
}

Summitthird(
  BuildContext context,
  TextEditingController textEditingControllerAddSheet,
  FocusNode searchNodeAddSection,
  String where,
  String id,
  int categorynumber,
) {
  final updatelist = [];
  final uiset = Get.put(uisetting());
  final initialtext = textEditingControllerAddSheet.text;
  var updateid;
  int indexcnt = linkspaceset.indexcnt.length;
  if (textEditingControllerAddSheet.text.isEmpty) {
    Snack.snackbars(
        context: context,
        title: where == 'editnametemplate' || where == 'editnametemplatein'
            ? '변경할 제목이 비어있어요!'
            : '추가할 페이지 제목이 비어있어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  } else {
    linkspaceset.setcompleted(true);
    if (where == 'editnametemplate') {
      firestore.collection('PageView').get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i].get('id') == id &&
              value.docs[i].get('type') == categorynumber &&
              value.docs[i].get('spacename') == initialtext) {
            updateid = value.docs[i].id;
          }
        }
        firestore.collection('PageView').doc(updateid).update(
            {'spacename': textEditingControllerAddSheet.text}).whenComplete(() {
          Snack.snackbars(
              context: context,
              title: '정상적으로 처리되었어요',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          linkspaceset.setcompleted(false);
          linkspaceset.setspacelink(textEditingControllerAddSheet.text);
          Get.back(result: true);
        });
      });
    } else if (where == 'editnametemplatein') {
      var parentid;
      firestore.collection('Pinchannelin').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (int j = 0; j < value.docs.length; j++) {
            final messageuniquecode = value.docs[j]['uniquecode'];
            final messageindex = value.docs[j]['index'];
            if (messageindex == categorynumber && messageuniquecode == id) {
              parentid = value.docs[j].id;
              firestore
                  .collection('Pinchannelin')
                  .doc(value.docs[j].id)
                  .update({'addname': textEditingControllerAddSheet.text});
            }
          }
        } else {}
      }).whenComplete(() {
        firestore.collection('Calendar').get().then((value) {
          if (value.docs.isNotEmpty) {
            for (int j = 0; j < value.docs.length; j++) {
              final messageuniquecode = value.docs[j]['parentid'];
              if (messageuniquecode == parentid) {
                firestore
                    .collection('Calendar')
                    .doc(value.docs[j].id)
                    .update({'calname': textEditingControllerAddSheet.text});
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
          linkspaceset.setspacelink(textEditingControllerAddSheet.text);
          Get.back(result: true);
        });
      });
    } else {
      firestore.collection('Pinchannel').add({
        'username': usercode,
        'linkname': textEditingControllerAddSheet.text,
        'setting': 'block',
        'email': useremail
      }).whenComplete(() {
        Snack.snackbars(
            context: context,
            title: '정상적으로 처리되었어요',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
        linkspaceset.setcompleted(false);
        linkspaceset.setspacelink(textEditingControllerAddSheet.text);
        Get.back(result: true);
      });
    }
  }
}
