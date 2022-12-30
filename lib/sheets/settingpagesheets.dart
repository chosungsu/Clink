// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import '../BACKENDPART/Auth/GoogleSignInController.dart';
import '../Enums/Variables.dart';
import '../LocalNotiPlatform/NotificationApi.dart';
import '../FRONTENDPART/Route/subuiroute.dart';
import '../Tool/BGColor.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/TextSize.dart';

setUsers(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: sheet1(context, node, controller, name),
              )),
        );
      }).whenComplete(() {});
}

sheet1(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title1(context),
              const SizedBox(
                height: 20,
              ),
              content1(context, node, controller, name),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title1(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('MY 정보',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content1(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  final peopleadd = Get.put(PeopleAdd());
  String usercode = Hive.box('user_setting').get('usercode');
  String subname = peopleadd.secondname;

  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('현재 닉네임',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(subname,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text('고유 코드',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
              const SizedBox(
                width: 10,
              ),
              SelectableText(usercode,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize())),
            ],
          ),
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
          thickness: 0.5,
          indent: 0,
          endIndent: 0,
        ),
        GestureDetector(
          onTap: () {
            Get.back();
            sheetmultiprofile(context, node, controller, name);
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.badge,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('닉네임 변경',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            GoogleSignInController()
                .logout(context, Hive.box('user_info').get('id'));
            GoToLogin('isnotfirst');
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.manage_accounts,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('다른 아이디 로그인',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            DeleteUserVerify(context, Hive.box('user_info').get('id'));
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 30,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('회원탈퇴',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    );
  });
}

DeleteUserVerify(BuildContext context, String name) {
  showModalBottomSheet(
      context: context,
      isDismissible: false,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: ((context, setState) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: sheet2(context),
          );
        }));
      });
}

sheet2(
  BuildContext context,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title2(),
              const SizedBox(
                height: 20,
              ),
              content2(),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title2() {
  return Text(
    '회원탈퇴',
    style: TextStyle(
      color: Colors.black,
      fontSize: contentTitleTextsize(),
      fontWeight: FontWeight.bold, // bold
    ),
  );
}

content2() {
  bool isloading = false;
  String updateid = '';
  List changepeople = [];
  final cal_share_person = Get.put(PeopleAdd());

  return StatefulBuilder(builder: ((context, setState) {
    return Column(
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
                Snack.snackbars(
                    context: context,
                    title: '회원탈퇴 중...',
                    backgroundcolor: Colors.red,
                    bordercolor: draw.backgroundcolor);
                await NotificationApi.cancelAll();
                GoogleSignInController().Deletelogout(context, name);
                await firestore.collection('Calendar').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    for (int j = 0;
                        j < value.docs[i].get('share').length;
                        j++) {
                      changepeople.add(value.docs[i].get('share')[j]);
                    }
                    if (changepeople.contains(cal_share_person.secondname)) {
                      changepeople.removeWhere(
                          (element) => element == cal_share_person.secondname);
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
                    for (int j = 0;
                        j < value.docs[i].get('friends').length;
                        j++) {
                      changepeople.add(value.docs[i].get('friends')[j]);
                    }
                    if (changepeople.contains(cal_share_person.secondname)) {
                      changepeople.removeWhere(
                          (element) => element == cal_share_person.secondname);
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
                await firestore
                    .collection('MemoAllAlarm')
                    .doc(usercode)
                    .delete();
                setState(() {
                  isloading = false;
                });
                GoToLogin(
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
      ],
    );
  }));
}

sheetmultiprofile(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: GestureDetector(
                    onTap: () {
                      node.unfocus();
                    },
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: sheet3(context, node, controller, name))),
              )),
        );
      }).whenComplete(() {
    controller.text = '';
  });
}

sheet3(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  return SizedBox(
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
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title3(context, name),
              const SizedBox(
                height: 20,
              ),
              content3(context, node, controller, name),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title3(BuildContext context, String name) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                    text: name,
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
}

content3(
  BuildContext context,
  FocusNode node,
  TextEditingController controller,
  String name,
) {
  bool _ischecked = false;
  bool isloading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cal_share_person = Get.put(PeopleAdd());
  List changepeople = [];
  var time, ok;
  String usercode = Hive.box('user_setting').get('usercode');

  return StatefulBuilder(builder: (_, StateSetter setState) {
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
          searchNodeAddSection: node,
          string: '다른 사용자에게 보일 이름 작성',
          textEditingControllerAddSheet: controller,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '초기 닉네임으로 변경',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize(),
                    color: Colors.black),
              ),
            ),
            Checkbox(
                value: _ischecked,
                onChanged: (value) {
                  setState(() {
                    _ischecked = value!;
                  });
                }),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: ButtonColor(),
              ),
              onPressed: () async {
                if (isloading) {
                  return;
                }
                setState(() {
                  isloading = true;
                });
                if (controller.text.isEmpty) {
                  if (_ischecked) {
                    /*await firestore
                        .collection('CalendarSheetHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarSheetHome_update')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('ShareHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          for (int k = 0; k < changepeople.length; k++) {
                            firestore
                                .collection('ShareHome_update')
                                .doc(value.docs[i].id.split('-')[0] +
                                    changepeople[k])
                                .set({
                              'share': changepeople,
                              'allowance_change_set':
                                  value.docs[i].get('allowance_change_set'),
                              'allowance_share':
                                  value.docs[i].get('allowance_share'),
                              'calname': value.docs[i].get('calname'),
                              'color': value.docs[i].get('color'),
                              'date': value.docs[i].get('date'),
                              'doc': value.docs[i].get('doc'),
                              'madeUser': usercode,
                              'showingUser': changepeople[k],
                              'themesetting': value.docs[i].get('themesetting'),
                              'type': value.docs[i].get('type'),
                              'viewsetting': value.docs[i].get('viewsetting'),
                            });
                          }

                          firestore
                              .collection('ShareHome_update')
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
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });*/
                    await firestore
                        .collection('User')
                        .doc(name)
                        .get()
                        .then((value) {
                      cal_share_person.secondnameset(name, value.get('code'));
                    });

                    setState(() {
                      isloading = false;
                    });
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      isloading = false;
                    });
                    Snack.snackbars(
                        context: context,
                        title: '변경할 닉네임 작성해주세요',
                        backgroundcolor: Colors.red,
                        bordercolor: draw.backgroundcolor);
                  }
                } else {
                  if (_ischecked) {
                    /*await firestore
                        .collection('CalendarSheetHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));

                          firestore
                              .collection('CalendarSheetHome_update')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('ShareHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          for (int k = 0; k < changepeople.length; k++) {
                            firestore
                                .collection('ShareHome_update')
                                .doc(value.docs[i].id.split('-')[0] +
                                    changepeople[k])
                                .set({
                              'share': changepeople,
                              'allowance_change_set':
                                  value.docs[i].get('allowance_change_set'),
                              'allowance_share':
                                  value.docs[i].get('allowance_share'),
                              'calname': value.docs[i].get('calname'),
                              'color': value.docs[i].get('color'),
                              'date': value.docs[i].get('date'),
                              'doc': value.docs[i].get('doc'),
                              'madeUser': usercode,
                              'showingUser': changepeople[k],
                              'themesetting': value.docs[i].get('themesetting'),
                              'type': value.docs[i].get('type'),
                              'viewsetting': value.docs[i].get('viewsetting'),
                            });
                          }
                          firestore
                              .collection('ShareHome_update')
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
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(Hive.box('user_info').get('id'));
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });*/
                    await firestore
                        .collection('User')
                        .doc(name)
                        .get()
                        .then((value) {
                      cal_share_person.secondnameset(name, value.get('code'));
                    });
                  } else {
                    /*await firestore
                        .collection('CalendarSheetHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('CalendarSheetHome_update')
                              .doc(value.docs[i].id)
                              .update({'share': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('CalendarDataBase')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('Shares').length;
                            j++) {
                          changepeople.add(value.docs[i].get('Shares')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('CalendarDataBase')
                              .doc(value.docs[i].id)
                              .update({'Shares': changepeople});
                        }
                        changepeople.clear();
                      }
                    });
                    await firestore
                        .collection('ShareHome_update')
                        .get()
                        .then((value) {
                      for (int i = 0; i < value.docs.length; i++) {
                        for (int j = 0;
                            j < value.docs[i].get('share').length;
                            j++) {
                          changepeople.add(value.docs[i].get('share')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('ShareHome_update')
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
                          changepeople.add(value.docs[i].get('friends')[j]);
                        }
                        if (changepeople
                            .contains(cal_share_person.secondname)) {
                          changepeople.removeWhere((element) =>
                              element == cal_share_person.secondname);
                          changepeople.add(controller.text);
                          firestore
                              .collection('PeopleList')
                              .doc(value.docs[i].id)
                              .update({'friends': changepeople});
                        }
                        changepeople.clear();
                      }
                    });*/
                    await firestore
                        .collection('User')
                        .doc(name)
                        .get()
                        .then((value) {
                      cal_share_person.secondnameset(
                          controller.text, value.get('code'));
                    });
                  }

                  setState(() {
                    isloading = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: isloading
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
                            '생성중...',
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
                            child: NeumorphicText(
                              '닉네임 변경',
                              style: const NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: Colors.white,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                              ),
                            ),
                          ),
                        ],
                      ),
              )),
        ),
      ],
    ));
  });
}

showreadycontent(
  BuildContext context,
) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? Get.width
            : Get.width / 2,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(
              left: 10, right: 10, bottom: kBottomNavigationBarHeight),
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: sheet4(
                  context,
                ),
              )),
        );
      }).whenComplete(() {});
}

sheet4(
  BuildContext context,
) {
  return SizedBox(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? (MediaQuery.of(context).size.width - 40) * 0.2
                              : (Get.width / 2 - 40) * 0.2,
                          alignment: Alignment.topCenter,
                          color: Colors.black45),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              title4(context),
              const SizedBox(
                height: 20,
              ),
              content4(
                context,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )));
}

title4(
  BuildContext context,
) {
  return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('도움&문의',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
}

content4(
  BuildContext context,
) {
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/instagram.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('광고 및 개발문의',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize())),
                Text('DM : @dev_habittracker_official',
                    style:
                        TextStyle(color: Colors.grey.shade400, fontSize: 15)),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
            String body = await _getEmailBody();
            final Email email = Email(
              body: body,
              subject: '[오류 및 건의사항]',
              recipients: ['ski06043@gmail.com'],
              cc: [],
              bcc: [],
              attachmentPaths: [],
              isHTML: false,
            );

            await FlutterEmailSender.send(email);
          },
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Icon(
                        Icons.forward_to_inbox,
                        size: 30,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('오류 및 건의사항',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTitleTextsize())),
                          Text('개발자에게 이메일보내기',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15)),
                        ],
                      ),
                    ],
                  )),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    );
  });
}

Future<String> _getEmailBody() async {
  Map<String, dynamic> userInfo = _getUserInfo();
  Map<String, dynamic> appInfo = await _getAppInfo();
  Map<String, dynamic> deviceInfo = await _getDeviceInfo();

  String body = "";

  body += "==============\n";
  body += "아래는 문의하시는 사용자 정보로, 참고용입니다.\n\n";

  userInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  appInfo.forEach((key, value) {
    body += "$key: $value\n";
  });

  deviceInfo.forEach((key, value) {
    body += "$key: $value\n\n";
  });

  body += "==============\n\n";
  body += "아래에 오류 및 건의사항을 적어주시면 됩니다.문의하신 내용은 업데이트에 최대한 반영해보도록 하겠습니다.감사합니다!\n\n";
  body += "==============\n\n";
  return body;
}

Map<String, dynamic> _getUserInfo() {
  String name = Hive.box('user_info').get('id');
  String email = Hive.box('user_info').get('email');
  return {"사용자 이름": name, "사용자 이메일": email};
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (GetPlatform.isAndroid == true) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (GetPlatform.isIOS == true) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS 버전": "$systemName $version", "기기": "$machine"};
}

Future<Map<String, dynamic>> _getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {"앱 버전": info.version};
}
