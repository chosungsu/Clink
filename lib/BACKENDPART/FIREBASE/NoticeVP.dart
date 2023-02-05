// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      notilist.listad.add(NotiList(title: messageText, date: messageDate));
    }
  }
  if (notilist.allcheck) {
    notilist.checkboxnoti =
        List.filled(notilist.listad.length, true, growable: true);
  } else {
    notilist.checkboxnoti =
        List.filled(notilist.listad.length, false, growable: true);
  }
}

SaveNoti(where, initialtext, changetext, {delete = false, add = false}) {
  firestore.collection('AppNoticeByUsers').add({
    'title': delete == true
        ? where == 'page'
            ? '[PAGE]' '$initialtext(이)가 삭제되었습니다.'
            : '[BOX]' '$initialtext(이)가 삭제되었습니다.'
        : (add == true
            ? where == 'page'
                ? '[PAGE]' '$initialtext 페이지가 추가되었습니다.'
                : '[BOX]' '$initialtext 페이지에서 새 BOX$changetext(이)가 추가되었습니다.'
            : where == 'page'
                ? '[PAGE]' '$initialtext에서 $changetext(으)로  변경되었습니다.'
                : '[BOX]' '$initialtext에서 $changetext(으)로  변경되었습니다.'),
    'date': DateFormat('yyyy-MM-dd hh:mm')
            .parse(DateTime.now().toString())
            .toString()
            .split(' ')[0] +
        ' ' +
        DateFormat('yyyy-MM-dd hh:mm')
            .parse(DateTime.now().toString())
            .toString()
            .split(' ')[1]
            .split(':')[0] +
        ':' +
        DateFormat('yyyy-MM-dd hh:mm')
            .parse(DateTime.now().toString())
            .toString()
            .split(' ')[1]
            .split(':')[1],
    'username': name,
    'sharename': [],
    'read': 'no',
  });
}
