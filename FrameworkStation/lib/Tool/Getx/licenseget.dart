import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class licenseget extends GetxController {
  List<String> licenses_title = List.empty(growable: true);
  List<String> licenses_content = List.empty(growable: true);

  void setlicense(String a, String b) async {
    licenses_title.insert(0, a);
    licenses_content.insert(0, b);
    update();
    notifyChildrens();
  }
}
