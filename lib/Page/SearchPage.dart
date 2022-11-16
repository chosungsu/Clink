// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/Getx/uisetting.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:clickbyme/UI/Home/firstContentNet/HomeView.dart';
import 'package:clickbyme/UI/Home/secondContentNet/ShowTips.dart';
import 'package:clickbyme/mongoDB/mongodatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info/package_info.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../DB/PageList.dart';
import '../DB/SpaceContent.dart';
import '../Route/subuiroute.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../sheets/readycontent.dart';
import 'DrawerScreen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.secondname}) : super(key: key);
  final String secondname;
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  int categorynumber = 0;
  List<SpaceContent> sc = [];
  late DateTime Date = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final draw = Get.put(navibool());
  List contentmy = [];
  List contentshare = [];
  String name = Hive.box('user_info').get('id');
  List defaulthomeviewlist = [
    '오늘의 일정',
    '공유된 오늘의 일정',
    '최근에 수정된 메모',
    '홈뷰에 저장된 메모',
  ];
  List userviewlist = [];
  int currentPage2 = 0;
  //프로 버전 구매시 사용하게될 코드
  bool isbought = false;
  TextEditingController controller = TextEditingController();
  FocusNode searchnode = FocusNode();
  ScrollController _scrollController = ScrollController();
  var searchNode = FocusNode();
  var newversion;
  var status;
  bool sameversion = true;
  List updateid = [];
  String textchangelistener = '';
  bool isread = false;
  final notilist = Get.put(notishow());
  late Animation animation;
  List updatefriends = [];
  String docid = '';
  final peopleadd = Get.put(PeopleAdd());
  final uiset = Get.put(uisetting());
  late PackageInfo info;
  String versioninfo = '';
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 1);
    docid = Hive.box('user_setting').get('usercode') ?? '';
    controller = TextEditingController();
    uiset.searchpagemove = '';
    /*firestore.collection('MemoAllAlarm').get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          //print(value.docs[i].data());
          MongoDB.add(
              collectionname: 'memoallalarm', addlist: value.docs[i].data());
        }
      }
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    controller.dispose();
    searchnode.unfocus();
    //notilist.noticontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BGColor(),
      body: GetBuilder<navibool>(
        init: navibool(),
        builder: (_) => draw.navi == 0
            ? (draw.drawopen == true
                ? Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        child: DrawerScreen(
                            index: Hive.box('user_setting').get('page_index')),
                      ),
                      HomeUi(),
                    ],
                  )
                : Stack(
                    children: [
                      HomeUi(),
                    ],
                  ))
            : Stack(
                children: [
                  HomeUi(),
                ],
              ),
      ),
    ));
  }

  HomeUi() {
    double height = MediaQuery.of(context).size.height;
    final List<CompanyPageList> listcompanytousers = [];
    var url;
    var checkid = '';

    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  searchnode.unfocus();
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
                      //decoration: BoxDecoration(color: colorselection),
                      child: GetBuilder<uisetting>(
                        builder: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uiset.searchpagemove == ''
                                ? AppBarCustom(
                                    title: '',
                                    righticon: false,
                                    iconname: Icons.notifications_none,
                                  )
                                : GetBuilder<uisetting>(
                                    builder: (_) => FutureBuilder(
                                        future: firestore
                                            .collection('Favorplace')
                                            .get()
                                            .then((value) {
                                          checkid = '';
                                          if (value.docs.isEmpty) {
                                            checkid = '';
                                          } else {
                                            final valuespace = value.docs;

                                            for (int i = 0;
                                                i < valuespace.length;
                                                i++) {
                                              if (valuespace[i]
                                                      ['favoradduser'] ==
                                                  usercode) {
                                                if (valuespace[i]['title'] ==
                                                    (Hive.box('user_setting').get(
                                                            'currenteditpage') ??
                                                        '')) {
                                                  checkid = valuespace[i].id;
                                                }
                                              }
                                            }
                                          }
                                        }),
                                        builder: ((context, snapshot) {
                                          if (checkid != '') {
                                            return AppBarCustom(
                                              title: uiset.searchpagemove,
                                              righticon: true,
                                              iconname: Icons.star,
                                            );
                                          } else {
                                            return AppBarCustom(
                                              title: uiset.searchpagemove,
                                              righticon: true,
                                              iconname: Icons.star_border,
                                            );
                                          }
                                        }))),
                            uiset.searchpagemove == ''
                                ? Flexible(
                                    fit: FlexFit.tight,
                                    child: SizedBox(
                                      child: ScrollConfiguration(
                                        behavior: NoBehavior(),
                                        child: SingleChildScrollView(
                                            controller: _scrollController,
                                            child: StatefulBuilder(builder:
                                                (_, StateSetter setState) {
                                              return GetBuilder<uisetting>(
                                                  builder: (_) => Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Se_Container0(height),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Se_Container01(
                                                              height),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Se_Container1(height),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Se_Container11(
                                                              height),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Se_Container3(height),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                        ],
                                                      ));
                                            })),
                                      ),
                                    ))
                                : ScrollConfiguration(
                                    behavior: NoBehavior(),
                                    child: Se_Container2(uiset.searchpagemove)),
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }

  Se_Container0(
    double height,
  ) {
    //프로버전 구매시 보이지 않게 함
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerDesign(
              color: BGColor(),
              child: TextField(
                onChanged: ((value) {
                  setState(() {
                    textchangelistener = value;
                  });
                }),
                controller: controller,
                maxLines: 1,
                focusNode: searchnode,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: TextColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: BGColor(),
                  border: InputBorder.none,
                  hintMaxLines: 2,
                  hintText: '탐색하실 페이지 제목 입력',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: TextColor()),
                  isCollapsed: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: TextColor_shadowcolor(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Se_Container01(
    double height,
  ) {
    return GetBuilder<uisetting>(
        builder: (_) => Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Pinchannel').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    uiset.searchpagelist.clear();
                    uiset.editpagelist.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      final messageuser = sp.get('username');
                      final messagetitle = sp.get('linkname');
                      final messageemail = sp.get('email');
                      final messagesetting = sp.get('setting');
                      if (messageuser == usercode) {
                        if (textchangelistener == '') {
                        } else {
                          if (messagetitle
                              .toString()
                              .contains(textchangelistener)) {
                            uiset.searchpagelist.add(PageList(
                                title: messagetitle,
                                username: messageuser,
                                email: messageemail,
                                id: sp.id,
                                setting: messagesetting));
                          }
                        }
                      }
                    }

                    return uiset.searchpagelist.isEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContainerDesign(
                                  child: SizedBox(
                                    height: 40.h,
                                    child: Center(
                                      child: NeumorphicText(
                                        '검색 결과 없음',
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
                                    ),
                                  ),
                                  color: Colors.transparent)
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContainerDesign(
                                  color: Colors.transparent,
                                  child: GetBuilder<uisetting>(
                                    builder: (_) => ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: uiset.searchpagelist.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    searchnode.unfocus();
                                                    Hive.box('user_setting')
                                                        .put('page_index', 11);
                                                    uiset.setsearchpageindex(
                                                        index);
                                                    uiset.seteditpage(
                                                        uiset
                                                            .searchpagelist[
                                                                index]
                                                            .title,
                                                        uiset
                                                            .searchpagelist[
                                                                index]
                                                            .username
                                                            .toString(),
                                                        uiset
                                                            .searchpagelist[
                                                                index]
                                                            .email
                                                            .toString(),
                                                        uiset
                                                            .searchpagelist[
                                                                index]
                                                            .id
                                                            .toString(),
                                                        uiset
                                                            .searchpagelist[
                                                                index]
                                                            .setting
                                                            .toString());
                                                  },
                                                  child: ContainerDesign(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  uiset
                                                                      .searchpagelist[
                                                                          index]
                                                                      .title,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize()),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Text(
                                                                  uiset
                                                                      .searchpagelist[
                                                                          index]
                                                                      .email
                                                                      .toString(),
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      color:
                                                                          TextColor(),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          contentTextsize()),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              ],
                                                            )),
                                                        Icon(
                                                          Icons.chevron_right,
                                                          color:
                                                              TextColor_shadowcolor(),
                                                        ),
                                                      ],
                                                    ),
                                                    color: BGColor(),
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          );
                                        }),
                                  ))
                            ],
                          );
                  }
                  return ContainerDesign(
                      child: SizedBox(
                        height: 40.h,
                        child: Center(
                          child: NeumorphicText(
                            '검색 결과 없음',
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
                        ),
                      ),
                      color: Colors.transparent);
                },
              ),
            ));
  }

  Se_Container1(
    double height,
  ) {
    //프로버전 구매시 보이지 않게 함
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '즐겨찾기 페이지',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Se_Container11(
    double height,
  ) {
    return GetBuilder<uisetting>(
        builder: (_) => Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Favorplace').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    uiset.favorpagelist.clear();
                    uiset.editpagelist.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      final messageuser = sp.get('originuser');
                      final messagetitle = sp.get('title');
                      final messageadduser = sp.get('favoradduser');
                      final messageemail = sp.get('email');
                      final messageid = sp.get('id');
                      final messagesetting = sp.get('setting');
                      if (messageadduser == usercode) {
                        uiset.favorpagelist.add(PageList(
                            title: messagetitle,
                            email: messageemail,
                            username: messageuser,
                            id: messageid,
                            setting: messagesetting));
                      }
                    }

                    return uiset.favorpagelist.isEmpty
                        ? ContainerDesign(
                            child: SizedBox(
                              height: 40.h,
                              child: Center(
                                child: NeumorphicText(
                                  '즐겨찾기 설정하신 페이지가 없네요',
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
                              ),
                            ),
                            color: Colors.transparent)
                        : ContainerDesign(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: uiset.favorpagelist.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          searchnode.unfocus();
                                          Hive.box('user_setting')
                                              .put('page_index', 21);
                                          uiset.setfavorpageindex(index);
                                          uiset.seteditpage(
                                              uiset.favorpagelist[index].title,
                                              uiset
                                                  .favorpagelist[index].username
                                                  .toString(),
                                              uiset.favorpagelist[index].email
                                                  .toString(),
                                              uiset.favorpagelist[index].id
                                                  .toString(),
                                              uiset.favorpagelist[index].setting
                                                  .toString());
                                        },
                                        child: ContainerDesign(
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        uiset
                                                            .favorpagelist[
                                                                index]
                                                            .title,
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        uiset
                                                            .favorpagelist[
                                                                index]
                                                            .email
                                                            .toString(),
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                contentTextsize()),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    ],
                                                  )),
                                              Icon(
                                                Icons.chevron_right,
                                                color: TextColor_shadowcolor(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                }),
                            color: Colors.transparent,
                          );
                  }
                  return ContainerDesign(
                      child: SizedBox(
                        height: 40.h,
                        child: Center(
                          child: NeumorphicText(
                            '즐겨찾기 설정하신 페이지가 없네요',
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
                        ),
                      ),
                      color: Colors.transparent);
                },
              ),
            ));
  }

  Se_Container2(String searchpagemove) {
    return listy_My(searchpagemove);
  }

  Se_Container3(
    double height,
  ) {
    //프로버전 구매시 보이지 않게 함
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '페이지 팁',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: contentTitleTextsize(),
                        color: TextColor()),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ShowTips(
              height: height,
              pageindex: 0,
            ),
          ],
        ),
      ),
    );
  }

  H_Container_3(double height) {
    //프로버전 구매시 보이지 않게 함
    /*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //ADEvents(context)
      ],
    )*/
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '광고공간입니다',
                style: TextStyle(
                    color: TextColor_shadowcolor(),
                    fontWeight: FontWeight.bold,
                    fontSize: contentTextsize()),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  H_Container_4(double height) {
    //프로버전 구매시 보이지 않게 함
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await MongoDB.find(
                      collectionname: 'homeview',
                      query: 'usercode',
                      what: Hive.box('user_setting').get('usercode'));
                  peopleadd.setcode();
                  Get.to(
                      () => const HomeView(
                            where: 'home',
                            link: '',
                          ),
                      transition: Transition.zoom);
                },
                child: Text('홈뷰설정',
                    style: TextStyle(
                        color: TextColor_shadowcolor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
              VerticalDivider(
                thickness: 1,
                color: TextColor_shadowcolor(),
              ),
              InkWell(
                onTap: () {
                  showreadycontent(context);
                },
                child: Text('문의하기',
                    style: TextStyle(
                        color: TextColor_shadowcolor(),
                        fontWeight: FontWeight.bold,
                        fontSize: contentTextsize())),
              ),
            ],
          ),
        )
      ],
    );
  }
}
