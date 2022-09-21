import 'package:clickbyme/Tool/FlushbarStyle.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

import '../Tool/Getx/PeopleAdd.dart';
import '../route.dart';

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
    await Hive.box('user_info').put('id', nick);
    await Hive.box('user_info').put('email', email);
    await Hive.box('user_info').put('count', count);
    await Hive.box('user_info').put('autologin', ischecked);
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
    firestore.collection('User').doc(nick).get().then((value) async {
      Snack.show(
          title: '로딩중',
          snackType: SnackType.waiting,
          content: '로그인중입니다.잠시만 기다려주세요',
          context: context);
      if (value.exists) {
        await firestore.collection('User').doc(nick).update({
          'name': nick,
          'email': email,
          'login_where': 'google_user',
          'autologin': ischecked,
          'code': codes
        }).whenComplete(() {
          GoToMain(context);
        });
      } else {
        await firestore.collection('User').doc(nick).set({
          'name': nick,
          'subname': nick,
          'email': email,
          'login_where': 'google_user',
          'time': DateTime.now(),
          'autologin': ischecked,
          'code': codes
        }, SetOptions(merge: true)).whenComplete(() {
          GoToMain(context);
        });
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
