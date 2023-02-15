// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Enums/PageList.dart';
import '../Enums/Variables.dart';
import '../Getx/uisetting.dart';

SearchpageStreamParent() {
  return firestore.collection('Favorplace').snapshots();
}

SearchpageChild0(snapshot) {
  final valuespace = snapshot.data!.docs;
  if (valuespace.isEmpty) {
    checkid = '';
  } else {
    for (var sp in valuespace) {
      final messageuser = sp.get('favoradduser');
      final messagetitle = sp.get('title');
      if (messageuser == usercode) {
        if (messagetitle ==
            (Hive.box('user_setting').get('currenteditpage') ?? '')) {
          checkid = sp.id;
        }
      }
    }
  }
}

SearchpageChild1(snapshot) {
  final uiset = Get.put(uisetting());
  uiset.searchpagelist.clear();
  uiset.editpagelist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageuser = sp.get('nick');
    final messagetitle = sp.get('linkname');
    final messagesetting = sp.get('setting');
    if (uiset.textrecognizer == '') {
    } else {
      if (messagetitle.toString().contains(uiset.textrecognizer)) {
        if (messagetitle == '빈 스페이스') {
        } else {
          uiset.searchpagelist.add(PageList(
              title: messagetitle,
              username: messageuser,
              id: sp.id,
              setting: messagesetting));
        }
      }
    }
  }
}

SearchpageChild2(snapshot) {
  final uiset = Get.put(uisetting());
  uiset.favorpagelist.clear();
  uiset.editpagelist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageuser = sp.get('originuser');
    final messagetitle = sp.get('title');
    final messageadduser = sp.get('favoradduser');
    final messageid = sp.get('id');
    final messagesetting = sp.get('setting');
    if (messageadduser == usercode) {
      uiset.favorpagelist.add(PageList(
          title: messagetitle,
          username: messageuser,
          id: messageid,
          setting: messagesetting));
    }
  }
}
