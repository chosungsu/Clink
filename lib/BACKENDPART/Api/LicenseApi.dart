// ignore_for_file: file_names, unused_element, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Enums/Expandable.dart';

class LicenseApiProvider extends GetxController {
  createTasks() async {
    var url = '$baseurl/license/';
    var response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (data.length == 0) {
        var url = '$baseurl/licensetype/create';
        try {
          for (int i = 0; i < licensedatamap.length; i++) {
            var res = await http.post(
              Uri.parse(url),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(licensedatamap[i]),
            );
          }
        } catch (e) {
          print(e);
        }
      }
    } else {}

    update();
    notifyChildrens();
  }

  getTasks() async {
    try {
      var url = '$baseurl/license/';
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < data.length; i++) {
          final title = data[i]['title'];
          final content = data[i]['content'];
          licensedata.insert(
              0, Expandable(title: title, sub: content, isExpanded: false));
        }
      } else {}
    } catch (e) {
      print(e);
    }
    update();
    notifyChildrens();
  }
}
