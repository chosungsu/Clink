// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:clickbyme/sheets/BottomSheet/AddContentWithBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../BACKENDPART/FIREBASE/NoticeVP.dart';
import '../../BACKENDPART/Enums/Variables.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../BACKENDPART/Getx/linkspacesetting.dart';
import '../../BACKENDPART/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());
final linkspaceset = Get.put(linkspacesetting());

Widgets_plusbtn(
    context, checkid, textcontroller, searchnode, where, id, categorypicknum) {
  Widget title;
  Widget content;
  Widget btn;
  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () {
          Get.back();
          title = Widgets_plusbtncontent1(
            context,
            textcontroller,
            searchnode,
            where,
            id,
            categorypicknum,
          )[0];
          content = Widgets_plusbtncontent1(
            context,
            textcontroller,
            searchnode,
            where,
            id,
            categorypicknum,
          )[1];
          btn = Widgets_plusbtncontent1(
            context,
            textcontroller,
            searchnode,
            where,
            id,
            categorypicknum,
          )[2];
          AddContentWithBtn(context, title, content, btn, searchnode);
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
          title = Widgets_plusbtncontent2(
              context, checkid, textcontroller, searchnode)[0];
          content = Widgets_plusbtncontent2(
              context, checkid, textcontroller, searchnode)[1];
          btn = Widgets_plusbtncontent2(
              context, checkid, textcontroller, searchnode)[2];
          AddContentWithBtn(context, title, content, btn, searchnode);
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

Widgets_plusbtncontent1(
  context,
  textcontroller,
  searchnode,
  where,
  id,
  categorypicknum,
) {
  Widget title;
  Widget content;
  Widget btn;

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('페이지 추가',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
  content = Column(
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: '추가할 페이지 제목 입력',
        textEditingControllerAddSheet: textcontroller,
      ),
    ],
  );
  btn = GetBuilder<uisetting>(
    builder: (controller) {
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
                  clickbtn1(
                      context, textcontroller, where, id, categorypicknum);
                },
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          linkspaceset.iscompleted == false ? '생성하기' : '처리중...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                          ),
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

Widgets_plusbtncontent2(
  context,
  checkid,
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
        children: [
          Text('박스 생성',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
  content = Column(
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: '추가할 박스 제목 입력',
        textEditingControllerAddSheet: textcontroller,
      ),
    ],
  );
  btn = GetBuilder<uisetting>(
    builder: (controller) {
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
                  clickbtn2(context, textcontroller, checkid);
                },
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          linkspaceset.iscompleted == false ? '생성하기' : '처리중...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: contentTextsize(),
                          ),
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

clickbtn1(context, textcontroller, where, id, categorynumber) {
  final updatelist = [];
  final initialtext = textcontroller.text;
  var updateid;
  int indexcnt = linkspaceset.indexcnt.length;

  if (textcontroller.text.isEmpty) {
    uiset.checktf(false);
  } else {
    uiset.setloading(true, 1);
    firestore.collection('Pinchannel').add({
      'username': usercode,
      'linkname': textcontroller.text,
      'setting': 'block',
      'email': useremail
    }).whenComplete(() {
      Snack.snackbars(
          context: context,
          title: '정상적으로 처리되었어요',
          backgroundcolor: Colors.green,
          bordercolor: draw.backgroundcolor);
      uiset.setloading(false, 1);
      linkspaceset.setspacelink(textcontroller.text);
      SaveNoti('page', textcontroller.text, '', add: true);
      Get.back();
      textcontroller.text = '';
    });
  }
}

clickbtn2(context, textcontroller, checkid) {
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
