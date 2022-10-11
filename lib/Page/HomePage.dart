import 'dart:async';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/PeopleAdd.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/Tool/AppBarCustom.dart';
import 'package:clickbyme/UI/Events/ADEvents.dart';
import 'package:clickbyme/UI/Home/firstContentNet/HomeView.dart';
import 'package:clickbyme/UI/Home/secondContentNet/ShowTips.dart';
import 'package:clickbyme/initScreenLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import '../DB/PageList.dart';
import '../DB/SpaceContent.dart';
import '../DB/Category.dart';
import '../LocalNotiPlatform/NotificationApi.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/Widgets/ViewSet.dart';
import '../UI/Home/firstContentNet/DayContentHome.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
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
  String name_second = Hive.box('user_info').get('id').toString().length > 5
      ? Hive.box('user_info').get('id').toString().substring(0, 4)
      : Hive.box('user_info').get('id').toString().substring(0, 2);
  String email_first =
      Hive.box('user_info').get('email').toString().substring(0, 3);
  String email_second = Hive.box('user_info')
      .get('email')
      .toString()
      .split('@')[1]
      .substring(0, 2);
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

  @override
  void initState() {
    super.initState();
    Hive.box('user_setting').put('page_index', 0);
    /*notilist.noticontroller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
        value: 0,
        upperBound: 1.05,
        lowerBound: 0.95);
    animation = CurvedAnimation(
        parent: notilist.noticontroller, curve: Curves.decelerate);
    notilist.noticontroller.forward();

    // forward면 AnimationStatus.completed
    // reverse면 AnimationStatus.dismissed
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        notilist.noticontroller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        notilist.noticontroller.forward();
      }
    });*/
    /*firestore.collection('CalendarDataBase').get().then((value) {
      List valueid = [];
      for (int i = 0; i < value.docs.length; i++) {
        valueid.add(value.docs[i].id);
      }
      for (int j = 0; j < valueid.length; j++) {
        firestore.collection('CalendarDataBase').doc(valueid[j]).update({
          'code': '',
        });
      }
    });*/
    docid = Hive.box('user_setting').get('usercode');

    _pController2 =
        PageController(initialPage: currentPage2, viewportFraction: 1);
    initScreen();
  }

  @override
  void dispose() {
    //notilist.noticontroller.dispose();
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
                            title: 'HashedLiv',
                            righticon: false,
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
                                              height: 10,
                                            ),
                                            H_Container_0(
                                                height, _pController2),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            H_Container_3(height),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            /*H_Container_2(height),
                                      const SizedBox(
                                        height: 20,
                                      ),*/
                                            /*H_Container_1(height),
                                            const SizedBox(
                                              height: 20,
                                            ),*/
                                            GetBuilder<PeopleAdd>(
                                                builder: (_) => ViewSet(
                                                    peopleadd
                                                        .defaulthomeviewlist,
                                                    peopleadd.userviewlist,
                                                    usercode)),
                                            /*const SizedBox(
                                              height: 20,
                                            ),
                                            H_Container_toBottom(),*/
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            H_Container_myroom(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            H_Container_testroom(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            CompanyNotice(),
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
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

  H_Con_Alert() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              '공지사항',
              style: TextStyle(
                  color: TextColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: contentTitleTextsize()),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              draw.setclose();
              Hive.box('user_setting').put('page_index', 3);
              Navigator.of(context).pushReplacement(
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const MyHomePage(
                    index: 3,
                  ),
                ),
              );
            },
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  '더보기',
                  maxLines: 1,
                  softWrap: true,
                  style: TextStyle(
                      color: TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  overflow: TextOverflow.fade,
                )),
          ),
        ],
      ),
    );
  }

  CompanyNotice() {
    final List<PageList> _list_ad = [];
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('CompanyNotice')
          .orderBy('date', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _list_ad.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            final messageText = sp.get('title');
            final messageDate = sp.get('date');
            _list_ad.add(PageList(
              title: messageText,
              sub: messageDate,
            ));
          }

          return _list_ad.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      color: Colors.grey.shade400,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '공지사항이 없습니다.',
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize()),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H_Con_Alert(),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: ContainerDesign(
                                color: BGColor(),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            _list_ad[0].title,
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
                            )
                          ],
                        ))
                  ],
                );
        }
        return LinearProgressIndicator(
          backgroundColor: BGColor(),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }

  /*H_Container_toBottom() {
    //프로버전 구매시 보이지 않게 함
    return GestureDetector(
      onTap: () {
        draw.setclose();
        _getAppInfo();
        Hive.box('user_setting').put('page_index', 1);
        //_scrollToBottom();
        Get.to(() => HomeView(), transition: Transition.zoom);
      },
      child: Container(
          color: ButtonColor(),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '홈에 나타나는 콘텐츠들을 홈뷰설정에서 순서변경이 가능해요',
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                      overflow: TextOverflow.fade,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                        backgroundColor: ButtonColor(),
                        child: Text(
                          'Go',
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: contentTextsize()),
                          overflow: TextOverflow.fade,
                        ))),
              ],
            ),
          )),
    );
  }*/

  H_Container_myroom() {
    //프로버전 구매시 보이지 않게 함
    return GestureDetector(
      onTap: () {
        draw.setclose();
        _getAppInfo();
        Hive.box('user_setting').put('page_index', 1);
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MyHomePage(
              index: 1,
            ),
          ),
        );
      },
      child: Container(
          color: ButtonColor(),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '마이룸에 작성하신 해빗T들이 자리하고 있어요',
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                      overflow: TextOverflow.fade,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: ButtonColor(),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  H_Container_testroom() {
    //프로버전 구매시 보이지 않게 함
    return GestureDetector(
      onTap: () {
        draw.setclose();
        _getAppInfo();
        Hive.box('user_setting').put('page_index', 3);
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const MyHomePage(
              index: 3,
            ),
          ),
        );
      },
      child: Container(
          color: ButtonColor(),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '넥스트버전에 추가될 사항들은 실험실에 가시면 볼 수 있어요',
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize()),
                      overflow: TextOverflow.fade,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: ButtonColor(),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  H_Container_1(double height) {
    //프로버전 구매시 보이지 않게 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ADEvents(context)],
    );
  }

  /*H_Container_2(double height) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: ContainerDesign(
                  color: BGColor(),
                  child: GestureDetector(
                    onTap: () async {
                      final reloadpage = await Get.to(
                          () => const ChooseCalendar(
                                isfromwhere: 'home',
                                index: 0,
                              ),
                          transition: Transition.rightToLeft);
                      if (reloadpage) {
                        GoToMain(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                        //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                        Container(
                          alignment: Alignment.center,
                          child: NeumorphicIcon(
                            Icons.calendar_month,
                            size: isresponsive == true ? 50 : 25,
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 2,
                                color: Colors.blue.shade400,
                                lightSource: LightSource.topLeft),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Center(
                          child: Text('캘린더',
                              style: TextStyle(
                                  color: TextColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: contentTextsize())),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
                flex: 1,
                child: ContainerDesign(
                    color: BGColor(),
                    child: GestureDetector(
                      onTap: () async {
                        final reloadpage = await Get.to(
                            () => const DayNoteHome(
                                  title: '',
                                  isfromwhere: 'home',
                                ),
                            transition: Transition.rightToLeft);
                        if (reloadpage) {
                          GoToMain(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                          //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                          Container(
                            alignment: Alignment.center,
                            child: NeumorphicIcon(
                              Icons.description,
                              size: isresponsive == true ? 50 : 25,
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 2,
                                  color: Colors.blue.shade400,
                                  lightSource: LightSource.topLeft),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Center(
                            child: Text('메모장',
                                style: TextStyle(
                                    color: TextColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: contentTextsize())),
                          ),
                        ],
                      ),
                    )))
          ],
        )
        /*ContainerDesign(
            color: BGColor(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //카테고리가 늘어날수록 한줄 제한을 3으로 줄이고
                //최대 두줄로 늘린 후 카테고리 로우 옆에 모두보기를 텍스트로 생성하기
                Center(
                  child: Text('마이페이지 이동',
                      style: TextStyle(
                          color: TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: contentTextsize())),
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  childAspectRatio: 2 / 1,
                  children: List.generate(2, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        index == 0
                            ? GestureDetector(
                                onTap: () async {
                                  final reloadpage = await Get.to(
                                      () => const ChooseCalendar(
                                            isfromwhere: 'home',
                                            index: 0,
                                          ),
                                      transition: Transition.rightToLeft);
                                  if (reloadpage) {
                                    GoToMain(context);
                                  }
                                },
                                child: SizedBox(
                                  height: isresponsive == true ? 110 : 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.calendar_month,
                                          size: isresponsive == true ? 50 : 25,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: TextColor(),
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                      SizedBox(
                                        height: isresponsive == true ? 40 : 30,
                                        child: Center(
                                          child: Text('캘린더',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  final reloadpage = await Get.to(
                                      () => const DayNoteHome(
                                            title: '',
                                            isfromwhere: 'home',
                                          ),
                                      transition: Transition.rightToLeft);
                                  if (reloadpage) {
                                    GoToMain(context);
                                  }
                                },
                                child: SizedBox(
                                  height: isresponsive == true ? 110 : 60,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: NeumorphicIcon(
                                          Icons.description,
                                          size: isresponsive == true ? 50 : 25,
                                          style: NeumorphicStyle(
                                              shape: NeumorphicShape.convex,
                                              depth: 2,
                                              color: TextColor(),
                                              lightSource: LightSource.topLeft),
                                        ),
                                      ),
                                      SizedBox(
                                        height: isresponsive == true ? 40 : 30,
                                        child: Center(
                                          child: Text('일상메모',
                                              style: TextStyle(
                                                  color: TextColor(),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: contentTextsize())),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    );
                  }),
                )
              ],
            ))*/
        );
  }*/

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
                onTap: () {
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
