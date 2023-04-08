// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Enums/PageList.dart';
import '../Getx/UserInfo.dart';
import '../Getx/notishow.dart';
import '../Getx/uisetting.dart';
import '../Locale/Translate.dart';

class NoticeApiProvider extends GetxController {
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(UserInfo());
  final notilist = Get.put(notishow());

  createTasks() async {}

  deleteTasks() async {}

  updateTasks() async {}

  getTasks() async {
    try {
      notilist.listappnoti.clear();
      var url = '$baseurl/notice/companynoti';
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < data.length; i++) {
          trans.clear();
          final title = data[i]['title'];
          final content = data[i]['content'];
          fetchTranslating(title).then((value) {
            transmap = {'ko': value.ko, 'en': value.en};
            tr1 = transmap[peopleadd.locale!.languageCode];
            trans.add(tr1);
            fetchTranslating(content).then((value) {
              transmap = {'ko': value.ko, 'en': value.en};
              tr2 = transmap[peopleadd.locale!.languageCode];
              trans.add(tr2);
            }).whenComplete(() {
              notilist.listappnoti
                  .add(Companynoti(title: trans[0], content: trans[1]));
            });
          });

          notilist.checkboxnoti.add(false);
        }
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
