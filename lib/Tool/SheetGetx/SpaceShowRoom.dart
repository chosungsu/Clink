import 'package:clickbyme/DB/SpaceContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../DB/SpaceList.dart';

class SpaceShowRoom extends GetxController {
  List<SpaceContent> spaceroom = [];

  void setspaceroom() {
    spaceroom = Hive.box('user_setting').get('spaceroom') ?? [];
    update();
    notifyChildrens();
  }
}
