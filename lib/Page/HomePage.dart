import 'dart:async';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/ChooseCalendar.dart';
import 'package:clickbyme/UI/Home/firstContentNet/DayNoteHome.dart';
import 'package:clickbyme/UI/Home/firstContentNet/HomeView.dart';
import 'package:clickbyme/UI/Home/secondContentNet/ShowTips.dart';
import 'package:clickbyme/initScreenLoading.dart';
import 'package:clickbyme/providers/mongodatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DB/PageList.dart';
import '../DB/SpaceContent.dart';
import '../DB/Category.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/Widgets/ViewSet.dart';
import '../route.dart';
import '../sheets/readycontent.dart';
import 'DrawerScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.secondname}) : super(key: key);
  final String secondname;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isresponsive = false;
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
  static final List<Category> fillcategory = [];
  late final PageController _pController2;
  int currentPage2 = 0;
  //프로 버전 구매시 사용하게될 코드
  bool isbought = false;
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  var searchNode = FocusNode();
  var newversion;
  var status;
  bool sameversion = true;
  List updateid = [];
  bool isread = false;
  final notilist = Get.put(notishow());
  late Animation animation;
  List updatefriends = [];
  String docid = '';
  final peopleadd = Get.put(PeopleAdd());
  late PackageInfo info;
  String versioninfo = '';
  String usercode = Hive.box('user_setting').get('usercode');
  bool serverstatus = Hive.box('user_info').get('server_status');

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    docid = Hive.box('user_setting').get('usercode') ?? '';

    _pController2 =
        PageController(initialPage: currentPage2, viewportFraction: 1);
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
    _pController2.dispose();
    _scrollController.dispose();
    //notilist.noticontroller.dispose();
  }

  /*void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }*/

  Future<void> _getAppInfo() async {
    info = await PackageInfo.fromPlatform();
    versioninfo = info.version;
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height > 900
        ? isresponsive = true
        : isresponsive = false;
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
                      HomeUi(
                        _pController2,
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      HomeUi(
                        _pController2,
                      ),
                    ],
                  ))
            : Stack(
                children: [
                  HomeUi(
                    _pController2,
                  ),
                ],
              ),
      ),
    ));
  }

  HomeUi(
    PageController pController,
  ) {
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<navibool>(
        builder: (_) => AnimatedContainer(
              transform:
                  Matrix4.translationValues(draw.xoffset, draw.yoffset, 0)
                    ..scale(draw.scalefactor),
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
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
                      //decoration: BoxDecoration(color: colorselection),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBarCustom(
                            title: 'LinkAI',
                            righticon: true,
                            iconname: Icons.notifications_none,
                            func: null,
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
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            CompanyNotice(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            H_Container_0(
                                                height, _pController2),
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
                                            ),
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

  H_Container_0(double height, PageController pController) {
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
                Text(
                  '이렇게 해보세요',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTitleTextsize(),
                      color: TextColor()),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ShowTips(
              height: height,
              pageController: pController,
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

  CompanyNotice() {
    final List<PageList> listcompanytousers = [];
    var url;
    return serverstatus == true
        ? FutureBuilder(
            future:
                MongoDB.getData(collectionname: 'companynotice').then((value) {
              for (int j = 0; j < value.length; j++) {
                final messageText = value[j]['title'];
                final messageDate = value[j]['date'];
                final messageyes = value[j]['showthisinapp'];
                final messagewhere = value[j]['where'];
                if (messageyes == 'yes' && messagewhere == 'home') {
                  listcompanytousers.add(PageList(
                    title: messageText,
                    sub: messageDate,
                  ));
                  url = Uri.parse(value[j]['url']);
                }
              }
            }),
            builder: (context, snapshot) {
              return listcompanytousers.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              draw.setclose();
                              if (await canLaunchUrl(url)) {
                                launchUrl(url);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200,
                              ),
                              child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.campaign,
                                      color: Colors.black45,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          listcompanytousers[0].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                              fontSize: contentTextsize()),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ));
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('CompanyNotice')
                .orderBy('date', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                listcompanytousers.clear();
                final valuespace = snapshot.data!.docs;
                for (var sp in valuespace) {
                  final messageText = sp.get('title');
                  final messageDate = sp.get('date');
                  final messageyes = sp.get('showthisinapp');
                  final messagewhere = sp.get('where');
                  if (messageyes == 'yes' && messagewhere == 'home') {
                    listcompanytousers.add(PageList(
                      title: messageText,
                      sub: messageDate,
                    ));
                    url = Uri.parse(sp.get('url'));
                  }
                }

                return listcompanytousers.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                draw.setclose();
                                /*Hive.box('user_setting').put('page_index', 3);
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const MyHomePage(
                                    index: 3,
                                  ),
                                ),
                              );*/
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                }
                              },
                              child: ContainerDesign(
                                color: Colors.grey.shade300,
                                child: SizedBox(
                                  height: 90,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Icon(
                                        Icons.new_releases,
                                        color: TextColor(),
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            listcompanytousers[0].title,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: TextColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: contentTextsize()),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ));
              }
              return LinearProgressIndicator(
                backgroundColor: BGColor(),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              );
            },
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
                  Get.to(() => HomeView(), transition: Transition.zoom);
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
