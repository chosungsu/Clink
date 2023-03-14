// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../sheets/BottomSheet/AddContentWithBtn.dart';
import '../Enums/Expandable.dart';
import '../Enums/Variables.dart';
import '../../Tool/FlushbarStyle.dart';
import '../Getx/PeopleAdd.dart';
import '../Getx/uisetting.dart';
import '../../Tool/TextSize.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../BACKENDPART/Api/LoginApi.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../../BACKENDPART/LocalNotiPlatform/NotificationApi.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';

final peopleadd = Get.put(PeopleAdd());
final uiset = Get.put(uisetting());

Settingtestpage() {}

Settinglicensepage() {
  firestore.collection("AppLicense").doc('License').get().then((value) {
    for (int i = 0; i < value.get('licensetitle').length; i++) {
      uiset.setlicense(value.get('licensetitle')[i], value.get('content')[i]);
      licensedata.insert(
          0,
          Expandable(
              title: value.get('licensetitle')[i],
              sub: value.get('content')[i],
              isExpanded: false));
    }
  });
}

Widgets_personchange(context, controller, searchnode) {
  Widget title, content, btn;
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());

  title = const SizedBox();
  content = Column(
    children: [
      GestureDetector(
          onTap: () async {
            Get.back();
            Clipboard.setData(ClipboardData(text: usercode)).whenComplete(() {
              Snack.snackbars(
                  context: context,
                  title: '클립보드에 복사되었습니다.',
                  backgroundcolor: Colors.green,
                  bordercolor: draw.backgroundcolor);
            });
          },
          child: ListTile(
            leading: const Icon(
              MaterialIcons.fiber_pin,
              size: 30,
              color: Colors.blue,
            ),
            title: Text('고유코드',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            subtitle: SelectableText(usercode,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize())),
            trailing: Icon(Ionicons.copy_outline,
                size: 30, color: Colors.blue.shade400),
          )),
      GestureDetector(
          onTap: () async {
            Get.back();
            uiset.checktf(true);
            title = Widgets_settingpagenickchange(
                context, controller, searchnode)[0];
            content = Widgets_settingpagenickchange(
                context, controller, searchnode)[1];
            btn = Widgets_settingpagenickchange(
                context, controller, searchnode)[2];
            AddContentWithBtn(context, title, content, btn, searchnode);
          },
          child: ListTile(
            leading: const Icon(
              MaterialCommunityIcons.rename_box,
              size: 30,
              color: Colors.blue,
            ),
            title: Text('닉네임 변경',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            trailing: Icon(
              MaterialIcons.chevron_right,
              size: 30,
              color: draw.color_textstatus,
            ),
          )),
    ],
  );
  return [title, content];
}

Widgets_tocompany(context, controller, searchnode) {
  Widget title;
  Widget content;
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());

  title = const SizedBox();
  content = Column(
    children: [
      GestureDetector(
        onTap: () async {
          Get.back();
          Clipboard.setData(
                  const ClipboardData(text: 'dev_habittracker_official'))
              .whenComplete(() {
            Snack.snackbars(
                context: context,
                title: '클립보드에 복사되었습니다.',
                backgroundcolor: Colors.green,
                bordercolor: draw.backgroundcolor);
          });
        },
        child: Row(
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: Row(
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
                        Text('광고문의',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                        Text(
                          '@dev_habittracker_official',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                )),
            Icon(Ionicons.copy_outline, color: Colors.blue.shade400)
          ],
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      GestureDetector(
        onTap: () async {
          Get.back();
          Clipboard.setData(const ClipboardData(text: 'lenbizco@gmail.com'))
              .whenComplete(() {
            Snack.snackbars(
                context: context,
                title: '클립보드에 복사되었습니다.',
                backgroundcolor: Colors.green,
                bordercolor: draw.backgroundcolor);
          });
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
                        Text('오류신고',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize())),
                        Text(
                          'lenbizco@gmail.com',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                )),
            Icon(Ionicons.copy_outline, color: Colors.blue.shade400)
          ],
        ),
      )
    ],
  );
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
                  uiset.setloading(true, 1);
                  if (textcontroller.text.isEmpty) {
                    uiset.checktf(false);
                    uiset.setloading(false, 1);
                  } else {
                    var returndata = await LoginApiProvider().getTasks();
                    if (returndata.toString().contains(textcontroller.text)) {
                      uiset.checktf(true);
                      uiset.changeavailable(false);
                    } else {
                      uiset.checktf(true);
                      uiset.changeavailable(true);
                      Hive.box('user_info').put('id', textcontroller.text);
                      LoginApiProvider().updateTasks();
                      Get.back();
                      textcontroller.clear();
                    }
                    uiset.setloading(false, 1);
                  }
                },
                child: Center(
                  child: uiset.sheetloading
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
              ? (uiset.canchange == true
                  ? const SizedBox()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '해당 닉네임은 이미 사용중입니다.',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: contentsmallTextsize(),
                              color: Colors.red),
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ))
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

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '앱 내 데이터 삭제',
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
        '데이터 삭제를 진행하겠습니까? '
        '아래 버튼을 클릭하시면 기존알람들은 모두 초기화되며 삭제처리가 완료됩니다. '
        '처리가 완료되기 전까지 뒤로 가기 버튼을 누르지 말아주세요!',
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
          uiset.setloading(true, 1);
          await LoginApiProvider().deleteTasks();
          await NotificationApi.cancelAll();
          uiset.setloading(false, 1);
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
                    '처리중',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: contentTextsize(),
                      fontWeight: FontWeight.bold, // bold
                    ),
                  ),
                ],
              )
            : Text(
                '삭제',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: contentTextsize(),
                  fontWeight: FontWeight.bold, // bold
                ),
              ),
      ));
  return [title, content, btn];
}
/*Widgets_addpeople(context, controller, searchnode) {
  Widget title;
  Widget content;
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(PeopleAdd());

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('피플',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ],
      ));
  content = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      usersearch(
        context,
        controller,
        searchnode,
      )
    ],
  );
  return [title, content];
}

Search(
  context,
  searchnode,
  controller,
  searchlist_user,
  list_sp,
) {
  int cnt = 0;
  List changepeople = [];

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: '친구의 고유코드로 검색',
        textEditingControllerAddSheet: controller,
      ),
      const SizedBox(
        height: 20,
      ),
      searchlist_user.isNotEmpty
          ? SizedBox(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: searchlist_user.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? Get.width - 60
                                        : (GetPlatform.isWeb
                                            ? Get.width / 3 - 60
                                            : Get.width / 2 - 60),
                                    child: ListTile(
                                      onTap: () {
                                        if (!list_sp
                                            .contains(searchlist_user[index])) {
                                          list_sp.add(searchlist_user[index]);
                                          Get.back();
                                          Snack.snackbars(
                                              context: context,
                                              title: '정상적으로 추가되었습니다',
                                              backgroundcolor: Colors.green,
                                              bordercolor:
                                                  draw.backgroundcolor);
                                        } else {
                                          list_sp
                                              .remove(searchlist_user[index]);
                                          firestore
                                              .collection('PeopleList')
                                              .doc(usercode)
                                              .delete();
                                          Get.back();
                                          Snack.snackbars(
                                              context: context,
                                              title: '정상적으로 삭제되었습니다',
                                              backgroundcolor: Colors.green,
                                              bordercolor:
                                                  draw.backgroundcolor);
                                        }
                                        firestore
                                            .collection('PeopleList')
                                            .doc(usercode)
                                            .set({'friends': list_sp},
                                                SetOptions(merge: true));
                                      },
                                      trailing: list_sp
                                              .contains(searchlist_user[index])
                                          ? const Icon(
                                              Icons.remove,
                                              size: 20,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                      title: list_sp
                                              .contains(searchlist_user[index])
                                          ? Text(
                                              searchlist_user[index] +
                                                  '는 이미 추가된 이름입니다.',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.visible,
                                            )
                                          : Text(
                                              searchlist_user[index] +
                                                  '(이)가 맞습니까?',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize()),
                                              overflow: TextOverflow.visible,
                                            ),
                                    ),
                                  )
                                ],
                              ));
                        }),
                  )
                ],
              ))
          : SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '검색 결과가 없습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: contentTextsize(),
                        color: TextColor_shadowcolor()),
                  ),
                ],
              ),
            )
    ],
  );
}

usersearch(
  context,
  controller,
  searchnode,
) {
  String addwhat = '';
  List<String> searchlist_user = [];
  List<String> list_sp = [];
  firestore.collection('PeopleList').doc(usercode).get().then((value) {
    for (int i = 0; i < value.get('friends').length; i++) {
      list_sp.add(value.get('friends')[i]);
    }
  });
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return FutureBuilder(
        future: firestore
            .collection("User")
            .where('code',
                isEqualTo:
                    controller.text.isEmpty ? '' : 'User#' + controller.text)
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  setState(() {
                    searchlist_user.clear();
                    for (var doc in querySnapshot.docs) {
                      doc.get('nick') != null
                          ? searchlist_user.add(doc.get('nick'))
                          : searchlist_user.clear();
                    }
                    /*controller.text.isEmpty
                        ? addwhat = 'nothing'
                        : addwhat = controller.text.toString();
                    Hive.box('user_setting').put('user_people', addwhat);*/
                  })
                })),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          } else {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          }
        });
  });
}

getsearchuser(
  context,
  controller,
  searchnode,
) {
  String addwhat = '';
  List<String> searchlist_user = [];
  List<String> list_sp = [];
  firestore.collection('PeopleList').doc(usercode).get().then((value) {
    for (int i = 0; i < value.get('friends').length; i++) {
      list_sp.add(value.get('friends')[i]);
    }
  });
  return StatefulBuilder(builder: (_, StateSetter setState) {
    return FutureBuilder(
        future: firestore
            .collection("User")
            .where('code',
                isEqualTo:
                    controller.text.isEmpty ? '' : 'User#' + controller.text)
            .get()
            .then(((QuerySnapshot querySnapshot) => {
                  setState(() {
                    searchlist_user.clear();
                    for (var doc in querySnapshot.docs) {
                      doc.get('nick') != null
                          ? searchlist_user.add(doc.get('nick'))
                          : searchlist_user.clear();
                    }
                    /*controller.text.isEmpty
                        ? addwhat = 'nothing'
                        : addwhat = controller.text.toString();
                    Hive.box('user_setting').put('user_people', addwhat);*/
                  })
                })),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          } else {
            return Search(
                context, searchnode, controller, searchlist_user, list_sp);
          }
        });
  });
}*/
