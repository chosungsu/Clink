// ignore_for_file: non_constant_identifier_names

import 'package:clickbyme/BACKENDPART/Enums/Variables.dart';
import 'package:clickbyme/sheets/BottomSheet/AddContentWithBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Api/LoginApi.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../../BACKENDPART/LocalNotiPlatform/NotificationApi.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';
import '../../BACKENDPART/Getx/PeopleAdd.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());
final peopleadd = Get.put(PeopleAdd());

Widgets_settingpageiconclick(
  context,
  textcontroller,
  searchnode,
) {
  Widget title, title2, title3;
  Widget content, content2, content3;
  Widget btn2, btn3;

  title = const SizedBox();
  content = StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            uiset.checktf(true);
            title2 = Widgets_settingpagenickchange(
                context, textcontroller, searchnode)[0];
            content2 = Widgets_settingpagenickchange(
                context, textcontroller, searchnode)[1];
            btn2 = Widgets_settingpagenickchange(
                context, textcontroller, searchnode)[2];
            AddContentWithBtn(context, title2, content2, btn2, searchnode);
          },
          trailing: Icon(AntDesign.swap, color: Colors.grey.shade400),
          title: Text(
            '닉네임',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ListTile(
          onTap: () {},
          subtitle: SelectableText(usercode,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: contentsmallTextsize())),
          title: Text(
            '고유 코드',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
          thickness: 0.5,
          indent: 0,
          endIndent: 0,
        ),
        ListTile(
          onTap: () {
            Get.back();
            title3 = Widgets_settingpagedeleteuser(
                context, textcontroller, searchnode)[0];
            content3 = Widgets_settingpagedeleteuser(
                context, textcontroller, searchnode)[1];
            btn3 = Widgets_settingpagedeleteuser(
                context, textcontroller, searchnode)[2];
            AddContentWithBtn(context, title3, content3, btn3, searchnode);
          },
          trailing: Icon(Ionicons.chevron_forward, color: Colors.grey.shade400),
          title: Text(
            '회원탈퇴',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  });
  return [title, content];
}

Widgets_settingpagenickchange(
  context,
  textcontroller,
  searchnode,
) {
  Widget title;
  Widget content;
  Widget btn;
  bool _ischecked = false;

  title = SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                    text: Hive.box('user_info').get('id'),
                    style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                TextSpan(
                    text: '님의 닉네임 변경',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize()))
              ]))
        ],
      ));
  content = StatefulBuilder(builder: (_, StateSetter setState) {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize(),
              color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        ContainerTextFieldDesign(
          searchNodeAddSection: searchnode,
          string: '이곳에 작성',
          textEditingControllerAddSheet: textcontroller,
        ),
      ],
    ));
  });
  btn = GetBuilder<uisetting>(
    builder: (_) {
      return Column(
        children: [
          SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: ButtonColor(),
                ),
                onPressed: () async {
                  uiset.setloading(true);
                  if (textcontroller.text.isEmpty) {
                    uiset.checktf(false);
                    uiset.setloading(false);
                  } else {
                    uiset.checktf(true);
                    Hive.box('user_info').put('id', textcontroller.text);
                    uiset.setloading(false);
                    LoginApiProvider().updateTasks();
                    Get.back();
                    textcontroller.clear();
                  }
                },
                child: Center(
                  child: uiset.loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '생성중',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: contentTextsize(),
                                fontWeight: FontWeight.bold, // bold
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '변경',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize(),
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                )),
          ),
          uiset.isfilledtextfield == true
              ? const SizedBox()
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '입력란이 비어있어요!',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: contentsmallTextsize(),
                          color: Colors.red),
                      overflow: TextOverflow.fade,
                    )
                  ],
                )
        ],
      );
    },
  );
  return [title, content, btn];
}

Widgets_settingpagedeleteuser(
  context,
  textcontroller,
  searchnode,
) {
  Widget title;
  Widget content;
  Widget btn;
  String updateid = '';
  List changepeople = [];

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '회원탈퇴',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold, // bold
            ),
          )
        ],
      ));
  content = Column(
    children: [
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
      )
    ],
  );
  btn = SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          uiset.setloading(true);
          await NotificationApi.cancelAll();
          await firestore.collection('Calendar').get().then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              for (int j = 0; j < value.docs[i].get('share').length; j++) {
                changepeople.add(value.docs[i].get('share')[j]);
              }
              if (changepeople.contains(appnickname)) {
                changepeople.removeWhere((element) => element == appnickname);
                firestore
                    .collection('Calendar')
                    .doc(value.docs[i].id)
                    .update({'share': changepeople});
              }
              changepeople.clear();
            }
          });
          await firestore.collection('PeopleList').get().then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              for (int j = 0; j < value.docs[i].get('friends').length; j++) {
                changepeople.add(value.docs[i].get('friends')[j]);
              }
              if (changepeople.contains(appnickname)) {
                changepeople.removeWhere((element) => element == appnickname);
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
              .where('OriginalUser', isEqualTo: usercode)
              .get()
              .then((value) {
            for (var element in value.docs) {
              updateid = element.id;
              firestore
                  .collection('MemoDataBase')
                  .doc(updateid)
                  .update({'alarmok': false, 'alarmtime': '99:99'});
            }
          });
          await firestore.collection('MemoAllAlarm').doc(usercode).delete();
          uiset.setloading(false);
          GoToStartApp();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: uiset.loading
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
                    '탈퇴 처리중',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: contentTextsize(),
                      fontWeight: FontWeight.bold, // bold
                    ),
                  ),
                ],
              )
            : Text(
                '회원탈퇴',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: contentTextsize(),
                  fontWeight: FontWeight.bold, // bold
                ),
              ),
      ));
  return [title, content, btn];
}
