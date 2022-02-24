import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/all.dart';

class KakaoSignInController with ChangeNotifier {

  final storage = const FlutterSecureStorage();
  late int count;
  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  login(BuildContext context) async {
    count = 2;
    //설치 여부 묻기
    final installed = await isKakaoTalkInstalled();
    installed ? await UserApi.instance.loginWithKakaoTalk() :
    await UserApi.instance.loginWithKakaoAccount();
    //String authcode = await AuthCodeClient.instance.request();
    //await AuthApi.instance.issueAccessToken(authcode);
    User user = await UserApi.instance.me();
    //내부 저장으로 로그인 정보 저장
    if (user.kakaoAccount != null) {
      if (user.kakaoAccount!.profile!.nickname != null) {
        String? nick = user.kakaoAccount!.profile!.nickname;
        String? email = user.kakaoAccount!.email;
        await storage.write(
            key: "kakao_login",
            value: "id/" +
                nick! +
                "/" +
                "email/" +
                email! +
                "/" +
                "count/" +
                count.toString()
        );
        //firestore 저장
        /*await firestore.collection('User').doc('유저_login_data')
            .set({
          'name' : nick, 'email' : email, 'time' : DateTime.now(),
        });*/
      }
    }

    notifyListeners();
  }
  logout(BuildContext context) async {
    count = -2;
    await storage.deleteAll();
    await UserApi.instance.logout();
    notifyListeners();
  }
}