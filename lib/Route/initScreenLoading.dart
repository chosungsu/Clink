// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'package:clickbyme/Route/subuiroute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../DB/PageList.dart';
import '../LocalNotiPlatform/NotificationApi.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/memosetting.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/uisetting.dart';

Future<Widget?> initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final controll_memo = Get.put(memosetting());
  final uiset = Get.put(uisetting());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id') ?? '';
  String usercode = Hive.box('user_setting').get('usercode') ?? '';
  String useremail = Hive.box('user_info').get('email') ?? '';
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];

  if (name == '') {
  } else {
    await firestore
        .collection('HomeViewCategories')
        .doc(Hive.box('user_setting').get('usercode'))
        .get()
        .then((value) {
      peopleadd.defaulthomeviewlist.clear();
      peopleadd.userviewlist.clear();
      if (value.exists) {
        for (int i = 0; i < value.data()!['viewcategory'].length; i++) {
          peopleadd.defaulthomeviewlist.add(value.data()!['viewcategory'][i]);
        }
        for (int j = 0; j < value.data()!['hidecategory'].length; j++) {
          peopleadd.userviewlist.add(value.data()!['hidecategory'][j]);
        }
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      } else {
        peopleadd.defaulthomeviewlist.add(defaulthomeviewlist);
        peopleadd.userviewlist.add(userviewlist);
        firestore
            .collection('HomeViewCategories')
            .doc(Hive.box('user_setting').get('usercode'))
            .set({
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        }, SetOptions(merge: true));
        defaulthomeviewlist = peopleadd.defaulthomeviewlist;
        userviewlist = peopleadd.userviewlist;
      }
    });
    await firestore
        .collection('User')
        .where('name', isEqualTo: name)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          peopleadd.secondnameset(name, usercode);
        } else {
          peopleadd.secondnameset(
              value.docs[0].get('subname'), value.docs[0].get('code'));
        }
      },
    );
    await firestore.collection('AppNoticeByUsers').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['username'] == name ||
            element.data()['sharename'].toString().contains(name)) {
          updateid.add(element.data()['read']);
        }
      }
      if (updateid.contains('no')) {
        isread = false;
        notilist.isread = false;
      } else {
        isread = true;
        notilist.isread = true;
      }
    });
    await firestore.collection('Pinchannel').get().then((value) async {
      updateid.clear();
      uiset.pagelist.clear();
      for (var element in value.docs) {
        if (element.data()['username'] == usercode) {
          updateid.add(element.data()['linkname']);
          uiset.pagelist.add(PageList(
              title: element.data()['linkname'],
              id: element.id,
              setting: element.data()['setting']));
        }
      }
      if (updateid.isEmpty) {
        uiset.pagelist.clear();
        await firestore.collection('Pinchannel').add({
          'username': usercode,
          'linkname': '빈 스페이스',
          'email': useremail,
          'setting': 'block'
        }).then((value1) {
          uiset.pagelist
              .add(PageList(title: '빈 스페이스', id: value1.id, setting: 'block'));
        });
      }
    }).whenComplete(() {
      NotificationApi.runWhileAppIsTerminated();
      Hive.box('user_setting').put(
          'currentmypage', Hive.box('user_setting').get('currentmypage') ?? 0);
      GoToMain();
    });
  }
}
