import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../DB/TODO.dart';

Future<List<TODO>> homeasync(DateTime selectedDay) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String str_snaps = '';
  String str_todo = '';
  List<TODO> str_todo_list = [];
  if (Hive.box('user_info').get('id') != null) {
    str_todo_list.clear();
    await firestore
        .collection('TODO')
        .doc(Hive.box('user_info').get('id') +
            DateFormat('yyyy-MM-dd')
                .parse(selectedDay.toString().split(' ')[0])
                .toString())
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data() != null) {
        str_snaps = (ds.data() as Map)['time'];
        str_todo = (ds.data() as Map)['todo'];
        for (int i = 0; i < str_snaps.toString().split(',').length; i++) {
          str_todo_list.add(TODO(
              title: str_todo.toString().split(',')[i],
              time: str_snaps.toString().split(',')[i]));
        }
        str_todo_list.sort((a, b) => a.time.compareTo(b.time));
        print(str_todo_list.length);
      } else {
        print('sec : ' + str_todo_list.length.toString());
      }
    });
  }
  return str_todo_list;
}
