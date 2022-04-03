import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

saveMenu(BuildContext context, List<String> str_menu_list) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nick = Hive.box('user_info').get('id');
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "저장",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '이대로 저장하시겠습니까?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("네."),
              onPressed: () async{
                Navigator.pop(context);
                //firestore 저장
                await firestore.collection('QuickMenu').doc(nick).set({
                  'name': nick,
                  'menu': str_menu_list,
                });
              },
            ),
          ],
        );
      });
}
