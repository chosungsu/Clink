// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:clickbyme/sheets/BottomSheet/AddContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../BACKENDPART/Api/LoginApi.dart';
import '../../BACKENDPART/Api/PageApi.dart';
import '../../BACKENDPART/Enums/Linkpage.dart';
import '../../BACKENDPART/Getx/UserInfo.dart';
import '../../BACKENDPART/ViewPoints/NoticeVP.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';
import '../../Tool/pickimage.dart';

plusBtn(context, textcontroller, searchnode) {
  Widget title;
  Widget content;
  title = Contents_plusbtn(context, textcontroller, searchnode)[0];
  content = Contents_plusbtn(context, textcontroller, searchnode)[1];
  AddContent(context, title, content, searchnode);
}

Contents_plusbtn(context, textcontroller, searchnode) {
  Widget title;
  Widget content;
  Widget btn;
  final uiset = Get.put(uisetting());

  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () {
          Get.back();
          uiset.setpageindex(1);
          uiset.addpagecontroll = 0;
        },
        trailing: const Icon(
          Ionicons.create_outline,
          color: Colors.black,
        ),
        title: Text(
          '페이지 생성',
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
        onTap: () {
          Get.back();
          uiset.setpageindex(1);
          uiset.addpagecontroll = 1;
        },
        trailing: const Icon(
          Feather.box,
          color: Colors.black,
        ),
        title: Text(
          '박스 생성',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
  return [title, content];
}

Widgets_pagethumnail(context) {
  Widget title, content, btn;

  title = const SizedBox();
  content = Column(
    children: [
      GestureDetector(
          onTap: () async {
            Get.back();
            await pickImage(ImageSource.camera);
          },
          child: ListTile(
            leading: const Icon(
              Ionicons.camera,
              size: 30,
              color: Colors.black,
            ),
            title: Text('사진촬영',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            trailing: const Icon(
              Ionicons.chevron_forward,
              size: 30,
              color: Colors.black,
            ),
          )),
      GestureDetector(
          onTap: () async {
            Get.back();
            await pickImage(ImageSource.gallery);
          },
          child: ListTile(
            leading: const Icon(
              MaterialIcons.photo,
              size: 30,
              color: Colors.black,
            ),
            title: Text('갤러리 이동',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            trailing: const Icon(
              Ionicons.chevron_forward,
              size: 30,
              color: Colors.black,
            ),
          )),
      GestureDetector(
          onTap: () async {
            Get.back();
            final reloadpage = await Get.dialog(OSDialogforth(
                    context,
                    '알림',
                    SingleChildScrollView(
                      child: Text('정말 이미지를 삭제하시겠습니까?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: Colors.red)),
                    ),
                    GetBackWithTrue)) ??
                false;
            if (reloadpage) {
              peopleadd.setusrimg('');
              LoginApiProvider().updateTasks('img', peopleadd.usrimgurl);
              Get.back();
            } else {
              Get.back();
            }
          },
          child: ListTile(
            leading: const Icon(
              MaterialCommunityIcons.delete_alert,
              size: 30,
              color: Colors.red,
            ),
            title: Text('이미지 삭제',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: contentTitleTextsize())),
            trailing: const Icon(
              Ionicons.chevron_forward,
              size: 30,
              color: Colors.black,
            ),
          )),
    ],
  );
  return [title, content];
}

clickbtn1(context, textcontroller) {
  final uiset = Get.put(uisetting());
  final peopleadd = Get.put(UserInfo());
  final linkspaceset = Get.put(linkspacesetting());

  if (textcontroller.text.isEmpty) {
    uiset.checktf(false);
  } else {
    uiset.setloading(true, 1);
    linkspaceset.addlist.clear();
    linkspaceset.setaddlist(MainPageLinkList(
        title: textcontroller.text.toString(),
        isavailableshow: 'no',
        owner: peopleadd.usrcode,
        url: 'http://gox.co.kr',
        date: DateTime.now().toString(),
        image: ''));
    PageApiProvider().createTasks();
    Snack.snackbars(
        context: context,
        title: '정상적으로 처리되었어요',
        backgroundcolor: Colors.green,
        bordercolor: draw.backgroundcolor);
    uiset.setloading(false, 1);
    Get.back();
    textcontroller.text = '';
  }
}

clickbtn2(context, textcontroller) {
  final uiset = Get.put(uisetting());
  final linkspaceset = Get.put(linkspacesetting());
  int indexcnt = linkspaceset.indexcnt.length;
  if (textcontroller.text == '') {
    uiset.checktf(false);
  } else {
    uiset.setloading(true, 1);
    firestore.collection('PageView').add({
      'id': checkid,
      'spacename': textcontroller.text,
      'pagename': uiset.pagelist[uiset.mypagelistindex].title,
      'type': 0,
      'index': indexcnt + 1,
      'canshow': '나 혼자만',
    }).whenComplete(() {
      Snack.snackbars(
          context: context,
          title: '정상적으로 처리되었어요',
          backgroundcolor: Colors.green,
          bordercolor: draw.backgroundcolor);
      uiset.setloading(false, 1);
      linkspaceset.setspacelink(textcontroller.text);
      SaveNoti('box', uiset.pagelist[uiset.mypagelistindex].title,
          textcontroller.text,
          add: true);
      Get.back();
      textcontroller.text = '';
    });
  }
}
