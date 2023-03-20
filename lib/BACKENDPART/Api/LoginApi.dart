// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'dart:math';
import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Getx/PeopleAdd.dart';

class LoginApiProvider extends GetxController {
  final peopleadd = Get.put(PeopleAdd());
  final box = GetStorage();

  fetchTasks() async {
    var url, response, data;
    if (peopleadd.nickname == '') {
    } else {
      url = '$baseurl/users/${peopleadd.usrcode}/';
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        peopleadd.nickname = data['nick'];
        peopleadd.usrcode = data['code'];
        peopleadd.usrimgurl = data['picture'] ?? '';
        box.write('nick', peopleadd.nickname);
        box.write('code', peopleadd.usrcode);
        box.write('picture', peopleadd.usrimgurl);
      } else {
        peopleadd.nickname = '';
        peopleadd.usrcode = '';
        peopleadd.usrimgurl = '';
        box.write('nick', '');
        box.write('code', '');
        box.write('picture', '');
      }
    }

    update();
    notifyChildrens();
  }

  createTasks() async {
    var chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    String code = '';
    var url = '$baseurl/usertype/create/';

    code = 'User#' +
        String.fromCharCodes(Iterable.generate(
            5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    peopleadd.nickname = code.substring(5);
    peopleadd.usrcode = code.substring(5);
    peopleadd.usrimgurl = '';
    box.write('nick', peopleadd.nickname);
    box.write('code', peopleadd.usrcode);
    box.write('picture', peopleadd.usrimgurl);
    try {
      Map data = {
        "nick": peopleadd.nickname,
        "img": peopleadd.usrimgurl,
        "code": peopleadd.usrcode
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
    var url = '$baseurl/users/${peopleadd.usrcode}/';
    await http.delete(
      Uri.parse(url),
    );
  }

  updateTasks(String what, String change) async {
    try {
      Map data;
      var url = '$baseurl/users/${peopleadd.usrcode}/update';
      if (what == 'nick') {
        data = {"nick": change, "img": '', "code": ''};
        box.remove('nick');
        box.write('nick', change);
      } else {
        data = {"nick": '', "img": change == '' ? null : change, "code": ''};
        box.remove('picture');
        box.write('picture', change);
      }

      peopleadd.checkusrinfo();
      var res = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }

  getTasks() async {
    try {
      var url = '$baseurl/users/';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
