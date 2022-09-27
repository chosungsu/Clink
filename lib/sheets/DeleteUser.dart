import 'package:clickbyme/Tool/TextSize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Auth/GoogleSignInController.dart';
import '../LocalNotiPlatform/NotificationApi.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../UI/Sign/UserCheck.dart';

DeleteUserVerify(BuildContext context, String name) {
  bool isloading = false;
  String updateid = '';
  List changepeople = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());

  showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: ((context, setState) {
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
                        '아래 버튼을 클릭하시면 기존알람들은 모두 초기화되며 회원탈퇴처리가 완료됩니다. '
                        '더 좋은 서비스로 다음 기회에 찾아뵙겠습니다. '
                        '탈퇴처리가 완료되기 전까지 뒤로 가기 버튼을 누르지 말아주세요!',
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
                              if (isloading) {
                                return;
                              }
                              setState(() {
                                isloading = true;
                              });
                              Snack.show(
                                  title: '로딩중',
                                  snackType: SnackType.waiting,
                                  content: '회원탈퇴 중입니다.잠시만 기다려주세요',
                                  context: context);
                              await NotificationApi.cancelAll();
                              GoogleSignInController()
                                  .Deletelogout(context, name);
                              await firestore
                                  .collection('CalendarSheetHome')
                                  .get()
                                  .then((value) {
                                for (int i = 0; i < value.docs.length; i++) {
                                  for (int j = 0;
                                      j < value.docs[i].get('share').length;
                                      j++) {
                                    changepeople
                                        .add(value.docs[i].get('share')[j]);
                                  }
                                  if (changepeople
                                      .contains(cal_share_person.secondname)) {
                                    changepeople.removeWhere((element) =>
                                        element == cal_share_person.secondname);
                                    firestore
                                        .collection('CalendarSheetHome')
                                        .doc(value.docs[i].id)
                                        .update({'share': changepeople});
                                  }
                                  changepeople.clear();
                                }
                              });
                              await firestore
                                  .collection('PeopleList')
                                  .get()
                                  .then((value) {
                                for (int i = 0; i < value.docs.length; i++) {
                                  for (int j = 0;
                                      j < value.docs[i].get('friends').length;
                                      j++) {
                                    changepeople
                                        .add(value.docs[i].get('friends')[j]);
                                  }
                                  if (changepeople
                                      .contains(cal_share_person.secondname)) {
                                    changepeople.removeWhere((element) =>
                                        element == cal_share_person.secondname);
                                    firestore
                                        .collection('PeopleList')
                                        .doc(value.docs[i].id)
                                        .update({'friends': changepeople});
                                  }
                                  changepeople.clear();
                                }
                              });
                              await firestore
                                  .collection('MemoDataBase')
                                  .where('OriginalUser', isEqualTo: name)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  updateid = element.id;
                                  firestore
                                      .collection('MemoDataBase')
                                      .doc(updateid)
                                      .update({
                                    'alarmok': false,
                                    'alarmtime': '99:99'
                                  });
                                }
                              });
                              await firestore
                                  .collection('MemoAllAlarm')
                                  .doc(name)
                                  .delete();
                              setState(() {
                                isloading = false;
                              });
                              GoToLogin(
                                context,
                                'first',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amberAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2.0),
                            child: isloading
                                ?
                                // ignore: dead_code
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '잠시 기다려주세요...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: contentTextsize(),
                                          fontWeight: FontWeight.bold, // bold
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '탈퇴하기',
                                    style: TextStyle(
                                      color: Colors.white,
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
        }));
      });
}
