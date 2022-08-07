import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Auth/GoogleSignInController.dart';
import '../../Auth/KakaoSignInController.dart';

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 220,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 5,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 40) *
                                  0.4,
                            ),
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width - 40) *
                                        0.2,
                                alignment: Alignment.topCenter,
                                color: Colors.black45),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 40) *
                                  0.4,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '회원탈퇴',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '회원탈퇴 진행하겠습니까?\n'
                      '아래 버튼을 클릭하시면 회원탈퇴처리가 완료됩니다.\n'
                      '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w600, // bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: (MediaQuery.of(context).size.width - 40) * 0.8,
                        child: ElevatedButton(
                          onPressed: () async {
                            //탈퇴 로직 구현
                            /*Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const MyHomePage(title: 'HabitMind', index: 0,),
                  ),
                );*/
                            Provider.of<GoogleSignInController>(context,
                                    listen: false)
                                .logout(context, name);
                            Provider.of<KakaoSignInController>(context,
                                    listen: false)
                                .logout(context, name);
                            GoToLogin(context);
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600, // bold
                            ),
                          ),
                        ))
                  ],
                )));
      });
}
