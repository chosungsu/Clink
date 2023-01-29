// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Enums/Expandable.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Getx/PeopleAdd.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../sheets/Mainpage/appbarpersonalbtn.dart';

final peopleadd = Get.put(PeopleAdd());
final uiset = Get.put(uisetting());

Settingtestpage() {}
Settingfriendpage() {
  return firestore.collection('PeopleList').snapshots();
}

Settingfriend_res1(snapshot) {
  peopleadd.friendlist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    if (sp.id == name) {
      for (int i = 0; i < sp.get('friends').length; i++) {
        peopleadd.friendlist.add(sp.get('friends')[i]);
      }
    }
  }
  peopleadd.friendlist.sort(((a, b) {
    return a.toString().compareTo(b.toString());
  }));
}

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
