import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  final storage = const FlutterSecureStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late int count;

  login(BuildContext context) async {
    count = 1;
    googleSignInAccount = await _googleSignIn.signIn();
    String nick = googleSignInAccount!.displayName.toString();
    String email = googleSignInAccount!.email.toString();
    //내부 저장으로 로그인 정보 저장
    await storage.write(
        key: "google_login",
        value: "id/" +
            nick +
            "/" +
            "email/" +
            email +
            "/" +
            "count/" +
            count.toString()
    );
    //firestore 저장
    await firestore.collection('User').doc(nick)
        .set({
      'name' : nick, 'email' : email, 'login_where' : 'google_user', 'time' : DateTime.now(),
    });

    notifyListeners();
  }
  logout(BuildContext context, String name) async {
    count = -1;
    googleSignInAccount = await _googleSignIn.signOut();
    await storage.deleteAll();
    //firestore 삭제
    await firestore.collection('User').doc(name)
        .delete();
    notifyListeners();
  }
}