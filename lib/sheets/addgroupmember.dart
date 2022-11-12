import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:another_flushbar/flushbar.dart';

import '../Tool/Getx/PeopleAdd.dart';

addgroupmember(
  BuildContext context,
  FocusNode searchNode,
  TextEditingController controller,
  String code,
) {
  Get.bottomSheet(
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: GestureDetector(
                  onTap: () {
                    searchNode.unfocus();
                  },
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SheetPage(context, searchNode, controller, code),
                  )),
            ),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      .whenComplete(() {
    controller.clear();
    Hive.box('user_setting').put('user_people', null);
  });
}

SheetPage(BuildContext context, FocusNode searchNode,
    TextEditingController controller, String code) {
  final List<String> list_user = <String>[];
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
              title(context, controller),
              const SizedBox(
                height: 20,
              ),
              content(context, searchNode, list_user, controller, code)
            ],
          )));
}

title(
  BuildContext context,
  TextEditingController controller,
) {
  return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Flexible(
            fit: FlexFit.tight,
            child: Text('피플',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
        ],
      ));
}

content(
  BuildContext context,
  FocusNode searchNode,
  List<String> list_user,
  TextEditingController controller,
  String code,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text('피플 추가하기',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SearchBox(
              searchNode,
              list_user,
              controller,
              context,
            )
          ],
        ));
  });
}

SearchBox(
  FocusNode searchNode,
  List<String> list_user,
  TextEditingController controller,
  BuildContext context,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  return SizedBox(
    height: 140,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        usersearch(
          list_user,
          firestore,
          controller,
          searchNode,
          context,
        )
      ],
    ),
  );
}

Search(
  FocusNode searchNode,
  List<String> list_user,
  TextEditingController controller,
  FirebaseFirestore firestore,
  BuildContext context,
  List<String> list_sp,
) {
  String username = Hive.box('user_info').get(
    'id',
  );
  int cnt = 0;
  List changepeople = [];
  final cal_share_person = Get.put(PeopleAdd());

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 50,
              child: ContainerDesign(
                  child: TextField(
                    controller: controller,
                    focusNode: searchNode,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintMaxLines: 2,
                        hintText: '검색방법 : 친구의 고유 Code',
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black45),
                        prefixIcon: IconButton(
                          onPressed: () {
                            searchNode.unfocus();
                            usersearch(
                              list_user,
                              firestore,
                              controller,
                              searchNode,
                              context,
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                        isCollapsed: true,
                        prefixIconColor: Colors.black),
                  ),
                  color: Colors.white)),
          Hive.box('user_setting').get('user_people') != 'nothing' &&
                  list_user.isNotEmpty
              ? SizedBox(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: list_user.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ContainerDesign(
                                          color: Colors.white,
                                          child: SizedBox(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                list_sp.contains(
                                                        list_user[index])
                                                    ? Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          list_user[index] +
                                                              '는 이미 추가된 이름입니다.',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize()),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    : Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                            list_user[index] +
                                                                '(이)가 맞습니까?',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    contentTextsize())),
                                                      ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 25,
                                                    height: 25,
                                                    child: InkWell(
                                                        onTap: () {
                                                          if (!list_sp.contains(
                                                              list_user[
                                                                  index])) {
                                                            list_sp.add(
                                                                list_user[
                                                                    index]);
                                                            Get.back();
                                                            Snack.show(
                                                                context:
                                                                    context,
                                                                title: '알림',
                                                                content:
                                                                    '정상적으로 추가되었습니다.',
                                                                snackType:
                                                                    SnackType
                                                                        .info,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating);
                                                          } else {
                                                            list_sp.remove(
                                                                list_user[
                                                                    index]);
                                                            firestore
                                                                .collection(
                                                                    'PeopleList')
                                                                .doc(username)
                                                                .delete();
                                                            Get.back();
                                                            Snack.show(
                                                                context:
                                                                    context,
                                                                title: '알림',
                                                                content:
                                                                    '삭제하였습니다.',
                                                                snackType:
                                                                    SnackType
                                                                        .warning,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating);
                                                          }
                                                          firestore
                                                              .collection(
                                                                  'PeopleList')
                                                              .doc(username)
                                                              .set(
                                                                  {
                                                                'friends':
                                                                    list_sp
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          firestore
                                                              .collection(
                                                                  'CalendarSheetHome_update')
                                                              .get()
                                                              .then((value) {
                                                            for (int i = 0;
                                                                i <
                                                                    value.docs
                                                                        .length;
                                                                i++) {
                                                              for (int j = 0;
                                                                  j <
                                                                      value
                                                                          .docs[
                                                                              i]
                                                                          .get(
                                                                              'share')
                                                                          .length;
                                                                  j++) {
                                                                changepeople
                                                                    .add(value
                                                                        .docs[i]
                                                                        .get(
                                                                            'share')[j]);
                                                              }
                                                              if (changepeople
                                                                  .contains(
                                                                      list_user[
                                                                          index])) {
                                                                changepeople.removeWhere(
                                                                    (element) =>
                                                                        element ==
                                                                        list_user[
                                                                            index]);
                                                                firestore
                                                                    .collection(
                                                                        'CalendarSheetHome_update')
                                                                    .doc(value
                                                                        .docs[i]
                                                                        .id)
                                                                    .update({
                                                                  'share':
                                                                      changepeople,
                                                                });
                                                              }
                                                              changepeople
                                                                  .clear();
                                                            }
                                                          });
                                                        },
                                                        child: list_sp.contains(
                                                                list_user[
                                                                    index])
                                                            ? NeumorphicIcon(
                                                                Icons.remove,
                                                                size: 20,
                                                                style: const NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .red,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              )
                                                            : NeumorphicIcon(
                                                                Icons.add,
                                                                size: 20,
                                                                style: const NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    color: Colors
                                                                        .red,
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              )))
                                              ],
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ));
                            }),
                      )
                    ],
                  ))
              : const SizedBox(
                  height: 0,
                )
        ],
      )
    ],
  );
}

usersearch(
  List<String> list_user,
  FirebaseFirestore firestore,
  TextEditingController controller,
  FocusNode searchNode,
  BuildContext context,
) {
  String addwhat = '';
  String username = Hive.box('user_info').get(
    'id',
  );
  List<String> list_sp = [];
  firestore.collection('PeopleList').doc(username).get().then((value) {
    for (int i = 0; i < value.get('friends').length; i++) {
      list_sp.add(value.get('friends')[i]);
    }
  });
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return FutureBuilder(
        future: firestore
            .collection("User")
            .where('code',
                isEqualTo: controller.text.isEmpty ? '' : controller.text)
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  setState(() {
                    list_user.clear();
                    querySnapshot.docs.forEach((doc) {
                      doc.get('subname') != null
                          ? list_user.add(doc.get('subname'))
                          : list_user.clear();
                    });
                    controller.text.isEmpty
                        ? addwhat = 'nothing'
                        : addwhat = controller.text.toString();
                    Hive.box('user_setting').put('user_people', addwhat);
                  })
                })),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Search(
                searchNode, list_user, controller, firestore, context, list_sp);
          } else {
            return Search(
                searchNode, list_user, controller, firestore, context, list_sp);
          }
        });
  });
}
