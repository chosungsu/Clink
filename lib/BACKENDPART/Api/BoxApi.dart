// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Enums/BoxSelection.dart';
import '../Getx/UserInfo.dart';
import '../Getx/linkspacesetting.dart';
import '../Getx/uisetting.dart';

class BoxApiProvider extends GetxController {
  final peopleadd = Get.put(UserInfo());
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  var res;

  createTasks() async {
    var url = '$baseurl/boxtype/create';
    try {
      await getTasks();
      if (linkspaceset.boxtypelist.isEmpty) {
        for (int i = 0; i < boxtypedatamap.length; i++) {
          res = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(boxtypedatamap[i]),
          );
        }
        await getTasks();
      }
    } catch (e) {
      print(e);
    }

    update();
    notifyChildrens();
  }

  getTasks() async {
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
          final content = data[i]['content'];

          linkspaceset.setpageboxtypelist(BoxSelection(
              title: title, isavailable: isavailable, content: content));
        }
        linkspaceset.boxtypelist.sort(((a, b) {
          return a.title.compareTo(b.title);
        }));
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
