// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/notishow.dart';
import '../../Tool/Getx/uisetting.dart';

///Getx 호출
final linkspaceset = Get.put(linkspacesetting());
final uiset = Get.put(uisetting());
final notilist = Get.put(notishow());

NotiAlarmStreamFamily() {
  return firestore
      .collection('AppNoticeByUsers')
      .orderBy('date', descending: true)
      .snapshots();
}

NotiAlarmRes1(snapshot, listid, readlist) {
  notilist.listad.clear();
  listid.clear();
  readlist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageText = sp.get('title');
    final messageDate = sp.get('date');
    if (sp.get('sharename').toString().contains(name) ||
        sp.get('username') == name) {
      readlist.add(sp.get('read'));
      listid.add(sp.id);
      notilist.listad
          .add(CompanyPageList(title: messageText, date: messageDate));
    }
  }
  notilist.setcheckboxnoti();
}
