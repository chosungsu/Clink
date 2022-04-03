import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import '../DB/PageList.dart';

Future<List<String>> quickmenuasync() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> str_menu_list = [];
  final List<String> _list_ad = [
    '데이로그',
    '챌린지',
    '페이지마크',
    '탐색기록'
  ];
  if (Hive.box('user_info').get('id') != null) {
    str_menu_list.clear();
    await firestore
        .collection('QuickMenu')
        .doc(Hive.box('user_info').get('id'))
        .get()
        .then((DocumentSnapshot ds) {
      //print('4');
      //print(ds.get('menu'));

      if (ds.get('menu').isEmpty) {
        for (int i = 0; i < _list_ad.length; i++) {
          str_menu_list.add(_list_ad[i]);
        }
      } else {
        for (int i = 0; i < ds.get('menu').toString().split(',').length; i++) {
          str_menu_list.add(ds.get('menu')[i]);
        }
        print('async : ' + str_menu_list.toString());
      }
    });
  }
  return str_menu_list;
}
