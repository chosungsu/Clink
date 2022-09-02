import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class calendarsetting extends GetxController {
  int showcalendar = Hive.box('user_setting').get('viewcalsettings') ?? 0;
  int themecalendar = Hive.box('user_setting').get('origorpastel') ?? 0;
  int stylecalendar = Hive.box('user_setting').get('origordday') ?? 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List sharehomeid = [];

  void themecals1(String id) {
    themecalendar = 0;
    Hive.box('user_setting').put('origorpastel', 0);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'themesetting': themecalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'themesetting': themecalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void themecals2(String id) {
    themecalendar = 1;
    Hive.box('user_setting').put('origorpastel', 1);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'themesetting': themecalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'themesetting': themecalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void stylecalorigin(String id) {
    stylecalendar = 0;
    Hive.box('user_setting').put('origordday', 0);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'type': stylecalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'type': stylecalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void stylecaldday(String id) {
    stylecalendar = 1;
    Hive.box('user_setting').put('origordday', 1);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'type': stylecalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'type': stylecalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void setcals1w(String id) {
    showcalendar = 0;
    Hive.box('user_setting').put('viewcalsettings', 0);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'viewsetting': showcalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void setcals2w(String id) {
    showcalendar = 1;
    Hive.box('user_setting').put('viewcalsettings', 1);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'viewsetting': showcalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void setcals1m(String id) {
    showcalendar = 2;
    Hive.box('user_setting').put('viewcalsettings', 2);
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    firestore
        .collection('ShareHome')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome').doc(sharehomeid[j]).update({
          'viewsetting': showcalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }
}
