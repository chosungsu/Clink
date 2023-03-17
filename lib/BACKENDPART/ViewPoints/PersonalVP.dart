// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:clickbyme/BACKENDPART/ViewPoints/NoticeVP.dart';
import 'package:clickbyme/BACKENDPART/Enums/Radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../Enums/Linkpage.dart';
import '../Enums/PageList.dart';
import '../Enums/Variables.dart';
import '../../FRONTENDPART/Page/Spacein.dart';
import '../../FRONTENDPART/Route/subuiroute.dart';
import '../../Tool/AndroidIOS.dart';
import '../../Tool/BGColor.dart';
import '../../Tool/ContainerDesign.dart';
import '../../Tool/FlushbarStyle.dart';
import '../Getx/calendarsetting.dart';
import '../Getx/category.dart';
import '../Getx/linkspacesetting.dart';
import '../Getx/uisetting.dart';
import '../../FRONTENDPART/UI/DayNoteHome.dart';
import '../../Tool/TextSize.dart';
import '../../sheets/BottomSheet/AddContent.dart';
import '../../sheets/BottomSheet/AddContentWithBtn.dart';

///Getx 호출
final linkspaceset = Get.put(linkspacesetting());
final controll_cals = Get.put(calendarsetting());
final uiset = Get.put(uisetting());
final cg = Get.put(category());

///이 아래는 StreamBuilder기반 코드 작성
PageViewStreamParent1() {
  return firestore.collection('PageView').snapshots();
}

PageViewRes1_1(id, snapshot) {
  linkspaceset.indextreetmp.clear();
  linkspaceset.indexcnt.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    if (sp.get('id') == id) {
      linkspaceset.indextreetmp.add(List.empty(growable: true));
      linkspaceset.indexcnt.add(Linkspacepage(
        type: sp.get('type'),
        placestr: sp.get('spacename'),
        uniquecode: sp.get('id'),
        index: sp.get('index'),
        familycode: sp.id,
        canshow: sp.get('canshow'),
      ));
    }
  }
  linkspaceset.indexcnt.sort(((a, b) {
    return a.index.compareTo(b.index);
  }));
}

PageViewRes1_2(
  id,
  changeset,
) async {
  var insertlist;
  int changei = 0;
  String docid = '';
  uiset.setloading(true, 0);
  await firestore
      .collection('PageView')
      .doc(id)
      .update({'canshow': changeset}).whenComplete(() {
    uiset.setloading(false, 0);
  });
}

pageaddlogic(context, id, index) async {
  final List<Linkspacepage> listspacepageset = [];
  return await firestore.collection('Pinchannel').doc(id).get().then(
    (value) async {
      if (value.get('username') == usercode) {
        await firestore.collection('Pinchannelin').add({
          'addname': '빈 제목',
          'placestr': linkspaceset.indexcnt[index].placestr,
          'index': linkspaceset.indextreetmp[index].length,
          'uniquecode': linkspaceset.indexcnt[index].familycode,
          'type': linkspaceset.indexcnt[index].type,
          'spaceentercontent': linkspaceset.indexcnt[index].type == 1 ? '' : []
        }).whenComplete(() async {
          Snack.snackbars(
              context: context,
              title: '성공적으로 추가되었습니다',
              backgroundcolor: Colors.green,
              bordercolor: draw.backgroundcolor);
          SaveNoti('box', linkspaceset.indexcnt[index].placestr, '', add: true);
        });
        linkspaceset.setspacetreein(Linkspacetreepage(
            subindex: index,
            placestr: '빈 제목',
            uniqueid: linkspaceset.indexcnt[index].familycode));
      } else {
        if (value.get('setting') == 'block') {
          Snack.snackbars(
              context: context,
              title: '접근권한이 없어요!',
              backgroundcolor: Colors.red,
              bordercolor: draw.backgroundcolor);
        } else {
          await firestore.collection('Pinchannelin').add({
            'addname': '빈 제목',
            'placestr': linkspaceset.indexcnt[index].placestr,
            'index': linkspaceset.indextreetmp[index].length,
            'uniquecode': linkspaceset.indexcnt[index].familycode,
            'type': linkspaceset.indexcnt[index].type,
            'spaceentercontent':
                linkspaceset.indexcnt[index].type == 1 ? '' : []
          }).whenComplete(() async {
            SaveNoti('box', linkspaceset.indexcnt[index].placestr, '',
                add: true);
            Snack.snackbars(
                context: context,
                title: '성공적으로 추가되었습니다',
                backgroundcolor: Colors.green,
                bordercolor: draw.backgroundcolor);
          });
          linkspaceset.setspacetreein(Linkspacetreepage(
              subindex: index,
              placestr: '빈 제목',
              uniqueid: linkspaceset.indexcnt[index].familycode));
        }
      }
      Get.back();
    },
  );
}

pageeditlogic(context, id, index, controller, searchNode) async {
  Widget title;
  Widget content;
  await firestore.collection('Pinchannel').doc(id).get().then(
    (value) {
      if (value.get('username') == usercode) {
        title = Widgets_horizontalbtn(
          context,
          linkspaceset.indexcnt[index].uniquecode,
          index,
          linkspaceset.indexcnt[index].placestr,
          linkspaceset.indexcnt[index].familycode,
          linkspaceset.indexcnt[index].type,
          linkspaceset.indexcnt[index].canshow,
          controller,
          searchNode,
          'pinchannel',
        )[0];
        content = Widgets_horizontalbtn(
          context,
          linkspaceset.indexcnt[index].uniquecode,
          index,
          linkspaceset.indexcnt[index].placestr,
          linkspaceset.indexcnt[index].familycode,
          linkspaceset.indexcnt[index].type,
          linkspaceset.indexcnt[index].canshow,
          controller,
          searchNode,
          'pinchannel',
        )[1];
        AddContent(context, title, content, searchNode);
      } else {
        if (value.get('setting') == 'block') {
          Snack.snackbars(
              context: context,
              title: '접근권한이 없어요!',
              backgroundcolor: Colors.red,
              bordercolor: draw.backgroundcolor);
        } else {
          title = Widgets_horizontalbtn(
            context,
            linkspaceset.indexcnt[index].uniquecode,
            index,
            linkspaceset.indexcnt[index].placestr,
            linkspaceset.indexcnt[index].familycode,
            linkspaceset.indexcnt[index].type,
            linkspaceset.indexcnt[index].canshow,
            controller,
            searchNode,
            'pinchannel',
          )[0];
          content = Widgets_horizontalbtn(
              context,
              linkspaceset.indexcnt[index].uniquecode,
              index,
              linkspaceset.indexcnt[index].placestr,
              linkspaceset.indexcnt[index].familycode,
              linkspaceset.indexcnt[index].type,
              linkspaceset.indexcnt[index].canshow,
              controller,
              searchNode,
              'pinchannel')[1];
          AddContent(context, title, content, searchNode);
        }
      }
    },
  );
}

PageViewStreamParent2() {
  return firestore.collection('Pinchannelin').snapshots();
}

PageViewRes2(snapshot, index) {
  linkspaceset.indextreetmp[index].clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    if (linkspaceset.indexcnt[index].familycode == sp.get('uniquecode')) {
      linkspaceset.indextreetmp[index].add(Linkspacetreepage(
          subindex: sp.get('index'),
          placestr: sp.get('addname'),
          mainid: sp.id,
          uniqueid: sp.get('uniquecode')));
    }
  }
  linkspaceset.indextreetmp[index].sort(((a, b) {
    return a.subindex.compareTo(b.subindex);
  }));
}

PageViewStreamChild3(context, id, index, index2) async {
  var memoname = '';
  await firestore
      .collection('PageView')
      .doc(linkspaceset.indextreetmp[index][index2].uniqueid)
      .get()
      .then(
    (value) async {
      if (value.get('type') == 2) {
        await firestore.collection('Pinchannelin').get().then(
          (value) {
            final valuespace = value.docs;
            for (var sp in valuespace) {
              if (sp.get('uniquecode') ==
                  linkspaceset.indextreetmp[index][index2].uniqueid) {
                memoname = sp.get('addname');
              }
            }
            Get.to(
                () => DayNoteHome(
                      title: memoname,
                      isfromwhere: 'home',
                    ),
                transition: Transition.downToUp);
          },
        );
      } else {
        Get.to(
            () => Spacein(
                id: linkspaceset.indextreetmp[index][index2].mainid,
                type: value.get('type'),
                spacename: linkspaceset.indextreetmp[index][index2].placestr),
            transition: Transition.downToUp);
      }
    },
  );
}

PageViewStreamChild4(context, id, index, index2, controller, searchNode) async {
  Widget title;
  Widget content;

  await firestore.collection('Pinchannel').doc(id).get().then(
    (value) {
      if (value.get('username') == usercode) {
        title = Widgets_horizontalbtnsecond(
          context,
          linkspaceset.indextreetmp[index][index2].uniqueid,
          index2,
          linkspaceset.indextreetmp[index][index2].placestr,
          linkspaceset.indextreetmp[index][index2].mainid,
          0,
          controller,
          searchNode,
          'pinchannelin',
        )[0];
        content = Widgets_horizontalbtnsecond(
          context,
          linkspaceset.indextreetmp[index][index2].uniqueid,
          index2,
          linkspaceset.indextreetmp[index][index2].placestr,
          linkspaceset.indextreetmp[index][index2].mainid,
          0,
          controller,
          searchNode,
          'pinchannelin',
        )[1];
        AddContent(context, title, content, searchNode);
      } else {
        if (value.get('setting') == 'block') {
        } else {
          title = Widgets_horizontalbtnsecond(
            context,
            linkspaceset.indextreetmp[index][index2].uniqueid,
            index2,
            linkspaceset.indextreetmp[index][index2].placestr,
            linkspaceset.indextreetmp[index][index2].mainid,
            0,
            controller,
            searchNode,
            'pinchannelin',
          )[0];
          content = Widgets_horizontalbtnsecond(
            context,
            linkspaceset.indextreetmp[index][index2].uniqueid,
            index2,
            linkspaceset.indextreetmp[index][index2].placestr,
            linkspaceset.indextreetmp[index][index2].mainid,
            0,
            controller,
            searchNode,
            'pinchannelin',
          )[1];
          AddContent(context, title, content, searchNode);
        }
      }
    },
  );
}

PageViewStreamParent3() {
  return firestore.collection('Calendar').get();
}

PageViewStreamChild5(context, id) {
  firestore.collection('Calendar').get().then(
    (value) {
      linkspaceset.inindextreetmp.clear();
      if (value.docs.isEmpty) {
      } else {
        final valuespace = value.docs;
        for (var sp in valuespace) {
          if (sp.get('parentid') == id) {
            controll_cals.share = sp.get('share');
            controll_cals.events = {};
            controll_cals.calname = sp.get('calname');
            controll_cals.themecalendar = sp.get('themesetting');
            controll_cals.showcalendar = sp.get('viewsetting');
            linkspaceset.inindextreetmp
                .add(Linkspacepageenter(addname: sp.get('calname')));
          }
        }
      }
    },
  );
}

AddTemplateStreamFamily(spaceindata, id) {
  return firestore.collection('PageView').get().then((value) {
    spaceindata.clear();
    uiset.pageviewlist.clear();
    if (value.docs.isEmpty) {
    } else {
      final valuespace = value.docs;
      for (int i = 0; i < valuespace.length; i++) {
        if (valuespace[i]['id'] == id) {
          if (cg.categorypicknumber == 0) {
            for (int j = 0; j < valuespace[i]['urllist'].length; j++) {
              spaceindata.add(valuespace[i]['urllist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
                title: valuespace[i]['spacename'],
                urlcontent: spaceindata,
                type: valuespace[i]['type'],
                uniquecode: valuespace[i]['id']));
          } else if (cg.categorypicknumber == 1) {
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              calendarcontent: valuespace[i]['calendarname'] ?? '',
            ));
          } else if (cg.categorypicknumber == 2) {
            for (int j = 0; j < valuespace[i]['todolist'].length; j++) {
              spaceindata.add(valuespace[i]['todolist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              todolistcontent: spaceindata,
            ));
          } else if (cg.categorypicknumber == 3) {
            for (int j = 0; j < valuespace[i]['memolist'].length; j++) {
              spaceindata.add(valuespace[i]['memolist'][j]);
            }
            uiset.pageviewlist.add(PageviewList(
              title: valuespace[i]['spacename'],
              type: valuespace[i]['type'],
              uniquecode: valuespace[i]['id'],
              memocontent: spaceindata,
            ));
          } else {}
        }
      }
      uiset.pageviewlist.sort(((a, b) {
        return a.title.compareTo(b.title);
      }));
    }
  });
}

SpacepageStreamParent() {
  return firestore.collection('Pinchannel').snapshots();
}

SpacepageChild1(snapshot) {
  uiset.pagelist.clear();
  final valuespace = snapshot.data!.docs;
  for (var sp in valuespace) {
    final messageuser = sp.get('nick');
    final messagetitle = sp.get('linkname');
    if (messageuser == usercode) {
      uiset.pagelist
          .add(PageList(title: messagetitle, username: messageuser, id: sp.id));
    }
  }
}

/// 이 아래에는 바텀시트를 통해 db에 접근하는 로직 작성
Widgets_editpageconsole(
  context,
  textcontroller,
  searchnode,
  index,
) {
  Widget title, title2, title3;
  Widget content, content2, content3;
  Widget bnt3;

  title = const SizedBox();
  content = Column(
    children: [
      ListTile(
        onTap: () {
          Get.back();
        },
        trailing: const Icon(
          Icons.settings,
          color: Colors.black,
        ),
        title: Text(
          '접근 권한 설정',
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
          title3 = Widgets_editpagesecond(context, textcontroller, searchnode,
              uiset.pagelist[index].title)[0];
          content3 = Widgets_editpagesecond(context, textcontroller, searchnode,
              uiset.pagelist[index].title)[1];
          bnt3 = Widgets_editpagesecond(context, textcontroller, searchnode,
              uiset.pagelist[index].title)[2];
          AddContentWithBtn(context, title3, content3, bnt3, searchnode);
        },
        trailing: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
        title: Text(
          '이름 바꾸기',
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
        onTap: () async {
          final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
                builder: (context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SingleChildScrollView(
                      child: Text('정말 이 링크를 삭제하시겠습니까?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize(),
                              color: Colors.blueGrey)),
                    ),
                  );
                },
              ), pressed2)) ??
              false;
          if (reloadpage) {
            uiset.setloading(true, 0);

            var id = '';
            await firestore.collection('Pinchannel').get().then((value) {
              for (int i = 0; i < value.docs.length; i++) {
                if (value.docs[i].get('username') == usercode &&
                    value.docs[i].get('linkname') ==
                        uiset.pagelist[index].title &&
                    value.docs[i].id == uiset.pagelist[index].id) {
                  id = value.docs[i].id;
                }
              }
              firestore.collection('Pinchannel').doc(id).delete();
            }).whenComplete(() async {
              var ids;
              await firestore.collection('PageView').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('id') == id) {
                    ids = value.docs[i].id;
                  }
                }
                firestore.collection('PageView').doc(ids).delete();
              }).whenComplete(() async {
                final idlist = [];
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('uniquecode') ==
                        uiset.pagelist[index].id) {
                      id = value.docs[i].id;
                      firestore.collection('Pinchannelin').doc(id).delete();
                    }
                  }
                }).whenComplete(() {
                  uiset.setloading(false, 0);
                  SaveNoti('page', uiset.pagelist[index].title, '',
                      delete: true);
                  Get.back();
                });
              });
            });
          }
        },
        trailing: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        title: Text(
          '삭제하기',
          softWrap: true,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: contentTextsize()),
          overflow: TextOverflow.ellipsis,
        ),
      )
    ],
  );
  return [title, content];
}

Widgets_editpagesecond(
  context,
  textcontroller,
  searchnode,
  prevtitle,
) {
  Widget title;
  Widget content;
  Widget btn;
  final updatelist = [];
  final uniquecodelist = [];
  textcontroller.text = prevtitle;

  title = SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름 변경',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: secondTitleTextsize()))
        ],
      ));
  content = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ContainerTextFieldDesign(
        searchNodeAddSection: searchnode,
        string: '변경할 제목입력',
        textEditingControllerAddSheet: textcontroller,
      ),
    ],
  );
  btn = SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  SummitEditpage(
                      context, textcontroller, updatelist, prevtitle);
                },
                child: GetBuilder<uisetting>(
                  builder: (_) => Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        uiset.loading == true
                            ? Center(
                                child: Text(
                                  '처리중',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.white),
                                ),
                              )
                            : Center(
                                child: Text(
                                  '변경',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTextsize(),
                                      color: Colors.white),
                                ),
                              )
                      ],
                    ),
                  ),
                )),
          )
        ],
      ));
  return [title, content, btn];
}

Widgets_horizontalbtn(
  context,
  parentid,
  index,
  placestr,
  uniquecode,
  type,
  canshow,
  controller,
  searchNode,
  String s,
) {
  Widget title, title2;
  Widget content, content2;
  Widget btn2;
  final List<Linkspacepage> listspacepageset = [];
  var id;
  var updateid = [];
  var updateindex = [];
  var radiogroups = [0, 1, 2];
  String prevtitle = placestr;
  String changeset = canshow == '나 혼자만'
      ? radiogroup1[0]
      : (canshow == '팔로워만 공개' ? radiogroup1[1] : radiogroup1[2]);

  title = const SizedBox();
  content = StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            controller.text = placestr;
            title2 = SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름 변경',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: secondTitleTextsize()))
                  ],
                ));
            content2 = ContainerTextFieldDesign(
              searchNodeAddSection: searchNode,
              string: '변경할 이름 입력',
              textEditingControllerAddSheet: controller,
            );
            btn2 = SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: ButtonColor(),
                  ),
                  onPressed: () async {
                    SummitEditBox(
                        context,
                        controller,
                        searchNode,
                        'editnametemplate',
                        uniquecode,
                        type,
                        parentid,
                        prevtitle);
                  },
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            uiset.loading == false ? '변경' : '처리중',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
            AddContentWithBtn(context, title2, content2, btn2, searchNode);
          },
          trailing: const Icon(
            AntDesign.edit,
            color: Colors.black,
          ),
          title: Text(
            '이름 변경',
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
            Get.dialog(OSDialogWithoutaction(
              context,
              '선택',
              Builder(
                builder: (context) {
                  return GetBuilder<uisetting>(builder: ((controller) {
                    return SizedBox(
                        width: Get.width / 2,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: radiogroup1.length,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return RadioListTile<String>(
                                      title: Text(radiogroup1[index]),
                                      value: radiogroup1[index],
                                      groupValue: changeset,
                                      onChanged: (value) async {
                                        setState(() {
                                          changeset = value!;
                                        });
                                        await PageViewRes1_2(
                                            uniquecode, changeset);
                                      },
                                    );
                                  },
                                ),
                                uiset.loading == true
                                    ? SizedBox(
                                        height: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                          },
                        ));
                  }));
                },
              ),
            )).whenComplete(() {
              Get.back();
            });
          },
          trailing: const Icon(
            Ionicons.eye_outline,
            color: Colors.black,
          ),
          title: Text(
            '공개범위 변경',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: contentTextsize()),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: GetBuilder<uisetting>(
            builder: (controller) {
              return Text(
                'now : ' + changeset,
                softWrap: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: contentTextsize()),
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        ListTile(
          onTap: () async {
            final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
                  builder: (context) {
                    return SizedBox(
                      width: Get.width / 2,
                      child: SingleChildScrollView(
                        child: Text('정말 이 링크를 삭제하시겠습니까?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.blueGrey)),
                      ),
                    );
                  },
                ), pressed2)) ??
                false;
            if (reloadpage) {
              uiset.setloading(true, 0);

              var boxparentid;
              await firestore
                  .collection('PageView')
                  .doc(uniquecode)
                  .delete()
                  .whenComplete(() async {
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('uniquecode') == uniquecode) {
                      boxparentid = value.docs[i].id;
                      updateid.add(boxparentid);
                    }
                  }
                  if (updateid.isEmpty) {
                  } else {
                    for (int j = 0; j < updateid.length; j++) {
                      firestore
                          .collection('Pinchannelin')
                          .doc(updateid[j])
                          .delete();
                    }
                  }
                }).whenComplete(() async {
                  updateid.clear();
                  updateindex.clear();
                  Snack.snackbars(
                      context: context,
                      title: '삭제완료!',
                      backgroundcolor: Colors.red,
                      bordercolor: draw.backgroundcolor);
                  await firestore.collection('PageView').get().then((value) {
                    for (int i = 0; i < value.docs.length; i++) {
                      if (value.docs[i].get('index') > index) {
                        updateid.add(value.docs[i].id);
                        updateindex.add(value.docs[i].get('index'));
                      }
                    }
                    if (updateid.isEmpty) {
                    } else {
                      for (int j = 0; j < updateid.length; j++) {
                        firestore
                            .collection('PageView')
                            .doc(updateid[j])
                            .update({'index': updateindex[j] - 1});
                      }
                    }
                  }).whenComplete(() {
                    SaveNoti('box', placestr, '', delete: true);
                    uiset.setloading(false, 0);
                    Get.back();
                  });
                });
              });
            }
          },
          trailing: const Icon(
            AntDesign.delete,
            color: Colors.red,
          ),
          title: Text(
            '삭제',
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

Widgets_horizontalbtnsecond(
  context,
  parentid,
  index,
  placestr,
  uniquecode,
  type,
  controller,
  searchNode,
  String s,
) {
  Widget title, title2;
  Widget content, content2;
  Widget btn2;
  final List<Linkspacepage> listspacepageset = [];
  var id;
  var updateid = [];
  var updateindex = [];
  String prevtitle = placestr;

  title = const SizedBox();
  content = StatefulBuilder(builder: (_, StateSetter setState) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.back();
            controller.text = placestr;
            title2 = SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름 변경',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: secondTitleTextsize()))
                  ],
                ));
            content2 = ContainerTextFieldDesign(
              searchNodeAddSection: searchNode,
              string: '변경할 이름 입력',
              textEditingControllerAddSheet: controller,
            );
            btn2 = SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: ButtonColor(),
                  ),
                  onPressed: () async {
                    SummitEditBox(
                        context,
                        controller,
                        searchNode,
                        'editnametemplatein',
                        uniquecode,
                        index,
                        parentid,
                        prevtitle);
                  },
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            uiset.loading == false ? '변경' : '처리중',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
            AddContentWithBtn(context, title2, content2, btn2, searchNode);
          },
          trailing: const Icon(
            AntDesign.edit,
            color: Colors.black,
          ),
          title: Text(
            '이름 변경',
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
          onTap: () async {
            final reloadpage = await Get.dialog(OSDialog(context, '경고', Builder(
                  builder: (context) {
                    return SizedBox(
                      width: Get.width / 2,
                      child: SingleChildScrollView(
                        child: Text('정말 이 링크를 삭제하시겠습니까?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTextsize(),
                                color: Colors.blueGrey)),
                      ),
                    );
                  },
                ), pressed2)) ??
                false;
            if (reloadpage) {
              uiset.setloading(true, 0);
              var changeindex;

              await firestore.collection('Pinchannelin').get().then((value) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (value.docs[i].get('addname') == placestr &&
                      value.docs[i].get('uniquecode') == parentid &&
                      value.docs[i].get('index') == index) {
                    id = value.docs[i].id;
                    changeindex = value.docs[i].get('index');
                  }
                }
                firestore.collection('Pinchannelin').doc(id).delete();
              }).whenComplete(() async {
                updateid.clear();
                updateindex.clear();
                await firestore.collection('Pinchannelin').get().then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (value.docs[i].get('uniquecode') == parentid &&
                        value.docs[i].get('index') > changeindex) {
                      updateid.add(value.docs[i].id);
                      updateindex.add(value.docs[i].get('index'));
                    }
                  }
                  if (updateid.isEmpty) {
                  } else {
                    for (int j = 0; j < updateid.length; j++) {
                      firestore
                          .collection('Pinchannelin')
                          .doc(updateid[j])
                          .update({'index': updateindex[j] - 1});
                    }
                  }
                }).whenComplete(() async {
                  Snack.snackbars(
                      context: context,
                      title: '삭제완료!',
                      backgroundcolor: Colors.red,
                      bordercolor: draw.backgroundcolor);
                  uiset.setloading(false, 0);
                  SaveNoti('box', placestr, '', delete: true);
                  Get.back();
                });
              });
            }
          },
          trailing: const Icon(
            AntDesign.delete,
            color: Colors.red,
          ),
          title: Text(
            '삭제',
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

SummitEditpage(context, controller, updatelist, prevtitle) async {
  if (controller.text.isEmpty) {
    Snack.snackbars(
        context: context,
        title: '변경할 이름이 비어있어요',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  } else {
    updatelist.clear();
    var id = '';
    uiset.setloading(true, 0);

    await firestore.collection('Pinchannel').get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].get('linkname') == prevtitle) {
          if (value.docs[i].get('username') == usercode) {
            id = value.docs[i].id;
          }
        }
      }
      firestore.collection('Pinchannel').doc(id).update({
        'linkname': controller.text,
      });
    }).whenComplete(() async {
      await firestore.collection('Favorplace').get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i].get('title') == prevtitle) {
            if (value.docs[i].get('originuser') == usercode) {
              id = value.docs[i].id;
              firestore.collection('Favorplace').doc(id).update({
                'title': controller.text,
              });
            }
          }
        }
      }).whenComplete(() async {
        Snack.snackbars(
            context: context,
            title: '정상적으로 처리되었어요',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
        uiset.setloading(false, 0);
        SaveNoti('page', prevtitle, controller.text);
        Get.back();
        uiset.setuserspace(init: false);
      });
    });
  }
}

SummitEditBox(
  context,
  textEditingControllerAddSheet,
  searchNodeAddSection,
  where,
  id,
  type,
  parentid,
  prevtitle,
) {
  final updatelist = [];
  var updateid;
  int indexcnt = linkspaceset.indexcnt.length;
  if (textEditingControllerAddSheet.text.isEmpty) {
    Snack.snackbars(
        context: context,
        title: where == 'editnametemplate' || where == 'editnametemplatein'
            ? '변경할 제목이 비어있어요!'
            : '추가할 페이지 제목이 비어있어요!',
        backgroundcolor: Colors.red,
        bordercolor: draw.backgroundcolor);
  } else {
    uiset.setloading(true, 0);
    if (where == 'editnametemplate') {
      firestore.collection('PageView').doc(id).update(
          {'spacename': textEditingControllerAddSheet.text}).whenComplete(() {
        Snack.snackbars(
            context: context,
            title: '정상적으로 처리되었어요',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
        uiset.setloading(false, 0);
        linkspaceset.setspacelink(textEditingControllerAddSheet.text);
      }).whenComplete(() async {
        SaveNoti('box', prevtitle, textEditingControllerAddSheet.text);
        Get.back();
      });
    } else {
      firestore.collection('Pinchannelin').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (int j = 0; j < value.docs.length; j++) {
            final messageuniquecode = value.docs[j]['uniquecode'];
            final messageindex = value.docs[j]['index'];
            if (messageindex == type && messageuniquecode == parentid) {
              firestore
                  .collection('Pinchannelin')
                  .doc(value.docs[j].id)
                  .update({'addname': textEditingControllerAddSheet.text});
            }
          }
        } else {}
      }).whenComplete(() async {
        Snack.snackbars(
            context: context,
            title: '정상적으로 처리되었어요',
            backgroundcolor: Colors.green,
            bordercolor: draw.backgroundcolor);
        uiset.setloading(false, 0);
        linkspaceset.setspacelink(textEditingControllerAddSheet.text);
        SaveNoti('box', prevtitle, textEditingControllerAddSheet.text);
        Get.back();
      });
    }
  }
}
