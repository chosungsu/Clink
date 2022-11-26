// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Enums/Linkpage.dart';
import '../../Enums/PageList.dart';
import '../../Enums/Variables.dart';
import '../../FRONTENDPART/Page/Spacein.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/category.dart';
import '../../Tool/Getx/linkspacesetting.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../sheets/linksettingsheet.dart';

PageViewStreamParent() {
  return firestore.collection('PageView').snapshots();
}

PageViewRes1(id, snapshot) {
  final linkspaceset = Get.put(linkspacesetting());
  linkspaceset.indextreetmp.clear();
  linkspaceset.indexcnt.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    pagename = sp.get('pagename');
    spacename = sp.get('spacename');
    type = sp.get('type');
    if (sp.get('id') == id) {
      linkspaceset.indextreetmp.add(List.empty(growable: true));
      linkspaceset.indexcnt.add(Linkspacepage(
          type: sp.get('type'),
          placestr: sp.get('spacename'),
          uniquecode: sp.get('id'),
          index: sp.get('index'),
          familycode: sp.id));
    }
  }
  linkspaceset.indexcnt.sort(((a, b) {
    return a.index.compareTo(b.index);
  }));
}

PageViewStreamChild1(context, id, index) async {
  final linkspaceset = Get.put(linkspacesetting());
  return await firestore.collection('Pinchannel').doc(id).get().then(
    (value) {
      if (value.get('username') == usercode) {
        linkmadetreeplace(
          context,
          usercode,
          uiset.pagelist[0].title,
          linkspaceset.indexcnt[index].placestr,
          linkspaceset.indextreetmp[index].length,
          linkspaceset.indexcnt[index].familycode,
          linkspaceset.indexcnt[index].type,
        );
      } else {
        if (value.get('setting') == 'block') {
          Snack.snackbars(
              context: context,
              title: '접근권한이 없어요!',
              backgroundcolor: Colors.red,
              bordercolor: draw.backgroundcolor);
        } else {
          linkmadetreeplace(
            context,
            usercode,
            uiset.pagelist[0].title,
            linkspaceset.indexcnt[index].placestr,
            linkspaceset.indextreetmp[index].length,
            linkspaceset.indexcnt[index].familycode,
            linkspaceset.indexcnt[index].type,
          );
        }
      }
    },
  );
}

PageViewStreamChild2(context, id, index, controller, searchNode) async {
  final linkspaceset = Get.put(linkspacesetting());
  await firestore.collection('Pinchannel').doc(id).get().then(
    (value) {
      if (value.get('username') == usercode) {
        linkplacechangeoptions(
            context,
            index,
            linkspaceset.indexcnt[index].placestr,
            linkspaceset.indexcnt[index].uniquecode,
            linkspaceset.indexcnt[index].type,
            controller,
            searchNode,
            'pinchannel');
      } else {
        if (value.get('setting') == 'block') {
          Snack.snackbars(
              context: context,
              title: '접근권한이 없어요!',
              backgroundcolor: Colors.red,
              bordercolor: draw.backgroundcolor);
        } else {
          linkplacechangeoptions(
              context,
              index,
              linkspaceset.indexcnt[index].placestr,
              linkspaceset.indexcnt[index].uniquecode,
              linkspaceset.indexcnt[index].type,
              controller,
              searchNode,
              'pinchannel');
        }
      }
    },
  );
}

PageViewStreamParent2() {
  return firestore.collection('Pinchannelin').snapshots();
}

PageViewRes2(id, snapshot, index) {
  final linkspaceset = Get.put(linkspacesetting());
  linkspaceset.indextreetmp[index].clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    spacename = sp.get('addname');
    if (linkspaceset.indexcnt[index].familycode == sp.get('uniquecode')) {
      linkspaceset.indextreetmp[index].add(Linkspacetreepage(
          subindex: sp.get('index'),
          placestr: spacename,
          mainid: sp.id,
          uniqueid: sp.get('uniquecode')));
    }
  }
  linkspaceset.indextreetmp[index].sort(((a, b) {
    return a.subindex.compareTo(b.subindex);
  }));
}

PageViewStreamChild3(context, id, index, index2) async {
  final linkspaceset = Get.put(linkspacesetting());
  await firestore
      .collection('PageView')
      .doc(linkspaceset.indextreetmp[index][index2].uniqueid)
      .get()
      .then(
    (value) {
      Get.to(
          () => Spacein(
              id: linkspaceset.indextreetmp[index][index2].mainid,
              type: value.get('type'),
              spacename: linkspaceset.indextreetmp[index][index2].placestr),
          transition: Transition.downToUp);
    },
  );
}

PageViewStreamChild4(context, id, index, index2, controller, searchNode) async {
  final linkspaceset = Get.put(linkspacesetting());
  await firestore.collection('Pinchannel').doc(id).get().then(
    (value) {
      if (value.get('username') == usercode) {
        linkplacechangeoptions(
            context,
            index2,
            linkspaceset.indextreetmp[index][index2].placestr,
            linkspaceset.indextreetmp[index][index2].uniqueid,
            0,
            controller,
            searchNode,
            'pinchannelin');
      } else {
        if (value.get('setting') == 'block') {
        } else {
          linkplacechangeoptions(
              context,
              index2,
              linkspaceset.indextreetmp[index][index2].placestr,
              linkspaceset.indextreetmp[index][index2].uniqueid,
              0,
              controller,
              searchNode,
              'pinchannelin');
        }
      }
    },
  );
}

PageViewStreamParent3() {
  return firestore.collection('Calendar').get();
}

PageViewStreamChild5(context, id) async {
  final linkspaceset = Get.put(linkspacesetting());

  await firestore.collection('Calendar').get().then(
    (value) {
      linkspaceset.inindextreetmp.clear();
      if (value.docs.isEmpty) {
      } else {
        final valuespace = value.docs;
        for (var sp in valuespace) {
          spacename = sp.get('parentid');
          if (spacename == id) {
            linkspaceset.inindextreetmp
                .add(Linkspacepageenter(addname: sp.get('calname')));
          }
        }
      }
    },
  );
}

AddTemplateStreamFamily(spaceindata, id) {
  final cg = Get.put(category());
  return firestore.collection('PageView').get().then((value) {
    spaceindata.clear();
    uiset.pageviewlist.clear();
    if (value.docs.isEmpty) {
    } else {
      final valuespace = value.docs;
      for (int i = 0; i < valuespace.length; i++) {
        if (valuespace[i]['id'] == id) {
          if (cg.categorypicknumber == 0) {
            for (int j = 0; j < valuespace[i]['urllist'].length; j++) {
              spaceindata.add(valuespace[i]['urllist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
                title: valuespace[i]['spacename'],
                urlcontent: spaceindata,
                type: valuespace[i]['type'],
                uniquecode: valuespace[i]['id']));
          } else if (cg.categorypicknumber == 1) {
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              calendarcontent: valuespace[i]['calendarname'] ?? '',
            ));
          } else if (cg.categorypicknumber == 2) {
            for (int j = 0; j < valuespace[i]['todolist'].length; j++) {
              spaceindata.add(valuespace[i]['todolist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              todolistcontent: spaceindata,
            ));
          } else if (cg.categorypicknumber == 3) {
            for (int j = 0; j < valuespace[i]['memolist'].length; j++) {
              spaceindata.add(valuespace[i]['memolist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              memocontent: spaceindata,
            ));
          } else {}
        }
      }
      uiset.pageviewlist.sort(((a, b) {
        return a.title.compareTo(b.title);
      }));
    }
  });
}

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
}

CompanyNoticeStreamFamily() {
  return firestore.collection('CompanyNotice').snapshots();
}

CompanyNoticeChild1(snapshot, str) {
  var url;
  //final List<CompanyPageList> listcompanytousers = [];
  listcompanytousers.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageText = sp.get('title');
    final messageDate = sp.get('date');
    final messageyes = sp.get('showthisinapp');
    final messagewhere = sp.get('where');
    if (messageyes == 'yes' && messagewhere == str) {
      listcompanytousers.add(CompanyPageList(
        title: messageText,
        date: messageDate,
      ));
      url = Uri.parse(sp.get('url'));
    }
  }
  return url;
}

SpacepageStreamParent() {
  return firestore.collection('Pinchannel').snapshots();
}

SpacepageChild1(snapshot) {
  final uiset = Get.put(uisetting());
  uiset.pagelist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageuser = sp.get('username');
    final messagetitle = sp.get('linkname');
    if (messageuser == usercode) {
      uiset.pagelist
          .add(PageList(title: messagetitle, username: messageuser, id: sp.id));
    }
  }
}
