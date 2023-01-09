// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'package:clickbyme/Tool/Getx/MainGet.dart';
import 'package:get/get.dart';

import '../../Enums/Linkpage.dart';
import '../../Enums/Variables.dart';

/**
 * PageViewStreamOn() {
  Pinchannelgetfirst();
  return firestore.collection('PageView').snapshots();
}

Pinchannelgetfirst() async {
  var id = '';
  var index = 0;
  final mainget = Get.put(MainGet());
  var pagename = uiset.pagelist[uiset.mypagelistindex].title;
  await firestore.collection('Pinchannel').get().then((value) {
    final valuespace = value.docs;
    for (int i = 0; i < valuespace.length; i++) {
      if (valuespace[i].get('linkname') == pagename &&
          valuespace[i].get('username') == usercode) {
        id = valuespace[i].id;
      }
    }
  }).whenComplete(() async {
    await firestore.collection('PageView').get().then((value) {
      final valuespace = value.docs;
      mainget.spacecontent.clear();
      for (int i = 0; i < valuespace.length; i++) {
        if (valuespace[i].get('id') == id) {
          index += 1;
          mainget.spacecontent.insert(
              valuespace[i].get('index') - 1,
              Linkspacepage(
                type: valuespace[i].get('type'),
                placestr: valuespace[i].get('spacename'),
                uniquecode: valuespace[i].id,
                index: valuespace[i].get('index'),
                familycode: valuespace[i].get('id'),
              ));
        }
      }
    }).whenComplete(() {
      mainget.resetspace();
      mainget.setspace(index);
      for (int i = 0; i < index; i++) {
        mainget.setindexofspace(i);
      }
    });
  });
  return id;
}

Pinchannelgetsecond(type, name) async {
  final mainget = Get.put(MainGet());
  var id = await Pinchannelgetfirst();
  await firestore.collection('PageView').add({
    'id': id,
    'type': type,
    'index': mainget.spaceindex.length,
    'spacename': name
  });
}

 */