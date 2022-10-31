import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../LocalNotiPlatform/NotificationApi.dart';
import '../BGColor.dart';

class uisetting extends GetxController {
  bool loading = false;
  int pagenumber = 0;

  void setloading(bool what) {
    loading = what;
    update();
    notifyChildrens();
  }

  void setpageindex(int what) {
    pagenumber = what;
    update();
    notifyChildrens();
  }
}
