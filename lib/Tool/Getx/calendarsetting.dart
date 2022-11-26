import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Enums/Event.dart';
import '../../LocalNotiPlatform/NotificationApi.dart';
import 'PeopleAdd.dart';

class calendarsetting extends GetxController {
  List share = [];
  String calname = '';
  Map<DateTime, List<Event>> events = {};
  int showcalendar = Hive.box('user_setting').get('viewcalsettings') ?? 0;
  int themecalendar = Hive.box('user_setting').get('origorpastel') ?? 0;
  int stylecalendar = Hive.box('user_setting').get('origordday') ?? 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List sharehomeid = [];
  int sort = Hive.box('user_setting').get('sort_cal_card') ?? 0;
  int repeatdate = 0;
  String repeatwhile = '주';
  DateTime now = DateTime.now();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String hour1 = '99';
  String minute1 = '99';

  void setclickday(DateTime selectone, DateTime focusone) {
    selectedDay = selectone;
    focusedDay = focusone;
    update();
    notifyChildrens();
  }

  void setrepeatdate(int num, String whilecreate) {
    if (num.toString() != '') {
      Hive.box('user_setting').put('repeatdate', num);
      repeatdate = Hive.box('user_setting').get('repeatdate');
      Hive.box('user_setting').put('repeatwhile', whilecreate);
      repeatwhile = Hive.box('user_setting').get('repeatwhile');
    } else {
      Hive.box('user_setting').put('repeatwhile', 'no');
      repeatwhile = Hive.box('user_setting').get('repeatwhile');
    }

    update();
    notifyChildrens();
  }

  void setcalname(what) {
    calname = what;
    update();
    notifyChildrens();
  }

  void setshare(what) {
    share = what;
    update();
    notifyChildrens();
  }

  void themecals1(String id) {
    themecalendar = 0;
    Hive.box('user_setting').put('origorpastel', 0);
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'themesetting': themecalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'themesetting': themecalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'themesetting': themecalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'themesetting': themecalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'type': stylecalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'type': stylecalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'type': stylecalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'type': stylecalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'viewsetting': showcalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'viewsetting': showcalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
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
    /*
    firestore.collection('CalendarSheetHome').doc(id).update({
      'viewsetting': showcalendar,
    });
    */
    firestore.collection('CalendarSheetHome_update').doc(id).update({
      'viewsetting': showcalendar,
    });
    /*firestore
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
    });*/
    firestore
        .collection('ShareHome_update')
        .where('doc', isEqualTo: id)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        sharehomeid.add(value.docs[i].id);
      }
    }).whenComplete(() {
      for (int j = 0; j < sharehomeid.length; j++) {
        firestore.collection('ShareHome_update').doc(sharehomeid[j]).update({
          'viewsetting': showcalendar,
        });
      }
    });
    update();
    notifyChildrens();
  }

  void setsortcal(int sortnum) {
    Hive.box('user_setting').put('sort_cal_card', sortnum);
    sort = Hive.box('user_setting').get('sort_cal_card');
    update();
    notifyChildrens();
  }

  void setalarmcal(String title, String id) {
    NotificationApi.cancelNotification(id: 1 + id.hashCode);
    firestore
        .collection('CalendarDataBase')
        .doc(id)
        .update({'alarmhour': '99', 'alarmminute': '99'});

    update();
    notifyChildrens();
  }

  void setalarmtype(String id, List list) {
    firestore.collection('CalendarDataBase').doc(id).update({
      'alarmtype': list,
    });
    update();
    notifyChildrens();
  }

  void settimeminute(int hour, int minute, String title, String id) {
    final cal_share_person = Get.put(PeopleAdd());
    if (title != '') {
      hour1 = hour.toString();
      minute1 = minute.toString();
      /*Hive.box('user_setting').put(
          'alarm_cal_hour_${id}_${cal_share_person.secondname}',
          hour.toString());
      Hive.box('user_setting').put(
          'alarm_cal_minute_${id}_${cal_share_person.secondname}',
          minute.toString());*/
    } else {
      hour1 = hour.toString();
      minute1 = minute.toString();
      /*Hive.box('user_setting').put(
          'alarm_cal_hour_${cal_share_person.secondname}', hour.toString());
      Hive.box('user_setting').put(
          'alarm_cal_minute_${cal_share_person.secondname}', minute.toString());*/
    }
    update();
    notifyChildrens();
  }
}
