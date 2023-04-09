// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Enums/BoxSelection.dart';
import '../Getx/UserInfo.dart';
import '../Getx/linkspacesetting.dart';
import '../Getx/uisetting.dart';
import '../Locale/Translate.dart';

class BoxApiProvider extends GetxController {
  final peopleadd = Get.put(UserInfo());
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());

  getTasks({where = 'add', reset = false}) async {
    var url;

    try {
      url = '$baseurl/box/';
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        linkspaceset.boxtypelist.clear();
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < data.length; i++) {
          final title = data[i]['title'];
          final isavailable = data[i]['isavailable'];
          final content = data[i]['typing'];

          await fetchTranslating(content).then((value) {
            trans.clear();
            transmap = {'ko': value.ko, 'en': value.en};
            tr1 = transmap[peopleadd.locale!.languageCode];
            trans.add(tr1);
          }).whenComplete(() {
            linkspaceset.setpageboxtypelist(BoxSelection(
                title: title, isavailable: isavailable, content: trans[0]));
            linkspaceset.boxtypelist.sort(((a, b) {
              return a.title.compareTo(b.title);
            }));
          });
        }
        if (uiset.showboxlist.isEmpty || reset == true) {
          if (where == 'add') {
            uiset.showboxlist = List.generate(1, (index) {
              return false;
            }, growable: true);
          } else {
            uiset.showboxlist =
                List.generate(linkspaceset.boxtypelist.length, (index) {
              return false;
            }, growable: true);
          }
        }
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
