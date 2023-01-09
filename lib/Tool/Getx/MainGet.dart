// ignore_for_file: camel_case_types

import 'package:get/get.dart';

class MainGet extends GetxController {
  List spaceindex = [];
  List spacecontent = [];

  void setspace(int totalindex) {
    spaceindex = List.generate(totalindex, (index) => 0, growable: true);
    update();
    notifyChildrens();
  }

  void resetspace() {
    spaceindex.clear();
    update();
    notifyChildrens();
  }

  void setindexofspace(int index) {
    spaceindex[index] = index;
    update();
    notifyChildrens();
  }

  void setspacecontent(int totalindex) {
    spacecontent = List.generate(totalindex, (index) => 0, growable: true);
    update();
    notifyChildrens();
  }

  void resetspacecontent() {
    spacecontent.clear();
    update();
    notifyChildrens();
  }

  void setindexofspacecontent(int index, what) {
    spacecontent[index] = what;
    update();
    notifyChildrens();
  }
}
