// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:clickbyme/sheets/BottomSheet/AddContentWithBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Enums/Variables.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../../Tool/Getx/uisetting.dart';
import '../../Tool/TextSize.dart';

final uiset = Get.put(uisetting());

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
          Text(
              where == 'editnametemplate' || where == 'editnametemplatein'
                  ? '이름 변경'
                  : '페이지 추가',
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
        string: where == 'editnametemplate' || where == 'editnametemplatein'
            ? '변경할 스페이스 이름 입력'
            : '추가할 페이지 제목 입력',
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
    uiset.setloading(true);
    if (where == 'editnametemplate') {
      firestore.collection('PageView').get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i].get('id') == id &&
              value.docs[i].get('type') == categorynumber &&
              value.docs[i].get('spacename') == initialtext) {
            updateid = value.docs[i].id;
          }
        }
        firestore
            .collection('PageView')
            .doc(updateid)
            .update({'spacename': textcontroller.text}).whenComplete(() {
          Snack.snackbars(
              context: context,
              title: '정상적으로 처리되었어요',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          uiset.setloading(false);
          linkspaceset.setspacelink(textcontroller.text);
          Get.back(result: true);
        });
      });
    } else if (where == 'editnametemplatein') {
      var parentid;
      firestore.collection('Pinchannelin').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (int j = 0; j < value.docs.length; j++) {
            final messageuniquecode = value.docs[j]['uniquecode'];
            final messageindex = value.docs[j]['index'];
            if (messageindex == categorynumber && messageuniquecode == id) {
              parentid = value.docs[j].id;
              firestore
                  .collection('Pinchannelin')
                  .doc(value.docs[j].id)
                  .update({'addname': textcontroller.text});
            }
          }
        } else {}
      }).whenComplete(() {
        firestore.collection('Calendar').get().then((value) {
          if (value.docs.isNotEmpty) {
            for (int j = 0; j < value.docs.length; j++) {
              final messageuniquecode = value.docs[j]['parentid'];
              if (messageuniquecode == parentid) {
                firestore
                    .collection('Calendar')
                    .doc(value.docs[j].id)
                    .update({'calname': textcontroller.text});
              }
            }
          } else {}
        }).whenComplete(() {
          Snack.snackbars(
              context: context,
              title: '정상적으로 처리되었어요',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          uiset.setloading(false);
          linkspaceset.setspacelink(textcontroller.text);
          Get.back(result: true);
        });
      });
    } else {
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
        uiset.setloading(false);
        linkspaceset.setspacelink(textcontroller.text);
        Get.back(result: true);
      });
    }
  }
}

clickbtn2(context, textcontroller, checkid) {
  int indexcnt = linkspaceset.indexcnt.length;
  if (textcontroller.text == '') {
    uiset.checktf(false);
  } else {
    uiset.setloading(true);
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
      uiset.setloading(false);
      linkspaceset.setspacelink(textcontroller.text);
      Get.back();
    });
  }
}
