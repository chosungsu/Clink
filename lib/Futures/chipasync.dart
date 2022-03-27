import 'package:clickbyme/DB/ChipList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../DB/TODO.dart';

Future<List<ChipList>> chipasync() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String str_first_word = '';
  String str_title = '';
  List<ChipList> str_chip_list = [];
  if (Hive.box('user_info').get('id') != null) {
    str_chip_list.clear();
    await firestore
        .collection('CHIP')
        .doc(Hive.box('user_info').get('id'))
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data() != null) {
        str_first_word = (ds.data() as Map)['first_word'];
        str_title = (ds.data() as Map)['title'];
        for (int i = 0; i < str_title.toString().split(',').length; i++) {
          str_chip_list.add(ChipList(
            first_word: str_first_word.toString().split(',')[i],
            title: str_title.toString().split(',')[i]));
        }
        str_chip_list.sort((a, b) => a.title.compareTo(b.title));
      } else {
      }
    });
  }
  return str_chip_list;
}
