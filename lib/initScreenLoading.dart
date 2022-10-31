import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'DB/Event.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/memosetting.dart';
import 'Tool/Getx/notishow.dart';
import 'providers/mongodatabase.dart';

Future<Widget?> initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final controll_memo = Get.put(memosetting());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id') ?? '';
  String usercode = Hive.box('user_setting').get('usercode') ?? '';
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  bool serverstatus = Hive.box('user_info').get('server_status');

  if (name == '') {
  } else {
    if (serverstatus) {
      await MongoDB.find(collectionname: 'user', query: 'name', what: name);
      if (MongoDB.res == null) {
      } else {
        peopleadd.secondnameset(MongoDB.res['subname']);
      }
      await MongoDB.find(
          collectionname: 'homeview',
          query: 'usercode',
          what: Hive.box('user_setting').get('usercode'));
      if (MongoDB.res == null) {
        peopleadd.defaulthomeviewlist.clear();
        peopleadd.userviewlist.clear();
        peopleadd.defaulthomeviewlist.add(defaulthomeviewlist);
        peopleadd.userviewlist.add(userviewlist);
        MongoDB.add(collectionname: 'homeview', addlist: {
          'usercode': Hive.box('user_setting').get('usercode'),
          'viewcategory': peopleadd.defaulthomeviewlist,
          'hidecategory': peopleadd.userviewlist
        });
      } else {
        peopleadd.defaulthomeviewlist.clear();
        peopleadd.userviewlist.clear();
        for (int i = 0; i < MongoDB.res['viewcategory'].length; i++) {
          peopleadd.defaulthomeviewlist.add(MongoDB.res['viewcategory'][i]);
        }
        for (int j = 0; j < MongoDB.res['hidecategory'].length; j++) {
          peopleadd.userviewlist.add(MongoDB.res['hidecategory'][j]);
        }
        MongoDB.update(
            collectionname: 'homeview',
            query: 'usercode',
            what: Hive.box('user_setting').get('usercode'),
            updatelist: {
              'usercode': Hive.box('user_setting').get('usercode'),
              'viewcategory': peopleadd.defaulthomeviewlist,
              'hidecategory': peopleadd.userviewlist
            });
      }
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
    } else {
      await firestore.collection('User').doc(name).get().then((value) {
        if (value.exists) {
          peopleadd.secondnameset(value.data()!['subname']);
        }
      });
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
    }
  }
}
