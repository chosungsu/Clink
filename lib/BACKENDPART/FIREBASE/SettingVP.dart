// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Enums/Expandable.dart';
import '../../Enums/Variables.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';
import '../../sheets/Mainpage/appbarpersonbtn.dart';

final peopleadd = Get.put(PeopleAdd());
final uiset = Get.put(uisetting());

Settingtestpage() {}

Settinglicensepage() {
  firestore.collection("AppLicense").doc('License').get().then((value) {
    for (int i = 0; i < value.get('licensetitle').length; i++) {
      uiset.setlicense(value.get('licensetitle')[i], value.get('content')[i]);
      licensedata.insert(
          0,
          Expandable(
              title: value.get('licensetitle')[i],
              sub: value.get('content')[i],
              isExpanded: false));
    }
  });
}

SPIconclick(
  context,
  textcontroller,
  searchnode,
) {
  Widget title;
  Widget content;
  title = Widgets_settingpageiconclick(context, textcontroller, searchnode)[0];
  content =
      Widgets_settingpageiconclick(context, textcontroller, searchnode)[1];
  AddContent(context, title, content, searchnode);
}

Widgets_addpeople(context, controller, searchnode) {
  Widget title;
  Widget content;
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('피플',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
  content = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      usersearch(
        context,
        controller,
        searchnode,
      )
    ],
  );
  return [title, content];
}

Search(
  context,
  searchnode,
  controller,
  searchlist_user,
  list_sp,
) {
  int cnt = 0;
  List changepeople = [];

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: '검색방법 : 친구의 고유 Code',
        textEditingControllerAddSheet: controller,
      ),
      const SizedBox(
        height: 20,
      ),
      searchlist_user.isNotEmpty
          ? SizedBox(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: searchlist_user.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? Get.width - 60
                                        : (GetPlatform.isWeb
                                            ? Get.width / 3 - 60
                                            : Get.width / 2 - 60),
                                    child: ListTile(
                                      onTap: () {
                                        if (!list_sp
                                            .contains(searchlist_user[index])) {
                                          list_sp.add(searchlist_user[index]);
                                          Get.back();
                                          Snack.snackbars(
                                              context: context,
                                              title: '정상적으로 추가되었습니다',
                                              backgroundcolor: Colors.green,
                                              bordercolor:
                                                  draw.backgroundcolor);
                                        } else {
                                          list_sp
                                              .remove(searchlist_user[index]);
                                          firestore
                                              .collection('PeopleList')
                                              .doc(name)
                                              .delete();
                                          Get.back();
                                          Snack.snackbars(
                                              context: context,
                                              title: '정상적으로 삭제되었습니다',
                                              backgroundcolor: Colors.green,
                                              bordercolor:
                                                  draw.backgroundcolor);
                                        }
                                        firestore
                                            .collection('PeopleList')
                                            .doc(name)
                                            .set({'friends': list_sp},
                                                SetOptions(merge: true));
                                      },
                                      trailing: list_sp
                                              .contains(searchlist_user[index])
                                          ? const Icon(
                                              Icons.remove,
                                              size: 20,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                      title: list_sp
                                              .contains(searchlist_user[index])
                                          ? Text(
                                              searchlist_user[index] +
                                                  '는 이미 추가된 이름입니다.',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.visible,
                                            )
                                          : Text(
                                              searchlist_user[index] +
                                                  '(이)가 맞습니까?',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.visible,
                                            ),
                                    ),
                                  )
                                ],
                              ));
                        }),
                  )
                ],
              ))
          : SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AntDesign.frowno,
                    color: Colors.orange,
                    size: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '검색 결과가 없습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: TextColor_shadowcolor()),
                  ),
                ],
              ),
            )
    ],
  );
}

usersearch(
  context,
  controller,
  searchnode,
) {
  String addwhat = '';
  List<String> searchlist_user = [];
  List<String> list_sp = [];
  firestore.collection('PeopleList').doc(name).get().then((value) {
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
                    searchlist_user.clear();
                    for (var doc in querySnapshot.docs) {
                      doc.get('subname') != null
                          ? searchlist_user.add(doc.get('subname'))
                          : searchlist_user.clear();
                    }
                    /*controller.text.isEmpty
                        ? addwhat = 'nothing'
                        : addwhat = controller.text.toString();
                    Hive.box('user_setting').put('user_people', addwhat);*/
                  })
                })),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          } else {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          }
        });
  });
}
