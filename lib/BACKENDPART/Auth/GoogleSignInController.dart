// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../../Enums/Variables.dart';
import '../../FRONTENDPART/Route/initScreenLoading.dart';

class GoogleSignInController extends GetxController {
  final _googleSignIn = GoogleSignIn(
      clientId:
          "789398252263-0egnmrhp7qso704ekt7pclkbmkia1s6f.apps.googleusercontent.com");
  GoogleSignInAccount? googleSignInAccount;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late int count;

  login(BuildContext context, bool ischecked) async {
    count = 1;
    googleSignInAccount = await _googleSignIn.signIn();
    String nick = googleSignInAccount!.displayName.toString();
    String email = googleSignInAccount!.email.toString();
    var _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String code = '';

    //내부 저장으로 로그인 정보 저장
    code = email.toString().substring(0, 3) +
        email.toString().split('@')[1].substring(0, 2) +
        String.fromCharCodes(Iterable.generate(
            5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    //firestore 저장

    await firestore.collection('User').doc(nick).get().then((value) async {
      if (value.exists) {
        await firestore.collection('User').doc(nick).update({
          'name': nick,
          'email': email,
          'login_where': 'google_user',
          'autologin': ischecked,
        }).whenComplete(() async {
          await Hive.box('user_info').put('id', nick);
          await Hive.box('user_info').put('email', email);
          await Hive.box('user_info').put('count', count);
          await Hive.box('user_info').put('autologin', ischecked);
          await firestore
              .collection('User')
              .doc(Hive.box('user_info').get('id'))
              .get()
              .then((value) async {
            if (value.exists) {
              await Hive.box('user_setting')
                  .put('usercode', value.data()!['code']);
              name = nick;
              email = email;
              usercode = value.data()!['code'];
              initScreen();
            } else {}
          });
        });
      } else {
        await firestore.collection('User').doc(nick).set({
          'name': nick,
          'subname': nick,
          'email': email,
          'login_where': 'google_user',
          'autologin': ischecked,
          'code': code
        }, SetOptions(merge: true)).whenComplete(() async {
          await Hive.box('user_info').put('id', nick);
          await Hive.box('user_info').put('email', email);
          await Hive.box('user_info').put('count', count);
          await Hive.box('user_info').put('autologin', ischecked);
          await Hive.box('user_setting').put('usercode', code);
          name = nick;
          email = email;
          usercode = code;
          initScreen();
        });
      }
    });

    update();
    notifyChildrens();
  }

  logout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    Hive.box('user_info').delete('id');
    update();
    notifyChildrens();
  }

  Deletelogout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    Hive.box('user_info').delete('id');
    //firestore 삭제
    //await firestore.collection('User').doc(name).delete();
    update();
    notifyChildrens();
  }
}
