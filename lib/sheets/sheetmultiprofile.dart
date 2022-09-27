import 'package:another_flushbar/flushbar.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/memosetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../Tool/BGColor.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/IconBtn.dart';

sheetmultiprofile(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
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
                child: GestureDetector(
                    onTap: () {
                      node.unfocus();
                    },
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SheetPage(context, node, controller, name))),
              )),
        );
      }).whenComplete(() {
    controller.text = '';
  });
}

SheetPage(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
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
              title(context, name),
              const SizedBox(
                height: 20,
              ),
              content(context, node, controller, name),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title(BuildContext context, String name) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                    text: name,
                    style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                TextSpan(
                    text: '님의 닉네임 변경',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()))
              ]))
        ],
      ));
}

content(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  bool _ischecked = false;
  bool isloading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());
  List changepeople = [];
  var time, ok;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize(),
              color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          minLines: 1,
          maxLines: 1,
          focusNode: node,
          style: TextStyle(fontSize: contentTextsize(), color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            contentPadding: const EdgeInsets.only(left: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            isCollapsed: true,
            hintText: '다른 사용자에게 보일 이름 작성',
            hintStyle: TextStyle(
                fontSize: contentTextsize(), color: Colors.grey.shade400),
          ),
          controller: controller,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '초기 닉네임으로 변경',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: Colors.black),
              ),
            ),
            Checkbox(
                value: _ischecked,
                onChanged: (value) {
                  setState(() {
                    _ischecked = value!;
                  });
                }),
          ],
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
                if (isloading) {
                  return;
                }
                setState(() {
                  isloading = true;
                });
                if (controller.text.isEmpty) {
                  if (_ischecked) {
                    await firestore
                        .collection('CalendarSheetHome')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('OriginalUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({
                            'OriginalUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('ShareHome').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          for (int k = 0; k < changepeople.length; k++) {
                            firestore
                                .collection('ShareHome')
                                .doc(value.docs[i].id.split('-')[0] +
                                    changepeople[k])
                                .set({
                              'share': changepeople,
                              'allowance_change_set':
                                  value.docs[i].get('allowance_change_set'),
                              'allowance_share':
                                  value.docs[i].get('allowance_share'),
                              'calname': value.docs[i].get('calname'),
                              'color': value.docs[i].get('color'),
                              'date': value.docs[i].get('date'),
                              'doc': value.docs[i].get('doc'),
                              'madeUser': Hive.box('user_info').get('id'),
                              'showingUser': changepeople[k],
                              'themesetting': value.docs[i].get('themesetting'),
                              'type': value.docs[i].get('type'),
                              'viewsetting': value.docs[i].get('viewsetting'),
                            });
                          }

                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('MemoCollections')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('MemoCollections')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                      }
                    });
                    await firestore
                        .collection('PeopleList')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('friends').length;
                            j++) {
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('User').get().then((value) {
                      if (value.docs.isEmpty) {
                      } else {
                        cal_share_person.secondnameset(value.docs[0]['name']);
                      }
                    });

                    setState(() {
                      isloading = false;
                    });
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      isloading = false;
                    });
                    Snack.show(
                        title: '경고',
                        content: '변경할 닉네임 작성바랍니다.',
                        context: context,
                        snackType: SnackType.warning);
                  }
                } else {
                  if (_ischecked) {
                    await firestore
                        .collection('CalendarSheetHome')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));

                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('OriginalUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({
                            'OriginalUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('ShareHome').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          for (int k = 0; k < changepeople.length; k++) {
                            firestore
                                .collection('ShareHome')
                                .doc(value.docs[i].id.split('-')[0] +
                                    changepeople[k])
                                .set({
                              'share': changepeople,
                              'allowance_change_set':
                                  value.docs[i].get('allowance_change_set'),
                              'allowance_share':
                                  value.docs[i].get('allowance_share'),
                              'calname': value.docs[i].get('calname'),
                              'color': value.docs[i].get('color'),
                              'date': value.docs[i].get('date'),
                              'doc': value.docs[i].get('doc'),
                              'madeUser': Hive.box('user_info').get('id'),
                              'showingUser': changepeople[k],
                              'themesetting': value.docs[i].get('themesetting'),
                              'type': value.docs[i].get('type'),
                              'viewsetting': value.docs[i].get('viewsetting'),
                            });
                          }
                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('MemoCollections')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('MemoCollections')
                              .doc(value.docs[i].id)
                              .update({
                            'madeUser': Hive.box('user_info').get('id')
                          });
                        }
                      }
                    });
                    await firestore
                        .collection('PeopleList')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('friends').length;
                            j++) {
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('User').get().then((value) {
                      if (value.docs.isEmpty) {
                      } else {
                        cal_share_person.secondnameset(value.docs[0]['name']);
                      }
                    });
                  } else {
                    await firestore
                        .collection('CalendarSheetHome')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({'madeUser': controller.text});
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('CalendarSheetHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('OriginalUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'OriginalUser': controller.text});
                        }
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('ShareHome').get().then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].get('madeUser') ==
                            cal_share_person.secondname) {
                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({'madeUser': controller.text});
                        }
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('ShareHome')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('PeopleList')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('friends').length;
                            j++) {
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore.collection('User').get().then((value) {
                      if (value.docs.isEmpty) {
                      } else {
                        cal_share_person.secondnameset(controller.text);
                      }
                    });
                  }

                  setState(() {
                    isloading = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: isloading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '생성중...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: contentTextsize(),
                              fontWeight: FontWeight.bold, // bold
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: NeumorphicText(
                              '닉네임 변경',
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
    ));
  });
}
