import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'DB/Event.dart';
import 'Tool/Getx/PeopleAdd.dart';
import 'Tool/Getx/notishow.dart';

Future<Widget?> initScreen() async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  List updateid = [];
  bool isread = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = Hive.box('user_info').get('id') ?? '';
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  if (name == '') {
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
/*
Stream<Object?> initcalendarloading(
  String title,
  Map<DateTime, List<Event>> _events,
) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore
      .collection('CalendarDataBase')
      .where('calname', isEqualTo: title)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      _events.clear();
      final valuespace = value.docs;
      for (var sp in valuespace) {
        final ev_date = sp.get('Date');
        final ev_todo = sp.get('Daytodo');
        if (_events[DateTime.parse(
                sp.get('Date').toString().split('일')[0] + ' 00:00:00.000Z')] !=
            null) {
          _events[DateTime.parse(
                  sp.get('Date').toString().split('일')[0] + ' 00:00:00.000Z')]!
              .add(Event(title: sp.get('Daytodo')));
        } else {
          _events[DateTime.parse(
              sp.get('Date').toString().split('일')[0] + ' 00:00:00.000Z')] = [
            Event(title: sp.get('Daytodo'))
          ];
        }
      }
    }
  });
  return 
}*/
