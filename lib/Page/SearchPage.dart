// ignore_for_file: non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:async';
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
import 'package:status_bar_control/status_bar_control.dart';
import '../DB/PageList.dart';
import '../DB/SpaceContent.dart';
import '../DB/Category.dart';
import '../Route/subuiroute.dart';
import '../Tool/ContainerDesign.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/Widgets/ViewSet.dart';
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBarCustom(
                            title: '',
                            righticon: false,
                            iconname: Icons.notifications_none,
                          ),
                          Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                child: ScrollConfiguration(
                                  behavior: NoBehavior(),
                                  child: SingleChildScrollView(
                                      controller: _scrollController,
                                      child: StatefulBuilder(
                                          builder: (_, StateSetter setState) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Se_Container0(height),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Se_Container01(height),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Se_Container1(height),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Se_Container11(height),
                                            /*FutureBuilder(
                                                future: MongoDB.getData(
                                                        collectionname:
                                                            'companynotice')
                                                    .then((value) {
                                                  for (int j = 0;
                                                      j < value.length;
                                                      j++) {
                                                    final messageText =
                                                        value[j]['title'];
                                                    final messageDate =
                                                        value[j]['date'];
                                                    final messageyes = value[j]
                                                        ['showthisinapp'];
                                                    final messagewhere =
                                                        value[j]['where'];
                                                    if (messageyes == 'yes' &&
                                                        messagewhere ==
                                                            'home') {
                                                      listcompanytousers
                                                          .add(CompanyPageList(
                                                        title: messageText,
                                                        url: messageDate,
                                                      ));
                                                      url = Uri.parse(
                                                          value[j]['url']);
                                                      uiset.seteventspace(
                                                          listcompanytousers[0]
                                                              .title,
                                                          value[j]['url']);
                                                    }
                                                  }
                                                }),
                                                builder: ((context, snapshot) {
                                                  return CompanyNotice(
                                                    'home',
                                                  );
                                                })),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            H_Container_0(
                                              height,
                                            ),

                                            /*const SizedBox(
                                              height: 20,
                                            ),
                                            H_Container_3(height),*/
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            GetBuilder<PeopleAdd>(
                                                builder: (_) => ViewSet(
                                                    peopleadd
                                                        .defaulthomeviewlist,
                                                    peopleadd.userviewlist,
                                                    usercode)),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            H_Container_4(height),
                                            const SizedBox(
                                              height: 50,
                                            ),*/
                                          ],
                                        );
                                      })),
                                ),
                              )),
                        ],
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: TextColor(), width: 2)),
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
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      final messageuser = sp.get('username');
                      final messagetitle = sp.get('linkname');
                      if (textchangelistener == '') {
                      } else {
                        if (messagetitle
                            .toString()
                            .contains(textchangelistener)) {
                          uiset.searchpagelist.add(PageList(
                              title: messagetitle, username: messageuser));
                        }
                      }
                    }

                    return uiset.searchpagelist.isEmpty
                        ? ContainerDesign(
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
                        : ContainerDesign(
                            color: Colors.transparent,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: uiset.searchpagelist.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      height: 50,
                                      child: SizedBox(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                uiset.searchpagelist[index]
                                                    .title,
                                                softWrap: true,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: TextColor(),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        contentTextsize()),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ],
                                      )));
                                }),
                          );
                  }
                  return LinearProgressIndicator(
                    backgroundColor: BGColor(),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
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
            const SizedBox(
              height: 20,
            ),
            /*ShowTips(
              height: height,
              pageController: pController,
              pageindex: 0,
            ),*/
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
                stream: firestore.collection('Favorpage').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    uiset.favorpagelist.clear();
                    final valuespace = snapshot.data!.docs;
                    for (var sp in valuespace) {
                      final messageuser = sp.get('username');
                      final messagetitle = sp.get('linkname');
                      if (messageuser == usercode) {
                        uiset.favorpagelist.add(PageList(
                            title: messagetitle, username: messageuser));
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
                        : SizedBox(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: uiset.favorpagelist.length,
                                itemBuilder: (context, index) {
                                  return ContainerDesign(
                                      child: SizedBox(
                                          height: (uiset.favorpagelist.length
                                                  .toDouble()) *
                                              50,
                                          child: SizedBox(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    uiset.favorpagelist[index]
                                                        .title,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                            ],
                                          ))),
                                      color: Colors.transparent);
                                }),
                          );
                  }
                  return LinearProgressIndicator(
                    backgroundColor: BGColor(),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  );
                },
              ),
            ));
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
