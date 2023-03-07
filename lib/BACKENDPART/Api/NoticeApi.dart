// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'dart:math';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Enums/PageList.dart';
import '../Getx/notishow.dart';
import '../Getx/uisetting.dart';

class NoticeApiProvider extends GetxController {
  final uiset = Get.put(uisetting());
  final notilist = Get.put(notishow());

  createTasks() async {
    var chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    String code = '';
    var url = '$baseurl/usertype/create/';

    code = 'User#' +
        String.fromCharCodes(Iterable.generate(
            5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    Hive.box('user_setting').put('usercode', code.substring(5));
    Hive.box('user_info').put('id', code.substring(5));
    try {
      Map data = {
        "nick": Hive.box('user_info').get('id'),
        "email": "",
        "code": Hive.box('user_setting').get('usercode')
      };
      var res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }

  deleteTasks() async {
    var url = '$baseurl/users/${Hive.box('user_setting').get('usercode')}/';
    await http.delete(
      Uri.parse(url),
    );
  }

  updateTasks() async {
    try {
      deleteTasks().whenComplete(() async {
        var url = '$baseurl/usertype/create/';
        Map data = {
          "nick": Hive.box('user_info').get('id'),
          "email": "",
          "code": Hive.box('user_setting').get('usercode')
        };
        var res = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(data),
        );
        print(res.statusCode);
      });
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }

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
          final title = data[i]['title'];
          final content = data[i]['content'];
          notilist.listappnoti.add(Companynoti(title: title, content: content));
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
