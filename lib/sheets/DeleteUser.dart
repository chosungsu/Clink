import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Auth/GoogleSignInController.dart';
import '../Auth/KakaoSignInController.dart';

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width - 40) *
                                        0.2,
                                alignment: Alignment.topCenter,
                                color: Colors.black45),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '회원탈퇴',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: contentTitleTextsize(),
                        fontWeight: FontWeight.bold, // bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '회원탈퇴 진행하겠습니까? '
                      '아래 버튼을 클릭하시면 회원탈퇴처리가 완료됩니다. '
                      '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: contentTextsize(),
                        fontWeight: FontWeight.w600, // bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            Provider.of<GoogleSignInController>(context,
                                    listen: false)
                                .Deletelogout(context, name);
                            Provider.of<KakaoSignInController>(context,
                                    listen: false)
                                .Deletelogout(context, name);
                            GoToLogin(context, 'first');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 2.0),
                          child: Text(
                            '탈퇴하기',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: contentTextsize(),
                              fontWeight: FontWeight.bold, // bold
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )));
      });
}
