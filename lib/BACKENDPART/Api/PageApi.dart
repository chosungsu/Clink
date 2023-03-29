// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:clickbyme/BACKENDPART/Enums/Linkpage.dart';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Getx/UserInfo.dart';
import '../Getx/linkspacesetting.dart';

class PageApiProvider extends GetxController {
  final peopleadd = Get.put(UserInfo());
  final linkspaceset = Get.put(linkspacesetting());
  var res;

  createTasks() async {
    var url = '$baseurl/pagetype/create';
    try {
      for (int i = 0; i < linkspaceset.addlist.length; i++) {
        Map data = {
          "title": linkspaceset.addlist[i].title,
          "isavailableshow": linkspaceset.addlist[i].isavailableshow,
          "owner": linkspaceset.addlist[i].owner,
          "url": linkspaceset.addlist[i].url,
          "date": linkspaceset.addlist[i].date,
        };
        res = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );
      }
    } catch (e) {
      print(e);
    }

    update();
    notifyChildrens();
  }

  getTasks() async {
    var url;
    linkspaceset.alllist.clear();
    try {
      if (linkspaceset.clickmainoption == 0) {
        url = '$baseurl/page/';
      } else if (linkspaceset.clickmainoption == 1) {
        url = '$baseurl/pagetype/search/${linkspaceset.searchurl}';
      } else {
        url = '$baseurl/page/${peopleadd.usrcode}';
      }

      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < data.length; i++) {
          final title = data[i]['title'];
          final isavailableshow = data[i]['isavailableshow'];
          final owner = data[i]['owner'];
          final url = data[i]['url'];
          final date = data[i]['date'];
          linkspaceset.setalllist(MainPageLinkList(
              title: title,
              isavailableshow: isavailableshow,
              owner: owner,
              url: url,
              date: date));
        }
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
