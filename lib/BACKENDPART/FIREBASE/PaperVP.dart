// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

import '../../Enums/Linkpage.dart';
import '../../Enums/Variables.dart';
import '../Getx/calendarsetting.dart';
import '../Getx/linkspacesetting.dart';
import '../Getx/uisetting.dart';

///Getx 호출
final linkspaceset = Get.put(linkspacesetting());
final controll_cals = Get.put(calendarsetting());
final uiset = Get.put(uisetting());

///이 아래는 StreamBuilder기반 코드 작성
PaperViewStreamParent1() {
  return firestore.collection('PaperMake').snapshots();
}

PaperViewRes1(id, snapshot) {
  linkspaceset.inpapertreetmp.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    spacestr = sp.get('pagename');
    unique = sp.id;
    familyid = sp.get('familycode');
    if (familyid == id) {
      linkspaceset.inpapertreetmp.add(
          LinkofPapers(placestr: spacestr, uniqueid: unique, mainid: familyid));
    }
  }
}
