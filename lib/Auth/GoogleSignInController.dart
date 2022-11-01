import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../Route/subuiroute.dart';
import '../Route/initScreenLoading.dart';
import '../mongoDB/mongodatabase.dart';

class GoogleSignInController extends GetxController {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late int count;
  bool serverstatus = Hive.box('user_info').get('server_status');

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
    await Hive.box('user_info').put('id', nick);
    await Hive.box('user_info').put('email', email);
    await Hive.box('user_info').put('count', count);
    await Hive.box('user_info').put('autologin', ischecked);
    code = Hive.box('user_info').get('email').toString().substring(0, 3) +
        Hive.box('user_info')
            .get('email')
            .toString()
            .split('@')[1]
            .substring(0, 2) +
        String.fromCharCodes(Iterable.generate(
            5, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    //firestore 저장
    if (serverstatus) {
      await MongoDB.find(collectionname: 'user', query: 'name', what: nick);
      if (MongoDB.res == null) {
        await MongoDB.add(collectionname: 'user', addlist: {
          'name': nick,
          'subname': nick,
          'email': email,
          'login_where': 'google_user',
          'autologin': ischecked,
          'code': code
        });
        Hive.box('user_setting').put('usercode', MongoDB.res['code']);
      } else {
        await MongoDB.update(
            collectionname: 'user',
            query: 'name',
            what: nick,
            updatelist: {
              'name': nick,
              'email': email,
              'login_where': 'google_user',
              'autologin': ischecked,
            });
        Hive.box('user_setting').put('usercode', MongoDB.res['code']);
      }

      firestore.collection('User').doc(nick).get().then((value) async {
        if (value.exists) {
          await firestore.collection('User').doc(nick).update({
            'name': nick,
            'email': email,
            'login_where': 'google_user',
            'autologin': ischecked,
          }).whenComplete(() {
            firestore
                .collection('User')
                .doc(Hive.box('user_info').get('id'))
                .get()
                .then((value) async {
              if (value.exists) {
                await Hive.box('user_setting')
                    .put('usercode', value.data()!['code']);
              } else {}
            });
          });
        } else {
          await firestore.collection('User').doc(nick).set({
            'name': nick,
            'subname': nick,
            'email': email,
            'login_where': 'google_user',
            'time': DateTime.now(),
            'autologin': ischecked,
            'code': code
          }, SetOptions(merge: true)).whenComplete(() async {
            await Hive.box('user_setting').put('usercode', code);
          });
        }
      });
      await initScreen();
      GoToMain(context);
    } else {
      firestore.collection('User').doc(nick).get().then((value) async {
        if (value.exists) {
          await firestore.collection('User').doc(nick).update({
            'name': nick,
            'email': email,
            'login_where': 'google_user',
            'autologin': ischecked,
          }).whenComplete(() {
            firestore
                .collection('User')
                .doc(Hive.box('user_info').get('id'))
                .get()
                .then((value) async {
              if (value.exists) {
                await Hive.box('user_setting')
                    .put('usercode', value.data()!['code']);
              } else {}
            });
          });
        } else {
          await firestore.collection('User').doc(nick).set({
            'name': nick,
            'subname': nick,
            'email': email,
            'login_where': 'google_user',
            'time': DateTime.now(),
            'autologin': ischecked,
            'code': code
          }, SetOptions(merge: true)).whenComplete(() async {
            await Hive.box('user_setting').put('usercode', code);
          });
        }
      });
      await initScreen();
      GoToMain(context);
    }

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
