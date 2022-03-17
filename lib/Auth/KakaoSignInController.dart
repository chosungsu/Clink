import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kakao_flutter_sdk/all.dart';

class KakaoSignInController with ChangeNotifier {

  late int count;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  login(BuildContext context, bool ischecked) async {
    count = 2;
    //설치 여부 묻기
    final installed = await isKakaoTalkInstalled();
    installed ? await UserApi.instance.loginWithKakaoTalk() :
    await UserApi.instance.loginWithKakaoAccount();
    User user = await UserApi.instance.me();
    //내부 저장으로 로그인 정보 저장
    if (user.kakaoAccount != null) {
      if (user.kakaoAccount!.profile!.nickname != null) {
        String? nick = user.kakaoAccount!.profile!.nickname;
        String? email = user.kakaoAccount!.email;
        Hive.box('user_info').put('id', nick);
        Hive.box('user_info').put('email', email);
        Hive.box('user_info').put('count', count);
        Hive.box('user_info').put('autologin', ischecked);
        //firestore 저장
        await firestore.collection('User').doc(nick)
            .set({
          'name' : nick, 'email' : email, 'login_where' : 'kakao_user', 'time' : DateTime.now(), 'autologin' : ischecked
        });
      }
    }

    notifyListeners();
  }
  logout(BuildContext context, String name) async {
    count = -2;
    Hive.box('user_info').delete('id');
    await UserApi.instance.logout();
    //firestore 삭제
    await firestore.collection('User').doc(name)
        .delete();
    notifyListeners();
  }
}