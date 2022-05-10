import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';
import '../route.dart';

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(children: [
            const Text(
              '회원탈퇴',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 22,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '회원탈퇴 진행하겠습니까?\n'
              '아래 버튼을 클릭하시면 회원탈퇴처리가 완료됩니다.\n'
              '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600, // bold
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //탈퇴 로직 구현
                /*Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const MyHomePage(title: 'HabitMind', index: 0,),
                  ),
                );*/
                GoToLogin2(context);
                Provider.of<GoogleSignInController>(context, listen: false)
                    .logout(context, name);
                Provider.of<KakaoSignInController>(context, listen: false)
                    .logout(context, name);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0),
              child: const Text(
                '탈퇴하기',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // bold
                ),
              ),
            ),
          ]),
        );
      });
}
