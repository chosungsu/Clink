// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:clickbyme/BACKENDPART/FIREBASE/PersonalVP.dart';
import 'package:clickbyme/Enums/Radio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Enums/Linkpage.dart';
import '../../Enums/Variables.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/category.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/RadioCustom.dart';
import '../../Tool/TextSize.dart';

Widgets_horizontalbtn(
  context,
  index,
  placestr,
  uniquecode,
  type,
  canshow,
  controller,
  searchNode,
  String s,
) {
  Widget title;
  Widget content;
  final linkspaceset = Get.put(linkspacesetting());
  final cg = Get.put(category());
  final uiset = Get.put(uisetting());
  final List<Linkspacepage> listspacepageset = [];
  bool loading = false;
  var id;
  var updateid = [];
  var updateindex = [];
  var radiogroups = [0, 1, 2];
  String changeset = canshow == '나 혼자만'
      ? radiogroup1[0]
      : (canshow == '팔로워만 공개' ? radiogroup1[1] : radiogroup1[2]);

  title = const SizedBox();
  content = StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            controller.text = placestr;
            if (s == 'pinchannel') {
              func6(context, controller, searchNode, 'editnametemplate',
                  uniquecode, type, 0);
            } else {
              func6(context, controller, searchNode, 'editnametemplatein',
                  uniquecode, index, 0);
            }
          },
          trailing: const Icon(
            AntDesign.edit,
            color: Colors.black,
          ),
          title: Text(
            '이름 변경',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: placestr == 'calendar'
                    ? Colors.grey.shade300
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ListTile(
          onTap: () {
            Get.dialog(OSDialogWithoutaction(
              context,
              '선택',
              Builder(
                builder: (context) {
                  return GetBuilder<uisetting>(builder: ((controller) {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: radiogroup1.length,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return RadioListTile<String>(
                                      title: Text(radiogroup1[index]),
                                      value: radiogroup1[index],
                                      groupValue: changeset,
                                      onChanged: (value) async {
                                        setState(() {
                                          changeset = value!;
                                        });
                                        await PageViewRes1_2(id, changeset);
                                      },
                                    );
                                  },
                                ),
                                uiset.loading == true
                                    ? SizedBox(
                                        height: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                          },
                        ));
                  }));
                },
              ),
            )).whenComplete(() {
              Get.back();
            });
          },
          trailing: const Icon(
            Ionicons.eye_outline,
            color: Colors.black,
          ),
          title: Text(
            '공개범위 변경',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: GetBuilder<uisetting>(
            builder: (controller) {
              return Text(
                'now : ' + changeset,
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: contentTextsize()),
                overflow: TextOverflow.ellipsis,
              );
            },
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
              Get.back();
              var parentid;
              var changeindex;
              if (s == 'pinchannel') {
                await firestore.collection('PageView').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('spacename') == placestr &&
                        value.docs[i].get('id') == uniquecode &&
                        value.docs[i].get('type') == type) {
                      id = value.docs[i].id;
                      changeindex = value.docs[i].get('index');
                    }
                  }
                  firestore.collection('PageView').doc(id).delete();
                }).whenComplete(() async {
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('uniquecode') == id) {
                        parentid = value.docs[i].id;
                        updateid.add(parentid);
                      }
                    }
                    if (updateid.isEmpty) {
                    } else {
                      for (int j = 0; j < updateid.length; j++) {
                        firestore
                            .collection('Pinchannelin')
                            .doc(updateid[j])
                            .delete();
                      }
                    }
                  }).whenComplete(() async {
                    updateid.clear();
                    updateindex.clear();
                    Snack.snackbars(
                        context: context,
                        title: '삭제완료!',
                        backgroundcolor: Colors.red,
                        bordercolor: draw.backgroundcolor);
                    await firestore.collection('PageView').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('index') > changeindex) {
                          updateid.add(value.docs[i].id);
                          updateindex.add(value.docs[i].get('index'));
                        }
                      }
                      if (updateid.isEmpty) {
                      } else {
                        for (int j = 0; j < updateid.length; j++) {
                          firestore
                              .collection('PageView')
                              .doc(updateid[j])
                              .update({'index': updateindex[j] - 1});
                        }
                      }
                    }).whenComplete(() {
                      linkspaceset.setcompleted(false);
                    });
                  });
                });
              } else {
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('addname') == placestr &&
                        value.docs[i].get('uniquecode') == uniquecode &&
                        value.docs[i].get('index') == index) {
                      id = value.docs[i].id;
                      changeindex = value.docs[i].get('index');
                    }
                  }
                  firestore.collection('Pinchannelin').doc(id).delete();
                }).whenComplete(() async {
                  updateid.clear();
                  updateindex.clear();
                  await firestore
                      .collection('Pinchannelin')
                      .get()
                      .then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('uniquecode') == uniquecode &&
                          value.docs[i].get('index') > changeindex) {
                        updateid.add(value.docs[i].id);
                        updateindex.add(value.docs[i].get('index'));
                      }
                    }
                    if (updateid.isEmpty) {
                    } else {
                      for (int j = 0; j < updateid.length; j++) {
                        firestore
                            .collection('Pinchannelin')
                            .doc(updateid[j])
                            .update({'index': updateindex[j] - 1});
                      }
                    }
                  }).whenComplete(() async {
                    Snack.snackbars(
                        context: context,
                        title: '삭제완료!',
                        backgroundcolor: Colors.red,
                        bordercolor: draw.backgroundcolor);
                    linkspaceset.setcompleted(false);
                    firestore.collection('Calendar').get().then((value) {
                      if (value.docs.isNotEmpty) {
                        for (int j = 0; j < value.docs.length; j++) {
                          final messageuniquecode = value.docs[j]['parentid'];
                          if (messageuniquecode == id) {
                            firestore
                                .collection('Calendar')
                                .doc(value.docs[j].id)
                                .delete();
                          }
                        }
                      } else {}
                    }).whenComplete(() {});
                  });
                });
              }
            }
          },
          trailing: const Icon(
            AntDesign.delete,
            color: Colors.red,
          ),
          title: Text(
            '삭제',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  });
  return [title, content];
}
