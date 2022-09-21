import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../Tool/Getx/PeopleAdd.dart';

class GoogleSignInController extends GetxController {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late int count;

  void login(BuildContext context, bool ischecked) async {
    count = 1;
    googleSignInAccount = await _googleSignIn.signIn();
    String nick = googleSignInAccount!.displayName.toString();
    String email = googleSignInAccount!.email.toString();

    //내부 저장으로 로그인 정보 저장
    Hive.box('user_info').put('id', nick);
    Hive.box('user_info').put('email', email);
    Hive.box('user_info').put('count', count);
    Hive.box('user_info').put('autologin', ischecked);
    String codes = Hive.box('user_info').get('id').toString().length > 5
        ? Hive.box('user_info').get('email').toString().substring(0, 3) +
            Hive.box('user_info')
                .get('email')
                .toString()
                .split('@')[1]
                .substring(0, 2) +
            Hive.box('user_info').get('id').toString().substring(0, 4)
        : Hive.box('user_info').get('email').toString().substring(0, 3) +
            Hive.box('user_info')
                .get('email')
                .toString()
                .split('@')[1]
                .substring(0, 2) +
            Hive.box('user_info').get('id').toString().substring(0, 2);
    //firestore 저장
    firestore.collection('User').doc(nick).get().then((value) {
      if (value.exists) {
        firestore.collection('User').doc(nick).update({
          'name': nick,
          'email': email,
          'login_where': 'google_user',
          'autologin': ischecked,
          'code': codes
        });
      } else {
        firestore.collection('User').doc(nick).set({
          'name': nick,
          'subname': nick,
          'email': email,
          'login_where': 'google_user',
          'time': DateTime.now(),
          'autologin': ischecked,
          'code': codes
        }, SetOptions(merge: true));
      }
    });

    update();
    notifyChildrens();
  }

  void logout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    Hive.box('user_info').delete('id');
    update();
    notifyChildrens();
  }

  void Deletelogout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    Hive.box('user_info').delete('id');
    //firestore 삭제
    await firestore.collection('User').doc(name).delete();
    update();
    notifyChildrens();
  }
}
