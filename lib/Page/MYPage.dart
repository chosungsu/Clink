// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, non_constant_identifier_names

import 'package:clickbyme/DB/Linkpage.dart';
import 'package:clickbyme/Page/Linkin.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/sheets/infoshow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../DB/PageList.dart';
import '../Route/subuiroute.dart';
import '../Tool/FlushbarStyle.dart';
import '../Tool/Getx/PeopleAdd.dart';
import '../Tool/Getx/linkspacesetting.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/Getx/notishow.dart';
import '../Tool/Getx/selectcollection.dart';
import '../Tool/Loader.dart';
import '../Tool/NoBehavior.dart';
import '../Tool/AppBarCustom.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../mongoDB/mongodatabase.dart';
import '../sheets/linksettingsheet.dart';
import '../sheets/movetolinkspace.dart';
import 'DrawerScreen.dart';

class MYPage extends StatefulWidget {
  const MYPage({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MYPageState();
}

class _MYPageState extends State<MYPage> with TickerProviderStateMixin {
  bool login_state = false;
  String name = Hive.box('user_info').get('id');
  final draw = Get.put(navibool());
  final notilist = Get.put(notishow());
  final cal_share_person = Get.put(PeopleAdd());
  final uiset = Get.put(uisetting());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final sharelist = [];
  final colorlist = [];
  final calnamelist = [];
  final friendnamelist = [];
  final searchNode = FocusNode();
  var scrollController;
  var _controller = TextEditingController();
  late FToast fToast;
  final scollection = Get.put(selectcollection());
  final linkspaceset = Get.put(linkspacesetting());
  late Animation animation;
  String usercode = Hive.box('user_setting').get('usercode');
  final List<Linkpage> listpinlink = [];
  final List<CompanyPageList> listcompanytousers = [];
  var url;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    listpinlink.clear();
    uiset.showtopbutton = false;
    Hive.box('user_setting').put('page_index', 0);
    fToast = FToast();
    fToast.init(context);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
    super.dispose();
    _controller.dispose();
    scrollController.dispose();
    //notilist.noticontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGColor(),
        floatingActionButton: Speeddialmemo(
            context,
            usercode,
            _controller,
            searchNode,
            scrollController,
            isDialOpen,
            uiset.pagelist.isEmpty ? '빈 스페이스' : uiset.pagelist[0].title),
        body: SafeArea(
          child: GetBuilder<navibool>(
            builder: (_) => draw.navi == 0
                ? (draw.drawopen == true
                    ? Stack(
                        children: [
                          SizedBox(
                            width: 80,
                            child: DrawerScreen(
                              index: Hive.box('user_setting').get('page_index'),
                            ),
                          ),
                          GroupBody(context),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      )
                    : Stack(
                        children: [
                          GroupBody(context),
                          uiset.loading == true
                              ? const Loader(
                                  wherein: 'route',
                                )
                              : Container()
                        ],
                      ))
                : Stack(
                    children: [
                      GroupBody(context),
                      uiset.loading == true
                          ? const Loader(
                              wherein: 'route',
                            )
                          : Container()
                    ],
                  ),
          ),
        ));
  }

  Widget GroupBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
            transform: Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
              ..scale(draw.scalefactor),
            duration: const Duration(milliseconds: 250),
            child: GetBuilder<navibool>(
              builder: (_) => GestureDetector(
                onTap: () {
                  draw.drawopen == true
                      ? setState(() {
                          draw.drawopen = false;
                          draw.setclose();
                          Hive.box('user_setting').put('page_opened', false);
                        })
                      : null;
                },
                child: SizedBox(
                  height: height,
                  child: Container(
                      color: BGColor(),
                      child: Column(
                        children: [
                          AppBarCustom(
                              title: 'MY',
                              righticon: true,
                              iconname: Icons.notifications_none,
                              textEditingController: _controller,
                              focusNode: searchNode),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                  child: ScrollConfiguration(
                                      behavior: NoBehavior(),
                                      child: SingleChildScrollView(
                                          //controller: scrollController,
                                          physics: const ScrollPhysics(),
                                          child: Column(
                                            children: [
                                              CompanyNotice(
                                                'home',
                                              ),
                                              listy_My()
                                            ],
                                          )))))
                        ],
                      )),
                ),
              ),
            )));
  }

  listy_My() {
    var user, linkname, placestr;

    return GetBuilder<linkspacesetting>(
        builder: (_) => serverstatus == true
            ? FutureBuilder(
                future: MongoDB.getData(collectionname: 'pinchannelin')
                    .then((value) {
                  linkspaceset.indexcnt.clear();
                  linkspaceset.indextreetmp.clear();
                  if (value.isEmpty) {
                  } else {
                    for (var sp in value) {
                      user = sp['username'];
                      linkname = sp['linkname'];
                      if (usercode == user &&
                          uiset.pagelist[0].title == linkname) {
                        linkspaceset.indextreetmp
                            .add(List.empty(growable: true));
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp['index'].toString()),
                            placestr: sp['placestr'],
                            uniquecode: sp['uniquecode']));
                      }
                    }
                    linkspaceset.indexcnt.sort(((a, b) {
                      return a.index.compareTo(b.index);
                    }));
                  }
                }),
                builder: (context, snapshot) {
                  return linkspaceset.indexcnt.isEmpty
                      ? SizedBox(
                          child: Center(
                          child: NeumorphicText(
                            '텅! 비어있어요~',
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 3,
                              color: TextColor_shadowcolor(),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: contentTitleTextsize(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ))
                      : ListView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: linkspaceset.indexcnt.length,
                          itemBuilder: ((context, index) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: SizedBox(
                                            child: Column(
                                          children: [
                                            Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr ==
                                                              'board'
                                                          ? '보드'
                                                          : (linkspaceset
                                                                      .indexcnt[
                                                                          index]
                                                                      .placestr ==
                                                                  'card'
                                                              ? '링크 및 파일'
                                                              : '캘린더'),
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              contentTextsize()),
                                                    ),
                                                  ),
                                                  linkspaceset.indexcnt[index]
                                                              .placestr ==
                                                          'calendar'
                                                      ? const SizedBox()
                                                      : InkWell(
                                                          onTap: () {
                                                            linkmadetreeplace(
                                                                context,
                                                                usercode,
                                                                uiset
                                                                    .pagelist[0]
                                                                    .title,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr,
                                                                linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length,
                                                                linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .uniquecode);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color:
                                                                Colors.black45,
                                                          ),
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _controller.text = '';
                                                      linkplacechangeoptions(
                                                          context,
                                                          usercode,
                                                          uiset.pagelist[0]
                                                              .title,
                                                          index,
                                                          searchNode,
                                                          _controller,
                                                          linkspaceset
                                                              .indexcnt[index]
                                                              .placestr,
                                                          linkspaceset
                                                              .indexcnt[index]
                                                              .uniquecode);
                                                    },
                                                    child: const Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.black45,
                                                    ),
                                                  )
                                                ]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder(
                                                future: MongoDB.getData(
                                                  collectionname: 'linknet',
                                                ).then((value) {
                                                  linkspaceset
                                                      .indextreetmp[index]
                                                      .clear();
                                                  if (value.isEmpty) {
                                                  } else {
                                                    for (var sp in value) {
                                                      user = sp['username'];
                                                      placestr = sp['placestr'];
                                                      if (usercode == user &&
                                                          linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .placestr ==
                                                              placestr &&
                                                          linkspaceset
                                                                  .indexcnt[
                                                                      index]
                                                                  .uniquecode ==
                                                              sp['uniquecode']) {
                                                        linkspaceset
                                                            .indextreetmp[index]
                                                            .add(Linkspacetreepage(
                                                                subindex: linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length,
                                                                placestr: sp[
                                                                    'addname'],
                                                                uniqueid: sp[
                                                                    'uniquecode']));
                                                      }
                                                    }
                                                    linkspaceset
                                                        .indextreetmp[index]
                                                        .sort(((a, b) {
                                                      return a.subindex
                                                          .compareTo(
                                                              b.subindex);
                                                    }));
                                                  }
                                                }),
                                                builder: ((context, snapshot) {
                                                  if (linkspaceset
                                                      .indextreetmp[index]
                                                      .isNotEmpty) {
                                                    return SizedBox(
                                                        height: linkspaceset.indexcnt[index].placestr == 'board'
                                                            ? (linkspaceset
                                                                    .indextreetmp[
                                                                        index]
                                                                    .length) *
                                                                200
                                                            : (linkspaceset.indexcnt[index].placestr == 'card'
                                                                ? (linkspaceset
                                                                        .indextreetmp[
                                                                            index]
                                                                        .length) *
                                                                    130
                                                                : 130),
                                                        child: ListView.builder(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10,
                                                              right: 10,
                                                            ),
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ScrollPhysics(),
                                                            itemCount: linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .placestr ==
                                                                    'calendar'
                                                                ? 1
                                                                : linkspaceset
                                                                    .indextreetmp[index]
                                                                    .length,
                                                            itemBuilder: ((context, index2) {
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (linkspaceset
                                                                              .indexcnt[index]
                                                                              .placestr ==
                                                                          'calendar') {
                                                                        Get.to(
                                                                            () =>
                                                                                const ChooseCalendar(isfromwhere: 'mypagehome', index: 0),
                                                                            transition: Transition.rightToLeft);
                                                                      } else {}
                                                                    },
                                                                    child: ContainerDesign(
                                                                        color: Colors.white,
                                                                        child: SizedBox(
                                                                          height: linkspaceset.indexcnt[index].placestr == 'board'
                                                                              ? 150
                                                                              : (linkspaceset.indexcnt[index].placestr == 'card' ? 80 : 80),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  _controller.text = linkspaceset.indextreetmp[index][index2].placestr == '' ? '' : linkspaceset.indextreetmp[index][index2].placestr;
                                                                                  linkplacenamechange(context, usercode, linkspaceset.indextreetmp[index][index2].uniqueid, index2, linkspaceset.indextreetmp[index][index2].placestr, searchNode, _controller, linkspaceset.indexcnt[index].placestr);
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      fit: FlexFit.tight,
                                                                                      child: Text(
                                                                                        linkspaceset.indextreetmp[index][index2].placestr == '' ? '제목없음' : linkspaceset.indextreetmp[index][index2].placestr,
                                                                                        textAlign: TextAlign.start,
                                                                                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.edit,
                                                                                      color: Colors.black45,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              );
                                                            })));
                                                  } else {
                                                    return SizedBox(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              linkspaceset
                                                                          .indexcnt[
                                                                              index]
                                                                          .placestr ==
                                                                      'board'
                                                                  ? '보드 공간은 이미지모음, 메모를 클립보드 형식으로 보여주는 공간입니다.'
                                                                  : (linkspaceset
                                                                              .indexcnt[index]
                                                                              .placestr ==
                                                                          'card'
                                                                      ? '카드 공간은 링크 및 파일을 바로가기 카드뷰로 보여주는 공간입니다.'
                                                                      : '캘린더 공간은 캘린더 형식만을 보여주는 공간입니다.'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      contentTextsize()),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }))
                                          ],
                                        )))),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }));
                },
              )
            : StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Pinchannelin').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    linkspaceset.indextreetmp.clear();
                    linkspaceset.indexcnt.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      user = sp.get('username');
                      linkname = sp.get('linkname');
                      if (user == usercode &&
                          linkname == uiset.pagelist[0].title) {
                        linkspaceset.indextreetmp
                            .add(List.empty(growable: true));
                        linkspaceset.indexcnt.add(Linkspacepage(
                            index: int.parse(sp.get('index').toString()),
                            placestr: sp.get('placestr'),
                            uniquecode: sp.get('uniquecode')));
                      }
                    }
                    linkspaceset.indexcnt.sort(((a, b) {
                      return a.uniquecode.compareTo(b.uniquecode);
                    }));
                    return linkspaceset.indexcnt.isEmpty
                        ? SizedBox(
                            child: Center(
                            child: NeumorphicText(
                              '텅! 비어있어요~',
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 3,
                                color: TextColor_shadowcolor(),
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: contentTitleTextsize(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ))
                        : ListView.builder(
                            //controller: scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: linkspaceset.indexcnt.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr ==
                                                                'board'
                                                            ? '보드'
                                                            : (linkspaceset
                                                                        .indexcnt[
                                                                            index]
                                                                        .placestr ==
                                                                    'card'
                                                                ? '링크 및 파일'
                                                                : '캘린더'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        linkmadetreeplace(
                                                            context,
                                                            usercode,
                                                            uiset.pagelist[0]
                                                                .title,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .placestr,
                                                            index,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .uniquecode);
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _controller.text = '';
                                                        linkplacechangeoptions(
                                                            context,
                                                            usercode,
                                                            uiset.pagelist[0]
                                                                .title,
                                                            index,
                                                            searchNode,
                                                            _controller,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .placestr,
                                                            linkspaceset
                                                                .indexcnt[index]
                                                                .uniquecode);
                                                      },
                                                      child: const Icon(
                                                        Icons.more_horiz,
                                                        color: Colors.black45,
                                                      ),
                                                    )
                                                  ]),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FutureBuilder(
                                                  future: MongoDB.getData(
                                                    collectionname: 'linknet',
                                                  ).then((value) {
                                                    linkspaceset
                                                        .indextreetmp[index]
                                                        .clear();
                                                    if (value.isEmpty) {
                                                    } else {
                                                      for (var sp in value) {
                                                        user = sp['username'];
                                                        placestr =
                                                            sp['placestr'];
                                                        if (usercode == user &&
                                                            linkspaceset
                                                                    .indexcnt[
                                                                        index]
                                                                    .placestr ==
                                                                placestr) {
                                                          linkspaceset
                                                              .indextreetmp[
                                                                  index]
                                                              .add(Linkspacetreepage(
                                                                  subindex: linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length,
                                                                  placestr: sp[
                                                                      'addname'],
                                                                  uniqueid: sp[
                                                                      'uniquecode']));
                                                        }
                                                      }
                                                      linkspaceset
                                                          .indextreetmp[index]
                                                          .sort(((a, b) {
                                                        return a.subindex
                                                            .compareTo(
                                                                b.subindex);
                                                      }));
                                                    }
                                                  }),
                                                  builder:
                                                      ((context, snapshot) {
                                                    if (linkspaceset
                                                        .indextreetmp[index]
                                                        .isNotEmpty) {
                                                      return SizedBox(
                                                          height: linkspaceset
                                                                      .indexcnt[
                                                                          index]
                                                                      .placestr ==
                                                                  'board'
                                                              ? (linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length) *
                                                                  200
                                                              : (linkspaceset.indexcnt[index].placestr ==
                                                                      'card'
                                                                  ? (linkspaceset
                                                                          .indextreetmp[
                                                                              index]
                                                                          .length) *
                                                                      130
                                                                  : (linkspaceset
                                                                          .indextreetmp[
                                                                              index]
                                                                          .length) *
                                                                      130),
                                                          child:
                                                              ListView.builder(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                  ),
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      const ScrollPhysics(),
                                                                  itemCount: linkspaceset
                                                                      .indextreetmp[
                                                                          index]
                                                                      .length,
                                                                  itemBuilder:
                                                                      ((context,
                                                                          index2) {
                                                                    return Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        ContainerDesign(
                                                                            color:
                                                                                Colors.white,
                                                                            child: SizedBox(
                                                                              height: linkspaceset.indexcnt[index].placestr == 'board' ? 150 : (linkspaceset.indexcnt[index].placestr == 'card' ? 80 : 80),
                                                                              child: Column(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      _controller.text = linkspaceset.indextreetmp[index][index2].placestr == '' ? '' : linkspaceset.indextreetmp[index][index2].placestr;
                                                                                      linkplacenamechange(context, usercode, linkspaceset.indextreetmp[index][index2].uniqueid, index2, linkspaceset.indextreetmp[index][index2].placestr, searchNode, _controller, linkspaceset.indexcnt[index].placestr);
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          fit: FlexFit.tight,
                                                                                          child: Text(
                                                                                            linkspaceset.indextreetmp[index][index2].placestr == '' ? '제목없음' : linkspaceset.indextreetmp[index][index2].placestr,
                                                                                            textAlign: TextAlign.start,
                                                                                            style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: contentTextsize()),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        const Icon(
                                                                                          Icons.edit,
                                                                                          color: Colors.black45,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  })));
                                                    } else {
                                                      return SizedBox(
                                                        height: 100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                linkspaceset
                                                                            .indexcnt[
                                                                                index]
                                                                            .placestr ==
                                                                        'board'
                                                                    ? '보드 공간은 이미지모음, 메모를 클립보드 형식으로 보여주는 공간입니다.'
                                                                    : (linkspaceset.indexcnt[index].placestr ==
                                                                            'card'
                                                                        ? '카드 공간은 링크 및 파일을 바로가기 카드뷰로 보여주는 공간입니다.'
                                                                        : '캘린더 공간은 캘린더 형식만을 보여주는 공간입니다.'),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  }))
                                            ],
                                          )))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }));
                  }
                  return LinearProgressIndicator(
                    backgroundColor: BGColor(),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                },
              ));
  }

  /*M_Container0(double height) {
    var link = [];
    var user = '';

    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<linkspacesetting>(builder: (_) {
              return serverstatus == true
                  ? FutureBuilder(
                      future: MongoDB.getData(collectionname: 'pinchannel')
                          .then((value) {
                        listpinlink.clear();
                        if (value.isEmpty) {
                        } else {
                          for (int j = 0; j < value.length; j++) {
                            user = value[j]['username'];
                            if (user == usercode) {
                              listpinlink
                                  .add(Linkpage(link: value[j]['linkname']));
                            }
                          }
                        }
                      }),
                      builder: (context, snapshot) {
                        return listpinlink.isEmpty
                            ? SizedBox(
                                child: Center(
                                child: NeumorphicText(
                                  '텅! 비어있어요~',
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    depth: 3,
                                    color: TextColor_shadowcolor(),
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTitleTextsize(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 3 / 1,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemCount: listpinlink.length,
                                    itemBuilder: ((context, index) {
                                      return GestureDetector(
                                          onLongPress: () {
                                            _controller.clear();

                                            _controller.text =
                                                listpinlink[index].link;
                                            _controller.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            listpinlink[index]
                                                                .link
                                                                .length));
                                            SetChangeLink(
                                                context,
                                                _controller,
                                                searchNode,
                                                listpinlink[index].link);
                                          },
                                          onTap: () async {
                                            var user, linkname, placestr;
                                            if (serverstatus) {
                                              await MongoDB.getData(
                                                      collectionname:
                                                          'pinchannelin')
                                                  .then((value) {
                                                linkspaceset.indexcnt.clear();
                                                linkspaceset.indextreetmp
                                                    .clear();
                                                if (value.isEmpty) {
                                                } else {
                                                  for (var sp in value) {
                                                    user = sp['username'];
                                                    linkname = sp['linkname'];
                                                    if (usercode == user &&
                                                        listpinlink[index]
                                                                .link ==
                                                            linkname) {
                                                      linkspaceset.indextreetmp
                                                          .add(List.empty(
                                                              growable: true));
                                                      linkspaceset.indexcnt.add(
                                                          Linkspacepage(
                                                              index: int.parse(sp[
                                                                      'index']
                                                                  .toString()),
                                                              placestr: sp[
                                                                  'placestr'],
                                                              uniquecode: sp[
                                                                  'uniquecode']));
                                                    }
                                                  }
                                                  linkspaceset.indexcnt
                                                      .sort(((a, b) {
                                                    return a.index
                                                        .compareTo(b.index);
                                                  }));
                                                }
                                              });
                                            } else {
                                              await firestore
                                                  .collection('Pinchannelin')
                                                  .get()
                                                  .then((value) {
                                                linkspaceset.indextreetmp
                                                    .clear();
                                                linkspaceset.indexcnt.clear();
                                                final valuespace = value.docs;
                                                for (var sp in valuespace) {
                                                  user = sp.get('username');
                                                  linkname = sp.get('linkname');
                                                  if (user == usercode &&
                                                      linkname ==
                                                          listpinlink[index]
                                                              .link) {
                                                    linkspaceset.indextreetmp
                                                        .add(List.empty(
                                                            growable: true));
                                                    linkspaceset.indexcnt.add(
                                                        Linkspacepage(
                                                            index: int.parse(sp
                                                                .get('index')
                                                                .toString()),
                                                            placestr: sp.get(
                                                                'placestr'),
                                                            uniquecode: sp.get(
                                                                'uniquecode')));
                                                  }
                                                }
                                                linkspaceset.indexcnt
                                                    .sort(((a, b) {
                                                  return a.uniqueid
                                                      .compareTo(b.uniqueid);
                                                }));
                                              });
                                            }
                                            Get.to(
                                                () => Linkin(
                                                      isfromwhere: 'mypagehome',
                                                      name: listpinlink[index]
                                                          .link,
                                                    ),
                                                transition:
                                                    Transition.rightToLeft);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: SizedBox(
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                    Flexible(
                                                        fit: FlexFit.tight,
                                                        child: Text(
                                                          listpinlink[index]
                                                              .link
                                                              .toString(),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize()),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ))
                                                  ]))));
                                    })));
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('Linknet').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listpinlink.clear();
                          final valuespace = snapshot.data!.docs;
                          for (var sp in valuespace) {
                            user = sp.get('username');
                            if (user == usercode) {
                              for (int i = 0; i < sp.get('link').length; i++) {
                                listpinlink
                                    .add(Linkpage(link: sp.get('link')[i]));
                              }
                            }
                          }
                          return listpinlink.isEmpty
                              ? SizedBox(
                                  child: Center(
                                  child: NeumorphicText(
                                    '텅! 비어있어요~',
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      depth: 3,
                                      color: TextColor_shadowcolor(),
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: contentTitleTextsize(),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              childAspectRatio: 3 / 1,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      itemCount: listpinlink.length,
                                      itemBuilder: ((context, index) {
                                        return GestureDetector(
                                            onTap: () async {},
                                            child: FocusedMenuHolder(
                                                menuItems: [
                                                  FocusedMenuItem(
                                                      trailingIcon: const Icon(
                                                        Icons.style,
                                                        size: 30,
                                                      ),
                                                      title: Text('상세정보',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                      onPressed: () async {}),
                                                  FocusedMenuItem(
                                                      trailingIcon: const Icon(
                                                        Icons.share,
                                                        size: 30,
                                                      ),
                                                      title: Text('Sharing 설정',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  contentTextsize())),
                                                      onPressed: () {
                                                        //공유자 검색
                                                      }),
                                                ],
                                                duration:
                                                    const Duration(seconds: 0),
                                                animateMenuItems: true,
                                                menuOffset: 20,
                                                bottomOffsetHeight: 10,
                                                menuWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        40,
                                                openWithTap: false,
                                                onPressed: () {},
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                    child: SizedBox(
                                                        child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                          Flexible(
                                                              fit:
                                                                  FlexFit.tight,
                                                              child: Text(
                                                                listpinlink[
                                                                        index]
                                                                    .link
                                                                    .toString(),
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        contentTextsize()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ))
                                                        ])))));
                                      })));
                        }
                        return LinearProgressIndicator(
                          backgroundColor: BGColor(),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        );
                      },
                    );
            }),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }*/
}
