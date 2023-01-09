// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names, unused_local_variable

import 'package:clickbyme/FRONTENDPART/Route/subuiroute.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/memosetting.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';

Future<Widget?> initScreen(BuildContext context) async {
  final peopleadd = Get.put(PeopleAdd());
  final notilist = Get.put(notishow());
  final controll_memo = Get.put(memosetting());
  final uiset = Get.put(uisetting());
  List updateid = [];
  bool isread = false;

  if (name == '') {
  } else {
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
      //NotificationApi.runWhileAppIsTerminated();
      Hive.box('user_setting').put('currentmypage', 0);
      uiset.setloading(false);
      if (uiset.loading) {
      } else {
        Snack.snackbars(
            context: context,
            title: '로그인 완료',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
      }
      GoToMain();
    });
  }
}
