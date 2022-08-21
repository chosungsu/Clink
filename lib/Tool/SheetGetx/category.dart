import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class category extends GetxController {
  int number = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void setcategory() async {
    await firestore.collection('HomeCategories').get().then(((value) {
      number = value.docs.length;
    }));
    update();
    notifyChildrens();
  }
}
