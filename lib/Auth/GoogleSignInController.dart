import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class GoogleSignInController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late int count;

  login(BuildContext context, bool ischecked) async {
    count = 1;
    googleSignInAccount = await _googleSignIn.signIn();
    String nick = googleSignInAccount!.displayName.toString();
    String email = googleSignInAccount!.email.toString();
    String codes = Hive.box('user_info').get('id').toString().length > 5
      ? Hive.box('user_info').get('id').toString().substring(0, 4) + 
      Hive.box('user_info').get('email').toString().substring(0, 3) +
      Hive.box('user_info')
      .get('email')
      .toString()
      .split('@')[1]
      .substring(0, 2)
      : Hive.box('user_info').get('id').toString().substring(0, 2)+ 
      Hive.box('user_info').get('email').toString().substring(0, 3) +
      Hive.box('user_info')
      .get('email')
      .toString()
      .split('@')[1]
      .substring(0, 2);
    //내부 저장으로 로그인 정보 저장
    Hive.box('user_info').put('id', nick);
    Hive.box('user_info').put('email', email);
    Hive.box('user_info').put('count', count);
    Hive.box('user_info').put('autologin', ischecked);
    //firestore 저장
    await firestore.collection('User').doc(nick).set({
      'name': nick,
      'email': email,
      'login_where': 'google_user',
      'time': DateTime.now(), 
      'autologin' : ischecked,
      'code' : codes
    });

    notifyListeners();
  }

  logout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    Hive.box('user_info').delete('id');
    //firestore 삭제
    await firestore.collection('User').doc(name).delete();
    notifyListeners();
  }
}
