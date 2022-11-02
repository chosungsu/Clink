import 'package:clickbyme/Route/initScreenLoading.dart';
import 'package:clickbyme/Tool/Getx/linkspacesetting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import '../Route/mainroute.dart';
import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/TextSize.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Route/subuiroute.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/calendarsetting.dart';
import '../Tool/Getx/memosetting.dart';
import '../Tool/Getx/uisetting.dart';
import '../Tool/Loader.dart';
import '../UI/Home/Widgets/CreateCalandmemo.dart';
import '../mongoDB/mongodatabase.dart';

movetolinkspace(
  BuildContext context,
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
                child: space(
                  context,
                ),
              )),
        );
      }).whenComplete(() {});
}

space(
  BuildContext context,
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
              title(context),
              const SizedBox(
                height: 20,
              ),
              content(
                context,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('스페이스 이동',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content(
  BuildContext context,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            Get.back();
            movetolinkspacesecond(context, '공유');
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
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            movetolinkspacesecond(context, 'MY');
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.workspaces,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('나의 다른 스페이스',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          Text('계정 이동없는 간편한 이동',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
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
        const SizedBox(
          height: 30,
        ),
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
                        Icons.workspaces,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('나의 다른 스페이스',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          Text('계정 이동없는 간편한 이동',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    );
  });
}

linkstation(
  BuildContext context,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
  selectcollection scollection,
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
        contentthird(context, textEditingController_add_sheet,
            searchNode_add_section, scollection, username),
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
          Text('컬렉션 추가',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

contentthird(
  BuildContext context,
  TextEditingController textEditingController_add_sheet,
  FocusNode searchNode_add_section,
  selectcollection scollection,
  String username,
) {
  bool serverstatus = Hive.box('user_info').get('server_status');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final updatelist = [];
  final linkspaceset = Get.put(linkspacesetting());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        TextField(
          minLines: 2,
          maxLines: 2,
          focusNode: searchNode_add_section,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            contentPadding: const EdgeInsets.only(left: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            isCollapsed: true,
            hintText: '추가할 컬렉션 입력',
            hintStyle:
                TextStyle(fontSize: contentTextsize(), color: Colors.black45),
          ),
          controller: textEditingController_add_sheet,
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
                if (textEditingController_add_sheet.text.isEmpty) {
                  Snack.show(
                      title: '알림',
                      content: '추가할 컬렉션이 비어있어요!',
                      context: context,
                      snackType: SnackType.warning);
                } else {
                  if (serverstatus) {
                    await MongoDB.find(
                        collectionname: 'linknet',
                        query: 'username',
                        what: username);
                    if (MongoDB.res == null) {
                      await MongoDB.add(collectionname: 'linknet', addlist: {
                        'username': username,
                        'link': [textEditingController_add_sheet.text],
                      });
                      linkspaceset
                          .setspacelink(textEditingController_add_sheet.text);
                    } else {
                      await MongoDB.getData(collectionname: 'linknet')
                          .then((value) async {
                        updatelist.clear();
                        for (int j = 0; j < value.length; j++) {
                          final user = value[j]['username'];
                          if (user == username) {
                            for (int i = 0; i < value[j]['link'].length; i++) {
                              updatelist.add(value[j]['link'][i]);
                            }
                          }
                        }
                        await MongoDB.delete(
                            collectionname: 'linknet',
                            deletelist: {
                              'username': username,
                            });
                      });
                      updatelist.add(textEditingController_add_sheet.text);
                      await MongoDB.add(collectionname: 'linknet', addlist: {
                        'username': username,
                        'link': updatelist,
                      });
                      for (int k = 0; k < updatelist.length; k++) {
                        linkspaceset.setspacelink(updatelist[k]);
                      }
                    }
                    linkspaceset.setcompleted(true);
                    Get.back();
                    var id = '';
                    firestore.collection('Linknet').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('username') == username) {
                          id = value.docs[i].id;
                        }
                      }
                      firestore.collection('Linknet').doc(id).delete();
                    });
                    firestore.collection('Linknet').add({
                      'username': username,
                      'title': updatelist,
                    }).whenComplete(() {});
                  } else {
                    updatelist.clear();
                    var id = '';
                    firestore.collection('Linknet').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('username') == username) {
                          for (int j = 0;
                              j < value.docs[i].get('link').length;
                              j++) {
                            updatelist.add(value.docs[i].get('link')[j]);
                          }
                          id = value.docs[i].id;
                        }
                      }
                      firestore.collection('Linknet').doc(id).delete();
                    });
                    updatelist.add(textEditingController_add_sheet.text);
                    firestore.collection('Linknet').add({
                      'username': username,
                      'title': updatelist,
                    }).whenComplete(() {
                      linkspaceset.setcompleted(true);
                      Get.back();
                      for (int k = 0; k < updatelist.length; k++) {
                        linkspaceset.setspacelink(updatelist[k]);
                      }
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
                        '생성하기',
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
  FToast fToast,
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
                  margin: const EdgeInsets.all(10),
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
                              child: SetchangeLink(context, controller,
                                  searchNode, fToast, link))),
                    ],
                  ),
                )));
      }).whenComplete(() async {
    final linkspaceset = Get.put(linkspacesetting());
    if (linkspaceset.iscompleted) {
      controller.clear();
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

SetchangeLink(BuildContext context, TextEditingController controller,
    FocusNode searchNode, FToast fToast, String link) {
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
              contentforth(context, searchNode, controller, fToast, link),
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
          Text('설정',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
}

contentforth(BuildContext context, FocusNode searchNode,
    TextEditingController controller, FToast fToast, String link) {
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');
  final updatelist = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final linkspaceset = Get.put(linkspacesetting());

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Text('링크이름 변경',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize())),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          minLines: 2,
          maxLines: 2,
          focusNode: searchNode,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            contentPadding: const EdgeInsets.only(left: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            isCollapsed: true,
            hintText: '링크 이름 입력',
            hintStyle:
                TextStyle(fontSize: contentTextsize(), color: Colors.black45),
          ),
          controller: controller,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      final reloadpage =
                          await Get.dialog(OSDialog(context, '경고', Builder(
                                builder: (context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
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
                        if (serverstatus) {
                          await MongoDB.getData(collectionname: 'linknet')
                              .then((value) async {
                            updatelist.clear();
                            for (int j = 0; j < value.length; j++) {
                              final user = value[j]['username'];
                              if (user == usercode) {
                                for (int i = 0;
                                    i < value[j]['link'].length;
                                    i++) {
                                  if (link != value[j]['link'][i]) {
                                    updatelist.add(value[j]['link'][i]);
                                  }
                                }
                              }
                            }
                            await MongoDB.delete(
                                collectionname: 'linknet',
                                deletelist: {
                                  'username': usercode,
                                });
                            await MongoDB.add(
                                collectionname: 'linknet',
                                addlist: {
                                  'username': usercode,
                                  'link': updatelist,
                                });
                            var id = '';
                            await firestore
                                .collection('Linknet')
                                .get()
                                .then((value) {
                              for (int i = 0; i < value.docs.length; i++) {
                                if (value.docs[i].get('username') == usercode) {
                                  id = value.docs[i].id;
                                }
                              }
                              firestore.collection('Linknet').doc(id).delete();
                            }).whenComplete(() {
                              firestore.collection('Linknet').add({
                                'username': usercode,
                                'title': updatelist,
                              });
                            });
                          }).whenComplete(() {
                            controller.clear();
                            linkspaceset.resetspacelink();
                            for (int k = 0; k < updatelist.length; k++) {
                              linkspaceset.setspacelink(updatelist[k]);
                            }
                            linkspaceset.setcompleted(true);
                            Get.back();
                          });
                        } else {
                          updatelist.clear();
                          var id = '';

                          await firestore
                              .collection('Linknet')
                              .get()
                              .then((value) {
                            for (int i = 0; i < value.docs.length; i++) {
                              if (value.docs[i].get('username') == usercode) {
                                for (int j = 0;
                                    j < value.docs[i].get('link').length;
                                    j++) {
                                  if (link != value.docs[i].get('link')[j]) {
                                    updatelist
                                        .add(value.docs[i].get('link')[j]);
                                  }
                                }
                                id = value.docs[i].id;
                              }
                            }
                            firestore.collection('Linknet').doc(id).delete();
                          });
                          firestore.collection('Linknet').add({
                            'username': usercode,
                            'title': updatelist,
                          }).whenComplete(() {
                            controller.clear();
                            linkspaceset.resetspacelink();
                            for (int k = 0; k < updatelist.length; k++) {
                              linkspaceset.setspacelink(updatelist[k]);
                            }
                            linkspaceset.setcompleted(true);
                            Get.back();
                          });
                        }
                      }
                    },
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          uisetting().loading == true
                              ? Center(
                                  child: NeumorphicText(
                                    '대기',
                                    style: const NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Colors.red,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: NeumorphicText(
                                    '삭제',
                                    style: const NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: Colors.red,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
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
                          if (serverstatus) {
                            await MongoDB.getData(collectionname: 'linknet')
                                .then((value) async {
                              updatelist.clear();
                              for (int j = 0; j < value.length; j++) {
                                final user = value[j]['username'];
                                if (user == usercode) {
                                  for (int i = 0;
                                      i < value[j]['link'].length;
                                      i++) {
                                    if (link != value[j]['link'][i]) {
                                      updatelist.add(value[j]['link'][i]);
                                    }
                                  }
                                }
                              }
                              updatelist.add(controller.text);
                              await MongoDB.delete(
                                  collectionname: 'linknet',
                                  deletelist: {
                                    'username': usercode,
                                  });
                              await MongoDB.add(
                                  collectionname: 'linknet',
                                  addlist: {
                                    'username': usercode,
                                    'link': updatelist,
                                  });
                            }).whenComplete(() {
                              var id = '';
                              firestore
                                  .collection('Linknet')
                                  .get()
                                  .then((value) {
                                for (int i = 0; i < value.docs.length; i++) {
                                  if (value.docs[i].get('username') ==
                                      usercode) {
                                    id = value.docs[i].id;
                                  }
                                }
                                if (updatelist.isEmpty) {
                                } else {
                                  firestore
                                      .collection('Linknet')
                                      .doc(id)
                                      .delete();
                                  firestore.collection('Linknet').add({
                                    'username': usercode,
                                    'title': updatelist,
                                  });
                                }
                              }).whenComplete(() {
                                linkspaceset.resetspacelink();
                                for (int k = 0; k < updatelist.length; k++) {
                                  linkspaceset.setspacelink(updatelist[k]);
                                }
                                linkspaceset.setcompleted(true);
                                controller.clear();
                                Get.back();
                              });
                            });
                          } else {
                            updatelist.clear();
                            var id = '';
                            firestore.collection('Linknet').get().then((value) {
                              for (int i = 0; i < value.docs.length; i++) {
                                if (value.docs[i].get('username') == usercode) {
                                  for (int j = 0;
                                      j < value.docs[i].get('link').length;
                                      j++) {
                                    if (link != value.docs[i].get('link')[j]) {
                                      updatelist
                                          .add(value.docs[i].get('link')[j]);
                                    }
                                  }
                                  id = value.docs[i].id;
                                }
                              }
                              if (updatelist.isEmpty) {
                              } else {
                                firestore
                                    .collection('Linknet')
                                    .doc(id)
                                    .delete();
                                updatelist.add(controller.text);
                                firestore.collection('Linknet').add({
                                  'username': usercode,
                                  'title': updatelist,
                                });
                              }
                            }).whenComplete(() {
                              controller.clear();
                              linkspaceset.resetspacelink();
                              for (int k = 0; k < updatelist.length; k++) {
                                linkspaceset.setspacelink(updatelist[k]);
                              }
                              linkspaceset.setcompleted(true);
                              Get.back();
                            });
                          }
                        }
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            uisetting().loading == true
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
                      )),
                )
              ],
            )),
      ],
    ));
  });
}
