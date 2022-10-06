import 'package:clickbyme/DB/PageList.dart';
import 'package:clickbyme/Tool/BGColor.dart';
import 'package:clickbyme/Tool/ContainerDesign.dart';
import 'package:clickbyme/Tool/Getx/notishow.dart';
import 'package:clickbyme/Tool/TextSize.dart';
import 'package:clickbyme/UI/Sign/UserCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../Dialogs/destroyBackKey.dart';
import '../Tool/AndroidIOS.dart';
import '../Tool/AppBarCustom.dart';
import '../Tool/Getx/navibool.dart';
import '../Tool/IconBtn.dart';
import '../Tool/NoBehavior.dart';
import '../UI/Home/firstContentNet/ChooseCalendar.dart';
import '../UI/Home/firstContentNet/DayNoteHome.dart';
import 'DrawerScreen.dart';

class NotiAlarm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotiAlarmState();
}

class _NotiAlarmState extends State<NotiAlarm>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0.0;
  int whatwantnotice = 0;
  String name = Hive.box('user_info').get('id');
  final List notinamelist = [
    '공지글',
    '푸쉬알림',
  ];
  final List<PageList> _list_ad = [];
  var userlist = [Hive.box('user_info').get('id')];
  var updateid = '';
  var updateusername = [];
  final notilist = Get.put(notishow());
  final draw = Get.put(navibool());
  final readlist = [];
  final listid = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //late TabController tabController;
  int pageindex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Hive.box('user_setting').put('noti_home_click', 0);
    whatwantnotice = notilist.whatnoticepagenum;
    /*tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );*/
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Future.delayed(const Duration(seconds: 0), () {
      GoToMain(context);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: BGColor(),
            body: GetBuilder<navibool>(
              builder: (_) => draw.navi == 0
                  ? (draw.drawopen == true
                      ? Stack(
                          children: [
                            Container(
                              width: 80,
                              child: DrawerScreen(
                                index:
                                    Hive.box('user_setting').get('page_index'),
                              ),
                            ),
                            UI(),
                          ],
                        )
                      : Stack(
                          children: [
                            UI(),
                          ],
                        ))
                  : Stack(
                      children: [
                        UI(),
                      ],
                    ),
            ))
        /*Scaffold(
      backgroundColor: BGColor(),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: UI(),
      ),
    )*/
        );
  }

  UI() {
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
                          GetBuilder<navibool>(
                              builder: (_) => SizedBox(
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        draw.navi == 0
                                            ? draw.drawopen == true
                                                ? IconBtn(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            draw.setclose();
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'page_opened',
                                                                    false);
                                                          });
                                                        },
                                                        icon: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 30,
                                                          height: 30,
                                                          child: NeumorphicIcon(
                                                            Icons
                                                                .keyboard_arrow_left,
                                                            size: 30,
                                                            style: NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                depth: 2,
                                                                surfaceIntensity:
                                                                    0.5,
                                                                color:
                                                                    TextColor(),
                                                                lightSource:
                                                                    LightSource
                                                                        .topLeft),
                                                          ),
                                                        )),
                                                    color: TextColor())
                                                : IconBtn(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            draw.setopen();
                                                            Hive.box(
                                                                    'user_setting')
                                                                .put(
                                                                    'page_opened',
                                                                    true);
                                                          });
                                                        },
                                                        icon: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 30,
                                                          height: 30,
                                                          child: NeumorphicIcon(
                                                            Icons.menu,
                                                            size: 30,
                                                            style: NeumorphicStyle(
                                                                shape:
                                                                    NeumorphicShape
                                                                        .convex,
                                                                surfaceIntensity:
                                                                    0.5,
                                                                depth: 2,
                                                                color:
                                                                    TextColor(),
                                                                lightSource:
                                                                    LightSource
                                                                        .topLeft),
                                                          ),
                                                        )),
                                                    color: TextColor())
                                            : const SizedBox(),
                                        SizedBox(
                                            width: draw.navi == 0
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    70
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    20,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Text('알림',
                                                          style: TextStyle(
                                                            fontSize:
                                                                secondTitleTextsize(),
                                                            color: TextColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                    IconBtn(
                                                        child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              final reloadpage = await Get.dialog(OSDialog(
                                                                      context,
                                                                      '경고',
                                                                      Text(
                                                                          '알림들을 삭제하시겠습니까?',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: contentTextsize(),
                                                                              color: Colors.blueGrey)),
                                                                      pressed2)) ??
                                                                  false;
                                                              if (reloadpage) {
                                                                firestore
                                                                    .collection(
                                                                        'AppNoticeByUsers')
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  for (var element
                                                                      in value
                                                                          .docs) {
                                                                    if (element
                                                                            .get('sharename')
                                                                            .toString()
                                                                            .contains(name) ==
                                                                        true) {
                                                                      updateid =
                                                                          element
                                                                              .id;
                                                                      updateusername = element
                                                                          .get(
                                                                              'sharename')
                                                                          .toString()
                                                                          .split(
                                                                              ',')
                                                                          .toList();
                                                                      if (updateusername
                                                                              .length ==
                                                                          1) {
                                                                        firestore
                                                                            .collection('AppNoticeByUsers')
                                                                            .doc(updateid)
                                                                            .delete();
                                                                      } else {
                                                                        updateusername.removeWhere((element) => element
                                                                            .toString()
                                                                            .contains(name));
                                                                        firestore
                                                                            .collection(
                                                                                'AppNoticeByUsers')
                                                                            .doc(
                                                                                updateid)
                                                                            .update({
                                                                          'sharename':
                                                                              updateusername
                                                                        });
                                                                      }
                                                                    } else {
                                                                      if (element
                                                                              .get('username')
                                                                              .toString() ==
                                                                          name) {
                                                                        updateid =
                                                                            element.id;
                                                                        firestore
                                                                            .collection('AppNoticeByUsers')
                                                                            .doc(updateid)
                                                                            .delete();
                                                                      } else {}
                                                                    }
                                                                  }
                                                                }).whenComplete(
                                                                        () {
                                                                  setState(() {
                                                                    Hive.box(
                                                                            'user_setting')
                                                                        .put(
                                                                            'noti_home_click',
                                                                            0);
                                                                    whatwantnotice =
                                                                        0;
                                                                  });
                                                                });
                                                              }
                                                            },
                                                            icon: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  NeumorphicIcon(
                                                                Icons.delete,
                                                                size: 30,
                                                                style: NeumorphicStyle(
                                                                    shape: NeumorphicShape
                                                                        .convex,
                                                                    depth: 2,
                                                                    surfaceIntensity:
                                                                        0.5,
                                                                    color:
                                                                        TextColor(),
                                                                    lightSource:
                                                                        LightSource
                                                                            .topLeft),
                                                              ),
                                                            )),
                                                        color: TextColor()),
                                                  ],
                                                ))),
                                      ],
                                    ),
                                  ))),
                          Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: ScrollConfiguration(
                                behavior: NoBehavior(),
                                child: SingleChildScrollView(child:
                                    StatefulBuilder(
                                        builder: (_, StateSetter setState) {
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NoticeLists(whatwantnotice),
                                          N_Container_1(height)
                                        ],
                                      ));
                                })),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            )));
    /*double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Container(
          decoration: BoxDecoration(
            color: BGColor(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TabViewScreen(),
              Flexible(
                  fit: FlexFit.tight,
                  child: SizedBox(
                    child: ScrollConfiguration(
                      behavior: NoBehavior(),
                      child: SingleChildScrollView(child:
                          StatefulBuilder(builder: (_, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NoticeLists(whatwantnotice),
                              N_Container_1(height)
                            ],
                          ),
                        );
                      })),
                    ),
                  )),
            ],
          )),
    );*/
  }

  /*TabViewScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: TextColor_shadowcolor(),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: TabBar(
                onTap: (index) {
                  setState(() {
                    pageindex = index;
                  });
                },
                controller: tabController,
                labelColor: TextColor(),
                unselectedLabelColor: BGColor(),
                indicator: BoxDecoration(
                    color: BGColor(), borderRadius: BorderRadius.circular(30)),
                tabs: [
                  /*Text(
                    '공지사항',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),*/
                  Text(
                    '인앱알림',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: contentTextsize(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          )),
    );
  }*/

  allread() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        allreadBox()
      ],
    );
  }

  allreadBox() {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                for (int i = 0; i < listid.length; i++) {
                  notilist.updatenoti(listid[i]);
                  readlist[i] = 'yes';
                }
              });
            },
            child: Text(
              '모두 읽음표시',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: contentTextsize(),
                  decoration: TextDecoration.underline),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  N_Container_1(double height) {
    //프로버전 구매시 보이지 않게 함
    /*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //ADEvents(context)
      ],
    )*/
    return SizedBox(
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
    );
  }

  NoticeLists(int whatwantnotice) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        allread(),
        UserNotice(),
      ],
    );
  }

  UserNotice() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('AppNoticeByUsers')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        /*notilist.listad.sort(
          (a, b) {
            return b.sub.toString().compareTo(a.sub);
          },
        );*/
        if (snapshot.hasData) {
          notilist.listad.clear();
          listid.clear();
          readlist.clear();
          final valuespace = snapshot.data!.docs;
          for (var sp in valuespace) {
            final messageText = sp.get('title');
            final messageDate = sp.get('date');
            if (sp.get('sharename').toString().contains(name) ||
                sp.get('username') == name) {
              readlist.add(sp.get('read'));
              listid.add(sp.id);
              notilist.listad
                  .add(PageList(title: messageText, sub: messageDate));
            }
          }
          return notilist.listad.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  height: draw.navi == 1
                      ? MediaQuery.of(context).size.height - 300
                      : MediaQuery.of(context).size.height - 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: NeumorphicText(
                          '생성된 푸시알림이 아직 없습니다.',
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
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: draw.navi == 1
                      ? MediaQuery.of(context).size.height - 300
                      : MediaQuery.of(context).size.height - 240,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: notilist.listad.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              notilist.updatenoti(listid[index]);
                              setState(() {
                                readlist[index] = 'yes';
                              });
                              notilist.listad[index].title
                                      .toString()
                                      .contains('메모')
                                  ? Get.to(
                                      () => const DayNoteHome(
                                            title: '',
                                            isfromwhere: 'notihome',
                                          ),
                                      transition: Transition.rightToLeft)
                                  : Get.to(
                                      () => ChooseCalendar(
                                            isfromwhere: 'notihome',
                                            index: 0,
                                          ),
                                      transition: Transition.rightToLeft);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ContainerDesign(
                                  color: readlist[index] == 'no'
                                      ? BGColor()
                                      : Colors.grey.shade400,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notilist.listad[index]
                                                            .title,
                                                        softWrap: true,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    notilist.listad[index].sub
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: TextColor(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            contentTextsize()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ));
                      }),
                );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              height: draw.navi == 1
                  ? MediaQuery.of(context).size.height - 300
                  : MediaQuery.of(context).size.height - 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator())],
              ));
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: draw.navi == 1
              ? MediaQuery.of(context).size.height - 300
              : MediaQuery.of(context).size.height - 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: NeumorphicText(
                  '생성된 푸시알림이 아직 없습니다.',
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
              )
            ],
          ),
        );
      },
    );
  }
}
